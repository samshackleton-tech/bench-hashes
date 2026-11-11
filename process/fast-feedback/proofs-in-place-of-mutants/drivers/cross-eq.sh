#!/bin/bash
# Experiment (BLAKE3 #361): the Lean model under hash_eq_is_equality (tools/verify/machine/eq/X86.lean)
# against this machine's processor, by the branch's own eq/cross.sh; Lean installed here first.
set -euo pipefail
R="$1";O="$R/out";mkdir -p "$O";export HOME=/root
export ELAN_HOME="$R/elan"; export PATH="$ELAN_HOME/bin:$PATH"
cd "$R/library"; { echo "library $(git rev-parse HEAD)"; nproc; grep -m1 'model name' /proc/cpuinfo || true; } > "$O/identity.txt"
curl -sSf https://elan.lean-lang.org/elan-init.sh | sh -s -- -y --default-toolchain none --no-modify-path > "$O/elan.log" 2>&1
cd tools/verify/machine/eq
CROSS_WORK="$R/cross" ./cross.sh > "$O/cross.log" 2>&1; rc=$?
tail -n 6 "$O/cross.log"; cp "$R/cross/wrong.out" "$O/" 2>/dev/null || true
test $rc -eq 0 && grep -q "cross-check done" "$O/cross.log" && echo "cross-check done" > "$O/status.txt"
