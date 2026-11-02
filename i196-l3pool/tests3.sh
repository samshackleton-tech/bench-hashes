#!/bin/bash
# BLAKE3 #196 on the EPYC: is the probe's forked_child failure and its collect hang a caller in a
# domain with no worker? These tests start a pool of 2 threads (one worker) or fewer; with four L3
# domains, three have no worker. Each test 3 times with the whole run on CPU 0 (domain 0-5,24-29)
# and on CPU 12 (domain 12-17,36-41), for the probe (9c25ed9e) and servil (09d3bbc6).
set -u
R="$1"; O="$R/out"; mkdir -p "$O"; cd "$R"
. /root/.cargo/env
{ grep -m1 'model name' /proc/cpuinfo; git -C base log -1 --format=%H; git -C probe log -1 --format=%H; } > "$O/machine.txt"
grep -n "initialize_multithreaded" probe/tests/forked_child.rs probe/tests/stream_collect_parked_workers.rs probe/tests/stream_collect_one_worker.rs > "$O/pool-sizes.txt"
for v in probe base; do
  cd "$R/$v"; cargo nextest run --release --no-run > "$O/$v-build.log" 2>&1
  for cpu in 0 12; do
    for t in forked_child stream_collect_parked_workers stream_collect_one_worker; do
      for i in 1 2 3; do
        taskset -c $cpu cargo nextest run --release --test $t > "$O/$v-cpu$cpu-$t-$i.out" 2> "$O/$v-cpu$cpu-$t-$i.err"
        r=$(grep -oE "^\s+(PASS|FAIL|TIMEOUT) " "$O/$v-cpu$cpu-$t-$i.err" | head -1 | tr -d ' ')
        echo "$v cpu$cpu $t $i ${r:-NONE}" >> "$O/results.txt"
      done
    done
  done
done
echo "tests3 done" >> "$O/status.txt"
