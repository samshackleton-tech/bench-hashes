#!/bin/bash
# The x86-64 half of the proofs on the tip: the generated kernels against their
# generators, the independent-output proofs (sixteen and eight lanes), every kind
# prove_x86.py declares, hash_many at every count, the models against this CPU,
# and the proof helpers' tests. Each step's exit is recorded; all run.
set -euo pipefail
exec timeout -k 15s 3400s bash -s -- "$1" <<'JOB'
set -uo pipefail
R="$1";O="$R/out";mkdir -p "$O";export HOME=/root;. <home>/.cargo/env
cd "$R/library"
{ echo "library $(git rev-parse HEAD)"; clang --version | head -n 1; python3 -c 'import z3; print("Z3", z3.get_full_version())'; echo "proof inputs $(git ls-tree HEAD -- c c2sp tools/verify tools/gen_x86.py tools/gen_output16.py tools/gen_output8.py | sha256sum | cut -c1-16)"; } > "$O/identity.txt" 2>&1
: > "$O/steps.tsv"
step() { local name="$1"; shift; local start=$SECONDS; "$@" > "$O/$name.log" 2>&1; printf '%s\trc=%s\t%ss\n' "$name" "$?" "$((SECONDS-start))" >> "$O/steps.tsv"; }
step generated sh -c 'python3 tools/gen_output16.py | cmp - c/blake3_output16.S && python3 tools/gen_output8.py | cmp - c/blake3_output8.S && python3 tools/gen_x86.py | cmp - c/blake3_partial_x86-64_unix.S'
step prove_output python3 tools/verify/prove_output.py
step prove_output8 python3 tools/verify/prove_output8.py
step cross_check_x86 python3 tools/verify/cross_check_x86.py
step helpers python3 -m unittest discover -s tools/verify -p 'test_*.py'
step prove_x86 python3 tools/verify/prove_x86.py
step prove_x86_loop sh -c 'ulimit -v 6291456; exec python3 tools/verify/prove_x86_loop.py'
git status --porcelain > "$O/final-git-status.txt"
cat "$O/steps.tsv"
if grep -v -q 'rc=0' "$O/steps.tsv"; then echo "proofs: FAILED steps: $(grep -v 'rc=0' "$O/steps.tsv" | cut -f1 | tr '\n' ' ')" > "$O/status.txt"; exit 1; fi
echo "proofs: every x86-64 step passed" > "$O/status.txt"
JOB
