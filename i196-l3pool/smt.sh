#!/bin/bash
# BLAKE3 #196: John's test of the hardware-thread cause. l3v3.sh's measurements (servil 68fd3e57,
# probe/l3-pool-r 8381f8d9, probe/l3-pool-unpinned 8a025c7e; the programs at 16, 64, 256 KiB and the
# pinned callers, one full run each) twice in one job: first with SMT off
# (/sys/devices/system/cpu/smt/control), then with it on again. SMT is restored on any exit.
set -u
R="$1"; O="$R/out"; mkdir -p "$O"; cd "$R"
. /root/.cargo/env
SMT0=$(cat /sys/devices/system/cpu/smt/control); echo "smt at start: $SMT0" > "$O/smt.txt"
restore() { echo "$SMT0" > /sys/devices/system/cpu/smt/control 2>/dev/null; }
trap restore EXIT
{ grep -m1 'model name' /proc/cpuinfo; nproc; for v in base r unp; do echo "$v $(git -C $v log -1 --format=%H)"; done; git -C bench log -1 --format=%H; } > "$O/machine.txt"
for v in base r unp; do
  mkdir -p tc-$v/src
  cat > tc-$v/Cargo.toml <<TOML_END
[package]
name = "two-callers"
version = "0.0.0"
edition = "2021"
[dependencies]
blake3-servil = { path = "../$v" }
libc = "0.2"
TOML_END
  cat > tc-$v/src/main.rs <<'RUST_END'
//! Callers pinned to the given CPUs, started together, each streaming SIZE-byte messages for
//! SECS seconds through performance::stream (8 places, collect for a free one). Prints each
//! caller's CPU and messages a second.
use blake3_servil::performance::{stream, Block};
use blake3_servil::{Hash, Mode};
use std::time::{Duration, Instant};
fn pin(cpu: usize) {
    // Sound: a zeroed cpu_set_t is empty; CPU_SET writes within it.
    unsafe {
        let mut set: libc::cpu_set_t = core::mem::zeroed();
        libc::CPU_SET(cpu, &mut set);
        assert_eq!(libc::sched_setaffinity(0, core::mem::size_of::<libc::cpu_set_t>(), &set), 0);
    }
}
fn main() {
    let a: Vec<String> = std::env::args().collect();
    let size: usize = a[1].parse().unwrap();
    let secs: f64 = a[2].parse().unwrap();
    let cpus: Vec<usize> = a[3].split(',').map(|c| c.parse().unwrap()).collect();
    blake3_servil::initialize_multithreaded(None);
    let start = std::sync::Arc::new(std::sync::Barrier::new(cpus.len()));
    let handles: Vec<_> = cpus.iter().map(|&cpu| {
        let start = start.clone();
        std::thread::spawn(move || {
            pin(cpu);
            let mut b = vec![Block::ZERO; size.div_ceil(64).max(1)];
            for (i, x) in Block::bytes_mut(&mut b)[..size].iter_mut().enumerate() { *x = (i * 31 + cpu) as u8; }
            let mut places = vec![Hash::from([0; 32]); 8];
            let free = std::cell::RefCell::new(places.iter_mut().collect::<Vec<_>>());
            let count = std::cell::Cell::new(0u64);
            start.wait();
            let t = Instant::now();
            let until = t + Duration::from_secs_f64(secs);
            stream(Mode::Plain, |p: &mut [Hash]| { std::hint::black_box(&p[0]); count.set(count.get() + 1); free.borrow_mut().push(&mut p[0]); }, |s| {
                while Instant::now() < until {
                    for _ in 0..256 {
                        let place = loop { if let Some(p) = free.borrow_mut().pop() { break p; } s.collect(); };
                        s.submit(&b, size, place);
                    }
                }
                s.finish();
            });
            (cpu, count.get() as f64 / t.elapsed().as_secs_f64())
        })
    }).collect();
    for h in handles { let (cpu, rate) = h.join().unwrap(); println!("cpu {cpu}\t{rate:.0}"); }
}
RUST_END
  (cd tc-$v && cargo build --release) > "$O/tc-$v-build.log" 2>&1 || { echo "two-callers $v build failed" >> "$O/status.txt"; exit 2; }
  grep -A2 'name = "blake3-servil"' tc-$v/Cargo.lock > "$O/tc-$v-lock.txt"
done
cd "$R/bench"; cargo build --release > "$O/bench-build.log" 2>&1 || { echo "bench build failed" >> "$O/status.txt"; exit 2; }
for v in base r unp; do
  E=$(./target/release/bench-hashes build-against "$R/$v" 2> "$O/build-against-$v.err" | tail -1); [ -x "$E" ] || { echo "build-against $v failed" >> "$O/status.txt"; exit 3; }
  echo "$v $E" >> "$O/exes.txt"
done
[ "$(cut -d' ' -f2 "$O/exes.txt" | sort -u | wc -l)" = 3 ] || { echo "EXECUTABLES NOT DISTINCT" >> "$O/status.txt"; exit 3; }
cd "$R"
for T in smtoff smton; do
  if [ $T = smtoff ]; then echo off > /sys/devices/system/cpu/smt/control; else echo on > /sys/devices/system/cpu/smt/control; fi
  sleep 2; echo "$T: smt $(cat /sys/devices/system/cpu/smt/control), $(nproc) CPUs online, CPU 24 online $(cat /sys/devices/system/cpu/cpu24/online 2>/dev/null)" >> "$O/smt.txt"
for round in 1 2 3 4 5; do
  for size in 16384 65536 262144; do
    for v in base r unp; do
      "$R/tc-$v/target/release/two-callers" $size 2 0 > "$O/$T-one-$v-$size-$round.txt" 2> "$O/$T-one-$v-$size-$round.err"
      echo "$T one $v size $size round $round exit $?" >> "$O/status.txt"
    done
  done
done
for round in 1 2 3; do
  P="0 0,1 0,6"; [ $round = 2 ] && P="0,6 0 0,1"; [ $round = 3 ] && P="0,1 0,6 0"
  for size in 64 1024 65536; do
    for p in $P; do
      for v in base r unp; do
        "$R/tc-$v/target/release/two-callers" $size 2 $p > "$O/$T-$v-$size-$p-$round.txt" 2> "$O/$T-$v-$size-$p-$round.err"
        echo "$T $v size $size cpus $p round $round exit $?" >> "$O/status.txt"
      done
    done
  done
done
for round in 1; do
  for v in base r unp; do
    E=$(grep "^$v " "$O/exes.txt" | cut -d' ' -f2); C=$(git -C "$R/$v" rev-parse HEAD)
    D="$R/scratch-$T-$v-$round"; mkdir -p "$D"; cd "$D"
    "$E" --contenders blake3-servil-mt --expect-servil $C > "$O/$T-full-$v-$round.out" 2> "$O/$T-full-$v-$round.err"
    echo "$T full $v round $round exit $?" >> "$O/status.txt"
    cp "$D"/benchmark-results/*/bench-hashes.samples.tsv "$O/$T-full-$v-$round.samples.tsv" 2>/dev/null || echo "$T full $v round $round: NO SAMPLES" >> "$O/status.txt"
  done
  cd "$R/bench"
done
done
restore; trap - EXIT
echo "smt at end: $(cat /sys/devices/system/cpu/smt/control)" >> "$O/smt.txt"
echo "smt done" >> "$O/status.txt"
