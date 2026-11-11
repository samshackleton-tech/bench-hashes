#!/bin/bash
# Experiment (BLAKE3 #361): the Lean instruction model of the two one-block kernels against this
# machine's CPU (kernel512/cross.sh of the experiment branch), with its control.
set -euo pipefail
R="$1";O="$R/out";mkdir -p "$O";export HOME=/root;. <home>/.cargo/env
export ELAN_HOME="$R/elan"; export PATH="$ELAN_HOME/bin:$PATH"
cd "$R/library"; { echo "library $(git rev-parse HEAD)"; grep -m1 'model name' /proc/cpuinfo; grep -o -w -E 'avx512f|avx512vl' /proc/cpuinfo | sort -u | tr '\n' ' '; echo; } > "$O/identity.txt"
curl -sSf https://elan.lean-lang.org/elan-init.sh | sh -s -- -y --default-toolchain none --no-modify-path > "$O/elan.log" 2>&1
cd tools/verify/machine/kernel512
s=$SECONDS; CROSS_WORK="$R/work" sh cross.sh > "$O/cross.log" 2>&1 < /dev/null || true
echo "cross-check $((SECONDS-s))s" > "$O/steps.txt"
tail -n 6 "$O/cross.log"; grep -q "cross-check done" "$O/cross.log" && echo "cross experiment done" > "$O/status.txt"
