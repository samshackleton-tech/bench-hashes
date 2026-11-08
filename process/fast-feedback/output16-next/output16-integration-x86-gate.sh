#!/bin/bash
set -euo pipefail
R="$1"
mkdir -p "$R/out"
export HOME=/root
. /root/.cargo/env
export CARGO_TARGET_DIR="$R/target"
new=$(git -C "$R/fork" rev-parse HEAD)
{
    echo "library $new"
    echo 'base 597581e963b3b6a2eb3df96234339a99aec274cd'
    echo "bench $(git -C "$R/bench" rev-parse HEAD)"
    rustc -Vv
} > "$R/out/identity.txt"
python3 - "$R/out/unsupported-point.txt" <<'PY'
from pathlib import Path
import sys
files = list(Path('/sys/devices/system/cpu').glob('cpu*/cpuidle/state*/disable'))
driver = Path('/sys/devices/system/cpu/cpuidle/current_driver').read_text().strip()
assert driver == 'none' and not files, (driver, files)
Path(sys.argv[1]).write_text('controlled idle turn 256 unavailable: cpuidle driver=none; zero state disable controls\n')
PY
cd "$R/bench"
timeout -k 5s 150s cargo build --release > "$R/out/build.log" 2>&1
# Fresh layouts and the standard automatic 64-pair suspect stage; AFK budget.
timeout -k 5s 3600s "$R/target/release/bench-hashes" check --fork "$R/fork" \
    --against 597581e963b3b6a2eb3df96234339a99aec274cd --new "$new" \
    --points '64 B,idle 64 B,1 KiB,1 MiB,interleaved 256,turn 256,idle turn 256,brief idle turn 256' \
    --keep "$R/out/gate-runs" > "$R/out/check.log" 2>&1
printf 'output16 integration supported x86 gate complete\n' > "$R/out/status.txt"
