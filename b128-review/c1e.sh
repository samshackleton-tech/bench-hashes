#!/bin/bash
# bench-hashes #128 / #117, the Xeon's 5 ms cost: C1E's or C6's? (run b128-c1e) Servil st and official at
# idle 64 B and idle 1 KiB (5 ms pauses) under three settings of every CPU's cpuidle states, in turn,
# 3 runs each: shipped (all on), C1E off alone (C6 on), C1E and C6 off (as the controlled block). Every
# disable file restored on exit (trap) and checked against the record taken first.
set -u
R="$1"; O="$R/out"; mkdir -p "$O"; cd "$R/bench"
export HOME=/root; . /root/.cargo/env
for f in /sys/devices/system/cpu/cpu*/cpuidle/state*/disable; do echo "$f $(cat $f)"; done > "$O/disable-before.txt"
restore() { while read -r f v; do echo "$v" > "$f"; done < "$O/disable-before.txt"; }
trap restore EXIT
setstates() { # names to switch off
  restore
  for d in /sys/devices/system/cpu/cpu*/cpuidle/state*; do
    n=$(cat $d/name); for off in "$@"; do [ "$n" = "$off" ] && echo 1 > $d/disable; done
  done
}
{ grep -m1 'model name' /proc/cpuinfo; nproc; echo "bench $(git rev-parse HEAD)"; cat /sys/devices/system/cpu/cpu0/cpuidle/state*/name | tr '\n' ' '; echo; } > "$O/machine.txt"
cargo build --release > "$O/build.log" 2>&1 || { echo "bench build failed" >> "$O/status.txt"; exit 2; }
for run in 1 2 3; do
  for c in shipped c1e-off c1e-c6-off; do
    case $c in shipped) setstates ;; c1e-off) setstates C1E ;; c1e-c6-off) setstates C1E C6 ;; esac
    for f in /sys/devices/system/cpu/cpu2/cpuidle/state*; do echo -n "$(cat $f/name)=$(cat $f/disable) "; done > "$O/states-$c-$run.txt"
    mkdir -p "$R/s-$c-$run" && cd "$R/s-$c-$run"
    "$R/bench/target/release/bench-hashes" --contenders blake3-servil-st,blake3-official --points "idle 64 B,idle 1 KiB" > "$O/run-$c-$run.out" 2> "$O/run-$c-$run.err"; echo "$c run $run exit $?" >> "$O/status.txt"
    cp benchmark-results/*/bench-hashes.samples.tsv "$O/run-$c-$run.samples.tsv" 2>/dev/null || echo "NO SAMPLES" >> "$O/status.txt"
    cd "$R/bench"
  done
done
restore
for f in /sys/devices/system/cpu/cpu*/cpuidle/state*/disable; do echo "$f $(cat $f)"; done > "$O/disable-after.txt"
cmp -s "$O/disable-before.txt" "$O/disable-after.txt" && echo "disable files restored" >> "$O/status.txt" || echo "DISABLE FILES CHANGED" >> "$O/status.txt"
echo "c1e done" >> "$O/status.txt"
