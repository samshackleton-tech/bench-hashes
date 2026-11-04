#!/bin/bash
# bench-hashes #128 on this machine (run b128-review): the workspace's tests (nextest, release), then
# bench-hashes at the PR's head, servil st and official at the busy and two after-pause points, one
# run; the samples header's instrument lines (sample clock, effective idle states) and the cells.
set -u
R="$1"; O="$R/out"; mkdir -p "$O"; cd "$R/bench"
export HOME=/root; . /root/.cargo/env
{ uname -a; nproc; grep -m1 -E 'model name' /proc/cpuinfo || lscpu | grep -m1 'Model name'; rustc --version; echo "bench $(git rev-parse HEAD)"
  ls /sys/bus/event_source/devices/ | tr '\n' ' '; echo; cat /sys/devices/system/cpu/cpu0/cpuidle/state*/name 2>/dev/null | tr '\n' ' '; echo; } > "$O/machine.txt" 2>&1
cargo nextest --version > /dev/null 2>&1 || cargo install cargo-nextest --locked > "$O/nextest-install.log" 2>&1
cargo nextest run --release --workspace --no-fail-fast > "$O/tests.txt" 2>&1; echo "tests exit $?" >> "$O/status.txt"
cargo build --release > "$O/build.log" 2>&1 || { echo "bench build failed" >> "$O/status.txt"; exit 2; }
mkdir -p "$R/scratch" && cd "$R/scratch"
"$R/bench/target/release/bench-hashes" --contenders blake3-servil-st,blake3-official --points "64 B,brief idle 64 B,idle 64 B,1 KiB,brief idle 1 KiB,idle 1 KiB" > "$O/run.out" 2> "$O/run.err"; echo "run exit $?" >> "$O/status.txt"
cp benchmark-results/*/bench-hashes.samples.tsv "$O/run.samples.tsv" 2>/dev/null || echo "NO SAMPLES" >> "$O/status.txt"
grep '^#' "$O/run.samples.tsv" > "$O/header.txt" 2>/dev/null
echo "review done" >> "$O/status.txt"
