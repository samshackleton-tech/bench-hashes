#!/bin/bash
# bench-hashes #128, Devon's AVX-512 power-up hypothesis for official's bimodal 1 KiB on the Xeon
# (run b128-lic). Two builds of the PR's head: as is (A), and official blake3 with its no_avx512
# feature (B, a job commit in a second checkout, its own target dir). Prediction: A's official
# 1 KiB after other work / controlled is bimodal, B's is not; servil st reads alike in both builds
# (control); 64 B (one block, no AVX-512 in official) unimodal in both (control). 6 runs each,
# order A B B A A B B A A B B A. Then perf's licence-cycle counts for one cell per process. Which
# kernels official dispatches to in each build, from perf samples, is the builds' identity check.
set -u
R="$1"; O="$R/out"; mkdir -p "$O"; cd "$R"
export HOME=/root; . /root/.cargo/env
git clone -q bench bench-noavx && git -C bench-noavx checkout -q --detach "$(git -C bench rev-parse HEAD)"
python3 - bench-noavx/Cargo.toml <<'PY_FEAT_END'
import sys
p = sys.argv[1]; s = open(p).read()
old = '[dependencies.blake3]\nversion = "1"\ndefault-features = false\nfeatures = ["std", "rayon"]\n'
assert s.count(old) == 1, "Cargo.toml's blake3 dependency moved"
open(p, "w").write(s.replace(old, old.replace('["std", "rayon"]', '["std", "rayon", "no_avx512"]')))
PY_FEAT_END
git -C bench-noavx -c user.name=job -c user.email=job@localhost -c core.hooksPath=/dev/null commit -qam "job: official blake3 with no_avx512"
for b in bench bench-noavx; do ( cd $b && CARGO_TARGET_DIR="$R/target-$b" cargo build --release ) > "$O/build-$b.log" 2>&1 || { echo "build $b failed" >> "$O/status.txt"; exit 2; }; done
A="$R/target-bench/release/bench-hashes"; B="$R/target-bench-noavx/release/bench-hashes"
{ uname -a; nproc; grep -m1 'model name' /proc/cpuinfo; rustc --version; echo "bench $(git -C bench rev-parse HEAD)"; echo "noavx $(git -C bench-noavx rev-parse HEAD) on $(git -C bench-noavx rev-parse HEAD~1)"
  grep -A2 'name = "blake3"' bench-noavx/Cargo.lock | head -3; } > "$O/machine.txt" 2>&1
# Which of official's kernels each build dispatches to (blake3's no_avx512 short-circuits detection
# at run time; its assembly is linked either way): official's compress_in_place calls (AVX-512 or SSE4.1; AVX2 has
# none), counted exactly by uprobes (file offsets from the LOAD headers), official's 1 KiB cell alone.
mkdir -p "$R/scratch-id" && cd "$R/scratch-id"
cat > "$R/uprobe.py" <<'PY_UP_END'
import subprocess, sys
binary, sym = sys.argv[1], sys.argv[2]
vaddr = next(int(l.split()[0], 16) for l in subprocess.run(["nm", binary], capture_output=True, text=True).stdout.splitlines() if l.split()[-1] == sym)
for l in subprocess.run(["readelf", "-lW", binary], capture_output=True, text=True).stdout.splitlines():
    x = l.split()
    if x and x[0] == "LOAD":
        off, va, size = int(x[1], 16), int(x[2], 16), int(x[5], 16)
        if va <= vaddr < va + size:
            print(hex(vaddr - va + off)); break
PY_UP_END
for arm in A B; do bin=$A; [ $arm = B ] && bin=$B; ev=""
  for k in avx512 sse41; do
    echo "p:lic/$k$arm $bin:$(python3 "$R/uprobe.py" "$bin" blake3_compress_in_place_$k)" >> /sys/kernel/tracing/uprobe_events && ev="$ev,lic:$k$arm"
  done
  perf stat -x, -e "${ev#,}" -o "$O/kernels-$arm.csv" -- "$bin" --contenders blake3-official --points "1 KiB" > /dev/null 2>&1
  for k in avx512 sse41; do echo "-:lic/$k$arm" >> /sys/kernel/tracing/uprobe_events; done
  n=$(grep "lic:avx512$arm" "$O/kernels-$arm.csv" | cut -d, -f1); m=$(grep -E "lic:sse41$arm" "$O/kernels-$arm.csv" | cut -d, -f1 | paste -sd+ | bc)
  echo "$arm official compress_in_place calls: avx512 $n, narrower $m" >> "$O/machine.txt"
  echo "$arm official kernels: avx512 $([ "${n:-0}" -gt 0 ] && echo yes || echo no), narrower $([ "${m:-0}" -gt 0 ] && echo yes || echo no)" >> "$O/machine.txt"
done
cd "$R"
for f in /sys/devices/system/cpu/cpu*/cpuidle/state*/disable; do echo "$f $(cat $f)"; done > "$O/disable-before.txt" 2>/dev/null
POINTS="64 B,idle 64 B,controlled idle 64 B,1 KiB,brief idle 1 KiB,idle 1 KiB,controlled idle 1 KiB"
echo "points $POINTS" >> "$O/machine.txt"
i=0
for arm in A B B A A B B A A B B A; do
  i=$((i+1)); bin=$A; [ $arm = B ] && bin=$B
  mkdir -p "$R/scratch-$i" && cd "$R/scratch-$i"
  "$bin" --contenders blake3-servil-st,blake3-official --points "$POINTS" > "$O/run-$i-$arm.out" 2> "$O/run-$i-$arm.err"; echo "run $i $arm exit $?" >> "$O/status.txt"
  cp benchmark-results/*/bench-hashes.samples.tsv "$O/run-$i-$arm.samples.tsv" 2>/dev/null || echo "NO SAMPLES $i" >> "$O/status.txt"
  for f in /sys/devices/system/cpu/cpu*/cpuidle/state*/disable; do echo "$f $(cat $f)"; done > "$O/disable-after.txt" 2>/dev/null
  cmp -s "$O/disable-before.txt" "$O/disable-after.txt" || echo "run $i DISABLE FILES CHANGED" >> "$O/status.txt"
done
# Licence cycles, one contender and one point a process, each build.
mkdir -p "$R/scratch-perf" && cd "$R/scratch-perf"
for arm in A B; do bin=$A; [ $arm = B ] && bin=$B
  for c in blake3-official blake3-servil-st; do for p in "1 KiB" "64 B"; do
    perf stat -x, -e cycles,core_power.lvl0_turbo_license,core_power.lvl1_turbo_license,core_power.lvl2_turbo_license -o "$O/perf-$arm-$c-${p// /}.csv" -- "$bin" --contenders $c --points "$p" > /dev/null 2>&1; echo "perf $arm $c $p exit $?" >> "$O/status.txt"
  done; done; done
echo "lic done" >> "$O/status.txt"
