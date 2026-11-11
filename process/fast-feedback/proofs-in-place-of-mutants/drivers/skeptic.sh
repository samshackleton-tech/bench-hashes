#!/bin/bash
# What a third party would do (BLAKE3 #361): with no Lean on the machine, install it, build the
# library, confirm Code.lean is its machine code, check the theorem; then the 25 changed instructions.
# Each step's time is recorded.
set -euo pipefail
R="$1";O="$R/out";mkdir -p "$O";export HOME=/root;. <home>/.cargo/env
export ELAN_HOME="$R/elan"; export PATH="$ELAN_HOME/bin:$PATH"
cd "$R/library"; { echo "library $(git rev-parse HEAD)"; rustc -V; nproc; } > "$O/identity.txt"
: > "$O/steps.txt"
step() { local n="$1"; shift; local s=$(date +%s.%N); "$@" > "$O/$n.log" 2>&1 < /dev/null; local rc=$?; echo "$n rc=$rc $(python3 -c "import sys,time; print(round(time.time()-float(sys.argv[1]),1))" "$s")s" >> "$O/steps.txt"; return $rc; }
step elan sh -c 'curl -sSf https://elan.lean-lang.org/elan-init.sh | sh -s -- -y --default-toolchain none --no-modify-path'
cd tools/verify/machine
step toolchain lake --version
step check sh check.sh
step check-again sh check.sh
step lake-clean-build sh -c 'rm -rf .lake && lake build'
step mutants python3 mutants.py
cp mutants.tsv "$O/" ; cat "$O/steps.txt"; tail -n 3 "$O/mutants.log"
du -sh "$ELAN_HOME" > "$O/sizes.txt"; wc -l *.lean >> "$O/sizes.txt"
echo "skeptic done" > "$O/status.txt"
