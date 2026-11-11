#!/bin/bash
# The branch's two other-compiler scripts, from nothing, on a machine with no Lean (BLAKE3 #361).
set -uo pipefail
R="$1";O="$R/out";mkdir -p "$O";export HOME=/root;. <home>/.cargo/env
export ELAN_HOME="$R/elan"; export PATH="$ELAN_HOME/bin:$PATH"
cd "$R/library"; { echo "library $(git rev-parse HEAD)"; nproc; } > "$O/identity.txt"
curl -sSf https://elan.lean-lang.org/elan-init.sh | sh -s -- -y --default-toolchain none --no-modify-path > "$O/elan.log" 2>&1
cd tools/verify/machine
s=$(date +%s); ./other_compiler.sh > "$O/detection.log" 2>&1 < /dev/null; echo "detection rc=$? $(( $(date +%s) - s )) s: $(tail -n 1 "$O/detection.log")" | tee "$O/results.txt"
s=$(date +%s); (cd one && lake build MergeSpec MergeAll > "$O/one-build.log" 2>&1 < /dev/null); echo "one's own build rc=$? $(( $(date +%s) - s )) s" | tee -a "$O/results.txt"
s=$(date +%s); one/other_compiler.sh > "$O/merge.log" 2>&1 < /dev/null; echo "merge rc=$? $(( $(date +%s) - s )) s: $(tail -n 1 "$O/merge.log")" | tee -a "$O/results.txt"
grep -c "rc=0" "$O/results.txt" | grep -q 3 && echo "other compilers checked" > "$O/status.txt"
