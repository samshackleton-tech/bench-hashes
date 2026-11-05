#!/bin/bash
# bench-hashes #69, John Servil's ask: an A/A on the EPYC, pinned and unpinned, showing whether pinning
# (candidate/sam-pin-pairs) narrows the spread inside the check. 1) bench-hashes check of servil
# against itself, every cell (pinned: the new default), its builds kept. 2) On those builds, regress
# over the small cells after other work (where #69's parity lives) and controls, PINNED and UNPINNED in
# turn, 2 runs x 16 pairs each, every run kept: each cell's spread of pair log ratios, by mode.
set -u
R="$1"; O="$R/out"; mkdir -p "$O"
. /root/.cargo/env
export PATH="$(rustc --print sysroot)/lib/rustlib/x86_64-unknown-linux-gnu/bin:$PATH"
export GIT_AUTHOR_NAME='Sam Shackleton' GIT_COMMITTER_NAME='Sam Shackleton' GIT_AUTHOR_EMAIL='samshackleton-tech@users.noreply.github.com' GIT_COMMITTER_EMAIL='samshackleton-tech@users.noreply.github.com'
T=$(git -C "$R/fork" rev-parse HEAD)
{ date -u; grep -m1 'model name' /proc/cpuinfo; nproc; echo "library $T"; echo "bench $(git -C "$R/fork/bench" rev-parse HEAD)"; } > "$O/provenance.txt"
cd "$R/fork/bench"
cargo build --release > "$O/bench-build.log" 2>&1 || { echo "bench build failed" >> "$O/status.txt"; exit 2; }
X="$R/fork/bench/target/release/bench-hashes"
"$X" check --fork "$R/fork" --against $T --cells all --keep "$O/check" > "$O/check.out" 2> "$O/check.err"; rc=$?
echo "check exit $rc" >> "$O/status.txt"; case $rc in 0|1) echo "check verdict" >> "$O/status.txt";; esac
OLD=$(find "$R/fork" -type d -name old -path '*check*' | head -1); NEW=$(dirname "$OLD")/new
mapfile -t old < <(ls "$OLD" | grep -E '^bench-hashes-[0-9]+$' | sort -t- -k3 -n | sed "s|^|$OLD/|")
mapfile -t new < <(ls "$NEW" | grep -E '^bench-hashes-[0-9]+$' | sort -t- -k3 -n | sed "s|^|$NEW/|")
echo "layouts ${#old[@]} ${#new[@]} in $OLD" >> "$O/provenance.txt"
P="64 B,128 B,256 B,512 B,1,2,4,6,idle 64 B,1 MiB,1024"
for k in 1 2; do for mode in pinned unpinned; do
  flag=""; [ $mode = unpinned ] && flag="--unpinned"
  "$X" regress $flag --contenders blake3-servil-st,blake3-official --points "$P" --pairs 16 --keep "$O/$mode-$k" "${old[@]}" -- "${new[@]}" > "$O/$mode-$k.out" 2> "$O/$mode-$k.err"
  echo "regress $mode $k exit $?" >> "$O/status.txt"
done; done
echo "aa done" >> "$O/status.txt"
