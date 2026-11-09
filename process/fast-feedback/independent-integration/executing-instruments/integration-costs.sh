#!/bin/bash
set -euo pipefail
exec timeout -k 5s 1200s bash -s -- "$1" <<'JOB'
set -euo pipefail
R="$1";export HOME=/root
. /root/.cargo/env
mkdir -p "$R/out"
S="$R/evidence/process/fast-feedback/ring-closure/r88/sampler-2355/mixed-stage-costs.sh"
CARGO_TARGET_DIR="$R/b3sum-target" cargo install --locked --version '=1.8.7' b3sum --root "$R/b3sum-install" > "$R/out/install-b3sum.log" 2>&1
python3 - "$S" "$R/b3sum-install/bin/b3sum" <<'PY'
from pathlib import Path
import hashlib,subprocess,sys
p=Path(sys.argv[1]);assert hashlib.sha256(p.read_bytes()).hexdigest()=='3a0595df2a83d2c2c42b5decf50ebad56449f26d82721ac3c32ba89cdd3782cb'
assert subprocess.check_output([sys.argv[2],'--no-names',str(p)],text=True).strip()=='835914929e9d8408c9db7bd316dfd0c8f0d65b44c73a2206579cddf8c6ee119b'
PY
test "${API_FAMILY:-}" = next
test "${PINNED_RUN_PREFLIGHT:-0}" = 0
bash "$S" "$R" > "$R/out/driver.log" 2>&1
JOB
