#!/bin/bash
# bench-hashes #108: would the solo cells alone have caught #77? #77 (fork 5b05b6fe, reverted in
# fc9903b2) set the pool's longest piece to 1 MiB (was 128 KiB) and slowed servil mt's *shared*
# Collection "git objects" +6.2% on the i7. Re-applied to 0.8 (b5b988d8: src/lanes.rs,
# MAX_PIECE_LEN 128 -> 1024 chunks), judged by bench 0.19.3's check against the tag: a changed
# constant measures every servil cell, solo and shared.
set -u
R="$1"; O="$R/out"; mkdir -p "$O"; cd "$R"
. /root/.cargo/env
export PATH="$(rustc --print sysroot)/lib/rustlib/x86_64-unknown-linux-gnu/bin:$PATH"
E=b5b988d8982bea9490c38c79ec4b8c5c2428270c
{ grep -m1 'model name' /proc/cpuinfo; nproc; sort -u /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor
  git -C bench log -1 --format='%H %s' | cut -c1-100; git -C fork log -1 --format=%H; } > "$O/machine.txt"
python3 - fork/src/lanes.rs <<'PY_END'
import sys
p = sys.argv[1]; s = open(p).read(); a = 'const MAX_PIECE_LEN: usize = 128 * CHUNK_LEN;'
assert s.count(a) == 1, s.count(a)
open(p, 'w').write(s.replace(a, 'const MAX_PIECE_LEN: usize = 1024 * CHUNK_LEN;'))
PY_END
git -C fork diff --stat > "$O/diff.txt"; git -C fork diff >> "$O/diff.txt"
cd bench; cargo build --release > "$O/bench-build.log" 2>&1 || { echo "bench build failed" >> "$O/status.txt"; exit 2; }
s=$(date +%s)
./target/release/bench-hashes check --fork ../fork --against $E > "$O/check.out" 2> "$O/check.err"
echo "check exit $? $(( $(date +%s) - s )) s" >> "$O/status.txt"
git -C "$R/fork" checkout -q -- src/lanes.rs
echo "pr77 done" >> "$O/status.txt"
