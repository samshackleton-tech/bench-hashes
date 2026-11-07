#!/bin/bash
set -euo pipefail
R="$1";O="$R/out";mkdir -p "$O";export HOME=/root;. /root/.cargo/env
cd "$R/fork";export CARGO_TARGET_DIR="$R/target"
echo "library $(git rev-parse HEAD)" > "$O/identity.txt"
cargo nextest run --features serde,zeroize --lib -E 'test(clone_from_copies_only_the_live_stage_prefix)' --no-capture > "$O/positive.log" 2>&1
cat > "$R/old.txt" <<'OLD_EOF'
        let prefix = &source.stage[..source.staged];
        self.core.clone_from(&source.core);
        self.staged = source.staged;
        // The unused capacity is overwritten before it becomes input.
        self.stage[..prefix.len()].copy_from_slice(prefix);
OLD_EOF
cat > "$R/new.txt" <<'NEW_EOF'
        *self = source.clone();
NEW_EOF
replace -f src/incremental.rs "$R/old.txt" "$R/new.txt" > "$O/plant-replacement.log"
git diff > "$O/plant.diff"
if cargo nextest run --features serde,zeroize --lib -E 'test(clone_from_copies_only_the_live_stage_prefix)' --no-capture > "$O/negative.log" 2>&1;then
 echo 'full-capacity in-place clone escaped live-prefix canary' >&2;exit 1
fi
grep -F 'unused stage copied at len=0' "$O/negative.log"
echo 'in-place live-prefix work control passed; canonical source/destination assertions preceded canary' > "$O/status.txt"
