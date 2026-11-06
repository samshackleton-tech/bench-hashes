#!/bin/bash
set -euo pipefail
R="$1"; O="$R/out"; mkdir -p "$O"; cd "$R/fork"
{ echo "library $(git rev-parse HEAD)"; uname -a; python3 -c 'import z3; print("Z3",z3.get_version_string())'; } > "$O/identity.txt"
python3 -m unittest discover -s tools/verify -p test_x86_memory.py > "$O/unit.log" 2>&1
python3 tools/verify/cross_check_x86.py > "$O/cpu.log" 2>&1
python3 tools/verify/prove_last.py --workers 1 16:3:5 > "$O/proof.log" 2>&1
echo 'model check done' > "$O/status.txt"
