#!/bin/bash
# bench-hashes #115 (0.20: shared for the multithreaded contenders, each sample's CPU recorded),
# reviewed on real hardware. Bench ee4a6b8b, the fork at 0.8 (b5b988d8).
# 1. The bench's tests. 2. A full run of the two multithreaded contenders (build-against, then
#    --contenders blake3-servil-mt,blake3-official-mt --expect-servil), whose samples' cpu column
#    is classified by the machine's topology (one CPU, one core's SMT pair, one L3, two L3s).
# 3. An A/A check of every cell: check --fork FORK --against b5b988d8 --cells all, timed.
set -u
R="$1"; O="$R/out"; mkdir -p "$O"; cd "$R"
. /root/.cargo/env
export PATH="$(rustc --print sysroot)/lib/rustlib/x86_64-unknown-linux-gnu/bin:$PATH"
E=b5b988d8982bea9490c38c79ec4b8c5c2428270c
{ grep -m1 'model name' /proc/cpuinfo; nproc; sort -u /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor; git -C bench log -1 --format='%H %s' | cut -c1-90; git -C fork log -1 --format=%H; } > "$O/machine.txt"
for c in /sys/devices/system/cpu/cpu[0-9]*; do n=${c##*cpu}; echo "$n $(cat $c/topology/core_id) $(cat $c/topology/physical_package_id) $(cat $c/cache/index3/shared_cpu_list)"; done | sort -n > "$O/topology.txt"
cd "$R/bench"
cargo nextest run --release > "$O/tests.out" 2> "$O/tests.err"; echo "tests exit $?" >> "$O/status.txt"
grep -E "Summary" "$O/tests.err" >> "$O/status.txt"
cargo build --release > "$O/bench-build.log" 2>&1 || { echo "bench build failed" >> "$O/status.txt"; exit 2; }
X="$R/bench/target/release/bench-hashes"
EXE=$($X build-against "$R/fork" 2> "$O/build-against.err" | tail -1); [ -x "$EXE" ] || { echo "build-against failed" >> "$O/status.txt"; exit 3; }
mkdir -p "$R/scratch"; cd "$R/scratch"
s=$(date +%s); "$EXE" --contenders blake3-servil-mt,blake3-official-mt --expect-servil $E > "$O/full.out" 2> "$O/full.err"
echo "full exit $? $(( $(date +%s) - s )) s" >> "$O/status.txt"
cp "$R"/scratch/benchmark-results/*/bench-hashes.samples.tsv "$O/full.samples.tsv" 2>/dev/null || echo "NO SAMPLES" >> "$O/status.txt"
cp "$R"/scratch/benchmark-results/*/bench-hashes.result.txt "$O/full.result.txt" 2>/dev/null
cd "$R/bench"
s=$(date +%s); $X check --fork ../fork --against $E --cells all > "$O/aa.out" 2> "$O/aa.err"
echo "aa exit $? $(( $(date +%s) - s )) s" >> "$O/status.txt"
echo "review done" >> "$O/status.txt"
