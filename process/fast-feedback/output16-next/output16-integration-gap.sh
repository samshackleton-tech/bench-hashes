#!/bin/bash
set -euo pipefail
R="$1"
mkdir -p "$R/out"
export HOME=/root
. /root/.cargo/env
export CARGO_TARGET_DIR="$R/target"
printf 'library %s\n' "$(git -C "$R/fork" rev-parse HEAD)" > "$R/out/identity.txt"
cd "$R/fork"
timeout -k 5s 120s cargo nextest run --release --lib -E 'test(incremental_roots_batch_all_modes_and_selected_indices)' > "$R/out/test.log" 2>&1
printf 'output16 integration index test complete\n' > "$R/out/status.txt"
