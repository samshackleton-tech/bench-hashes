#!/bin/bash
# BLAKE3 #196, in flight (Little's law): run i196-link found one domain reads 110 GB/s, and the
# 64 KiB stream at 8 in flight reads 64.7 GB/s on one domain and on two. Messages in flight against
# the 6 cores of the caller's domain: 4, 6, 8, 12, 16 in flight, servil 68fd3e57 and -r 8381f8d9,
# unrestricted, the caller on CPU 0, at 64 and 256 KiB, 5 rounds. (link.sh's head, kept below:)
# BLAKE3 #196, John's link hypothesis (a CCD reaches memory through one link to the I/O die, about
# 64 GB/s; -r's single 64 KiB stream tops out near that from one domain). Three measurements on
# the EPYC 9255, 5 rounds, interleaved:
# 1. The stream (one caller, 8 places in flight, 2 s, the caller on CPU 0) at 64 KiB and 1 MiB:
#    servil 68fd3e57 unrestricted; the same under taskset on one domain (0-5,24-29) and on two
#    (0-11,24-35), the pool then sized to those CPUs; probe/l3-pool-r 8381f8d9 unrestricted.
# 2. The domain's compute: k threads, each pinned, each hashing its own 64 KiB in cache
#    single-threaded (performance::hash) back to back for 2 s; k = 6 (cores 0-5), 12 (0-5,24-29).
# 3. The domain's link: a STREAM-style read (sum of u64, 8 accumulators) of 4 GiB, first touched
#    by the readers, by 6 and 12 threads of one domain, 12 and 24 of two, 48 of all four.
# The stream's input is the same buffer each time: in the caller's caches, so workers elsewhere
# read it across the fabric, workers in its domain from its L3.
set -u
R="$1"; O="$R/out"; mkdir -p "$O"; cd "$R"
. /root/.cargo/env
{ grep -m1 'model name' /proc/cpuinfo; nproc; for v in base r; do echo "$v $(git -C $v log -1 --format=%H)"; done; } > "$O/machine.txt"
for v in base r; do
  mkdir -p tc-$v/src
  cat > tc-$v/Cargo.toml <<TOML_END
[package]
name = "link-probe"
version = "0.0.0"
edition = "2021"
[dependencies]
blake3-servil = { path = "../$v" }
libc = "0.2"
TOML_END
  cat > tc-$v/src/main.rs <<'RUST_END'
