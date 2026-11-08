#!/bin/bash
set -euo pipefail
R="$1"
mkdir -p "$R/out"
cd "$R/fork"
{
    echo "library $(git rev-parse HEAD)"
    echo "reviewed $(git -C "$R/frozen" rev-parse HEAD)"
    python3 --version
    clang --version
} > "$R/out/identity.txt"
for file in c/blake3_output16.S tools/gen_output16.py tools/verify/prove_output.py; do
    cmp "$R/fork/$file" "$R/frozen/$file"
done
timeout -k 5s 90s python3 tools/verify/prove_output.py > "$R/out/proof.log" 2>&1
printf 'output16 current-harness proof and controls complete\n' > "$R/out/status.txt"
