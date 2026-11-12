#!/bin/bash
# From nothing: the NEON hex kernel against Google DeepMind's AArch64 model (the experiment branch's arm/check.sh).
set -euo pipefail
R="$1";O="$R/out";mkdir -p "$O";export HOME=/root;. <home>/.cargo/env
export ELAN_HOME="$R/elan"; export PATH="$ELAN_HOME/bin:$PATH"
cd "$R/library"; { echo "library $(git rev-parse HEAD)"; nproc; uname -m; grep -m1 'model name' /proc/cpuinfo || true; clang --version | head -n 1; } > "$O/identity.txt"
: > "$O/steps.txt"
step() { local n="$1"; shift; local s=$(date +%s.%N); local rc=0; "$@" > "$O/$n.log" 2>&1 < /dev/null || rc=$?; echo "$n rc=$rc $(python3 -c "import sys,time; print(round(time.time()-float(sys.argv[1]),1))" "$s") s" >> "$O/steps.txt"; return 0; }
step elan sh -c 'curl -sSf https://elan.lean-lang.org/elan-init.sh | sh -s -- -y --default-toolchain none --no-modify-path'
cd tools/verify/machine/arm
command -v llvm-objdump > /dev/null 2>&1 || export OBJDUMP=objdump
step check ./prove_arm.sh
step fn ./prove_arm_fn.sh
cp build.log "$O/build.log" 2>/dev/null || true
grep -h "rev\|url" lake-manifest.json > "$O/their-commit.txt" 2>/dev/null || true
cat "$O/steps.txt"; tail -n 3 "$O/check.log"
grep -q "the compiler's proof of hex_neon on Google's AArch64 model: checked" "$O/check.log" && grep -q "7 changes: 7 rejected" "$O/check.log" && grep -q "the compiler's proof of push (AArch64) on Google's model: checked" "$O/fn.log" && grep -q "push (AArch64) meets Push.byteContract, the contract the x86-64 code meets: checked" "$O/fn.log" && grep -q "18 instructions: 18 rejected" "$O/fn.log" && grep -q "5 false statements: 5 rejected" "$O/fn.log" && grep -q "b0f729accbc21a0413e7ca4e1da43fa45b5f2e1b" "$O/their-commit.txt" && echo "arm-skeptic done" > "$O/status.txt"
