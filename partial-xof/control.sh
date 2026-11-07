#!/bin/bash
set -euo pipefail
R="$1";O="$R/out";mkdir -p "$O";export HOME=/root;. /root/.cargo/env
cd "$R/fork";export CARGO_TARGET_DIR="$R/target"
echo "library $(git rev-parse HEAD)" > "$O/identity.txt"
cargo nextest run --features serde,zeroize --lib -E 'test(test_fill_computes_each_block_once)' --no-capture > "$O/positive.log" 2>&1
replace src/lib.rs 'if !self.cache_valid {' 'if !self.cache_valid || self.cache_valid {' > "$O/plant-replacement.log"
git diff > "$O/plant.diff"
cargo nextest run --features serde,zeroize --lib -E 'test(test_xof_clone_and_empty_fill)' --no-capture > "$O/byte-control.log" 2>&1
if cargo nextest run --features serde,zeroize --lib -E 'test(test_fill_computes_each_block_once)' --no-capture > "$O/negative.log" 2>&1;then
 echo 'forced cache miss escaped actual RootBlock counter' >&2;exit 1
fi
grep -F 'the rest of that block is cached' "$O/negative.log"
echo 'partial XOF cache work control passed; independent golden byte control passed' > "$O/status.txt"
