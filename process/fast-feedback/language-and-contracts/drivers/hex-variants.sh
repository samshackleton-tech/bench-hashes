#!/bin/bash
# Ways for Hash::to_hex to make its string from the kernel, timed on this machine. Single runs: inventory.
set -euo pipefail
R="$1";O="$R/out";mkdir -p "$O";export HOME=/root;. <home>/.cargo/env
export CARGO_TARGET_DIR="$R/target"
{ echo "library $(git -C "$R/library" rev-parse HEAD)"; echo "crate $(git -C "$R/crate" rev-parse HEAD)"; rustc -V; uname -m; nproc; grep -m1 'model name' /proc/cpuinfo || true; } > "$O/identity.txt"
cd "$R/library/tools/verify/machine/hexbench"
cargo build --release --bin variants > "$O/build.log" 2>&1 < /dev/null
for i in 1 2 3; do "$R/target/release/variants" > "$O/run-$i.txt" 2>&1 < /dev/null; done
cat "$O/run-1.txt" "$O/run-3.txt"
grep -q "arithmetic" "$O/run-3.txt" && echo "variants read" > "$O/status.txt"
