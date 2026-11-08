#!/bin/bash
set -euo pipefail
R="$1"
mkdir -p "$R/out"
export HOME=/root
. /root/.cargo/env
export CARGO_TARGET_DIR="$R/target"
new=$(git -C "$R/fork" rev-parse HEAD)
printf 'library %s\nagainst 64ac019d4c65767f139429170fa8b85183d10ce4\nbench %s\n' "$new" "$(git -C "$R/bench" rev-parse HEAD)" > "$R/out/identity.txt"
cd "$R/bench"
timeout -k 5s 180s cargo build --release > "$R/out/build.log" 2>&1
timeout -k 5s 300s "$R/target/release/bench-hashes" check --fork "$R/fork" --against 64ac019d4c65767f139429170fa8b85183d10ce4 --new "$new" --points 'turn 256' > "$R/out/check.log" 2>&1
printf 'output16 integration aarch64 code gate complete\n' > "$R/out/status.txt"
