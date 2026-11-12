#!/bin/bash
# From nothing: the experiment branch's one command, with the audits.
set -euo pipefail
R="$1";O="$R/out";mkdir -p "$O";export HOME=/root;. <home>/.cargo/env
export ELAN_HOME="$R/elan"; export PATH="$ELAN_HOME/bin:$PATH"
cd "$R/library"; { echo "library $(git rev-parse HEAD)"; nproc; uname -m; grep -m1 'model name' /proc/cpuinfo || true; } > "$O/identity.txt"
curl -sSf https://elan.lean-lang.org/elan-init.sh | sh -s -- -y --default-toolchain none --no-modify-path > "$O/elan.log" 2>&1
cd tools/verify/machine
command -v llvm-objdump > /dev/null 2>&1 || export OBJDUMP=objdump
(cd one && lake build) > "$O/one.log" 2>&1 < /dev/null
AUDIT=1 JOBS="${JOBS:-6}" ./prove_all.sh > "$O/prove_all.txt" 2>&1 < /dev/null || true
cp prove_all.*.log "$O/" 2>/dev/null || true
# The index, made again here, beside the one in the tree.
( (cd lang && python3 ../index.py x86 > "$O/index-x86.md") && (cd arm && python3 ../index.py arm > "$O/index-arm.md") && python3 index.py join "$O/index-x86.md" "$O/index-arm.md" > "$O/INDEX.md" ) > "$O/index.log" 2>&1 < /dev/null || true
if cmp -s "$O/INDEX.md" INDEX.md; then echo "INDEX.md is what index.py writes here" > "$O/index.txt"; else echo "INDEX.md differs from what index.py writes here" > "$O/index.txt"; diff "$O/INDEX.md" INDEX.md >> "$O/index.txt" 2>&1 || true; fi
cat "$O/prove_all.txt"
grep -q "^all checked$" "$O/prove_all.txt" && echo "prove-all done" > "$O/status.txt"
