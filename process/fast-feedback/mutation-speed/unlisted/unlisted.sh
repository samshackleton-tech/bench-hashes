#!/bin/bash
# The mutants of the library's Rust files that no platform's list names, on x86-64 with AVX-512.
set -euo pipefail
exec timeout -k 30s 1500s bash -s -- "$1" <<'UNLISTED_JOB'
set -euo pipefail
R="$1"; O="$R/out"; mkdir -p "$O"; . <home>/.cargo/env
export CARGO_TARGET_DIR="$R/target" TMPDIR="$R/private-tmp"; mkdir -p "$TMPDIR"
{ for name in library mutator; do printf '%s %s\n' "$name" "$(git -C "$R/$name" rev-parse HEAD)"; done; rustc -V; uname -sm; lscpu | grep -E '^(Model name|CPU\(s\))'; grep -o -m1 -E 'avx512f' /proc/cpuinfo; } > "$O/identity.txt"
CARGO_TARGET_DIR="$R/mutator-target" cargo install --locked --path "$R/mutator" --root "$R/mutator-install" > "$O/install-mutator.log" 2>&1
export PATH="$R/mutator-install/bin:$PATH"
CARGO_TARGET_DIR="$R/b3sum-target" cargo install --locked --version '=1.8.7' b3sum --root "$R/target/b3sum-official-1.8.7" > "$O/install-b3sum.log" 2>&1
export MUTANTS_B3SUM="$R/target/b3sum-official-1.8.7/bin/b3sum"
cd "$R/library"; cargo fetch > "$O/fetch.log" 2>&1
cat > "$R/unlisted-run.py" <<'UNLISTED_RUN_PY'
#!/usr/bin/env python3
"""The mutants of the library's Rust files that no platform's list names, run as a whole
run runs a file's (every mutant, the suite stopping at a mutant's first failure, the
survivors' release builds). Prints each surviving and timed-out name with its count."""
import json, os, sys
root, shards, out = sys.argv[1], int(sys.argv[2]), sys.argv[3]
files = sys.argv[4:]
sys.path.insert(0, os.path.join(root, "tools", "mutants"))
os.chdir(root)
import check
check.remove_leftovers()
found, functions, timed = check.run(files, shards=shards, label="unlisted")
total = sum(len(v) for v in functions.values())
outcomes = {}
for (file, function), rows in functions.items():
    for summary, name in rows:
        outcomes.setdefault(summary, []).append(name)
result = dict(files=files, mutants=total, survivors=dict(found), timeouts=dict(timed),
              by_outcome={k: len(v) for k, v in outcomes.items()},
              same_code={k: check.SAME["unlisted"][k] for k in found if check.SAME["unlisted"][k]},
              same_in_release={k: check.RELEASE_SAME["unlisted"][k] for k in found if check.RELEASE_SAME["unlisted"][k]})
with open(out, "w") as f:
    json.dump(result, f, indent=1)
print(json.dumps(result, indent=1))
UNLISTED_RUN_PY
set +e
python3 "$R/unlisted-run.py" "$R/library" 8 "$O/unlisted.json" src/stream/receiver.rs src/stream/frontend.rs src/admission.rs src/ffi_avx512_32.rs src/ffi_chunk_root.rs > "$O/unlisted.log" 2> "$O/unlisted.stderr"; s=$?
set -e
echo "$s" > "$O/exit.txt"
if [ -f tmp/mutants-last/unlisted/tests.tsv ]; then gzip -c tmp/mutants-last/unlisted/tests.tsv > "$O/tests-unlisted.tsv.gz"; fi
git status --porcelain --untracked-files=no > "$O/final-source-status.txt"
test -s "$O/unlisted.json"
printf 'unlisted files run complete (exit %s); functional record; no speed claim\n' "$s" > "$O/status.txt"
UNLISTED_JOB
