#!/bin/bash
# bench-hashes #127: Devon's clock_survey (candidate/devon-raw-clock) on this machine (run b127-survey):
# pinned to CPU 0, unpinned, and pinned to a second kind of CPU where there is one; with the kernel's
# perf settings recorded as they are (nothing changed).
set -u
R="$1"; O="$R/out"; mkdir -p "$O"; cd "$R"
. /root/.cargo/env
{ uname -a; uname -m; grep -m1 -E 'model name|CPU part' /proc/cpuinfo; nproc; rustc --version; echo "bench $(git -C bench rev-parse HEAD)"
  echo "perf_event_paranoid $(cat /proc/sys/kernel/perf_event_paranoid)"; for f in /sys/bus/event_source/devices/*/rdpmc; do echo "$f $(cat $f)"; done
  echo "clocksource $(cat /sys/devices/system/clocksource/clocksource0/current_clocksource)"; systemctl is-active chrony systemd-timesyncd ntp 2>/dev/null | tr '\n' ' '; echo; } > "$O/machine.txt" 2>&1
(cd bench && cargo build --release -p clocks --example clock_survey) > "$O/build.log" 2>&1 || { echo "build failed" >> "$O/status.txt"; exit 2; }
S=$(ls bench/target/release/examples/clock_survey)
taskset -c 0 "$S" 20 > "$O/clock-survey-pinned0.txt" 2>&1; echo "pinned0 exit $?" >> "$O/status.txt"
"$S" 20 > "$O/clock-survey-unpinned.txt" 2>&1; echo "unpinned exit $?" >> "$O/status.txt"
echo "survey done" >> "$O/status.txt"
