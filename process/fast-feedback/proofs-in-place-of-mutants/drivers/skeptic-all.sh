#!/bin/bash
# What a third party would do with the experiment branch (BLAKE3 #361): on a machine with no
# Lean, install it and check every experiment from nothing; then run each one's changed-instruction
# script. Each step's time is recorded.
set -euo pipefail
R="$1";O="$R/out";mkdir -p "$O";export HOME=/root;. <home>/.cargo/env
export ELAN_HOME="$R/elan"; export PATH="$ELAN_HOME/bin:$PATH"
cd "$R/library"; { echo "library $(git rev-parse HEAD)"; nproc; uname -m; grep -m1 'model name' /proc/cpuinfo || true; } > "$O/identity.txt"
: > "$O/steps.txt"
step() { local n="$1"; shift; local s=$(date +%s.%N); local rc=0; "$@" > "$O/$n.log" 2>&1 < /dev/null || rc=$?; echo "$n rc=$rc $(python3 -c "import sys,time; print(round(time.time()-float(sys.argv[1]),1))" "$s")s" >> "$O/steps.txt"; return 0; }
step elan sh -c 'curl -sSf https://elan.lean-lang.org/elan-init.sh | sh -s -- -y --default-toolchain none --no-modify-path'
cd tools/verify/machine
step toolchain sh -c 'lake --version'
for d in ${DIRS:-. loop call a64 gen hex eq alg kernel kernel512 wide one}; do
  n=$(echo "$d" | tr -d './'); n=${n:-detection}
  step "build-$n" sh -c "cd $d && lake build"
  grep -c "depends on axioms" "$O/build-$n.log" >> "$O/axiom-lines.txt" || true
  grep -h -E "sorryAx|error" "$O/build-$n.log" | head -n 3 >> "$O/problems.txt" || true
done
step all-again sh -c 'for d in ${DIRS:-. loop call a64 gen hex eq alg kernel kernel512 wide one}; do (cd $d && lake build) || exit 1; done'
for d in ${MUTANTS-loop a64}; do step "mutants-$d" sh -c "cd $d && python3 mutants.py"; tail -n 2 "$O/mutants-$d.log" >> "$O/mutants.txt"; done
wc -l */*.lean *.lean | tail -n 1 > "$O/sizes.txt"; du -sh "$ELAN_HOME" >> "$O/sizes.txt"
cat "$O/steps.txt"; cat "$O/mutants.txt"; test ! -s "$O/problems.txt" && echo "skeptic-all done" > "$O/status.txt"
