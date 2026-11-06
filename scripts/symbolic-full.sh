#!/bin/bash
set -euo pipefail
R="$1";O="$R/out";mkdir -p "$O";cd "$R/fork"
{ echo "library $(git rev-parse HEAD)";uname -a;python3 -c 'import z3; print("Z3",z3.get_version_string())'; } > "$O/identity.txt"
python3 -m unittest discover -s tools/verify -p 'test_*.py' > "$O/unit.log" 2>&1
python3 tools/verify/test_last_controls.py > "$O/controls.log" 2>&1
python3 tools/verify/prove_last.py --workers 8 > "$O/equal.log" 2>&1
timeout 480 python3 tools/verify/prove_last.py --workers 8 --symbolic > "$O/symbolic.log" 2>&1
echo 'symbolic matrix done' > "$O/status.txt"