//! link-probe stream SIZE SECS CPU: one caller pinned to CPU, streaming SIZE-byte messages for
//!   SECS through performance::stream (8 places); prints messages a second.
//! link-probe hashst SIZE SECS CPUS: one thread a CPU, each hashing its own SIZE bytes
//!   single-threaded back to back; prints the sum of bytes a second.
//! link-probe read GIB CPUS: one thread a CPU reading its share of GIB GiB (first touched by
//!   it), 3 passes; prints the best pass's bytes a second.
use blake3_servil::performance::{hash, stream, Block};
use blake3_servil::{Hash, Mode};
use std::sync::{Arc, Barrier};
use std::time::{Duration, Instant};
fn pin(cpu: usize) {
    // Sound: a zeroed cpu_set_t is empty; CPU_SET writes within it.
    unsafe {
        let mut set: libc::cpu_set_t = core::mem::zeroed();
        libc::CPU_SET(cpu, &mut set);
        assert_eq!(libc::sched_setaffinity(0, core::mem::size_of::<libc::cpu_set_t>(), &set), 0);
    }
}
fn cpus(s: &str) -> Vec<usize> {
    s.split(',').flat_map(|r| match r.split_once('-') { Some((a, b)) => (a.parse().unwrap()..=b.parse().unwrap()).collect::<Vec<usize>>(), None => vec![r.parse().unwrap()] }).collect()
}
fn main() {
    let a: Vec<String> = std::env::args().collect();
    blake3_servil::initialize();
    match a[1].as_str() {
        "stream" => {
            let (size, secs, cpu): (usize, f64, usize) = (a[2].parse().unwrap(), a[3].parse().unwrap(), a[4].parse().unwrap());
            let inflight: usize = a.get(5).map_or(8, |x| x.parse().unwrap());
            blake3_servil::initialize_multithreaded(None);
            pin(cpu);
            let mut b = vec![Block::ZERO; size.div_ceil(64).max(1)];
            for (i, x) in Block::bytes_mut(&mut b)[..size].iter_mut().enumerate() { *x = (i * 31) as u8; }
            let mut places = vec![Hash::from([0; 32]); inflight];
            let free = std::cell::RefCell::new(places.iter_mut().collect::<Vec<_>>());
            let count = std::cell::Cell::new(0u64);
            let t = Instant::now();
            let until = t + Duration::from_secs_f64(secs);
            stream(Mode::Plain, |p: &mut [Hash]| { std::hint::black_box(&p[0]); count.set(count.get() + 1); free.borrow_mut().push(&mut p[0]); }, |s| {
                while Instant::now() < until {
                    for _ in 0..64 {
                        let place = loop { if let Some(p) = free.borrow_mut().pop() { break p; } s.collect(); };
                        s.submit(&b, size, place);
                    }
                }
                s.finish();
            });
            println!("{:.0}", count.get() as f64 / t.elapsed().as_secs_f64());
        }
        "hashst" => {
            let (size, secs, list): (usize, f64, Vec<usize>) = (a[2].parse().unwrap(), a[3].parse().unwrap(), cpus(&a[4]));
            let go = Arc::new(Barrier::new(list.len()));
            let hs: Vec<_> = list.into_iter().map(|cpu| { let go = go.clone(); std::thread::spawn(move || {
                pin(cpu);
                let mut b = vec![Block::ZERO; size.div_ceil(64)];
                for (i, x) in Block::bytes_mut(&mut b).iter_mut().enumerate() { *x = (i * 7 + cpu) as u8; }
                for _ in 0..100 { std::hint::black_box(hash(Mode::Plain, &b, size)); }
                go.wait();
                let t = Instant::now(); let until = t + Duration::from_secs_f64(secs); let mut n = 0u64;
                while Instant::now() < until { for _ in 0..16 { std::hint::black_box(hash(Mode::Plain, std::hint::black_box(&b), size)); } n += 16; }
                n as f64 * size as f64 / t.elapsed().as_secs_f64()
            }) }).collect();
            let total: f64 = hs.into_iter().map(|h| h.join().unwrap()).sum();
            println!("{:.0}", total);
        }
        "read" => {
            let (gib, list): (usize, Vec<usize>) = (a[2].parse().unwrap(), cpus(&a[3]));
            let words = (gib << 30) / 8 / list.len();
            let go = Arc::new(Barrier::new(list.len()));
            let hs: Vec<_> = list.into_iter().map(|cpu| { let go = go.clone(); std::thread::spawn(move || {
                pin(cpu);
                let v: Vec<u64> = (0..words as u64).collect(); // first touched here
                let mut best = 0f64;
                for _ in 0..3 {
                    go.wait();
                    let t = Instant::now();
                    let mut acc = [0u64; 8];
                    for c in v.chunks_exact(8) { for i in 0..8 { acc[i] = acc[i].wrapping_add(c[i]); } }
                    std::hint::black_box(acc);
                    let el = t.elapsed().as_secs_f64();
                    go.wait();
                    best = f64::max(best, (words * 8) as f64 / el);
                }
                best
            }) }).collect();
            let total: f64 = hs.into_iter().map(|h| h.join().unwrap()).sum();
            println!("{:.0}", total);
        }
        _ => panic!("mode"),
    }
}
RUST_END
  (cd tc-$v && cargo build --release) > "$O/tc-$v-build.log" 2>&1 || { echo "probe $v build failed" >> "$O/status.txt"; exit 2; }
  grep -A2 'name = "blake3-servil"' tc-$v/Cargo.lock > "$O/tc-$v-lock.txt"
done
B="$R/tc-base/target/release/link-probe"; RR="$R/tc-r/target/release/link-probe"
for round in 1 2 3 4 5; do
  for size in 65536 262144; do
    for n in 4 6 8 12 16; do
      for v in base r; do
        P="$B"; [ $v = r ] && P="$RR"
        rate=$("$P" stream $size 2 0 $n); echo "stream $v $size $n $round $rate" >> "$O/results.txt"
      done
    done
  done
done
echo "inflight done" >> "$O/status.txt"
