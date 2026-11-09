#!/bin/bash
set -euo pipefail
exec timeout -k 5s 480s bash -s -- "$1" <<'JOB'
set -euo pipefail
R="$1";mkdir -p "$R/out"
cd "$R/library"
{ echo "library $(git rev-parse HEAD)";echo "reference $(git -C "$R/reference" rev-parse HEAD)";clang --version;python3 -c 'import z3; print("Z3",z3.get_full_version())'; } > "$R/out/identity.txt"
for f in c/blake3_output8.S c/blake3_output16.S tools/gen_output8.py tools/verify/prove_output8.py;do cmp "$f" "$R/reference/$f";done
python3 tools/gen_output16.py | cmp - c/blake3_output16.S
python3 tools/gen_output8.py | cmp - c/blake3_output8.S
printf 'output8/16 kernels match existing candidate; generators agree\n' > "$R/out/generation.txt"
timeout -k 5s 90s python3 tools/verify/prove_output.py > "$R/out/output16-proof.log" 2>&1
timeout -k 5s 90s python3 tools/verify/prove_output8.py > "$R/out/output8-proof.log" 2>&1
timeout -k 5s 30s python3 -m unittest discover -s tools/verify -p test_long_proof_inputs.py -v > "$R/out/proof-inputs.log" 2>&1
timeout -k 5s 120s python3 tools/verify/cross_check_x86.py > "$R/out/cross-check.log" 2>&1
git status --porcelain > "$R/out/final-git-status.txt"
test ! -s "$R/out/final-git-status.txt"
printf 'independent next output proofs, eight rejecting controls, cache identities and native instruction models passed\n' > "$R/out/status.txt"
JOB
