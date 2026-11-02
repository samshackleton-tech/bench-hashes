#!/bin/bash
# bench-hashes #115: on a two-socket machine, does 72869592 put each shared copy's input in its CPU's
# memory node? Bench a40c26db (before) against 69cda51d (the branch head, with 72869592), each built
# against its own checkout of the fork at 0.8 (one checkout would give both one build directory).
# --contenders blake3-servil-mt --points "lent 64 MiB", 3 rounds alternating, while a sampler reads
# /proc/PID/numa_maps every 0.2 s: each mapping of 16000 pages or more, its N0= and N1= pages.
set -u
R="$1"; O="$R/out"; mkdir -p "$O"; cd "$R"
. /root/.cargo/env
E=b5b988d8982bea9490c38c79ec4b8c5c2428270c
{ grep -m1 'model name' /proc/cpuinfo; nproc; ls -d /sys/devices/system/node/node* | wc -l; git -C old log -1 --format='%H %s' | cut -c1-80; git -C new log -1 --format='%H %s' | cut -c1-80; git -C fork-old log -1 --format=%H; git -C fork-new log -1 --format=%H; } > "$O/machine.txt"
for v in old new; do
  cd "$R/$v"; cargo build --release > "$O/$v-build.log" 2>&1 || { echo "$v build failed" >> "$O/status.txt"; exit 2; }
  X=$(./target/release/bench-hashes build-against "$R/fork-$v" 2> "$O/$v-build-against.err" | tail -1); [ -x "$X" ] || { echo "$v build-against failed" >> "$O/status.txt"; exit 3; }
  echo "$v $X" >> "$O/exes.txt"
done
[ "$(cut -d' ' -f2 "$O/exes.txt" | sort -u | wc -l)" = 2 ] || { echo "ONE EXECUTABLE FOR BOTH" >> "$O/status.txt"; exit 3; }
sampler() { # $1 pid, $2 file
  while kill -0 $1 2>/dev/null; do
    t=$(date +%s.%N)
    awk -v t="$t" '{n0=0; n1=0; tot=0; for (i=1;i<=NF;i++) { if ($i ~ /^N0=/) n0=substr($i,4); if ($i ~ /^N1=/) n1=substr($i,4); if ($i ~ /^anon=/) tot=substr($i,6) } if (n0+n1 >= 16000) print t, $1, n0, n1 }' /proc/$1/numa_maps 2>/dev/null
    sleep 0.2
  done > "$2"
}
for round in 1 2 3; do
  for v in old new; do
    X=$(grep "^$v " "$O/exes.txt" | cut -d' ' -f2)
    D="$R/scratch-$v-$round"; mkdir -p "$D"; cd "$D"
    "$X" --contenders blake3-servil-mt --points "lent 64 MiB" --expect-servil $E > "$O/$v-$round.out" 2> "$O/$v-$round.err" &
    P=$!; sampler $P "$O/$v-$round.numa" & S=$!
    wait $P; echo "$v round $round exit $?" >> "$O/status.txt"; wait $S
    cp "$D"/benchmark-results/*/bench-hashes.samples.tsv "$O/$v-$round.samples.tsv" 2>/dev/null || echo "$v round $round: NO SAMPLES" >> "$O/status.txt"
  done
done
grep -h "^# shared placements" "$O"/*-1.samples.tsv > "$O/placement-lines.txt"
echo "numa done" >> "$O/status.txt"
