#!/bin/bash
# BLAKE3 #218: candidate/stream-abort (a panic in a stream ends the process; Drop for Stream reduced to
# an assertion) on x86: the fork's whole suite, and, where asked (CHECK=1), bench-hashes 0.20.0's
# check --fork CANDIDATE --against AGAINST (its servil parent) --cells all.
set -u
R="$1"; O="$R/out"; mkdir -p "$O"; cd "$R"
. /root/.cargo/env
export PATH="$(rustc --print sysroot)/lib/rustlib/x86_64-unknown-linux-gnu/bin:$PATH"
{ grep -m1 'model name' /proc/cpuinfo; nproc; git -C fork log -1 --format='%H %s' | cut -c1-120; git -C fork log --format='%H %s' -3 | cut -c1-100; } > "$O/machine.txt"
cd "$R/fork"; cargo nextest run --release --no-fail-fast > "$O/suite.out" 2> "$O/suite.err"; echo "suite exit $?" >> "$O/status.txt"
grep -E "^\s+(FAIL|TIMEOUT) |Summary" "$O/suite.err" | sort -u > "$O/suite-summary.txt"
if [ "${CHECK:-0}" = 1 ]; then
  cd "$R/bench"; cargo build --release > "$O/bench-build.log" 2>&1 || { echo "bench build failed" >> "$O/status.txt"; exit 2; }
  s=$(date +%s); ./target/release/bench-hashes check --fork ../fork --against "$AGAINST" --cells all > "$O/check.out" 2> "$O/check.err"
  echo "check exit $? $(( $(date +%s) - s )) s" >> "$O/status.txt"
fi
echo "i218 done" >> "$O/status.txt"
