#!/bin/bash
# BLAKE3 #196 follow-up, ASLR (run copyaslr): copyphys.sh's driver, servil on domain 0, 1 MiB copied, 24
# processes with address randomization off (setarch -R) and 24 with it on, interleaved. (copyphys.sh's head:)
# BLAKE3 #196 follow-up, physical placement (run copyphys): the driver also reads, as root, the physical
# frames of the source's pages and the first message's ring pages, and counts the pairs sharing the L2
# set's page bits (12-15) and bits 12-19; servil on domain 0, 1 MiB copied, 40 processes.
# (copyperf.sh's head:)
# BLAKE3 #196 follow-up, what differs between fast and slow processes (run copyperf): copyoff.sh's drivers,
# 1 MiB copied, each process under perf stat (cycles, instructions, where L2's fills came from, dTLB
# misses): servil on domain 0, 32 processes; the candidate on the whole machine, 16. (copyoff.sh's head:)
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
    println!("src\t{:#x}", src);
    // Physical frames (root: /proc/self/pagemap) of the source's pages and the first message's ring pages
    // (its first room onwards, size bytes): per page k, whether the pair shares physical bits 12-15 (the
    // high bits of a 1 MiB, 16-way L2's set index) and bits 12-19.
    {
        use std::io::{Read, Seek, SeekFrom};
        let pfn = |va: usize| -> Option<u64> {
            let mut f = std::fs::File::open("/proc/self/pagemap").ok()?;
            f.seek(SeekFrom::Start((va / 4096 * 8) as u64)).ok()?;
            let mut e = [0u8; 8];
            f.read_exact(&mut e).ok()?;
            let e = u64::from_le_bytes(e);
            if e >> 63 == 1 { Some(e & ((1 << 55) - 1)) } else { None }
        };
        let r0 = rooms.borrow()[0];
        let pages = size / 4096;
        let (mut same4, mut same8, mut known) = (0, 0, 0);
        let mut sp = Vec::new(); let mut dp = Vec::new();
        for k in 0..pages {
            if let (Some(a), Some(b)) = (pfn(src + k * 4096), pfn(r0 + k * 4096)) {
                known += 1;
                if (a ^ b) & 0xf == 0 { same4 += 1; }
                if (a ^ b) & 0xff == 0 { same8 += 1; }
                if k < 8 { sp.push(format!("{a:#x}")); dp.push(format!("{b:#x}")); }
            }
        }
        println!("phys\tpages {pages} known {known} same bits 12-15 {same4} same bits 12-19 {same8}\tsrc {}\tdst {}", sp.join(","), dp.join(","));
    }
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
  taskset -c 0-5,24-29 setarch -R "$E" 1048576 2 > "$O/norand-$i.txt" 2> "$O/norand-$i.err"; echo "norand $i exit $?" >> "$O/status.txt"
  taskset -c 0-5,24-29 "$E" 1048576 2 > "$O/rand-$i.txt" 2> "$O/rand-$i.err"; echo "rand $i exit $?" >> "$O/status.txt"
done
echo "copyaslr done" >> "$O/status.txt"
