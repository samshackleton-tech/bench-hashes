#!/bin/bash
# The Arm side on the tip, in the VM: the four suites and the change's mutation
# check against this machine's list, with every mutant. Functional only.
set -euo pipefail
exec timeout -k 15s 3000s bash -s -- "$1" <<'JOB'
set -uo pipefail
R="$1";O="$R/out";mkdir -p "$O";export HOME=/root;. <home>/.cargo/env
export CARGO_TARGET_DIR="$R/target" TMPDIR="$R/gate-tmp" PYTHONUNBUFFERED=1;mkdir -p "$TMPDIR"
export GIT_AUTHOR_NAME='Sam Shackleton' GIT_COMMITTER_NAME='Sam Shackleton' GIT_AUTHOR_EMAIL='samshackleton-tech@users.noreply.github.com' GIT_COMMITTER_EMAIL='samshackleton-tech@users.noreply.github.com'
BASE=$(git -C "$R/baseline" rev-parse HEAD); cd "$R/library"; git fetch --no-tags "$R/baseline" "$BASE" > "$O/base-object.log" 2>&1
{ for repo in library baseline mutator;do echo "$repo $(git -C "$R/$repo" rev-parse HEAD)";done;rustc -V;uname -m; } > "$O/identity.txt"
: > "$O/steps.tsv"
step() { local name="$1"; shift; local start=$SECONDS; "$@" > "$O/$name.log" 2>&1; printf '%s\trc=%s\t%ss\n' "$name" "$?" "$((SECONDS-start))" >> "$O/steps.tsv"; }
CARGO_TARGET_DIR="$R/mutator-target" cargo install --locked --path "$R/mutator" --root "$R/mutator-install" > "$O/install-mutator.log" 2>&1
export PATH="$R/mutator-install/bin:$PATH"
CARGO_TARGET_DIR="$R/b3sum-target" cargo install --locked --version '=1.8.7' b3sum --root "$R/target/b3sum-official-1.8.7" > "$O/install-b3sum.log" 2>&1
export MUTANTS_B3SUM="$R/target/b3sum-official-1.8.7/bin/b3sum"
step fmt cargo fmt --check
step lib cargo nextest run --release --lib
step doc cargo test --release --doc
step tests cargo nextest run --release --tests
step vectors cargo nextest run --release --manifest-path test_vectors/Cargo.toml
step mutants-every python3 tools/mutants/check.py --since "$BASE" --every-mutant
cat "$O/steps.tsv"; grep -E '^(mutants: the change since|NEW)' "$O/mutants-every.log" | tail -n 12
if grep -v -q 'rc=0' "$O/steps.tsv"; then echo "arm side: FAILED steps: $(grep -v 'rc=0' "$O/steps.tsv" | cut -f1 | tr '\n' ' ')" > "$O/status.txt"; exit 1; fi
echo "arm side: every step passed" > "$O/status.txt"
JOB
