#!/bin/bash
# The x86-64 0.9 candidate's functional gates on one host: format, builds,
# the four suites, the tool's tests, the change's mutation check. Each step's
# exit status is recorded; the job fails at its end if any step failed, after
# every step has run. No timing claim.
set -euo pipefail
exec timeout -k 15s 3300s bash -s -- "$1" <<'GATE'
set -uo pipefail
R="$1";O="$R/out";mkdir -p "$O";. <home>/.cargo/env
export CARGO_TARGET_DIR="$R/target" TMPDIR="$R/gate-tmp" PYTHONUNBUFFERED=1
mkdir -p "$TMPDIR"
export GIT_AUTHOR_NAME='Sam Shackleton' GIT_COMMITTER_NAME='Sam Shackleton'
export GIT_AUTHOR_EMAIL='samshackleton-tech@users.noreply.github.com' GIT_COMMITTER_EMAIL='samshackleton-tech@users.noreply.github.com'
BASE=$(git -C "$R/baseline" rev-parse HEAD)
cd "$R/library"
git fetch --no-tags "$R/baseline" "$BASE" > "$O/base-object.log" 2>&1
git merge-base --is-ancestor "$BASE" HEAD || { echo "the base is not an ancestor" > "$O/status.txt"; exit 1; }
{ for repo in library baseline mutator;do echo "$repo $(git -C "$R/$repo" rev-parse HEAD)";done;rustc -Vv;cargo -V;uname -m;grep -m1 -o -E 'avx512f|avx2' /proc/cpuinfo | sort -u | tr '\n' ' ';echo; } > "$O/identity.txt"
grep -c avx512f /proc/cpuinfo > /dev/null && echo "cpu: AVX-512" >> "$O/identity.txt" || echo "cpu: no AVX-512" >> "$O/identity.txt"
git diff --stat "$BASE" > "$O/change.stat"
: > "$O/steps.tsv"
step() { local name="$1"; shift; local start=$SECONDS; "$@" > "$O/$name.log" 2>&1; local rc=$?; printf '%s\trc=%s\t%ss\n' "$name" "$rc" "$((SECONDS-start))" >> "$O/steps.tsv"; }
CARGO_TARGET_DIR="$R/mutator-target" cargo install --locked --path "$R/mutator" --root "$R/mutator-install" > "$O/install-mutator.log" 2>&1
export PATH="$R/mutator-install/bin:$PATH"
CARGO_TARGET_DIR="$R/b3sum-target" cargo install --locked --version '=1.8.7' b3sum --root "$R/target/b3sum-official-1.8.7" > "$O/install-b3sum.log" 2>&1
export MUTANTS_B3SUM="$R/target/b3sum-official-1.8.7/bin/b3sum"
step fmt cargo fmt --check
step lib cargo nextest run --release --lib
step doc cargo test --release --doc
step tests cargo nextest run --release --tests
step vectors cargo nextest run --release --manifest-path test_vectors/Cargo.toml
step features cargo nextest run --features serde,zeroize
step builds sh tools/check-builds.sh
step tool-tests python3 -m unittest discover -s tools/mutants -p 'test_*.py'
step mutants python3 tools/mutants/check.py --since "$BASE"
step mutants-every python3 tools/mutants/check.py --since "$BASE" --every-mutant
git status --porcelain --untracked-files=all | grep -v -E '^\?\? tmp/(mutants-last/|mutants-diff-)' > "$O/final-source-status.txt"
cat "$O/steps.tsv"
if grep -v -q 'rc=0' "$O/steps.tsv"; then echo "gate: FAILED steps: $(grep -v 'rc=0' "$O/steps.tsv" | cut -f1 | tr '\n' ' ')" > "$O/status.txt"; exit 1; fi
test ! -s "$O/final-source-status.txt" || { echo "gate: the source tree changed" > "$O/status.txt"; exit 1; }
echo "gate: every step passed; functional evidence only, no speed verdict" > "$O/status.txt"
GATE
