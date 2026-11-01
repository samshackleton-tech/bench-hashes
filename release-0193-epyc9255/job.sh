#!/bin/bash
# bench-hashes 0.19.3 release runs on this machine (CONTRIBUTING "Releases", step 4), the fork at
# BLAKE3-Servil 0.8 (b5b988d8): the same-library check; the full run (build-against, then
# --all --expect-servil, from a scratch directory); the b3sum run (LAYOUTS=4, files on this disk);
# the map of the folder they wrote.
set -u
R="$1"; O="$R/out"; mkdir -p "$O"; cd "$R"
. /root/.cargo/env
export PATH="$(rustc --print sysroot)/lib/rustlib/x86_64-unknown-linux-gnu/bin:$PATH"
export GIT_AUTHOR_NAME='Sam Shackleton' GIT_COMMITTER_NAME='Sam Shackleton' GIT_AUTHOR_EMAIL='samshackleton-tech@users.noreply.github.com' GIT_COMMITTER_EMAIL='samshackleton-tech@users.noreply.github.com'
E=b5b988d8982bea9490c38c79ec4b8c5c2428270c
{ date -u; grep -m1 'model name' /proc/cpuinfo; nproc; uname -r; sort -u /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor; cat /sys/devices/system/cpu/cpu0/cpufreq/energy_performance_preference 2>/dev/null; systemctl is-active tuned 2>&1; findmnt -no FSTYPE,SOURCE -T /root/b3sum-files 2>/dev/null; git -C bench log -1 --format='%H %s' | cut -c1-100; git -C fork log -1 --format=%H; git -C fork status --short | head -3; } > "$O/machine.txt"
cd bench; cargo build --release > "$O/bench-build.log" 2>&1 || exit 2
X="$R/bench/target/release/bench-hashes"
step() { n=$1; shift; s=$(date +%s); "$@"; echo "$n exit $? $(( $(date +%s) - s )) s" >> "$O/status.txt"; }
step same-library $X check --fork ../fork --against $E --old-bench 1f4dfd6316405d1e992caf0df3822c9606bdac50 --cells all > "$O/same-library.out" 2> "$O/same-library.err"
git checkout -q -- index.html 2>/dev/null
EXE=$($X build-against ../fork 2> "$O/build-against.err" | tail -1); [ -x "$EXE" ] || exit 3
mkdir -p "$R/scratch"; cd "$R/scratch"
step full "$EXE" --all --expect-servil $E > "$O/full.out" 2> "$O/full.err"
LAYOUTS=4 python3 "$R/bench/tools/b3sum-contenders.py" "$R/fork" "$R/b3c" > "$O/b3sum-contenders.txt" 2> "$O/b3sum-build.log" || exit 4
step b3sum bash -c "tr '\n' '\0' < '$O/b3sum-contenders.txt' | xargs -0 '$X' b3sum --files /root/b3sum-files > '$O/b3sum.out' 2> '$O/b3sum.err'"
F=$(ls -d "$R"/scratch/benchmark-results/*/ | head -1); F=${F%/}; basename "$F" > "$O/folder.txt"
step map $X map "$F" > "$O/map.log" 2>&1
mkdir -p "$O/folder"; cp "$F"/bench-hashes.samples.tsv "$F"/b3sum.samples.tsv "$F"/bench-hashes.map.html "$O/folder/"
cp "$F"/bench-hashes.result.txt "$F"/b3sum.result.txt "$O/" 2>/dev/null
(cd "$O/folder" && sha256sum b3sum.samples.tsv bench-hashes.map.html bench-hashes.samples.tsv > SHA256SUMS && b3sum b3sum.samples.tsv bench-hashes.map.html bench-hashes.samples.tsv > BLAKE3SUMS) || (cd "$O/folder" && "$R/bench/target/release/bench-hashes" --version > /dev/null)
grep -h "load during the run\|^load:" "$O/bench-hashes.result.txt" "$O/b3sum.result.txt" > "$O/load.txt"
