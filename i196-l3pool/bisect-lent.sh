#!/bin/bash
# BLAKE3 #196: probe/l3-pool-r (8381f8d9) reads servil mt's lent batches of 16 to 4096 messages 3x
# slower than servil 68fd3e57 on the EPYC. Which commit of the rebased chain? Each checkout below
# (c0 ... c7: 7b3c2e29 7a043707 a419c6a2 23f20940 dc467ac8 e0717747 8381f8d9, then servil 68fd3e57)
# built against with bench 0.19.7, then --contenders blake3-servil-mt --points "lent batch 16,
# lent batch 1024,continuous batch 1024", 2 rounds.
set -u
R="$1"; O="$R/out"; mkdir -p "$O"; cd "$R"
. /root/.cargo/env
{ grep -m1 'model name' /proc/cpuinfo; for c in c0 c1 c2 c3 c4 c5 c6 c7; do echo "$c $(git -C $c log -1 --format='%H %s' | cut -c1-100)"; done; } > "$O/machine.txt"
cd "$R/bench"; cargo build --release > "$O/bench-build.log" 2>&1 || { echo "bench build failed" >> "$O/status.txt"; exit 2; }
for c in c0 c1 c2 c3 c4 c5 c6 c7; do
  E=$(./target/release/bench-hashes build-against "$R/$c" 2> "$O/build-against-$c.err" | tail -1); [ -x "$E" ] || { echo "build-against $c failed" >> "$O/status.txt"; exit 3; }
  echo "$c $E" >> "$O/exes.txt"
done
[ "$(cut -d' ' -f2 "$O/exes.txt" | sort -u | wc -l)" = 8 ] || { echo "EXECUTABLES NOT DISTINCT" >> "$O/status.txt"; exit 3; }
for round in 1 2; do
  for c in c0 c1 c2 c3 c4 c5 c6 c7; do
    E=$(grep "^$c " "$O/exes.txt" | cut -d' ' -f2); C=$(git -C "$R/$c" rev-parse HEAD)
    D="$R/scratch-$c-$round"; mkdir -p "$D"; cd "$D"
    "$E" --contenders blake3-servil-mt --points "lent batch 16,lent batch 1024,continuous batch 1024" --expect-servil $C > "$O/$c-$round.out" 2> "$O/$c-$round.err"
    echo "$c round $round exit $?" >> "$O/status.txt"
    cp "$D"/benchmark-results/*/bench-hashes.samples.tsv "$O/$c-$round.samples.tsv" 2>/dev/null || echo "$c round $round: NO SAMPLES" >> "$O/status.txt"
  done
  cd "$R/bench"
done
echo "bisect done" >> "$O/status.txt"
