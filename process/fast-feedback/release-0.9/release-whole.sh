#!/bin/bash
# The release's whole mutation run (CONTRIBUTING "Releases", step 4), as tools/release-check.py reads it:
# `python3 tools/mutants/check.py --whole` with the commit checked out, both crates, nothing written; its
# output is out/mutants-COMMIT12.log, the file release-check.py looks for as tmp/night/mutants-COMMIT12.log.
# The script then asks release-check.py's own reader what it makes of that log.
# Single execution: the times are inventory, no speed verdict.
set -euo pipefail
exec timeout -k 30s 12600s bash -s -- "$1" <<'JOB'
set -uo pipefail
R="$1";O="$R/out";mkdir -p "$O";. "$HOME/.cargo/env"
export CARGO_TARGET_DIR="$R/target" TMPDIR="$R/whole-tmp" PYTHONUNBUFFERED=1;mkdir -p "$TMPDIR"
cd "$R/library"
C=$(git rev-parse HEAD)
{ for repo in library mutator;do echo "$repo $(git -C "$R/$repo" rev-parse HEAD)";done;rustc -Vv;nproc;grep -m1 'model name' /proc/cpuinfo;grep -o -m1 avx512f /proc/cpuinfo || echo "no avx512f"; } > "$O/identity.txt"
CARGO_TARGET_DIR="$R/mutator-target" cargo install --locked --path "$R/mutator" --root "$R/mutator-install" > "$O/install-mutator.log" 2>&1 < /dev/null
export PATH="$R/mutator-install/bin:$PATH"
CARGO_TARGET_DIR="$R/b3sum-target" cargo install --locked --version '=1.8.7' b3sum --root "$R/target/b3sum-official-1.8.7" > "$O/install-b3sum.log" 2>&1 < /dev/null
export MUTANTS_B3SUM="$R/target/b3sum-official-1.8.7/bin/b3sum"
unset CARGO_TARGET_DIR
start=$(date +%s)
python3 tools/mutants/check.py --whole > "$O/mutants-${C:0:12}.log" 2> "$O/mutants-stderr.log" < /dev/null; rc=$?
echo "whole run of both crates: exit $rc in $(( $(date +%s) - start )) s" | tee "$O/status.txt"
grep -E '^mutants:' "$O/mutants-${C:0:12}.log" | tee "$O/summary.txt"
git status --short > "$O/git-status.txt"
# What the release's own reader says of the log (True: the step is done; False or a reason: it is not).
python3 - "$O/mutants-${C:0:12}.log" "$C" > "$O/release-check-reads.txt" 2>&1 <<'PY'
import importlib.util, sys
spec = importlib.util.spec_from_file_location("release_check", "tools/release-check.py")
m = importlib.util.module_from_spec(spec)
sys.argv = ["release-check.py", sys.argv[2]] + sys.argv[1:2]
spec.loader.exec_module(m)
print("release-check.py's mutation_result:", m.mutation_result(sys.argv[2], sys.argv[1]))
PY
cat "$O/release-check-reads.txt"
echo "the whole run ended" >> "$O/status.txt"
JOB
