#!/bin/bash
# bench-hashes #108: official st's 64 B stream pays x1.52 with a neighbour on the EPYC 9255
# (0.19.3 release run), servil st x1.00. Is it where the two copies run?
# bench a48ee6c7, its own contenders; official st and servil st, continuous 64 B and 4 KiB.
# Placements (the whole process confined with taskset): one core's SMT pair (0,24); two cores
# of one L3 domain (0,1); two cores of two domains (0,6); and free (no taskset), where a sampler
# reads which CPUs the duo-copy threads run on (/proc/PID/task/TID/stat, field 39) every 20 ms.
# 3 rounds, placements in rotated order.
set -u
R="$1"; O="$R/out"; mkdir -p "$O"; cd "$R"
. /root/.cargo/env
{ grep -m1 'model name' /proc/cpuinfo; nproc; sort -u /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor
  for c in 0 1 6 24; do echo "cpu$c core $(cat /sys/devices/system/cpu/cpu$c/topology/core_id) siblings $(cat /sys/devices/system/cpu/cpu$c/topology/thread_siblings_list) l3 $(cat /sys/devices/system/cpu/cpu$c/cache/index3/shared_cpu_list)"; done
  git -C bench log -1 --format='%H %s' | cut -c1-100; } > "$O/machine.txt"
cd bench; cargo build --release > "$O/bench-build.log" 2>&1 || { echo "bench build failed" >> "$O/status.txt"; exit 2; }
B="$R/bench/target/release/bench-hashes"
"$B" --list > "$O/list.txt" 2>&1
sampler() { # $1 pid, $2 file
  while kill -0 $1 2>/dev/null; do
    for t in /proc/$1/task/*; do
      n=$(cat $t/comm 2>/dev/null) || continue
      case $n in duo-copy-*) echo "$(date +%s%N) $n $(awk '{print $39}' $t/stat 2>/dev/null)";; esac
    done
    sleep 0.02
  done > "$2"
}
PL="smt:0,24 samel3:0,1 crossl3:0,6 free:"
for round in 1 2 3; do
  set -- $PL; [ $round = 2 ] && set -- $3 $4 $1 $2; [ $round = 3 ] && set -- $4 $2 $3 $1
  for p in "$@"; do
    name=${p%%:*}; cpus=${p#*:}; D="$R/run-$name-$round"; mkdir -p "$D"; cd "$D"
    if [ -n "$cpus" ]; then pre="taskset -c $cpus"; else pre=""; fi
    $pre "$B" --contenders blake3-official,blake3-servil-st --points "continuous 64 B,continuous 4 KiB" > "$O/$name-$round.out" 2> "$O/$name-$round.err" &
    P=$!
    [ "$name" = free ] && sampler $P "$O/free-$round.cpus" &
    wait $P; echo "$name round $round exit $?" >> "$O/status.txt"
    wait
    cp "$D"/benchmark-results/*/bench-hashes.samples.tsv "$O/$name-$round.samples.tsv" 2>/dev/null || echo "$name round $round: NO SAMPLES" >> "$O/status.txt"
  done
done
echo "place done" >> "$O/status.txt"
