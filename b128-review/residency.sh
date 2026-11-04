#!/bin/bash
# bench-hashes #128: what idle state the Xeon's CPU takes in 5 ms pauses (run b128-residency). Everything on
# CPU 2. For each: the kernel's cpuidle usage and time per state of CPU 2 (sysfs), and the core's hardware
# residency (perf stat -C 2, cstate_core c1/c6), before and after. Conditions, 3 times each in turn:
# A, 20 x 5 ms sleeps alone; B, 1000 x 20 us then 20 x 5 ms (as the header line measures); C, 200 x 5 ms;
# D, the bench's own cells idle 64 B and idle 1 KiB (servil st, taskset -c 2).
set -u
R="$1"; O="$R/out"; mkdir -p "$O"; cd "$R/bench"
export HOME=/root; . /root/.cargo/env
{ grep -m1 'model name' /proc/cpuinfo; echo "bench $(git rev-parse HEAD)"; cat /sys/devices/system/cpu/cpu2/cpuidle/state*/name | tr '\n' ' '; echo; cat /sys/devices/system/cpu/cpuidle/current_governor 2>/dev/null; } > "$O/machine.txt"
cargo build --release > "$O/build.log" 2>&1 || { echo "bench build failed" >> "$O/status.txt"; exit 2; }
cat > "$R/sleeps.py" <<'PY_SLEEPS_END'
import os, sys, time
os.sched_setaffinity(0, {2})
for spec in sys.argv[1:]:
    n, us = spec.split("x")
    for _ in range(int(n)):
        time.sleep(int(us) / 1e6)
PY_SLEEPS_END
snap() { for d in /sys/devices/system/cpu/cpu2/cpuidle/state*; do echo "$(cat $d/name) $(cat $d/usage) $(cat $d/time)"; done; }
measure() { # name, command...
  local name=$1; shift
  snap > "$O/$name.before"
  perf stat -x, -C 2 -e cstate_core/c1-residency/,cstate_core/c6-residency/,msr/tsc/ -o "$O/$name.perf" -- "$@" > "$O/$name.out" 2>&1
  echo "$name exit $?" >> "$O/status.txt"
  snap > "$O/$name.after"
}
for round in 1 2 3; do
  measure A-$round python3 "$R/sleeps.py" 20x5000
  measure B-$round python3 "$R/sleeps.py" 1000x20 20x5000
  measure C-$round python3 "$R/sleeps.py" 200x5000
  mkdir -p "$R/s-$round" && cd "$R/s-$round"
  measure D-$round taskset -c 2 "$R/bench/target/release/bench-hashes" --contenders blake3-servil-st --points "idle 64 B,idle 1 KiB"
  cd "$R/bench"
done
echo "residency done" >> "$O/status.txt"
