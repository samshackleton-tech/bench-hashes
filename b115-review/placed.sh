#!/bin/bash
# bench-hashes #115 at a40c26db: the shared copies placed (shared-one-cache, shared-two-caches).
# A short run, --contenders blake3-servil-mt --points "continuous 64 KiB", the fork at 0.8; the
# header's placement line, each layer's samples and their CPUs, against lscpu -e and sysfs.
set -u
R="$1"; O="$R/out"; mkdir -p "$O"; cd "$R"
. /root/.cargo/env
E=b5b988d8982bea9490c38c79ec4b8c5c2428270c
{ grep -m1 'model name' /proc/cpuinfo; nproc; git -C bench log -1 --format='%H %s' | cut -c1-90; git -C fork log -1 --format=%H; } > "$O/machine.txt"
lscpu -e > "$O/lscpu.txt" 2>&1
for c in /sys/devices/system/cpu/cpu[0-9]*; do n=${c##*cpu}; echo "$n core_cpus $(cat $c/topology/core_cpus_list) l3 $(cat $c/cache/index3/shared_cpu_list) pkg $(cat $c/topology/physical_package_id)"; done | sort -n > "$O/topology.txt"
cd "$R/bench"; cargo build --release > "$O/bench-build.log" 2>&1 || { echo "bench build failed" >> "$O/status.txt"; exit 2; }
cargo nextest run --release > "$O/tests.out" 2> "$O/tests.err"; echo "tests exit $?" >> "$O/status.txt"; grep Summary "$O/tests.err" >> "$O/status.txt"
X="$R/bench/target/release/bench-hashes"
EXE=$($X build-against "$R/fork" 2> "$O/build-against.err" | tail -1); [ -x "$EXE" ] || { echo "build-against failed" >> "$O/status.txt"; exit 3; }
mkdir -p "$R/scratch"; cd "$R/scratch"
"$EXE" --contenders blake3-servil-mt --points "continuous 64 KiB" --expect-servil $E > "$O/run.out" 2> "$O/run.err"; echo "run exit $?" >> "$O/status.txt"
cp "$R"/scratch/benchmark-results/*/bench-hashes.samples.tsv "$O/run.samples.tsv" 2>/dev/null || echo "NO SAMPLES" >> "$O/status.txt"
grep -E "^# (shared placements|idle states|bench-hashes samples)" "$O/run.samples.tsv" > "$O/header-lines.txt"
cut -f1-4,11 "$O/run.samples.tsv" | grep -v "^#" > "$O/cells-cpus.txt"
echo "placed done" >> "$O/status.txt"
