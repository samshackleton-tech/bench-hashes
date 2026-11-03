#!/bin/bash
# bench-hashes 0.20.0 release runs on this machine (John's #118, CONTRIBUTING "Releases" step 4), the fork
# at BLAKE3-Servil 0.8: the full run (build-against, then --all --expect-servil, from a scratch directory);
# the b3sum run (LAYOUTS=4 tools/b3sum-contenders.py into a fresh directory, then --files on this
# machine's own storage); the crowd run (the same executable); the map of the folder they wrote.
# 0.20 reads no v7 samples (no bridge), so the same-library check against 0.19 is not part of this run.
set -u
R="$1"; O="$R/out"; mkdir -p "$O"; cd "$R"
. /root/.cargo/env
export PATH="$(rustc --print sysroot)/lib/rustlib/x86_64-unknown-linux-gnu/bin:$PATH"
FORK_COMMIT=b5b988d8982bea9490c38c79ec4b8c5c2428270c
{ date -u; grep -m1 'model name' /proc/cpuinfo; nproc; uname -r; sort -u /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor
  cat /sys/devices/system/cpu/cpu0/cpufreq/energy_performance_preference 2>/dev/null; systemctl is-active tuned 2>&1
  findmnt -no FSTYPE,SOURCE -T /root/b3sum-files 2>/dev/null; git -C bench log -1 --format='%H %s' | cut -c1-100
  git -C fork log -1 --format=%H; git -C fork status --short | head -3; } > "$O/machine.txt"
step() { n=$1; shift; s=$(date +%s); "$@"; echo "$n exit $? $(( $(date +%s) - s )) s" >> "$O/status.txt"; }
cd "$R/bench"; cargo build --release > "$O/bench-build.log" 2>&1 || { echo "bench build failed" >> "$O/status.txt"; exit 2; }
X="$R/bench/target/release/bench-hashes"
EXE=$($X build-against "$R/fork" 2> "$O/build-against.err" | tail -1); [ -x "$EXE" ] || { echo "build-against failed" >> "$O/status.txt"; exit 3; }
echo "exe $EXE" >> "$O/machine.txt"
mkdir -p "$R/scratch"; cd "$R/scratch"
step full "$EXE" --all --expect-servil $FORK_COMMIT > "$O/full.out" 2> "$O/full.err"
cd "$R/bench"
LAYOUTS=4 python3 "$R/bench/tools/b3sum-contenders.py" "$R/fork" "$R/b3c" > "$O/b3sum-contenders.txt" 2> "$O/b3sum-build.log" || { echo "b3sum contenders failed" >> "$O/status.txt"; exit 4; }
cd "$R/scratch"
step b3sum bash -c "tr '\n' '\0' < '$O/b3sum-contenders.txt' | xargs -0 '$X' b3sum --files /root/b3sum-files > '$O/b3sum.out' 2> '$O/b3sum.err'"
step crowd "$EXE" crowd > "$O/crowd.out" 2> "$O/crowd.err"
F=$(ls -d "$R"/scratch/benchmark-results/*/ | head -1); F=${F%/}; basename "$F" > "$O/folder.txt"
step map $X map "$F" > "$O/map.log" 2>&1
mkdir -p "$O/folder"; cp "$F"/* "$O/folder/"
(cd "$O/folder" && sha256sum $(ls | grep -v SUMS) > SHA256SUMS)
cp "$F"/bench-hashes.result.txt "$F"/b3sum.result.txt "$O/" 2>/dev/null
grep -h "load during the run\|^load:" "$O/bench-hashes.result.txt" "$O/b3sum.result.txt" > "$O/load.txt" 2>/dev/null
ls "$O/folder" > "$O/folder-files.txt"
echo "release done" >> "$O/status.txt"
