#!/bin/bash
set -euo pipefail
R="$1"
mkdir -p "$R/out"
cd "$R/fork"
printf 'library %s\n' "$(git rev-parse HEAD)" > "$R/out/identity.txt"
clang --version >> "$R/out/identity.txt"
timeout -k 5s 90s python3 tools/verify/prove_output.py > "$R/out/output16-proof.log" 2>&1
timeout -k 5s 90s python3 tools/verify/prove_output8.py > "$R/out/output8-proof.log" 2>&1
timeout -k 5s 30s python3 -m unittest discover -s tools/verify -p test_long_proof_inputs.py -v > "$R/out/proof-inputs.log" 2>&1
printf 'output8 and output16 proof controls complete\n' > "$R/out/status.txt"
