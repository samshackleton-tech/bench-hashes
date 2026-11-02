#!/bin/bash
# BLAKE3 #196: the Xeon pair's two slower cells for probe/l3-pool (ManyMessages 4 +3.1%, OneMessage
# 2 MiB +7.8% in check), on fresh pairs: regress, servil mt at points "4" and "2 MiB", 32 pairs,
# servil (09d3bbc6) against the probe (9c25ed9e), one build-against build a side.
set -u
R="$1"; O="$R/out"; mkdir -p "$O"; cd "$R"
. /root/.cargo/env
export PATH="$(rustc --print sysroot)/lib/rustlib/x86_64-unknown-linux-gnu/bin:$PATH"
{ grep -m1 'model name' /proc/cpuinfo; git -C bench log -1 --format=%H; git -C base log -1 --format=%H; git -C probe log -1 --format=%H; } > "$O/machine.txt"
cd "$R/bench"; cargo build --release > "$O/bench-build.log" 2>&1 || { echo "bench build failed" >> "$O/status.txt"; exit 2; }
X="$R/bench/target/release/bench-hashes"
EB=$($X build-against "$R/base" 2> "$O/build-against-base.err" | tail -1); [ -x "$EB" ] || { echo "build-against base failed" >> "$O/status.txt"; exit 3; }
EP=$($X build-against "$R/probe" 2> "$O/build-against-probe.err" | tail -1); [ -x "$EP" ] || { echo "build-against probe failed" >> "$O/status.txt"; exit 3; }
s=$(date +%s); $X regress --contenders blake3-servil-mt --points "4,2 MiB" --pairs 32 --keep "$O/kept" "$EB" -- "$EP" > "$O/regress.out" 2> "$O/regress.err"
echo "regress exit $? $(( $(date +%s) - s )) s" >> "$O/status.txt"
ls "$O/kept" | head -5 > "$O/kept-list.txt"
echo "xeon2 done" >> "$O/status.txt"
