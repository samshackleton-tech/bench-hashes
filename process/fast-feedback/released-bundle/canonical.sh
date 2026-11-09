#!/bin/bash
set -euo pipefail
exec timeout -k 10s 11160s bash -s -- "$1" <<'JOB'
set -euo pipefail
R="$1"
mkdir -p "$R/out"
export HOME=/root
. /root/.cargo/env
export CARGO_TARGET_DIR="$R/target"
BASE="$(git -C "$R/base" rev-parse HEAD)"
NEW="$(git -C "$R/library" rev-parse HEAD)"
BENCH="$(git -C "$R/bench" rev-parse HEAD)"
for repo in base library bench;do test -z "$(git -C "$R/$repo" status --porcelain)";done
git -C "$R/library" fetch --no-tags "$R/base" "$BASE" > "$R/out/base-object.log" 2>&1
{ echo "library $NEW"; echo "base $BASE"; echo "bench $BENCH"; rustc -Vv; uname -m; } > "$R/out/identity.txt"
POINTS='continuous 64 B,continuous 128 B,continuous 256 B,continuous 512 B,continuous 1 KiB,continuous 4 KiB,continuous 16 KiB,continuous 64 KiB,continuous 256 KiB,continuous 1 MiB,continuous batch 16,continuous batch 64,continuous batch 1024,interleaved 256,turn 256,idle turn 256,brief idle turn 256,continuous collection git objects,continuous collection Nix files,receive saturated,receive 2 us,receive 20 us,merkle 65536,64 B,1 KiB'
printf '%s\n' "$POINTS" > "$R/out/points.txt"
cd "$R/bench"
timeout -k 5s 300s cargo build --release > "$R/out/build.log" 2>&1
# User approved the standard long gate. Do not override layout/pair counts.
set +e
timeout -k 10s 10800s "$R/target/release/bench-hashes" check --fork "$R/library" \
    --against "$BASE" --new "$NEW" --points "$POINTS" \
    --keep "$R/out/gate-runs" > "$R/out/check.log" 2>&1
status=$?
set -e
printf '%s\n' "$status" > "$R/out/check-exit.txt"
case "$status" in
 0) echo 'released bundle canonical check: no named cell slower' > "$R/out/status.txt" ;;
 1) echo 'released bundle canonical check: REGRESSION' > "$R/out/status.txt" ;;
 2) echo 'released bundle canonical check: verdict pending' > "$R/out/status.txt" ;;
 *) exit "$status" ;;
esac
for repo in library base;do git -C "$R/$repo" status --porcelain > "$R/out/final-$repo-status.txt";test ! -s "$R/out/final-$repo-status.txt";done
JOB
