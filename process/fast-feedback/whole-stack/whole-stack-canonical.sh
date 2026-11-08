#!/bin/bash
set -euo pipefail
R="$1"
mkdir -p "$R/out"
export HOME=/root
. /root/.cargo/env
export CARGO_TARGET_DIR="$R/target"
BASE=7ee5c1f8cfad7937fb490e6510f8f36fe5ce912f
NEW=4f1dd19c83122dfee2c62c1304eb593b812ee992
BENCH=9994de190259648ede82f7c5e4dbac4f1534a41d
test "$(git -C "$R/fork" rev-parse HEAD)" = "$NEW"
test "$(git -C "$R/base" rev-parse HEAD)" = "$BASE"
test "$(git -C "$R/bench" rev-parse HEAD)" = "$BENCH"
# Both source inputs come from the manifest's pinned private checkouts.
git -C "$R/fork" fetch --no-tags "$R/base" "$BASE" > "$R/out/base-object.log" 2>&1
{
    echo "library $NEW"
    echo "base $BASE"
    echo "bench $BENCH"
    rustc -Vv
    uname -m
} > "$R/out/identity.txt"
python3 - "$R/out/unsupported-point.txt" <<'PY'
from pathlib import Path
import sys
files=list(Path('/sys/devices/system/cpu').glob('cpu*/cpuidle/state*/disable'))
driver=Path('/sys/devices/system/cpu/cpuidle/current_driver').read_text().strip()
assert driver=='none'and not files,(driver,files)
Path(sys.argv[1]).write_text('controlled idle turn 256 not applicable: cpuidle driver=none; zero state disable controls\nEight named supported points only; the remaining canonical matrix is unmeasured.\n')
PY
cd "$R/bench"
timeout -k 5s 180s cargo build --release > "$R/out/build.log" 2>&1
# Reuse the canonical check unchanged, including its fresh layout/suspect stages.
# User is asleep; the complete gate may run longer than ten minutes.
timeout -k 5s 3600s "$R/target/release/bench-hashes" check --fork "$R/fork" \
    --against "$BASE" --new "$NEW" \
    --points '64 B,idle 64 B,1 KiB,1 MiB,interleaved 256,turn 256,idle turn 256,brief idle turn 256' \
    --keep "$R/out/gate-runs" > "$R/out/check.log" 2>&1
printf 'whole stack canonical eight-supported-point check complete\n' > "$R/out/status.txt"
