#!/bin/bash
# bench-hashes #128 (run b128-first): b128-lic found official's 1 KiB slow samples are its cells'
# first samples (sample 0: median 13,578 cycles a call against ~6,800 after, both builds; servil's
# not). Is it official's first use in the process, or something servil's presence does? Arms, one
# process each, 1 KiB after other work and after 5 ms: O official alone, S servil alone, B both.
# Order O S B B S O twice (6 runs each). The PR's head as is.
set -u
R="$1"; O="$R/out"; mkdir -p "$O"; cd "$R"
export HOME=/root; . /root/.cargo/env
( cd bench && CARGO_TARGET_DIR="$R/target" cargo build --release ) > "$O/build.log" 2>&1 || { echo "build failed" >> "$O/status.txt"; exit 2; }
X="$R/target/release/bench-hashes"
{ uname -a; nproc; grep -m1 'model name' /proc/cpuinfo; rustc --version; echo "bench $(git -C bench rev-parse HEAD)"; } > "$O/machine.txt" 2>&1
POINTS="1 KiB,idle 1 KiB"; echo "points $POINTS" >> "$O/machine.txt"
i=0
for arm in O S B B S O O S B B S O; do
  i=$((i+1)); case $arm in O) c=blake3-official;; S) c=blake3-servil-st;; B) c=blake3-servil-st,blake3-official;; esac
  mkdir -p "$R/scratch-$i" && cd "$R/scratch-$i"
  "$X" --contenders $c --points "$POINTS" > "$O/run-$i-$arm.out" 2> "$O/run-$i-$arm.err"; echo "run $i $arm exit $?" >> "$O/status.txt"
  cp benchmark-results/*/bench-hashes.samples.tsv "$O/run-$i-$arm.samples.tsv" 2>/dev/null || echo "NO SAMPLES $i" >> "$O/status.txt"
done
echo "first done" >> "$O/status.txt"
