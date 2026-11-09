#!/bin/bash
set -euo pipefail
exec timeout -k 10s 1200s bash -s -- "$1" <<'JOB'
set -euo pipefail
R="$1"
export HOME=/root
. /root/.cargo/env
S="$R/evidence/process/fast-feedback/ring-closure/r88/sampler-2355/mixed-stage-costs.sh"
mkdir -p "$R/out"
# Source byte identity was dual-hash checked when the immutable distribution
# was published; the pinned repository and this expected SHA select it here.
python3 - "$S" <<'PY'
from pathlib import Path
import hashlib,sys
p=Path(sys.argv[1]);assert hashlib.sha256(p.read_bytes()).hexdigest()=='3a0595df2a83d2c2c42b5decf50ebad56449f26d82721ac3c32ba89cdd3782cb'
PY
test "${API_FAMILY:-}" = main
test "${PINNED_RUN_PREFLIGHT:-0}" = 0
bash "$S" "$R" > "$R/out/driver.log" 2>&1
JOB
