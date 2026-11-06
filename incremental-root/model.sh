#!/bin/bash
set -euo pipefail
R="$1";O="$R/out";mkdir -p "$O";export HOME=/root;. /root/.cargo/env
{ date -u;uname -a;grep -m1 'model name' /proc/cpuinfo;echo "library $(git -C "$R/library" rev-parse HEAD)"; } > "$O/identity.txt"
cd "$R/library"
timeout -k 5s 420s python3 tools/verify/cross_check_x86.py > "$O/model.log" 2>&1
echo 'root output native model done' > "$O/status.txt"
