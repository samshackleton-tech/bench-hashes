#!/bin/bash
set -euo pipefail
R="$1";O="$R/out";mkdir -p "$O";export HOME=/root;. /root/.cargo/env
export CARGO_TARGET_DIR="$R/target"
OLD=$(git -C "$R/base" rev-parse HEAD)
NEW=$(git -C "$R/fork" rev-parse HEAD)
{ date -u;uname -a;grep -m1 'model name' /proc/cpuinfo;rustc --version;echo "base $OLD";echo "fork $NEW";echo "bench $(git -C "$R/bench" rev-parse HEAD)"; } > "$O/identity.txt"
cd "$R/bench"
set +e
cargo run --release -- check --fork "$R/fork" --against "$OLD" --new "$NEW" --points 'collection git objects,collection Nix files' --layouts 4 --keep "$O/check" > "$O/check.out" 2> "$O/check.err"
rc=$?
set -e
printf 'check exit %s\n' "$rc" > "$O/status.txt"
[ "$rc" -le 2 ] || exit "$rc"
echo 'requested collection check done' >> "$O/status.txt"
