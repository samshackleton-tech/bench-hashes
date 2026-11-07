#!/bin/bash
set -euo pipefail
R="$1";O="$R/out";mkdir -p "$O";export HOME=/root;. /root/.cargo/env
cd "$R/fork";export CARGO_TARGET_DIR="$R/target"
echo "library $(git rev-parse HEAD)" > "$O/identity.txt"
cargo nextest run --features serde,zeroize --lib -E 'test(finalization_clones_the_core_only_for_a_pending_stage)' --no-capture > "$O/positive.log" 2>&1
old=$(printf '        if self.staged == 0 {\n            return self.core.final_output();\n        }')
replace src/incremental.rs "$old" '' > "$O/plant-replacement.log"
git diff > "$O/plant.diff"
if cargo nextest run --features serde,zeroize --lib -E 'test(finalization_clones_the_core_only_for_a_pending_stage)' --no-capture > "$O/negative.log" 2>&1;then
 echo 'deleted guard escaped clone counter' >&2;exit 1
fi
grep -F 'canonical len=0' "$O/negative.log"
echo 'clone guard fault control passed' > "$O/status.txt"
