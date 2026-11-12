#!/bin/bash
# The mutation tool's tests and its short run (smoke.py) on each crate of the trial. Functional only.
set -euo pipefail
exec timeout -k 15s 1500s bash -s -- "$1" <<'JOB'
set -uo pipefail
R="$1";O="$R/out";mkdir -p "$O";export HOME=/root;. <home>/.cargo/env
export TMPDIR="$R/smoke-tmp" PYTHONUNBUFFERED=1;mkdir -p "$TMPDIR"
export GIT_AUTHOR_NAME='Sam Shackleton' GIT_COMMITTER_NAME='Sam Shackleton' GIT_AUTHOR_EMAIL='samshackleton-tech@users.noreply.github.com' GIT_COMMITTER_EMAIL='samshackleton-tech@users.noreply.github.com'
cd "$R/library"
{ for repo in library mutator;do echo "$repo $(git -C "$R/$repo" rev-parse HEAD)";done;rustc -V;uname -m; } > "$O/identity.txt"
CARGO_TARGET_DIR="$R/mutator-target" cargo install --locked --path "$R/mutator" --root "$R/mutator-install" > "$O/install-mutator.log" 2>&1 < /dev/null
export PATH="$R/mutator-install/bin:$PATH"
CARGO_TARGET_DIR="$R/b3sum-target" cargo install --locked --version '=1.8.7' b3sum --root "$R/b3sum-install" > "$O/install-b3sum.log" 2>&1 < /dev/null
export MUTANTS_B3SUM="$R/b3sum-install/bin/b3sum"
python3 -m unittest discover -s tools/mutants -p 'test_*.py' > "$O/unit.log" 2>&1 < /dev/null; echo "unit rc=$?" > "$O/steps.txt"
python3 tools/mutants/smoke.py > "$O/smoke-core.log" 2>&1 < /dev/null; echo "smoke core rc=$?" >> "$O/steps.txt"
python3 tools/mutants/smoke.py --crate threads > "$O/smoke-threads.log" 2>&1 < /dev/null; echo "smoke threads rc=$?" >> "$O/steps.txt"
cat "$O/steps.txt"; tail -n 2 "$O/smoke-core.log" "$O/smoke-threads.log"
grep -v -q 'rc=0' "$O/steps.txt" && { echo "FAILED: $(grep -v 'rc=0' "$O/steps.txt" | tr '\n' ';')" > "$O/status.txt"; exit 1; }
echo "tool tests and both crates' smoke runs passed; functional evidence only" > "$O/status.txt"
JOB
