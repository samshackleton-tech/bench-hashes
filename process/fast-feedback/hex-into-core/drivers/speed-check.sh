#!/bin/bash
# bench-hashes check, old next against the candidate, on one quiet host (CELLS=all: every cell).
# The check's own exit is the verdict (0 no regression, 1 regression, 2 no
# verdict, 3 a side stopped); the job records it and ends 0 when a verdict
# of 0 or 1 was reached.
set -euo pipefail
exec timeout -k 15s 7000s bash -s -- "$1" <<'JOB'
set -uo pipefail
R="$1";O="$R/out";mkdir -p "$O";. <home>/.cargo/env
export CARGO_TARGET_DIR="$R/target" TMPDIR="$R/check-tmp";mkdir -p "$TMPDIR"
OLD=$(git -C "$R/baseline" rev-parse HEAD)
git -C "$R/library" fetch --no-tags "$R/baseline" "$OLD" > "$O/base-object.log" 2>&1
{ for repo in library baseline bench;do echo "$repo $(git -C "$R/$repo" rev-parse HEAD)";done;rustc -Vv;uname -m; } > "$O/identity.txt"
POINTS="$(cat "$R/bench/../points.txt" 2>/dev/null || true)"
POINTS='interleaved 256,turn 256,turn 1024 x 1 KiB,idle turn 256,64 B,1 KiB,16 KiB,1 MiB,continuous 1 KiB,continuous batch 1024'
cd "$R/bench"
if [ "${CELLS:-}" = all ]; then
  cargo run --release --quiet -- check --fork "$R/library" --against "$OLD" --when-quiet --keep "$O/samples" --cells all > "$O/check.log" 2> "$O/check.stderr"
else
  cargo run --release --quiet -- check --fork "$R/library" --against "$OLD" --when-quiet --keep "$O/samples" --points "$POINTS" > "$O/check.log" 2> "$O/check.stderr"
fi
rc=$?
echo "check exit $rc: $(case $rc in 0) echo 'no regression';; 1) echo 'regression';; 2) echo 'no verdict';; 3) echo 'a side stopped';; *) echo 'error';; esac)" > "$O/status.txt"
tail -n 40 "$O/check.log"
case $rc in 0|1) exit 0;; *) exit 1;; esac
JOB
