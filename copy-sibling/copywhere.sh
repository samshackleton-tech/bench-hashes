#!/bin/bash
# BLAKE3 #196 follow-up, where the workers ran in each process (run copywhere): copysib.sh's drivers with a
# sampler (the last CPU, every 2 ms, each running worker's CPU); the candidate on the whole machine and
# servil on domain 0, 1 MiB copied, 24 processes each. (copysib.sh's head:)
# BLAKE3 #196 follow-up, the caller's SMT sibling (run copysib): copyoff.sh's drivers, 1 MiB copied, the
# caller on CPU 0; the process on domain 0 with CPU 0's sibling (24) allowed, or without it (0-5,25-29),
# servil and the candidate, 16 processes each, interleaved. (copyoff.sh's head:)
# BLAKE3 #196 follow-up, the copy's source offset and the whole machine (run copyoff): copyaddr.sh's
# driver with the source at +0, +64, +448, +960, +1984 bytes past its 64-byte-aligned buffer (so its
# address mod 4096 is 64, 128, 512, 1024, 2048 against the rooms' 64), 8 processes each, one domain,
# 64 KiB / 1 MiB / 4 MiB; and servil 354d71d1 against the candidate de0451dc on the whole machine,
# 1 MiB, 8 processes each. (copyaddr.sh's head:)
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
    // Probe (copywhere): a sampler on the last CPU notes every 2 ms where each running worker is.
    let done = std::sync::Arc::new(std::sync::atomic::AtomicBool::new(false));
    let sampler = {
        let done = done.clone();
        std::thread::spawn(move || {
            unsafe {
                let mut set: libc::cpu_set_t = core::mem::zeroed();
                libc::CPU_SET(std::thread::available_parallelism().map_or(1, |n| n.get()) - 1, &mut set);
                libc::sched_setaffinity(0, core::mem::size_of::<libc::cpu_set_t>(), &set);
            }
            let mut hist = std::collections::BTreeMap::<usize, u64>::new();
            let mut n = 0u64;
            while !done.load(std::sync::atomic::Ordering::Relaxed) {
                if let Ok(rd) = std::fs::read_dir("/proc/self/task") {
                    for e in rd.flatten() {
                        let p = e.path();
                        if !std::fs::read_to_string(p.join("comm")).unwrap_or_default().starts_with("blake3-worker") { continue; }
                        let st = std::fs::read_to_string(p.join("stat")).unwrap_or_default();
                        if let Some(i) = st.rfind(')') {
                            let f: Vec<&str> = st[i + 2..].split_whitespace().collect();
                            if f.first() == Some(&"R") {
                                if let Some(c) = f.get(36).and_then(|x| x.parse::<usize>().ok()) { *hist.entry(c).or_insert(0) += 1; }
                            }
                        }
                    }
                }
                n += 1;
                std::thread::sleep(std::time::Duration::from_millis(2));
            }
            (n, hist)
        })
    };
    // The source at OFF bytes past the buffer's start (argv[3], default 0): its address's low bits.
    let off: usize = a.get(3).map_or(0, |x| x.parse().unwrap());
    let mut b = vec![Block::ZERO; (size + off).div_ceil(64).max(1)];
    for (i, x) in Block::bytes_mut(&mut b)[off..off + size].iter_mut().enumerate() { *x = (i * 31) as u8; }
    let bytes = &Block::bytes(&b)[off..];
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
    done.store(true, std::sync::atomic::Ordering::Relaxed);
    let (n, hist) = sampler.join().unwrap();
    println!("samples\t{n}");
    for (c, k) in hist { println!("ran\t{c}\t{k}"); }
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
(cd cand && true); mkdir -p drvc && cp -r drv/src drvc/ && sed_free=1
python3 - "$R/drvc/Cargo.toml" "$R/drv/Cargo.toml" <<'PY_TOML_END'
import sys
s = open(sys.argv[2]).read().replace('path = "../fork"', 'path = "../cand"').replace('name = "copyaddr"', 'name = "copyaddrc"')
open(sys.argv[1], "w").write(s)
PY_TOML_END
(cd drvc && cargo build --release) > "$O/buildc.log" 2>&1 || { echo "driver build failed" >> "$O/status.txt"; exit 2; }
EC="$R/drvc/target/release/copyaddrc"
for i in $(seq 1 24); do
  "$EC" 1048576 2 > "$O/where-cand-whole-$i.txt" 2> "$O/where-cand-whole-$i.err"; echo "where cand whole $i exit $?" >> "$O/status.txt"
  taskset -c 0-5,24-29 "$E" 1048576 2 > "$O/where-base-dom-$i.txt" 2> "$O/where-base-dom-$i.err"; echo "where base dom $i exit $?" >> "$O/status.txt"
done
echo "copywhere done" >> "$O/status.txt"
