#!/bin/bash
# BLAKE3 #196 on the EPYC: the probe failed forked_child and timed out in
# stream_collect_parked_workers. Control: servil (09d3bbc6, the probe's parent) alongside the probe
# (9c25ed9e): each one's whole suite once, then the two tests 5 times each.
set -u
R="$1"; O="$R/out"; mkdir -p "$O"; cd "$R"
. /root/.cargo/env
{ grep -m1 'model name' /proc/cpuinfo; nproc; git -C base log -1 --format=%H; git -C probe log -1 --format=%H; cargo nextest --version 2>&1 | head -1; } > "$O/machine.txt"
for v in base probe; do
  cd "$R/$v"
  cargo nextest run --release --no-fail-fast > "$O/$v-suite.out" 2> "$O/$v-suite.err"; echo "$v suite exit $?" >> "$O/status.txt"
  grep -E "^\s+(FAIL|TIMEOUT) |Summary" "$O/$v-suite.err" | sort -u >> "$O/$v-summary.txt"
  for i in 1 2 3 4 5; do
    cargo nextest run --release --no-fail-fast --test forked_child --test stream_collect_parked_workers > "$O/$v-two-$i.out" 2> "$O/$v-two-$i.err"; echo "$v two round $i exit $?" >> "$O/status.txt"
    grep -E "^\s+(PASS|FAIL|TIMEOUT) " "$O/$v-two-$i.err" | sed -E 's/\[[^]]*\]//; s/\([^)]*\)//' >> "$O/$v-two.txt"
  done
done
echo "tests2 done" >> "$O/status.txt"
