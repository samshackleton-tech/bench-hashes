#!/bin/bash
set -euo pipefail
R="$1";O="$R/out";mkdir -p "$O";export HOME=/root;. /root/.cargo/env
{ date -u;uname -a;python3 --version;echo "library $(git -C "$R/library" rev-parse HEAD)"; } > "$O/identity.txt"
cd "$R/library"
timeout -k 5s 420s python3 tools/verify/prove_output8.py > "$O/proof.log" 2>&1
timeout -k 5s 120s python3 - <<'PY' > "$O/model.log" 2>&1
import sys
sys.path.insert(0,'tools/verify')
import cross_check_x86 as check
check.FILES=('output8',)
check.main()
PY
echo 'output8 proof and native model done' > "$O/status.txt"
