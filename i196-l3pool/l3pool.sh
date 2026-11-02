#!/bin/bash
# BLAKE3 #196: John's L3-domain pool (probe/l3-pool 9c25ed9e) against servil (09d3bbc6, its parent;
# the library is identical to 0b9f40d7's), with bench-hashes 0.19.6.
# 1. check --fork PROBE --against 09d3bbc6 --cells all (every cell, solo and shared).
# 2. Full runs of servil mt alone (--contenders blake3-servil-mt), 2 rounds in rotated order:
#    servil free; servil with the whole process confined to CPU 0's L3 domain (the one-domain
#    speed, as i196's table); the probe free.
set -u
R="$1"; O="$R/out"; mkdir -p "$O"; cd "$R"
. /root/.cargo/env
export PATH="$(rustc --print sysroot)/lib/rustlib/x86_64-unknown-linux-gnu/bin:$PATH"
BASE=09d3bbc6d07eedbf66545a35adfb6b5546445bc4
PROBE=9c25ed9ef6b3cb12c2ca8c77955663feeb2f09fa
L3=$(cat /sys/devices/system/cpu/cpu0/cache/index3/shared_cpu_list)
{ date -u; grep -m1 'model name' /proc/cpuinfo; nproc; uname -r; sort -u /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor
  echo "L3 domains: $(cat /sys/devices/system/cpu/cpu*/cache/index3/shared_cpu_list | sort -u | tr '\n' ' ')"; echo "cpu0's L3: $L3"
  git -C bench log -1 --format='%H %s' | cut -c1-100; git -C base log -1 --format=%H; git -C probe log -1 --format=%H; git -C probe merge-base --is-ancestor $BASE HEAD && echo "probe descends from base"; } > "$O/machine.txt"
cd bench; cargo build --release > "$O/bench-build.log" 2>&1 || { echo "bench build failed" >> "$O/status.txt"; exit 2; }
X="$R/bench/target/release/bench-hashes"
step() { n=$1; shift; s=$(date +%s); "$@"; echo "$n exit $? $(( $(date +%s) - s )) s" >> "$O/status.txt"; }
step check $X check --fork ../probe --against $BASE --cells all > "$O/check.out" 2> "$O/check.err"
git checkout -q -- index.html 2>/dev/null
EB=$($X build-against ../base 2> "$O/build-against-base.err" | tail -1); [ -x "$EB" ] || { echo "build-against base failed" >> "$O/status.txt"; exit 3; }
EP=$($X build-against ../probe 2> "$O/build-against-probe.err" | tail -1); [ -x "$EP" ] || { echo "build-against probe failed" >> "$O/status.txt"; exit 3; }
[ "$EB" != "$EP" ] || { echo "ONE EXECUTABLE FOR BOTH" >> "$O/status.txt"; exit 3; }
echo "base exe $EB" >> "$O/machine.txt"; echo "probe exe $EP" >> "$O/machine.txt"
for round in 1 2; do
  L="servil-free servil-onel3 probe-free"; [ $round = 2 ] && L="probe-free servil-onel3 servil-free"
  for c in $L; do
    D="$R/scratch-$c-$round"; mkdir -p "$D"; cd "$D"
    case $c in
      servil-free) cmd=("$EB" --contenders blake3-servil-mt --expect-servil $BASE) ;;
      servil-onel3) cmd=(taskset -c "$L3" "$EB" --contenders blake3-servil-mt --expect-servil $BASE) ;;
      probe-free) cmd=("$EP" --contenders blake3-servil-mt --expect-servil $PROBE) ;;
    esac
    step "$c round $round" "${cmd[@]}" > "$O/$c-$round.out" 2> "$O/$c-$round.err"
    cp "$D"/benchmark-results/*/bench-hashes.samples.tsv "$O/$c-$round.samples.tsv" 2>/dev/null || echo "$c round $round: NO SAMPLES" >> "$O/status.txt"
    cp "$D"/benchmark-results/*/bench-hashes.result.txt "$O/$c-$round.result.txt" 2>/dev/null
  done
done
echo "l3pool done" >> "$O/status.txt"
