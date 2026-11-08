#!/bin/bash
set -euo pipefail
R="$1"
mkdir -p "$R/out"
export HOME=/root
. /root/.cargo/env
export CARGO_TARGET_DIR="$R/target"
{
    echo "library $(git -C "$R/fork" rev-parse HEAD)"
    echo "base 597581e963b3b6a2eb3df96234339a99aec274cd"
    echo "bench $(git -C "$R/bench" rev-parse HEAD)"
    rustc -Vv
    uname -m
} > "$R/out/identity.txt"
cd "$R/bench"
timeout -k 5s 150s cargo build --release > "$R/out/build.log" 2>&1
timeout -k 5s 360s "$R/target/release/bench-hashes" check --fork "$R/fork" \
    --against 597581e963b3b6a2eb3df96234339a99aec274cd \
    --new 1d74d68667dce503e89c2399acdb20f630810871 \
    --points '64 B,idle 64 B,1 KiB,1 MiB,interleaved 256,turn 256,idle turn 256,brief idle turn 256,controlled idle turn 256' \
    --keep "$R/out/gate-runs" > "$R/out/check.log" 2>&1
printf 'canonical x86 scoped gate complete\n' > "$R/out/status.txt"
