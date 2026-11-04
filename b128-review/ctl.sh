#!/bin/bash
# bench-hashes #128's controlled block as root (run b128-ctl; Devon's ask): the cpuidle disable files
# before and after, the tests, then servil st and official at 64 B and 1 KiB busy, after 20 us, after
# 5 ms and controlled (5 ms, deep states off), 3 runs. (review.sh's head:)
# bench-hashes #128 on this machine (run b128-review): the workspace's tests (nextest, release), then
# bench-hashes at the PR's head, servil st and official at the busy and two after-pause points, one
# run; the samples header's instrument lines (sample clock, effective idle states) and the cells.
set -u
R="$1"; O="$R/out"; mkdir -p "$O"; cd "$R/bench"
export HOME=/root; . /root/.cargo/env
{ uname -a; nproc; grep -m1 -E 'model name' /proc/cpuinfo || lscpu | grep -m1 'Model name'; rustc --version; echo "bench $(git rev-parse HEAD)"
  ls /sys/bus/event_source/devices/ | tr '\n' ' '; echo; cat /sys/devices/system/cpu/cpu0/cpuidle/state*/name 2>/dev/null | tr '\n' ' '; echo; } > "$O/machine.txt" 2>&1
for f in /sys/devices/system/cpu/cpu*/cpuidle/state*/disable; do echo "$f $(cat $f)"; done > "$O/disable-before.txt" 2>/dev/null
cargo nextest --version > /dev/null 2>&1 || cargo install cargo-nextest --locked > "$O/nextest-install.log" 2>&1
cargo nextest run --release --workspace --no-fail-fast > "$O/tests.txt" 2>&1; echo "tests exit $?" >> "$O/status.txt"
cargo build --release > "$O/build.log" 2>&1 || { echo "bench build failed" >> "$O/status.txt"; exit 2; }
mkdir -p "$R/scratch" && cd "$R/scratch"
for run in 1 2 3; do
  mkdir -p "$R/scratch-$run" && cd "$R/scratch-$run"
  "$R/bench/target/release/bench-hashes" --contenders blake3-servil-st,blake3-official --points "64 B,brief idle 64 B,idle 64 B,controlled idle 64 B,1 KiB,brief idle 1 KiB,idle 1 KiB,controlled idle 1 KiB" > "$O/run-$run.out" 2> "$O/run-$run.err"; echo "run $run exit $?" >> "$O/status.txt"
  cp benchmark-results/*/bench-hashes.samples.tsv "$O/run-$run.samples.tsv" 2>/dev/null || echo "NO SAMPLES" >> "$O/status.txt"
  grep '^#' "$O/run-$run.samples.tsv" > "$O/header-$run.txt" 2>/dev/null
  for f in /sys/devices/system/cpu/cpu*/cpuidle/state*/disable; do echo "$f $(cat $f)"; done > "$O/disable-after-$run.txt" 2>/dev/null
  cmp -s "$O/disable-before.txt" "$O/disable-after-$run.txt" && echo "run $run disable files restored" >> "$O/status.txt" || echo "run $run DISABLE FILES CHANGED" >> "$O/status.txt"
done
echo "ctl done" >> "$O/status.txt"
