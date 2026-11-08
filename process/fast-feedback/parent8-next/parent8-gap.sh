#!/bin/bash
set -euo pipefail
R="$1";mkdir -p "$R/out";export HOME=/root;. /root/.cargo/env
export CARGO_TARGET_DIR="$R/target"
cd "$R/fork"
printf 'library %s\n' "$(git rev-parse HEAD)" > "$R/out/identity.txt"
set +e
timeout -k 5s 120s cargo nextest run --release --lib -E 'test(test_held_key_groups_take_one_partition_pass)' > "$R/out/test.log" 2>&1
status=$?
set -e
test "$status" = 100
grep -F 'eight-wide parent remainder: AVX512 n=2' "$R/out/test.log"
printf 'test-first existing parent remainder gap exposed\n' > "$R/out/status.txt"
