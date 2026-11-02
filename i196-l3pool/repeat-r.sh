#!/bin/bash
# BLAKE3 #196: probe/l3-pool-r (8381f8d9) ran small caller-thread calls 2-3x slower than servil in one
# job's two full runs, and level in another's two. Is it per process, and does it follow the main
# thread's CPU? Fresh processes, alternating: r x6, servil 68fd3e57 x3, full runs of servil mt, the
# main thread's CPU (/proc/PID/stat field 39) sampled every 0.1 s.
set -u
R="$1"; O="$R/out"; mkdir -p "$O"; cd "$R"
. /root/.cargo/env
{ grep -m1 'model name' /proc/cpuinfo; git -C r log -1 --format=%H; git -C base log -1 --format=%H; } > "$O/machine.txt"
cd "$R/bench"; cargo build --release > "$O/bench-build.log" 2>&1 || { echo "bench build failed" >> "$O/status.txt"; exit 2; }
for v in r base; do E=$(./target/release/bench-hashes build-against "$R/$v" 2> "$O/build-against-$v.err" | tail -1); [ -x "$E" ] || { echo "build-against $v failed" >> "$O/status.txt"; exit 3; }; echo "$v $E" >> "$O/exes.txt"; done
for i in 1 2 3 4 5 6 7 8 9; do
  case $i in 3|6|9) v=base ;; *) v=r ;; esac
  E=$(grep "^$v " "$O/exes.txt" | cut -d' ' -f2); C=$(git -C "$R/$v" rev-parse HEAD)
  D="$R/scratch-$i"; mkdir -p "$D"; cd "$D"
  "$E" --contenders blake3-servil-mt --expect-servil $C > "$O/run-$i-$v.out" 2> "$O/run-$i-$v.err" &
  P=$!
  while kill -0 $P 2>/dev/null; do awk '{print $39}' /proc/$P/stat 2>/dev/null; sleep 0.1; done > "$O/run-$i-$v.cpus"
  wait $P; echo "run $i $v exit $?" >> "$O/status.txt"
  cp "$D"/benchmark-results/*/bench-hashes.samples.tsv "$O/run-$i-$v.samples.tsv" 2>/dev/null || echo "run $i: NO SAMPLES" >> "$O/status.txt"
  cd "$R/bench"
done
echo "repeat done" >> "$O/status.txt"
