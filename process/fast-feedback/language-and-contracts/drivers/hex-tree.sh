#!/bin/bash
# From nothing: the candidate's in-tree proof folder for the hash's hexadecimal (tools/verify/hex/prove.sh).
set -euo pipefail
R="$1";O="$R/out";mkdir -p "$O";export HOME=/root;. <home>/.cargo/env
export ELAN_HOME="$R/elan"; export PATH="$ELAN_HOME/bin:$PATH"
cd "$R/library"; { echo "library $(git rev-parse HEAD)"; nproc; uname -m; grep -m1 'model name' /proc/cpuinfo || true; clang --version | head -n 1; } > "$O/identity.txt"
: > "$O/steps.txt"
step() { local n="$1"; shift; local s=$(date +%s.%N); local rc=0; "$@" > "$O/$n.log" 2>&1 < /dev/null || rc=$?; echo "$n rc=$rc $(python3 -c "import sys,time; print(round(time.time()-float(sys.argv[1]),1))" "$s") s" >> "$O/steps.txt"; return 0; }
step elan sh -c 'curl -sSf https://elan.lean-lang.org/elan-init.sh | sh -s -- -y --default-toolchain none --no-modify-path'
cd tools/verify/hex
command -v llvm-objdump > /dev/null 2>&1 || export OBJDUMP=objdump
step shipped ./check-shipped.sh
step x86 env JOBS=8 ./x86/prove.sh
step arm ./arm/prove.sh
find . -name '*.lean' -not -path '*/.lake/*' | xargs wc -l | tail -n 1 > "$O/lines.txt"
grep -h "rev\|url" arm/lake-manifest.json > "$O/their-commit.txt" 2>/dev/null || true
cat "$O/steps.txt"; tail -n 2 "$O/x86.log" "$O/arm.log"
grep -q "hex on x86-64: checked" "$O/x86.log" && grep -q "10 changed instructions: 10 rejected" "$O/x86.log" && grep -q "17 false statements: 17 rejected" "$O/x86.log" && grep -q "hex on AArch64: checked" "$O/arm.log" && grep -q "7 changes: 7 rejected" "$O/arm.log" && ! grep -q "NOT" "$O/shipped.log" && echo "hex-tree done" > "$O/status.txt"
