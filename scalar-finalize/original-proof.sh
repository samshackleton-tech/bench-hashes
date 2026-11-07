#!/bin/bash
set -euo pipefail
R="$1";O="$R/out";mkdir -p "$O";export HOME=/root;. /root/.cargo/env
{ date -u;uname -a;echo "library $(git -C "$R/library" rev-parse HEAD)"; } > "$O/identity.txt"
cd "$R/library"
timeout -k 5s 300s python3 tools/verify/prove_x86.py --workers 4 chunk_root > "$O/proof.log" 2>&1
echo 'original chunk root proofs done' > "$O/status.txt"
