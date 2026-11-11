#!/bin/bash
# What does it cost to compile the library's Rust so that its loops keep their source's shape?
# bench-hashes check, next against next plus a marker file PROOF-FLAGS; a compiler wrapper adds
# the flags in that file to the library crate (and to nothing else) on the side that has the file.
# The check's own exit is the verdict (0 no regression, 1 regression).
set -euo pipefail
exec timeout -k 15s 3300s bash -s -- "$1" <<'JOB'
set -uo pipefail
R="$1";O="$R/out";mkdir -p "$O";. <home>/.cargo/env
export CARGO_TARGET_DIR="$R/target" TMPDIR="$R/check-tmp";mkdir -p "$TMPDIR"
OLD=$(git -C "$R/baseline" rev-parse HEAD)
git -C "$R/library" fetch --no-tags "$R/baseline" "$OLD" > "$O/base-object.log" 2>&1
{ for repo in library baseline bench;do echo "$repo $(git -C "$R/$repo" rev-parse HEAD)";done;rustc -Vv;uname -m;echo "flags $(cat "$R/library/PROOF-FLAGS")"; } > "$O/identity.txt"
git -C "$R/library" diff --stat "$OLD" HEAD > "$O/difference.txt"
cat > "$R/wrapper.py" <<'PY'
#!/usr/bin/env python3
"""rustc, with the flags of PROOF-FLAGS added when the crate is the library and its checkout has that file."""
import os, pathlib, sys
args = sys.argv[1:]
flags = []
if "blake3_servil" in args and "--crate-name" in args and args[args.index("--crate-name") + 1] == "blake3_servil":
    for a in args:
        if a.endswith(".rs"):
            for d in pathlib.Path(a).resolve().parents[:3]:
                if (d / "PROOF-FLAGS").is_file():
                    flags = (d / "PROOF-FLAGS").read_text().split()
                    break
            with open(os.environ["PROOF_FLAGS_LOG"], "a") as f:
                f.write(("applied " + " ".join(flags) if flags else "plain") + "\t" + a + "\n")
            break
os.execvp(args[0], args + flags)
PY
chmod +x "$R/wrapper.py"
export RUSTC_WRAPPER="$R/wrapper.py" PROOF_FLAGS_LOG="$O/wrapper.log"; : > "$PROOF_FLAGS_LOG"
POINTS='interleaved 256,turn 256,turn 1024 x 1 KiB,idle turn 256,64 B,1 KiB,16 KiB,1 MiB,continuous 1 KiB,continuous batch 1024'
cd "$R/bench"
cargo run --release --quiet -- check --fork "$R/library" --against "$OLD" --when-quiet --keep "$O/samples" --points "$POINTS" > "$O/check.log" 2> "$O/check.stderr"
rc=$?
echo "check exit $rc: $(case $rc in 0) echo 'no regression';; 1) echo 'regression';; 2) echo 'no verdict';; 3) echo 'a side stopped';; *) echo 'error';; esac)" > "$O/status.txt"
sort "$PROOF_FLAGS_LOG" | cut -f1 | uniq -c > "$O/wrapper-summary.txt"
tail -n 40 "$O/check.log"; cat "$O/wrapper-summary.txt"
grep -q '^ *[0-9]* applied' "$O/wrapper-summary.txt" && grep -q '^ *[0-9]* plain' "$O/wrapper-summary.txt" || { echo "the wrapper did not see both sides" >> "$O/status.txt"; exit 1; }
case $rc in 0|1) exit 0;; *) exit 1;; esac
JOB
