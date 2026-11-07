#!/bin/bash
set -euo pipefail
R="$1";O="$R/out";mkdir -p "$O";export HOME=/root;. /root/.cargo/env
{ date -u;uname -a;python3 --version;echo "library $(git -C "$R/library" rev-parse HEAD)"; } > "$O/identity.txt"
cd "$R/library"
timeout -k 5s 240s python3 tools/verify/prove_root_block.py > "$O/proof.log" 2>&1
echo 'root block proof controls done' > "$O/status.txt"
