#!/bin/bash
# bench-hashes #116: bench-hashes crowd (69cda51d) twice more, the fork at 0.8, to check the Xeon pair's
# official mt 64 KiB collapse (5.6 GB/s for 112 programs) before anyone quotes it.
set -u
R="$1"; O="$R/out"; mkdir -p "$O"; cd "$R"
. /root/.cargo/env
{ grep -m1 'model name' /proc/cpuinfo; nproc; git -C bench log -1 --format=%H; git -C fork log -1 --format=%H; } > "$O/machine.txt"
cd "$R/bench"; cargo build --release > "$O/bench-build.log" 2>&1 || { echo "bench build failed" >> "$O/status.txt"; exit 2; }
EXE=$(./target/release/bench-hashes build-against "$R/fork" 2> "$O/build-against.err" | tail -1); [ -x "$EXE" ] || { echo "build-against failed" >> "$O/status.txt"; exit 3; }
for i in 1 2; do mkdir -p "$R/s$i"; cd "$R/s$i"; timeout 900 "$EXE" crowd > "$O/crowd-$i.out" 2> "$O/crowd-$i.err"; echo "crowd $i exit $?" >> "$O/status.txt"; done
echo "crowd2 done" >> "$O/status.txt"
