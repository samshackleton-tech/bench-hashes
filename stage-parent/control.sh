#!/bin/bash
set -euo pipefail
R="$1";O="$R/out";mkdir -p "$O";export HOME=/root;. /root/.cargo/env
cd "$R/fork";export CARGO_TARGET_DIR="$R/target"
echo "library $(git rev-parse HEAD)" > "$O/identity.txt"
cargo nextest run --features serde,zeroize --lib -E 'test(test_held_key_groups_take_one_partition_pass)' --no-capture > "$O/positive.log" 2>&1
replace src/each.rs 'if !others.is_empty() && crate::ffi_output::held_groups(hashers, held, platform)' 'if false && !others.is_empty() && crate::ffi_output::held_groups(hashers, held, platform)' > "$O/plant-replacement.log"
git diff > "$O/plant.diff"
if cargo nextest run --features serde,zeroize --lib -E 'test(test_held_key_groups_take_one_partition_pass)' --no-capture > "$O/negative.log" 2>&1;then
 echo 'recursive key grouping escaped actual partition counter' >&2;exit 1
fi
grep -F 'one held partition:' "$O/negative.log"
grep -F 'left: 2' "$O/negative.log"
echo 'one-pass held partition control passed; canonical and XOF checks preceded count assertion' > "$O/status.txt"
