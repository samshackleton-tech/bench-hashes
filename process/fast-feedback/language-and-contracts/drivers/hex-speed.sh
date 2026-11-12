#!/bin/bash
# The hex kernels beside the library's own to_hex at a named commit: do they agree (a million hashes), and
# what does a call take? Single runs: inventory, no speed verdict.
set -euo pipefail
R="$1";O="$R/out";mkdir -p "$O";export HOME=/root;. <home>/.cargo/env
export CARGO_TARGET_DIR="$R/target"
{ echo "library $(git -C "$R/library" rev-parse HEAD)"; echo "crate $(git -C "$R/crate" rev-parse HEAD)"; rustc -V; uname -m; nproc; grep -m1 'model name' /proc/cpuinfo || true; } > "$O/identity.txt"
cd "$R/library/tools/verify/machine/hexbench"
cargo build --release > "$O/build.log" 2>&1 < /dev/null
for i in 1 2 3; do "$R/target/release/hexbench" > "$O/run-$i.txt" 2>&1 < /dev/null; done
cat "$O/run-1.txt" "$O/run-2.txt" "$O/run-3.txt"
grep -q "1000000 hashes: 0 differ" "$O/run-1.txt" && grep -q "pass 2" "$O/run-3.txt" && echo "hex speed read" > "$O/status.txt"
