#!/bin/bash
set -euo pipefail
R="$1";O="$R/out";mkdir -p "$O";export HOME=/root;. /root/.cargo/env
{ date -u;uname -a;python3 --version;echo "library $(git -C "$R/library" rev-parse HEAD)"; } > "$O/identity.txt"
cd "$R/library"
timeout -k 5s 420s python3 tools/verify/prove_uniform.py --width 8 --blocks 1 2 16 --controls --workers 2 > "$O/proof.log" 2>&1
echo 'uniform proof8 done' > "$O/status.txt"
