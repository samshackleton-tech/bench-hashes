#!/bin/bash
# How much machine code a change of the source moves (BLAKE3 #361): a proof about the bytes is made
# again for every function whose bytes change. For each of the last commits on next that touch src/,
# the library's release build before and after, function by function (instruction text with addresses
# removed), and how many functions and instructions differ.
set -uo pipefail
R="$1";O="$R/out";mkdir -p "$O";export HOME=/root;. <home>/.cargo/env
export CARGO_INCREMENTAL=0
cd "$R/library"
{ echo "library $(git rev-parse HEAD)"; rustc -Vv | grep -E '^(rustc|host)'; } > "$O/identity.txt"
cat > "$R/functions.py" <<'FUNCTIONS_PY'
import glob, hashlib, json, re, subprocess, sys
out = sys.argv[1]
def norm(t):
    """An instruction's text without what any rebuild renames: LLVM's suffixes on private names and
    the hash and number in an unnamed constant's name."""
    t = re.sub(r"\s+", " ", t)
    t = re.sub(r"\s*\(\.llvm\.\d+\)", "", t)
    t = re.sub(r"(?:\.L)?anon\.[0-9a-f]+\.\d+(?:\.llvm\.\d+)?", "anon", t)
    return re.sub(r"\.llvm\.\d+", "", t)
funcs = {}
for obj in sorted(glob.glob("*.rcgu.o")):
    text = subprocess.run(["llvm-objdump", "-d", "-r", "-C", "-M", "intel", "--no-show-raw-insn", obj], capture_output=True, text=True).stdout
    name, lines = None, []
    def close():
        if name is not None and lines:
            funcs[name] = lines[:]
    for line in text.splitlines():
        m = re.match(r"^[0-9a-f]+ <(.+)>:$", line)
        if m:
            close(); name, lines = re.sub(r" \(\.llvm\.\d+\)", "", m.group(1)), []; continue
        m = re.match(r"^\s*[0-9a-f]+:\s+(\S.*)$", line)
        if m and name is not None:
            lines.append(norm(m.group(1)))
    close()
rows = {n: {"instructions": sum(1 for l in ls if not l.startswith("R_X86_64")), "sha256": hashlib.sha256("\n".join(ls).encode()).hexdigest(), "text": ls} for n, ls in funcs.items()}
with open(out, "w") as f:
    json.dump(rows, f, indent=0, sort_keys=True)
FUNCTIONS_PY
build() {  # commit -> $R/f-<commit>.json
  local c="$1"
  [ -s "$R/f-$c.json" ] && return 0
  rm -rf "$R/wt-$c"; git worktree add -q --detach "$R/wt-$c" "$c" || return 1
  (cd "$R/wt-$c" && CARGO_TARGET_DIR="$R/target-$c" cargo build --release > "$O/build-$c.log" 2>&1 < /dev/null) || return 1
  rm -rf "$R/x-$c"; mkdir -p "$R/x-$c"; local lib; lib=$(ls "$R/target-$c"/release/libblake3_servil*.rlib | head -n 1); cp "$lib" "$R/x-$c/"
  (cd "$R/x-$c" && ar x "$(basename "$lib")" && python3 "$R/functions.py" "$R/f-$c.json")
  rm -rf "$R/target-$c" "$R/x-$c"; git worktree remove --force "$R/wt-$c"
}
: > "$O/churn.tsv"
for c in $COMMITS; do
  p=$(git rev-parse "$c^") || continue
  build "$c" && build "$p" || { echo "$c: a build failed" >> "$O/failures.txt"; continue; }
  lines=$(git diff --numstat "$p" "$c" -- 'src/*.rs' | python3 -c "
import sys
a = d = 0
for l in sys.stdin:
    x = l.split()
    if x[0] != '-': a += int(x[0]); d += int(x[1])
print(a, d)")
  python3 - "$R/f-$p.json" "$R/f-$c.json" "$c" "$lines" "$(git log -1 --format=%s "$c" | cut -c1-70)" >> "$O/churn.tsv" <<'ROW_PY'
import json, sys
old, new = json.load(open(sys.argv[1])), json.load(open(sys.argv[2]))
both = [n for n in new if n in old]
changed = [n for n in both if old[n]["sha256"] != new[n]["sha256"]]
added = [n for n in new if n not in old]; gone = [n for n in old if n not in new]
total = sum(r["instructions"] for r in new.values())
moved = sum(new[n]["instructions"] for n in changed) + sum(new[n]["instructions"] for n in added)
a, d = sys.argv[4].split()
print("\t".join(map(str, [sys.argv[3][:8], a, d, len(new), total, len(changed), len(added), len(gone), moved, f"{moved / total:.1%}", sys.argv[5]])))
import difflib, os
with open(os.path.join(os.path.dirname(sys.argv[1]), "out", "diff-" + sys.argv[3][:8] + ".txt"), "w") as f:
    for n in sorted(changed, key=lambda n: new[n]["instructions"]):
        d = [l for l in difflib.unified_diff(old[n]["text"], new[n]["text"], lineterm="", n=0) if not l.startswith(("---", "+++", "@@"))]
        f.write(f"== {n[:150]}: {new[n]['instructions']} instructions, {len(d)} lines differ\n")
        for l in d[:6]: f.write("   " + l[:160] + "\n")
ROW_PY
done
{ printf 'commit\tlines added\tremoved\tfunctions\tinstructions\tchanged\tadded\tgone\tinstructions in changed or added\tshare\tsubject\n'; cat "$O/churn.tsv"; } > "$O/churn-table.tsv"
cat "$O/churn-table.tsv"
echo "churn measured" > "$O/status.txt"
