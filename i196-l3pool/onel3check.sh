#!/bin/bash
# BLAKE3 #196: the probe's one-L3 cost (John's VM checks: servil mt streams 3-11% slower), on bare
# metal with one L3: the whole check confined to CPU 0's L3 domain (taskset). With Sam's fix (98c811c7,
# on 39218e26) the probe counts only the CPUs it may use, so it sees one domain and runs the one-L3
# path. check --fork FIX --against 09d3bbc6 --cells all, bench 0.19.7.
set -u
R="$1"; O="$R/out"; mkdir -p "$O"; cd "$R"
. /root/.cargo/env
export PATH="$(rustc --print sysroot)/lib/rustlib/x86_64-unknown-linux-gnu/bin:$PATH"
L3=$(cat /sys/devices/system/cpu/cpu0/cache/index3/shared_cpu_list)
{ grep -m1 'model name' /proc/cpuinfo; nproc; echo "confined to: $L3"; git -C bench log -1 --format=%H; git -C fix log -1 --format=%H; } > "$O/machine.txt"
cd "$R/bench"; cargo build --release > "$O/bench-build.log" 2>&1 || { echo "bench build failed" >> "$O/status.txt"; exit 2; }
s=$(date +%s); taskset -c "$L3" ./target/release/bench-hashes check --fork ../fix --against 09d3bbc6d07eedbf66545a35adfb6b5546445bc4 --cells all > "$O/check.out" 2> "$O/check.err"
echo "check exit $? $(( $(date +%s) - s )) s" >> "$O/status.txt"
echo "onel3 done" >> "$O/status.txt"
