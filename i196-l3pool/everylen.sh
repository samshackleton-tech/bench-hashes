#!/bin/bash
# BLAKE3 #196: where should EVERY_LEN sit? probe/l3-pool (9c25ed9e) with EVERY_LEN at 8, 16, 32 (the
# probe's own), 64 MiB and never, each a commit with fixed metadata (made below, as
# mkvariants.sh does; the manifest names the hashes). Full runs of servil mt alone
# (--contenders blake3-servil-mt --expect-servil COMMIT), bench-hashes 0.19.6, 3 rounds, the
# variants' order rotated each round.
set -u
R="$1"; O="$R/out"; mkdir -p "$O"; cd "$R"
. /root/.cargo/env
{ date -u; grep -m1 'model name' /proc/cpuinfo; nproc; sort -u /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor
  echo "L3 domains: $(cat /sys/devices/system/cpu/cpu*/cache/index3/shared_cpu_list | sort -u | tr '\n' ' ')"
  git -C bench log -1 --format='%H %s' | cut -c1-100; git -C probe log -1 --format=%H; } > "$O/machine.txt"
for v in 8 16 32 64 never; do
  D="$R/every-$v"; git clone -q "$R/probe" "$D"; git -C "$D" checkout -q --detach 9c25ed9ef6b3cb12c2ca8c77955663feeb2f09fa
  # The source the run records is origin's URL: name the repository, not this local clone (a
  # path there makes the bench's map step panic after measuring: run 1 of this job).
  git -C "$D" remote set-url origin https://github.com/johnservil/BLAKE3
  if [ $v = never ]; then new='pub(crate) const EVERY_LEN: usize = usize::MAX;'; else new="pub(crate) const EVERY_LEN: usize = $v << 20;"; fi
  python3 - "$D/src/lanes.rs" "$new" <<'PY_END'
import sys
p, new = sys.argv[1], sys.argv[2]; s = open(p).read(); a = 'pub(crate) const EVERY_LEN: usize = 32 << 20;'
assert s.count(a) == 1, s.count(a)
open(p, 'w').write(s.replace(a, new))
PY_END
  if [ $v != 32 ]; then
    GIT_AUTHOR_NAME='Sam Shackleton' GIT_AUTHOR_EMAIL='samshackleton-tech@users.noreply.github.com' GIT_AUTHOR_DATE='2026-11-02T08:00:00+00:00' \
    GIT_COMMITTER_NAME='Sam Shackleton' GIT_COMMITTER_EMAIL='samshackleton-tech@users.noreply.github.com' GIT_COMMITTER_DATE='2026-11-02T08:00:00+00:00' \
      git -C "$D" -c core.hooksPath=/dev/null -c commit.gpgsign=false commit -q -am "Probe (#196) variant: EVERY_LEN $v MiB"
  fi
  echo "variant $v $(git -C "$D" rev-parse HEAD) $(grep 'const EVERY_LEN' "$D/src/lanes.rs")" >> "$O/machine.txt"
done
cd bench; cargo build --release > "$O/bench-build.log" 2>&1 || { echo "bench build failed" >> "$O/status.txt"; exit 2; }
X="$R/bench/target/release/bench-hashes"
for v in 8 16 32 64 never; do
  E=$($X build-against "$R/every-$v" 2> "$O/build-against-$v.err" | tail -1); [ -x "$E" ] || { echo "build-against $v failed" >> "$O/status.txt"; exit 3; }
  echo "$v $E $(git -C "$R/every-$v" rev-parse HEAD)" >> "$O/exes.txt"
done
[ "$(cut -d' ' -f2 "$O/exes.txt" | sort -u | wc -l)" = 5 ] || { echo "EXECUTABLES NOT DISTINCT" >> "$O/status.txt"; exit 3; }
for round in 1 2 3; do
  L="8 16 32 64 never"; [ $round = 2 ] && L="never 64 32 16 8"; [ $round = 3 ] && L="32 never 8 64 16"
  for v in $L; do
    read _ E C < <(grep "^$v " "$O/exes.txt")
    D="$R/scratch-$v-$round"; mkdir -p "$D"; cd "$D"
    s=$(date +%s); "$E" --contenders blake3-servil-mt --expect-servil "$C" > "$O/$v-$round.out" 2> "$O/$v-$round.err"
    echo "$v round $round exit $? $(( $(date +%s) - s )) s" >> "$O/status.txt"
    cp "$D"/benchmark-results/*/bench-hashes.samples.tsv "$O/$v-$round.samples.tsv" 2>/dev/null || echo "$v round $round: NO SAMPLES" >> "$O/status.txt"
    cp "$D"/benchmark-results/*/bench-hashes.result.txt "$O/$v-$round.result.txt" 2>/dev/null
  done
done
echo "everylen done" >> "$O/status.txt"
