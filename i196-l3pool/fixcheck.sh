#!/bin/bash
# BLAKE3 #196: Sam's fix for a domain with no worker (de9cf6d0, on probe/l3-pool f1d391ea).
# 1. The whole suite once. 2. forked_child, stream_collect_one_worker, stream_collect_parked_workers
# and pool_domains_empty, 3 times each with the run on CPU 0 and on CPU 12 (the probe failed or hung
# on CPU 12 at 9c25ed9e). 3. A bench run of servil mt under taskset -c 12,13 and on every CPU.
# 4. check --fork FIX --against f1d391ea --cells all: does the fix cost speed?
set -u
R="$1"; O="$R/out"; mkdir -p "$O"; cd "$R"
. /root/.cargo/env
export PATH="$(rustc --print sysroot)/lib/rustlib/x86_64-unknown-linux-gnu/bin:$PATH"
PROBE=f1d391ea52627196aadb7b5f59e82279982ed45b
{ grep -m1 'model name' /proc/cpuinfo; nproc; echo "L3 domains: $(cat /sys/devices/system/cpu/cpu*/cache/index3/shared_cpu_list | sort -u | tr '\n' ' ')"
  git -C bench log -1 --format=%H; git -C fix log -1 --format=%H; git -C fix merge-base --is-ancestor $PROBE HEAD && echo "fix descends from probe"; } > "$O/machine.txt"
cd "$R/fix"
cargo nextest run --release --no-fail-fast > "$O/suite.out" 2> "$O/suite.err"; echo "suite exit $?" >> "$O/status.txt"
grep -E "^\s+(FAIL|TIMEOUT) |Summary" "$O/suite.err" | sort -u > "$O/suite-summary.txt"
for cpu in 0 12; do
  for t in forked_child stream_collect_one_worker stream_collect_parked_workers pool_domains_empty; do
    for i in 1 2 3; do
      taskset -c $cpu cargo nextest run --release --test $t > "$O/cpu$cpu-$t-$i.out" 2> "$O/cpu$cpu-$t-$i.err"
      r=$(grep -oE "^\s+(PASS|FAIL|TIMEOUT) " "$O/cpu$cpu-$t-$i.err" | head -1 | tr -d ' ')
      echo "cpu$cpu $t $i ${r:-NONE}" >> "$O/pinned.txt"
    done
  done
done
cd "$R/bench"; cargo build --release > "$O/bench-build.log" 2>&1 || { echo "bench build failed" >> "$O/status.txt"; exit 2; }
X="$R/bench/target/release/bench-hashes"
E=$($X build-against "$R/fix" 2> "$O/build-against.err" | tail -1); [ -x "$E" ] || { echo "build-against failed" >> "$O/status.txt"; exit 3; }
for cpus in 12,13 0-$(( $(nproc) - 1 )); do
  D="$R/scratch-$cpus"; mkdir -p "$D"; cd "$D"
  timeout 300 taskset -c $cpus "$E" --contenders blake3-servil-mt --points "1 MiB,continuous 1 MiB" > "$O/confined-$cpus.out" 2> "$O/confined-$cpus.err"
  echo "confined cpus $cpus exit $?" >> "$O/status.txt"
done
cd "$R/bench"
s=$(date +%s); $X check --fork ../fix --against $PROBE --cells all > "$O/check.out" 2> "$O/check.err"
echo "check exit $? $(( $(date +%s) - s )) s" >> "$O/status.txt"
echo "fixcheck done" >> "$O/status.txt"
