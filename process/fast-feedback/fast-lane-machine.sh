#!/bin/bash
# Complete the instrument's new-machine checks under the existing host lock.
set -euo pipefail
R="$1"
mkdir -p "$R/out"
export HOME=/root
. /root/.cargo/env
{
    echo "bench $(git -C "$R/bench" rev-parse HEAD)"
    rustc -V
    cargo nextest --version
    uname -m
    grep -m1 'model name' /proc/cpuinfo
    for f in /sys/bus/event_source/devices/power/events/energy-pkg /sys/bus/event_source/devices/power/cpumask; do
        [ ! -r "$f" ] || printf '%s: %s\n' "$f" "$(<"$f")"
    done
} > "$R/out/identity.txt"
cd "$R/bench"
timeout -k 5s 180s cargo nextest run --release -p clocks -P machine \
    --status-level all --success-output final > "$R/out/machine.log" 2>&1
printf 'fast-lane machine checks complete\n' > "$R/out/status.txt"
