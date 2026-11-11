#!/bin/bash
# The audit of merge's proof at the branch's head, on a machine with no Lean (BLAKE3 #361): build one/,
# then change one instruction of merge at a time and require the build of its theorem to fail.
set -uo pipefail
R="$1";O="$R/out";mkdir -p "$O";export HOME=/root;. <home>/.cargo/env
export ELAN_HOME="$R/elan"; export PATH="$ELAN_HOME/bin:$PATH"
cd "$R/library"; { echo "library $(git rev-parse HEAD)"; nproc; } > "$O/identity.txt"
curl -sSf https://elan.lean-lang.org/elan-init.sh | sh -s -- -y --default-toolchain none --no-modify-path > "$O/elan.log" 2>&1
cd tools/verify/machine/one
s=$(date +%s); lake build > "$O/build.log" 2>&1 < /dev/null; echo "build rc=$? $(( $(date +%s) - s )) s" | tee "$O/results.txt"
s=$(date +%s); python3 mutants_merge.py --jobs 4 > "$O/mutants.log" 2>&1 < /dev/null; echo "mutants rc=$? $(( $(date +%s) - s )) s: $(tail -n 1 "$O/mutants.log")" | tee -a "$O/results.txt"
grep -q "build rc=0" "$O/results.txt" && grep -q "changed instructions" "$O/results.txt" && echo "merge audited" > "$O/status.txt"
