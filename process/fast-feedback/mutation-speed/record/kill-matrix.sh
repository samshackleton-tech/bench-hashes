#!/bin/bash
# Every test on every mutant of the whole library (check.py --whole --map --whole-suite):
# the record of which tests catch which mutants, and each test's time. No speed claim.
set -euo pipefail
exec timeout -k 30s 2700s bash -s -- "$1" <<'KILL_MATRIX'
set -euo pipefail
R="$1"; O="$R/out"; mkdir -p "$O"; . <home>/.cargo/env
export CARGO_TARGET_DIR="$R/target" TMPDIR="$R/private-tmp"; mkdir -p "$TMPDIR"
{ for name in library mutator; do printf '%s %s\n' "$name" "$(git -C "$R/$name" rev-parse HEAD)"; done; rustc -V; cargo -V; uname -sm; lscpu | grep -E '^(Model name|CPU\(s\)|Thread|Core|Socket)'; } > "$O/identity.txt"
CARGO_TARGET_DIR="$R/mutator-target" cargo install --locked --path "$R/mutator" --root "$R/mutator-install" > "$O/install-mutator.log" 2>&1
export PATH="$R/mutator-install/bin:$PATH"
test "$(cargo mutants --version)" = 'cargo-mutants 27.1.0'
CARGO_TARGET_DIR="$R/b3sum-target" cargo install --locked --version '=1.8.7' b3sum --root "$R/target/b3sum-official-1.8.7" > "$O/install-b3sum.log" 2>&1
export MUTANTS_B3SUM="$R/target/b3sum-official-1.8.7/bin/b3sum"
cd "$R/library"
cargo fetch > "$O/fetch.log" 2>&1
cat > "$R/shards.py" <<'KILL_MATRIX_SHARDS_PY'
# Experiment-only entry: the unmodified check.py on more shards than its whole run's six.
import sys
n=int(sys.argv[1]);sys.argv=['tools/mutants/check.py',*sys.argv[2:]]
sys.path.insert(0,'tools/mutants')
import check
check.SHARDS=n
defaults=list(check.run.__defaults__);assert defaults[1]==6;defaults[1]=n;check.run.__defaults__=tuple(defaults)
check.main()
KILL_MATRIX_SHARDS_PY
date -u +%FT%TZ > "$O/started.txt"
set +e
python3 "$R/shards.py" 16 --whole --map --whole-suite > "$O/check.log" 2> "$O/check.stderr"; s=$?
set -e
date -u +%FT%TZ > "$O/finished.txt"; echo "$s" > "$O/check-exit.txt"
for d in tmp/mutants-last/*; do
 label=$(basename "$d")
 if [ -f "$d/tests.tsv" ]; then gzip -c "$d/tests.tsv" > "$O/tests-$label.tsv.gz"; fi
 for shard in "$d"/shard*; do if [ -f "$shard/outcomes.json" ]; then gzip -c "$shard/outcomes.json" > "$O/outcomes-$label-$(basename "$shard").json.gz"; fi; done
done
git status --porcelain --untracked-files=no > "$O/final-source-status.txt"
test -s "$O/tests-map.tsv.gz" || test -s "$O/tests-run.tsv.gz"
printf 'kill matrix collected (check exit %s); every test on every mutant; no speed claim\n' "$s" > "$O/status.txt"
KILL_MATRIX
