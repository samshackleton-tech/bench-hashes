#!/bin/bash
set -euo pipefail
R="$1";O="$R/out";mkdir -p "$O";export HOME=/root;. /root/.cargo/env
{ date -u;uname -a;echo "library $(git -C "$R/library" rev-parse HEAD)"; } > "$O/identity.txt"
cd "$R/library"
timeout -k 5s 180s python3 - <<'PY' > "$O/model.log" 2>&1
import sys
sys.path.insert(0,'tools/verify')
import cross_check_x86 as check
check.FILES=('chunk_root',)
check.main()
PY
echo 'root block model done' > "$O/status.txt"
