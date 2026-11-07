#!/bin/bash
set -euo pipefail
R="$1";O="$R/out";mkdir -p "$O";export HOME=/root;. /root/.cargo/env
{ date -u;uname -a;echo "library $(git -C "$R/library" rev-parse HEAD)"; } > "$O/identity.txt"
cd "$R/library"
timeout -k 5s 60s python3 -m unittest discover -s tools/verify -p test_x86_memory.py -v > "$O/units.log" 2>&1
echo 'uniform model units done' > "$O/status.txt"
