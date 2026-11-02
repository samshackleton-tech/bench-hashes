#!/bin/bash
# BLAKE3 #196: probe/l3-pool's whole test suite on real multi-domain hardware (the EPYC's four L3
# domains, the Xeon pair's two sockets), and pool_domains and pool_fairness 5 times each.
set -u
R="$1"; O="$R/out"; mkdir -p "$O"; cd "$R"
. /root/.cargo/env
{ grep -m1 'model name' /proc/cpuinfo; nproc; echo "L3 domains: $(cat /sys/devices/system/cpu/cpu*/cache/index3/shared_cpu_list | sort -u | tr '\n' ' ')"; git -C probe log -1 --format=%H; cargo nextest --version 2>&1 | head -1; } > "$O/machine.txt"
cd probe
s=$(date +%s); cargo nextest run --release --no-fail-fast > "$O/suite.out" 2> "$O/suite.err"; echo "suite exit $? $(( $(date +%s) - s )) s" >> "$O/status.txt"
grep -E "Summary|FAIL|SIGSEGV|SIGABRT|TIMEOUT" "$O/suite.err" "$O/suite.out" | tail -20 > "$O/suite-summary.txt"
for i in 1 2 3 4 5; do
  cargo nextest run --release --test pool_domains --test pool_fairness > "$O/pool-$i.out" 2> "$O/pool-$i.err"; echo "pool round $i exit $?" >> "$O/status.txt"
done
grep -h "Summary" "$O"/pool-*.err > "$O/pool-summary.txt"
echo "tests done" >> "$O/status.txt"
