#!/bin/bash
set -euo pipefail
R="$1"
mkdir -p "$R/out"
export HOME=/root
. /root/.cargo/env
export CARGO_TARGET_DIR="$R/target"
[ "$(uname -m)" = aarch64 ]
{
    echo "library $(git -C "$R/fork" rev-parse HEAD)"
    echo "base 597581e963b3b6a2eb3df96234339a99aec274cd"
    echo "bench $(git -C "$R/bench" rev-parse HEAD)"
    rustc -Vv
} > "$R/out/identity.txt"
cd "$R/bench"
timeout -k 5s 180s cargo build --release > "$R/out/build.log" 2>&1
timeout -k 5s 330s "$R/target/release/bench-hashes" check --fork "$R/fork" \
    --against 597581e963b3b6a2eb3df96234339a99aec274cd \
    --new 1d74d68667dce503e89c2399acdb20f630810871 --points 'turn 256' \
    > "$R/out/check.log" 2>&1
grep -F 'check: same code: the change alters nothing the bench runs here' "$R/out/check.log"
printf 'AArch64 canonical same-code gate complete\n' > "$R/out/status.txt"
