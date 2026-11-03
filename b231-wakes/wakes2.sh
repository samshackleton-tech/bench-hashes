#!/bin/bash
# BLAKE3 servil, the wake-count test on AVX-512 (run wakes-wide): lanes'
# test_a_job_wakes_one_worker_a_piece_past_its_own at servil and at the fix (fix/sam-wakes-wide),
# then the fix's whole suite (nextest, --lib --tests, features serde,zeroize). Each checkout its own
# target directory (wakes-wide's first runs shared one, and cargo, which hashes no member's path,
# ran base's test binary for the fix's).
set -u
R="$1"; O="$R/out"; mkdir -p "$O"; cd "$R"
export HOME=/root; . /root/.cargo/env
{ nproc; grep -m1 'model name' /proc/cpuinfo; grep -o -w avx512f /proc/cpuinfo | sort -u; rustc --version; for v in base fix; do echo "$v $(git -C $v log -1 --format=%H)"; done; } > "$O/machine.txt" 2>&1
for v in base fix; do
  (cd $v && CARGO_TARGET_DIR="$R/target-$v" cargo test --features serde,zeroize --lib test_a_job_wakes_one_worker_a_piece_past_its_own) > "$O/test-$v.txt" 2>&1
  echo "test $v exit $?" >> "$O/status.txt"
done
(cd fix && CARGO_TARGET_DIR="$R/target-fix" cargo nextest run --features serde,zeroize --lib --tests) > "$O/nextest-fix.txt" 2>&1; echo "nextest fix exit $?" >> "$O/status.txt"
echo "wakes done" >> "$O/status.txt"
