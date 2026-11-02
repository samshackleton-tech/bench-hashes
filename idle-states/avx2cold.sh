#!/bin/bash
# BLAKE3-servil on the 2x Xeon Gold 6330: is a small batch after a pause faster on the AVX2
# kernels than on cold AVX-512 ones? (bench-hashes #106 found AVX-512's warm-up costs about x3.3
# for 16 x 64 B after 1 ms.) Two builds of the probe: the fork at b5b988d8 (AVX-512 detected), and
# a copy whose CPU detection leaves AVX-512 out (src/platform.rs: the AVX512 bit never set), so
# every call takes the AVX2 kernels. performance::hash_many of N x 64 B, N = 16, 256, 4096,
# pinned to CPU 2; per visit: a 1 ms pause, then either nothing or a 500 us scalar spin (which
# removes the C1E window and leaves the vector units cold), the timed call, and the 201st call
# of the visit (steady). 1000 visits a condition, 2 rounds in rotated order.
set -u
R="$1"; O="$R/out"; mkdir -p "$O"; cd "$R"
. /root/.cargo/env
{ grep -m1 'model name' /proc/cpuinfo; nproc; uname -r; sort -u /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor
  echo "cpuidle driver: $(cat /sys/devices/system/cpu/cpuidle/current_driver)"; grep -o -m1 'avx512f' /proc/cpuinfo
  git -C fork log -1 --format=%H; } > "$O/machine.txt"
cp -r fork fork-avx2
python3 - fork-avx2/src/platform.rs <<'PY_END'
import sys
p = sys.argv[1]; s = open(p).read(); a = "        if xcr0 & zmm == zmm && leaf7.ebx & f_vl == f_vl {"
assert s.count(a) == 1, s.count(a)
open(p, 'w').write(s.replace(a, "        if false && xcr0 & zmm == zmm && leaf7.ebx & f_vl == f_vl { // AVX-512 left out (this experiment)"))
PY_END
diff -u fork/src/platform.rs fork-avx2/src/platform.rs > "$O/avx2.diff"
for v in avx512 avx2; do
  src=fork; [ $v = avx2 ] && src=fork-avx2
  mkdir -p probe-$v/src
  cat > probe-$v/Cargo.toml <<TOML_END
[package]
name = "cold-probe"
version = "0.0.0"
edition = "2021"
[dependencies]
blake3-servil = { path = "../$src" }
TOML_END
  cat > probe-$v/src/main.rs <<'RUST_END'
//! Per visit: 1 ms pause; a scalar spin of `spin_us`; the timed hash_many of N x 64 B; the 201st
//! call of the visit. Columns: first ns, 201st ns. (Which kernel runs isn't public: the two
//! builds' steady speeds tell them apart.)
use blake3_servil::performance::{hash_many, Batch, Block};
use blake3_servil::Mode;
use std::time::{Duration, Instant};
fn main() {
    let a: Vec<String> = std::env::args().collect();
    let (n, visits, spin_us): (usize, usize, u64) = (a[1].parse().unwrap(), a[2].parse().unwrap(), a[3].parse().unwrap());
    blake3_servil::initialize();
    let mut blocks = vec![Block([0u8; 64]); n];
    let mut out = vec![[0u8; 32]; n];
    let mut call = || { hash_many(Mode::Plain, &Batch::from_blocks(&blocks, 64), &mut out); std::hint::black_box(&out); };
    for _ in 0..3 { call(); }
    for _ in 0..visits {
        std::thread::sleep(Duration::from_millis(1));
        let until = Instant::now() + Duration::from_micros(spin_us);
        while Instant::now() < until {}
        let t = Instant::now(); call(); let first = t.elapsed().as_nanos();
        for _ in 0..199 { call(); }
        let t = Instant::now(); call(); let steady = t.elapsed().as_nanos();
        println!("{first}\t{steady}");
    }
    let _ = &mut blocks;
}
RUST_END
  (cd probe-$v && cargo build --release) > "$O/probe-$v-build.log" 2>&1 || { echo "probe $v build failed" >> "$O/status.txt"; exit 2; }
  grep -A2 'name = "blake3-servil"' probe-$v/Cargo.lock > "$O/probe-$v-lock.txt"
done
CONDS="avx512-16-0 avx2-16-0 avx512-16-500 avx2-16-500 avx512-256-0 avx2-256-0 avx512-256-500 avx2-256-500 avx512-4096-0 avx2-4096-0 avx512-4096-500 avx2-4096-500"
for round in 1 2; do
  L=$CONDS; [ $round = 2 ] && L=$(echo $CONDS | tr ' ' '\n' | tac | tr '\n' ' ')
  for c in $L; do
    IFS=- read v n sp <<< "$c"
    taskset -c 2 "$R/probe-$v/target/release/cold-probe" $n 1000 $sp > "$O/$c-$round.tsv" 2> "$O/$c-$round.err"
    echo "$c round $round exit $?" >> "$O/status.txt"
  done
done
echo "avx2cold done" >> "$O/status.txt"
