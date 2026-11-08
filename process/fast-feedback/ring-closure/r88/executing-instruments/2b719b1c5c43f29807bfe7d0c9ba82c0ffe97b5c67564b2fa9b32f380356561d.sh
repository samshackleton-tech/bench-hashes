#!/bin/bash
set -euo pipefail
R="$1"
mkdir -p "$R/out"
export HOME=/root
. /root/.cargo/env
export CARGO_TARGET_DIR="$R/target"
BASE=fbfb319f3414ac7fac4b3d4bce266488a1fdee3b
NEW=fe60dc85bdb81c55163667dc78e18573765bc6cf
BENCH=7ea20449cdc97540bfeecf35574b548d1a1f0d0d
test "$(git -C "$R/fork" rev-parse HEAD)" = "$NEW"
test "$(git -C "$R/base" rev-parse HEAD)" = "$BASE"
test "$(git -C "$R/bench" rev-parse HEAD)" = "$BENCH"
git -C "$R/fork" fetch --no-tags "$R/base" "$BASE" > "$R/out/base-object.log" 2>&1
{
    echo "library $NEW"
    echo "base $BASE"
    echo "bench $BENCH"
    rustc -Vv
    uname -m
} > "$R/out/identity.txt"
# The ring carries stream tasks: every stream-fed contender's named cells,
# short to long continuous messages, batches, pipelined collections and the
# three receiving schedules. The rest of the matrix stays unmeasured here.
POINTS='continuous 64 B,continuous 128 B,continuous 256 B,continuous 1 KiB,continuous 4 KiB,continuous 64 KiB,continuous 256 KiB,continuous 1 MiB,continuous batch 64,continuous batch 1024,continuous collection git objects,continuous collection Nix files,receive saturated,receive 2 us,receive 20 us'
printf '%s\n' "$POINTS" > "$R/out/points.txt"
cd "$R/bench"
timeout -k 5s 300s cargo build --release > "$R/out/build.log" 2>&1
# The canonical check unchanged: fresh layouts, paired stages and its own
# busy-machine verdict. The user approved a run longer than ten minutes.
set +e
timeout -k 10s 5400s "$R/target/release/bench-hashes" check --fork "$R/fork" \
    --against "$BASE" --new "$NEW" --points "$POINTS" \
    --keep "$R/out/gate-runs" > "$R/out/check.log" 2>&1
status=$?
set -e
printf '%s\n' "$status" > "$R/out/check-exit.txt"
case "$status" in
    0) printf 'ring canonical scoped check: no named cell slower\n' > "$R/out/status.txt" ;;
    1) printf 'ring canonical scoped check: REGRESSION\n' > "$R/out/status.txt" ;;
    2) printf 'ring canonical scoped check: verdict pending\n' > "$R/out/status.txt" ;;
    *) exit "$status" ;;
esac
