#!/bin/bash
# bench-hashes #69, option (a) measured: the solo gap cells with the main thread unpinned (as 0.20
# runs) and pinned to CPU 0 (even) or CPU 1 (odd) around each sample (probe/sam-pin-solo,
# BENCH_PIN_SOLO_CPU). Servil st and official, the small cells and two idle controls, default rounds;
# 4 fresh runs a configuration, interleaved U P0 P1.
set -u
R="$1"; O="$R/out"; mkdir -p "$O"; cd "$R"
export HOME=/root; . /root/.cargo/env
{ grep -m1 'model name' /proc/cpuinfo; nproc; git -C bench log -1 --format='bench %H'; } > "$O/machine.txt"
(cd bench && cargo build --release) > "$O/build.log" 2>&1 || { echo "bench build failed" >> "$O/status.txt"; exit 2; }
E="$R/bench/target/release/bench-hashes"
P="64 B,128 B,256 B,512 B,1 KiB,4 KiB,1,2,4,6,8,64,1024,idle 64 B,idle 1"
for k in 1 2 3 4; do
  for c in U P0 P1; do
    D="$R/run-$c-$k"; mkdir -p "$D"; cd "$D"
    case $c in U) unset BENCH_PIN_SOLO_CPU;; P0) export BENCH_PIN_SOLO_CPU=0;; P1) export BENCH_PIN_SOLO_CPU=1;; esac
    "$E" --contenders blake3-servil-st,blake3-official --points "$P" > "$O/$c-$k.out" 2> "$O/$c-$k.err"
    echo "$c $k exit $?" >> "$O/status.txt"
    cp benchmark-results/*/bench-hashes.samples.tsv "$O/$c-$k.samples.tsv" || echo "$c $k NO SAMPLES" >> "$O/status.txt"
    unset BENCH_PIN_SOLO_CPU
    cd "$R"
  done
done
echo "pin done" >> "$O/status.txt"
