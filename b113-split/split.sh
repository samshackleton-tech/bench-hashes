#!/bin/bash
# bench-hashes #113: what between the gap and the call makes a small cold call after other work
# cheaper? John's split, as a probe outside the bench. Per visit: walk a 128 MiB buffer (other work's
# reads), then one filler, then the timed call. Fillers, interleaved visit by visit: none; two perf
# read()s of an instructions counter (as clocks' Counts::read); two getppid() (a syscall that does
# nothing); a spin as long as the two perf reads took (their median, measured first). Calls:
# blake3-servil convenience::hash (b5b988d8) and official blake3 1.8.7 hash, one message of 64 B,
# 1 KiB, 16 KiB. 600 visits a condition, pinned to CPU 2.
set -u
R="$1"; O="$R/out"; mkdir -p "$O"; cd "$R"
. /root/.cargo/env
{ grep -m1 'model name' /proc/cpuinfo; nproc; uname -r; cat /proc/sys/kernel/perf_event_paranoid; git -C fork log -1 --format=%H; } > "$O/machine.txt"
mkdir -p probe/src
cat > probe/Cargo.toml <<'TOML_END'
[package]
name = "split-probe"
version = "0.0.0"
edition = "2021"
[dependencies]
blake3-servil = { path = "../fork" }
blake3 = "=1.8.7"
libc = "0.2"
TOML_END
cat > probe/src/main.rs <<'RUST_END'
//! Per visit: a 128 MiB walk, a filler (none, perf, getppid, spin), the timed hash. Prints
//! "filler<TAB>hash<TAB>size<TAB>ns" per visit, and the perf reads' median first.
use std::time::Instant;

#[repr(C)]
#[derive(Default)]
struct PerfEventAttr {
    type_: u32,
    size: u32,
    config: u64,
    sample_period: u64,
    sample_type: u64,
    read_format: u64,
    flags: u64,
    wakeup_events: u32,
    bp_type: u32,
    config1: u64,
}

fn instructions_counter() -> i32 {
    // PERF_TYPE_HARDWARE 0, PERF_COUNT_HW_INSTRUCTIONS 1; flags: exclude_kernel (bit 5), exclude_hv (bit 6).
    let attr = PerfEventAttr { type_: 0, size: std::mem::size_of::<PerfEventAttr>() as u32, config: 1, flags: (1 << 5) | (1 << 6), ..Default::default() };
    // Sound: perf_event_open reads `attr` (its size given) for this thread on any CPU.
    let fd = unsafe { libc::syscall(libc::SYS_perf_event_open, &attr as *const PerfEventAttr, 0, -1, -1, 0) } as i32;
    assert!(fd >= 0, "perf_event_open: {}", std::io::Error::last_os_error());
    fd
}

fn read_counter(fd: i32) -> u64 {
    let mut v = 0u64;
    // Sound: reads 8 bytes into v.
    let n = unsafe { libc::read(fd, &mut v as *mut u64 as *mut libc::c_void, 8) };
    assert_eq!(n, 8);
    v
}

fn main() {
    let visits: usize = std::env::args().nth(1).map_or(600, |a| a.parse().unwrap());
    blake3_servil::initialize();
    let fd = instructions_counter();
    let mut walk = vec![1u8; 128 << 20];
    let mut sink = 0u64;
    let other = |v: &mut Vec<u8>, i: usize| {
        let mut s = 0u64;
        for c in v.chunks(64) { s = s.wrapping_add(c[0] as u64); }
        let n = v.len();
        v[i % n] = s as u8;
        s
    };
    // The perf reads' median duration, for the spin.
    let mut d: Vec<u128> = (0..200).map(|_| { let t = Instant::now(); std::hint::black_box(read_counter(fd)); std::hint::black_box(read_counter(fd)); t.elapsed().as_nanos() }).collect();
    d.sort();
    let spin_ns = d[d.len() / 2];
    println!("# perf reads median ns\t{spin_ns}");
    let fillers = ["none", "perf", "getppid", "spin"];
    let sizes = [64usize, 1024, 16384];
    let data: Vec<u8> = (0..16384).map(|i| (i * 7) as u8).collect();
    let mut i = 0usize;
    for v in 0..visits {
        for (fi, f) in fillers.iter().enumerate() {
            for &size in &sizes {
                for hash in ["servil", "official"] {
                    i += 1;
                    sink = sink.wrapping_add(other(&mut walk, i));
                    match fi {
                        1 => { std::hint::black_box(read_counter(fd)); std::hint::black_box(read_counter(fd)); }
                        // Sound: getppid takes nothing and can't fail.
                        2 => unsafe { std::hint::black_box(libc::getppid()); std::hint::black_box(libc::getppid()); },
                        3 => { let t = Instant::now(); while t.elapsed().as_nanos() < spin_ns {} }
                        _ => {}
                    }
                    let input = &data[..size];
                    let t = Instant::now();
                    let h = if hash == "servil" { *blake3_servil::convenience::hash(input).as_bytes() } else { *blake3::hash(input).as_bytes() };
                    let ns = t.elapsed().as_nanos();
                    std::hint::black_box(h);
                    if v > 0 { println!("{f}\t{hash}\t{size}\t{ns}"); }
                }
            }
        }
    }
    eprintln!("sink {sink}");
}
RUST_END
(cd probe && cargo build --release) > "$O/probe-build.log" 2>&1 || { echo "probe build failed" >> "$O/status.txt"; exit 2; }
grep -A2 'name = "blake3-servil"' probe/Cargo.lock > "$O/probe-lock.txt"; grep -A1 'name = "blake3"$' probe/Cargo.lock >> "$O/probe-lock.txt"
taskset -c 2 probe/target/release/split-probe 600 > "$O/visits.tsv" 2> "$O/probe.err"; echo "probe exit $?" >> "$O/status.txt"
echo "split done" >> "$O/status.txt"
