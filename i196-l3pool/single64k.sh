#!/bin/bash
# BLAKE3 #196: a single caller's 64 KiB stream read the probe 9% slower than servil in twocallers.sh,
# level in check. (1) bench regress, servil mt at "continuous 64 KiB" (the one-shot and stream cells),
# 32 pairs, servil (09d3bbc6) against the probe with the fix (de9cf6d0); (2) the program, one
# caller on CPU 0, 16, 64 and 256 KiB, 5 rounds. Earlier header, for the program: two callers in one L3 domain share its workers. Measured directly: callers
# pinned to CPUs, each running a stream of SIZE-byte messages for 2 s, on probe/l3-pool with Sam's
# fix (de9cf6d0) and on servil (09d3bbc6). Placements: one caller (CPU 0); two in one domain
# (CPUs 0 and 1); two in two domains (CPUs 0 and 6). Sizes 64 B, 1 KiB, 64 KiB. Each caller's
# messages a second. 3 rounds, rotated.
set -u
R="$1"; O="$R/out"; mkdir -p "$O"; cd "$R"
. /root/.cargo/env
{ grep -m1 'model name' /proc/cpuinfo; nproc; echo "L3 domains: $(cat /sys/devices/system/cpu/cpu*/cache/index3/shared_cpu_list | sort -u | tr '\n' ' ')"
  git -C base log -1 --format=%H; git -C fix log -1 --format=%H; } > "$O/machine.txt"
for v in base fix; do
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
X="$R/bench/target/release/bench-hashes"
EB=$($X build-against "$R/base" 2> "$O/build-against-base.err" | tail -1); [ -x "$EB" ] || { echo "build-against base failed" >> "$O/status.txt"; exit 3; }
EF=$($X build-against "$R/fix" 2> "$O/build-against-fix.err" | tail -1); [ -x "$EF" ] || { echo "build-against fix failed" >> "$O/status.txt"; exit 3; }
$X regress --contenders blake3-servil-mt --points "continuous 64 KiB" --pairs 32 --keep "$O/kept" "$EB" -- "$EF" > "$O/regress.out" 2> "$O/regress.err"; echo "regress exit $?" >> "$O/status.txt"
cd "$R"
for round in 1 2 3 4 5; do
  for size in 16384 65536 262144; do
    for v in base fix; do
      "$R/tc-$v/target/release/two-callers" $size 2 0 > "$O/one-$v-$size-$round.txt" 2> "$O/one-$v-$size-$round.err"
      echo "$v size $size round $round exit $?" >> "$O/status.txt"
    done
  done
done
echo "single64k done" >> "$O/status.txt"
