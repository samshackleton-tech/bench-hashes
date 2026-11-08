#!/bin/bash
set -euo pipefail
R="$1"
mkdir -p "$R/out"
export HOME=/root
. /root/.cargo/env
export CARGO_TARGET_DIR="$R/target"
BASE=fbfb319f3414ac7fac4b3d4bce266488a1fdee3b
BENCH=7ea20449cdc97540bfeecf35574b548d1a1f0d0d
NEW="$(git -C "$R/fork" rev-parse HEAD)"
test "$(git -C "$R/fork" rev-parse HEAD^)" = "$BASE"
test "$(git -C "$R/bench" rev-parse HEAD)" = "$BENCH"
git -C "$R/fork" fetch --no-tags "$R/base" "$BASE" > "$R/out/base-object.log" 2>&1
{ echo "library $NEW";echo "base $BASE";echo "bench $BENCH";echo "points $POINTS";rustc -Vv;uname -m;} > "$R/out/identity.txt"
cd "$R/bench"
timeout -k 5s 300s cargo build --release > "$R/out/build.log" 2>&1
set +e
timeout -k 10s 2400s "$R/target/release/bench-hashes" check --fork "$R/fork" --against "$BASE" --new "$NEW" --points "$POINTS" --keep "$R/out/gate-runs" > "$R/out/check.log" 2>&1
status=$?
set -e
printf '%s\n' "$status" > "$R/out/check-exit.txt"
case "$status" in
    0) printf 'fix check: no named cell slower\n' > "$R/out/status.txt" ;;
    1) printf 'fix check: REGRESSION\n' > "$R/out/status.txt" ;;
    2) printf 'fix check: verdict pending\n' > "$R/out/status.txt" ;;
    *) exit "$status" ;;
esac
