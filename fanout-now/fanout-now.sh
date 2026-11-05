#!/bin/bash
# BLAKE3 #198 at servil 06f6e26d: does the owed-wake cascade's cost on Ice Lake's mt ManyMessages 16384
# remain? The bisect (Oct 31) named 399a8f25; every wake direct (FANOUT 1024) gave the whole +7% back
# at the 0.8 tag. Arms, each against servil itself: FANOUT 1024, and FANOUT 8 (no change: the A/A).
# check --cells all builds both sides' layouts, then 32 pairs of the one cell. bench-hashes 0.20.4.
set -u
R="$1"; O="$R/out"; mkdir -p "$O"
. /root/.cargo/env
export PATH="$(rustc --print sysroot)/lib/rustlib/x86_64-unknown-linux-gnu/bin:$PATH"
export GIT_AUTHOR_NAME='Sam Shackleton' GIT_COMMITTER_NAME='Sam Shackleton' GIT_AUTHOR_EMAIL='samshackleton-tech@users.noreply.github.com' GIT_COMMITTER_EMAIL='samshackleton-tech@users.noreply.github.com'
T=06f6e26de800f7dec4e9d4af7d0b9b0ab571636a
{ grep -m1 'model name' /proc/cpuinfo; nproc; sort -u /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor; echo "src $(git -C "$R/src" rev-parse HEAD)"; echo "bench $(git -C "$R/bench" rev-parse HEAD)"; } > "$O/machine.txt"
for V in 1024 8; do
  d="$R/w-$V"; o="$O/fanout-$V"; mkdir -p "$o"
  git -C "$R/src" worktree add -q --detach "$d" $T || exit 2
  python3 - "$d/src/park.rs" "$V" <<'PY_FAN_END' || exit 3
import sys
p, v = sys.argv[1:3]; s = open(p).read(); a = "pub(crate) const FANOUT: usize = 8;"
assert s.count(a) == 1
open(p, "w").write(s.replace(a, f"pub(crate) const FANOUT: usize = {v};"))
PY_FAN_END
  git -C "$d" diff > "$o/patch.diff"
  [ "$V" = 8 ] || git -C "$d" commit -qam "job: FANOUT $V"
  git clone -q "$R/bench" "$d/bench-hashes" && git -C "$d/bench-hashes" checkout -q --detach "$(git -C "$R/bench" rev-parse HEAD)"
  cd "$d/bench-hashes"; CARGO_TARGET_DIR="$d/bench-target" cargo build --release > "$o/bench-build.log" 2>&1 || { echo "bench build failed" >> "$O/status.txt"; exit 4; }
  X="$d/bench-target/release/bench-hashes"
  "$X" check --fork "$d" --against $T --cells all > "$o/check.out" 2> "$o/check.err"; echo "fanout $V check exit $?" >> "$O/status.txt"
  OLD=$(find "$d" -type d -name old -path '*check*' | head -1); NEW=$(dirname "$OLD")/new
  echo "fanout $V builds $OLD $NEW" >> "$O/machine.txt"
  mapfile -t old < <(ls "$OLD" | grep -E '^bench-hashes-[0-9]+$' | sort -t- -k3 -n | sed "s|^|$OLD/|")
  mapfile -t new < <(ls "$NEW" | grep -E '^bench-hashes-[0-9]+$' | sort -t- -k3 -n | sed "s|^|$NEW/|")
  echo "fanout $V layouts ${#old[@]} ${#new[@]}" >> "$O/machine.txt"
  "$X" regress --contenders blake3-servil-mt --points 16384 --judge "blake3-servil-mt|solo|ManyMessages|16384" --pairs 32 --keep "$o/mm16384" "${old[@]}" -- "${new[@]}" > "$o/mm16384.out" 2>&1
  echo "fanout $V mm16384 exit $?" >> "$O/status.txt"
  cd "$R"
done
echo done >> "$O/status.txt"
