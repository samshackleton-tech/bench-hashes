#!/bin/bash
# bench-hashes #115 at 69cda51d (placed copies, inputs on their nodes, every shared sample contended,
# bench-hashes crowd), on a two-cache machine: 1. bench-hashes crowd at its defaults (one program a
# CPU), built against the fork at 0.8; 2. an A/A check of every cell, the fork against its own tree.
set -u
R="$1"; O="$R/out"; mkdir -p "$O"; cd "$R"
. /root/.cargo/env
export PATH="$(rustc --print sysroot)/lib/rustlib/x86_64-unknown-linux-gnu/bin:$PATH"
E=b5b988d8982bea9490c38c79ec4b8c5c2428270c
{ grep -m1 'model name' /proc/cpuinfo; nproc; sort -u /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor; git -C bench log -1 --format='%H %s' | cut -c1-90; git -C fork log -1 --format=%H; } > "$O/machine.txt"
cd "$R/bench"; cargo build --release > "$O/bench-build.log" 2>&1 || { echo "bench build failed" >> "$O/status.txt"; exit 2; }
X="$R/bench/target/release/bench-hashes"
EXE=$($X build-against "$R/fork" 2> "$O/build-against.err" | tail -1); [ -x "$EXE" ] || { echo "build-against failed" >> "$O/status.txt"; exit 3; }
mkdir -p "$R/scratch"; cd "$R/scratch"
s=$(date +%s); timeout 1800 "$EXE" crowd > "$O/crowd.out" 2> "$O/crowd.err"; echo "crowd exit $? $(( $(date +%s) - s )) s" >> "$O/status.txt"
find "$R/scratch" -name 'crowd.samples.tsv' -exec cp {} "$O/" \;
cd "$R/bench"
s=$(date +%s); $X check --fork ../fork --against $E --cells all > "$O/aa.out" 2> "$O/aa.err"
echo "aa exit $? $(( $(date +%s) - s )) s" >> "$O/status.txt"
echo "aa-head done" >> "$O/status.txt"
