#!/bin/bash
# bench-hashes #127 (Devon's ask, Nov 4): clocks' clock_survey on this machine, as he gives it:
# `cargo run --release -p clocks --example clock_survey 20`, once pinned to one core (CPU 2, taskset)
# and once unpinned, at candidate/devon-raw-clock (the manifest's commit). Beside it, what decides
# the clocks here: kernel, clock source, perf_event_paranoid, the time daemon's state.
set -u
R="$1"; O="$R/out"; mkdir -p "$O"; cd "$R/bench"
export HOME=/root; . /root/.cargo/env
{ uname -a; nproc; grep -m1 -E 'model name|Features' /proc/cpuinfo; lscpu | grep -E 'Model name|Vendor|Hypervisor|Virtualization type' ; rustc --version
  echo "clocksource $(cat /sys/devices/system/clocksource/clocksource0/current_clocksource) (available: $(cat /sys/devices/system/clocksource/clocksource0/available_clocksource))"
  echo "perf_event_paranoid $(cat /proc/sys/kernel/perf_event_paranoid)"
  echo "rdpmc $(cat /sys/bus/event_source/devices/cpu/rdpmc 2>/dev/null || echo n/a)"
  timedatectl show 2>/dev/null | grep -E 'NTP|Synchronized'; chronyc tracking 2>/dev/null | grep -E 'Frequency|Skew|System time' || true
  echo "bench $(git rev-parse HEAD)"; } > "$O/machine.txt" 2>&1
cargo build --release -p clocks --example clock_survey > "$O/build.log" 2>&1 || { echo "build failed" >> "$O/status.txt"; exit 2; }
E=$(ls target/release/examples/clock_survey)
taskset -c 2 "$E" 20 > "$O/clock-survey-pinned.txt" 2> "$O/clock-survey-pinned.err"; echo "pinned exit $?" >> "$O/status.txt"
"$E" 20 > "$O/clock-survey-unpinned.txt" 2> "$O/clock-survey-unpinned.err"; echo "unpinned exit $?" >> "$O/status.txt"
echo "survey done" >> "$O/status.txt"
