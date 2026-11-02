#!/bin/bash
# BLAKE3 #196: does probe/l3-pool fail in ordinary use when the process may run on two CPUs of one
# domain (taskset -c 12,13, as a container's cpuset)? The default pool takes the CPUs the process
# may use; the probe spreads its workers over the domains sysfs names. A bench run of servil mt,
# one-shot 1 MiB and the 1 MiB stream, for servil (09d3bbc6) and the probe (9c25ed9e), with a
# 300 s limit each.
set -u
R="$1"; O="$R/out"; mkdir -p "$O"; cd "$R"
. /root/.cargo/env
{ grep -m1 'model name' /proc/cpuinfo; git -C bench log -1 --format=%H; git -C base log -1 --format=%H; git -C probe log -1 --format=%H; } > "$O/machine.txt"
cd bench; cargo build --release > "$O/bench-build.log" 2>&1 || { echo "bench build failed" >> "$O/status.txt"; exit 2; }
X="$R/bench/target/release/bench-hashes"
for v in base probe; do
  cd "$R/bench"  # build-against copies the bench from the current directory
  E=$($X build-against "$R/$v" 2> "$O/build-against-$v.err" | tail -1); [ -x "$E" ] || { echo "build-against $v failed" >> "$O/status.txt"; exit 3; }
  for cpus in 12,13 0-47; do
    D="$R/scratch-$v-$cpus"; mkdir -p "$D"; cd "$D"
    timeout 300 taskset -c $cpus "$E" --contenders blake3-servil-mt --points "1 MiB,continuous 1 MiB" > "$O/$v-$cpus.out" 2> "$O/$v-$cpus.err"
    echo "$v cpus $cpus exit $?" >> "$O/status.txt"
    grep -m2 "panicked\|thread '" "$O/$v-$cpus.err" >> "$O/status.txt"
  done
done
echo "confined done" >> "$O/status.txt"
