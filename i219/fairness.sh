#!/bin/bash
# tests/pool_fairness.rs two_callers_share_the_pool failed once on the AmpereOne (4 vCPUs, 1.62 >
# 1.5 at 16 MiB). Is it the machine or a change? The test 10 times at servil (base) and 10 at
# candidate/sam-counting-tests (counting), alternating, each a fresh process, its ratio printed.
set -u
# The machine quiet first: load average and any apt or unattended-upgrade process, recorded.
R="$1"; O="$R/out"; mkdir -p "$O"; cd "$R"
export HOME=/root; . /root/.cargo/env
{ uname -m; nproc; uptime; pgrep -fa "[u]nattended-upgrade|[a]pt-get|[d]pkg" || echo "no apt processes"; git -C base log -1 --format='base %H'; git -C counting log -1 --format='counting %H'; } > "$O/machine.txt"
for side in base counting; do
  (cd $side && CARGO_TARGET_DIR="$R/target-$side" cargo test --features serde,zeroize --test pool_fairness --no-run) > "$O/build-$side.log" 2>&1 || echo "build $side failed" >> "$O/status.txt"
done
for k in 1 2 3 4 5 6 7 8 9 10; do
  for side in base counting; do
    exe=$(ls -t "$R/target-$side"/debug/deps/pool_fairness-* | grep -v '\.d$' | head -1)
    out=$("$exe" --exact two_callers_share_the_pool --nocapture 2>&1 | grep -E "times the other|test result")
    echo "$side $k | $out" >> "$O/runs.txt"
  done
done
echo "fairness done" >> "$O/status.txt"
