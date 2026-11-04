#!/bin/bash
# BLAKE3 #196 follow-up, the copy path's two speeds (run copyaddr): each process's message source and ring
# addresses beside its rate. A driver: one caller (CPU 0) streaming SIZE-byte messages copied into the
# ring by submit_with (8 in flight, 2 s), recording the first room of the first 64 messages and its
# offset from the source; servil 354d71d1. 24 fresh processes for each of: 1 MiB and 4 MiB, under
# taskset on domain 0 (0-5,24-29) and on the whole machine; interleaved.
set -u
R="$1"; O="$R/out"; mkdir -p "$O"; cd "$R"
. /root/.cargo/env
{ grep -m1 'model name' /proc/cpuinfo; nproc; uname -r; echo "fork $(git -C fork rev-parse HEAD)"; cat /sys/kernel/mm/transparent_hugepage/enabled; } > "$O/machine.txt"
mkdir -p drv/src
cat > drv/Cargo.toml <<'TOML_END'
[package]
name = "copyaddr"
version = "0.0.0"
edition = "2021"
[dependencies]
blake3-servil = { path = "../fork" }
libc = "0.2"
[profile.release]
debug = false
TOML_END
cat > drv/src/main.rs <<'RUST_END'
//! One caller pinned to CPU 0, streaming SIZE-byte messages copied into the stream's ring (submit_with),
//! 8 places, SECS seconds. Prints the rate, the rate in each quarter, the source's address, and for the
//! first 64 messages the first room's address and (room - source) mod 4096.
use blake3_servil::performance::{stream, Block};
use blake3_servil::{Hash, Mode};
use std::cell::RefCell;
use std::time::{Duration, Instant};
fn pin(cpu: usize) {
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
    blake3_servil::initialize_multithreaded(None);
    pin(0);
    let mut b = vec![Block::ZERO; size.div_ceil(64).max(1)];
    for (i, x) in Block::bytes_mut(&mut b)[..size].iter_mut().enumerate() { *x = (i * 31) as u8; }
    let bytes = Block::bytes(&b);
    let src = bytes.as_ptr() as usize;
    let rooms = RefCell::new(Vec::<usize>::new());
    let mut places = vec![Hash::from([0; 32]); 8];
    let free = RefCell::new(places.iter_mut().collect::<Vec<_>>());
    let count = std::cell::Cell::new(0u64);
    let mut quarters = [0u64; 4];
    let t = Instant::now();
    let until = t + Duration::from_secs_f64(secs);
    stream(Mode::Plain, |p: &mut [Hash]| { std::hint::black_box(&p[0]); count.set(count.get() + 1); free.borrow_mut().push(&mut p[0]); }, |s| {
        let mut n = 0usize;
        while Instant::now() < until {
            for _ in 0..16 {
                let place = loop { if let Some(p) = free.borrow_mut().pop() { break p; } s.collect(); };
                let first = n < 64;
                s.submit_with(size, |at, room| {
                    if first && at == 0 { rooms.borrow_mut().push(room.as_ptr() as usize); }
                    room.copy_from_slice(&bytes[at..][..room.len()]);
                    room.len()
                }, place);
                n += 1;
            }
            let q = ((t.elapsed().as_secs_f64() / secs) * 4.0).min(3.0) as usize;
            quarters[q] = count.get();
        }
        s.finish();
    });
    let el = t.elapsed().as_secs_f64();
    let mut prev = 0;
    let qs: Vec<String> = quarters.iter().map(|&c| { let d = c.saturating_sub(prev); prev = c.max(prev); format!("{:.0}", d as f64 / (el / 4.0)) }).collect();
    println!("rate\t{:.0}\tquarters\t{}", count.get() as f64 / el, qs.join(","));
    println!("src\t{:#x}", src);
    let r = rooms.borrow();
    let offs: Vec<String> = r.iter().map(|&x| format!("{}", (x.wrapping_sub(src)) % 4096)).collect();
    let rr: Vec<String> = r.iter().map(|&x| format!("{:#x}", x)).collect();
    println!("rooms\t{}", rr.join(","));
    println!("room-src mod 4096\t{}", offs.join(","));
}
RUST_END
(cd drv && cargo build --release) > "$O/build.log" 2>&1 || { echo "driver build failed" >> "$O/status.txt"; exit 2; }
E="$R/drv/target/release/copyaddr"
for i in $(seq 1 24); do
  for size in 1048576 4194304; do
    taskset -c 0-5,24-29 "$E" $size 2 > "$O/dom-$size-$i.txt" 2> "$O/dom-$size-$i.err"; echo "dom $size $i exit $?" >> "$O/status.txt"
    "$E" $size 2 > "$O/all-$size-$i.txt" 2> "$O/all-$size-$i.err"; echo "all $size $i exit $?" >> "$O/status.txt"
  done
done
echo "copyaddr done" >> "$O/status.txt"
