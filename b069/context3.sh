#!/bin/bash
# bench-hashes #69, third run (cold context only, CPUs 0-7, two perf groups of three): John's next step: rebuild the bench's context around a small batch, a piece
# at a time, and see which piece brings back the odd/even gap 0.20's EPYC record shows.
# Factors (each sample one cell on one CPU):
#   context (a fresh process each; 4 processes a context, contexts interleaved):
#     cold      every call after the bench's busy gap (clocks::Gap::Busy: ~1 MiB of other code,
#               a 128 MiB walk, integer work to 1 ms), through clocks::measure_after_gaps_prepared
#               as bench-hashes 0.20 takes a solo ManyMessages sample;
#     pool      cold, with blake3_servil::initialize_multithreaded(None) first (its workers parked);
#     pool+duo  pool, with two copy threads waiting on a condvar, as the bench's Duo between jobs;
#   cpu: 0, 1, 2, 3 (cores 0-3; 1 and 3 odd), the main thread pinned, interleaved within a process;
#   cell: servil st hash_many and official's hidden batch (the bench's blake3_batch), N x 64 B.
# Each cell and CPU: a timed sample (wall and thread counts, the calls alone), a warm control
# (back to back), and a counted sample (perf_event group around each call: cycles, instructions,
# L1i misses, L1d read misses, branch misses, LLC misses).
set -u
R="$1"; O="$R/out"; mkdir -p "$O"; cd "$R"
export HOME=/root; . /root/.cargo/env
{ grep -m1 'model name' /proc/cpuinfo; nproc; cat /sys/devices/system/cpu/smt/control; git -C fork log -1 --format='fork %H'; git -C clockrepo log -1 --format='clocks %H'; for c in 0 1 2 3; do echo "cpu$c core $(cat /sys/devices/system/cpu/cpu$c/topology/core_id) siblings $(cat /sys/devices/system/cpu/cpu$c/topology/thread_siblings_list)"; done; cat /proc/sys/kernel/perf_event_paranoid; } > "$O/machine.txt"
mkdir -p probe/src
cat > probe/Cargo.toml <<'TOML_END'
[package]
name = "context"
version = "0.0.0"
edition = "2021"
[dependencies]
blake3-servil = { path = "../fork", default-features = false, features = ["std"] }
blake3 = { version = "=1.8.7", default-features = false, features = ["std"] }
clocks = { path = "../clockrepo/clocks" }
libc = "0.2"
[profile.release]
debug = false
TOML_END
cat > probe/src/main.rs <<'RUST_END'
//! context MODE PROC SEED: one process of the #69 context experiment (see context.sh).
use blake3_servil::performance::{hash_many, Batch, Block};
use std::hint::black_box;

const GAP_NS: u64 = 1_000_000;
const GAP_WORK_BYTES: usize = 128 * 1024 * 1024;
const NS: [usize; 5] = [1, 2, 8, 64, 1024];
const CPUS: [usize; 8] = [0, 1, 2, 3, 4, 5, 6, 7];
const ROUNDS: usize = 6;

fn pin(cpu: usize) {
    unsafe {
        let mut set: libc::cpu_set_t = std::mem::zeroed();
        libc::CPU_SET(cpu, &mut set);
        assert_eq!(libc::sched_setaffinity(0, std::mem::size_of::<libc::cpu_set_t>(), &set), 0, "pin to {cpu}");
    }
}
fn on_cpu() -> i32 { unsafe { libc::sched_getcpu() } }

/// A perf_event group on this thread (user mode), its first event the leader; read with its
/// time enabled and running (equal when the group was never multiplexed off the PMU).
struct Group { fds: Vec<i32>, n: usize }
impl Group {
    fn open(events: &[(u32, u64)]) -> Option<Group> {
        // perf_event_attr laid out by hand (libc has none): type u32 @0, size u32 @4, config u64 @8,
        // read_format u64 @32, the flag bits @40 (disabled 0, exclude_kernel 5, exclude_hv 6).
        const FORMAT: u64 = 8 | 1 | 2; // GROUP | TOTAL_TIME_ENABLED | TOTAL_TIME_RUNNING
        const IOC_ENABLE: u64 = 0x2400;
        let mut fds: Vec<i32> = Vec::new();
        for (i, &(kind, config)) in events.iter().enumerate() {
            let mut attr = [0u64; 16];
            attr[0] = kind as u64 | (128u64 << 32);
            attr[1] = config;
            attr[4] = FORMAT;
            attr[5] = (1 << 5) | (1 << 6) | if i == 0 { 1 } else { 0 };
            let leader = if i == 0 { -1 } else { fds[0] };
            let fd = unsafe { libc::syscall(libc::SYS_perf_event_open, attr.as_ptr(), 0, -1, leader, 0) } as i32;
            if fd < 0 { eprintln!("perf_event_open event {i} ({kind} {config:#x}) failed"); return None; }
            fds.push(fd);
        }
        unsafe { libc::ioctl(fds[0], IOC_ENABLE as _, 1) };
        Some(Group { n: events.len(), fds })
    }
    #[inline(always)]
    fn read(&self) -> (u64, u64, [u64; 3]) {
        let mut buf = [0u64; 6];
        let want = (3 + self.n) * 8;
        let got = unsafe { libc::read(self.fds[0], buf.as_mut_ptr() as *mut _, want) };
        assert_eq!(got as usize, want);
        assert_eq!(buf[0] as usize, self.n);
        (buf[1], buf[2], [buf[3], buf[4], buf[5]])
    }
}

#[derive(Clone, Copy, PartialEq)]
enum Kind { Servil, Official }

fn official_batch(input: &[u8], out: &mut [[u8; 32]]) {
    const IV: [u32; 8] = [0x6A09E667, 0xBB67AE85, 0x3C6EF372, 0xA54FF53A, 0x510E527F, 0x9B05688C, 0x1F83D9AB, 0x5BE0CD19];
    let (messages, _) = input.as_chunks::<64>();
    let platform = blake3::platform::Platform::detect();
    for (group, out) in black_box(messages).chunks(16).zip(out.chunks_mut(16)) {
        let mut table = [&group[0]; 16];
        for (slot, m) in table.iter_mut().zip(group) { *slot = m; }
        platform.hash_many::<64>(&table[..group.len()], &IV, 0, blake3::IncrementCounter::No, 0, 1, 2 | 8, out.as_flattened_mut());
    }
}

fn call(kind: Kind, blocks: &[Block], out: &mut [[u8; 32]]) {
    match kind {
        Kind::Servil => hash_many(blake3_servil::Mode::Plain, &Batch::from_blocks(blocks, 64), out),
        Kind::Official => official_batch(Block::bytes(blocks), out),
    }
    black_box(&*out);
}

struct Rng(u64);
impl Rng {
    fn next(&mut self) -> u64 { self.0 ^= self.0 << 13; self.0 ^= self.0 >> 7; self.0 ^= self.0 << 17; self.0 }
    fn shuffle<T>(&mut self, v: &mut [T]) { for i in (1..v.len()).rev() { let j = (self.next() % (i as u64 + 1)) as usize; v.swap(i, j); } }
}

fn main() {
    let a: Vec<String> = std::env::args().collect();
    let (mode, proc_id, seed): (&str, usize, u64) = (&a[1], a[2].parse().unwrap(), a[3].parse().unwrap());
    blake3_servil::initialize();
    if mode != "cold" { blake3_servil::initialize_multithreaded(None); }
    if mode == "pool+duo" {
        // Two copy threads waiting on a condvar for a job that never comes, as the bench's Duo between jobs.
        let pair: &'static (std::sync::Mutex<bool>, std::sync::Condvar) = Box::leak(Box::new((std::sync::Mutex::new(false), std::sync::Condvar::new())));
        for copy in 0..2 {
            std::thread::Builder::new().name(format!("duo-copy-{copy}")).spawn(move || {
                let mut posted = pair.0.lock().unwrap();
                while !*posted { posted = pair.1.wait(posted).unwrap(); }
            }).unwrap();
        }
    }
    let work = vec![1u8; GAP_WORK_BYTES];
    let mut rng = Rng(seed | 1);
    // A: L1i misses (ic_tag_hit_miss.instruction_cache_miss), L2 misses of instruction fetches
    // (l2_cache_req_stat.ic_fill_miss), L1 iTLB misses that hit the L2 TLB
    // (bp_l1_tlb_miss_l2_tlb_hit). B: L1d read misses, L2 misses of L1i and L1d
    // (l2_cache_req_stat.ic_dc_miss_in_l2), branch misses. Three counters each: Zen 5 has six,
    // the NMI watchdog takes one, clocks' Counts two (cycles, instructions), and a group is
    // scheduled whole or not at all (run b069-context2: four read time_running 0).
    let groups = [
        Group::open(&[(4, 0x10000188e), (4, 0x164), (4, 0x84)]).expect("group A"),
        Group::open(&[(3, 0 | (0 << 8) | (1 << 16)), (4, 0x964), (0, 5)]).expect("group B"),
    ];
    let max = *NS.iter().max().unwrap();
    let mut source = vec![0u8; max * 64];
    for (i, b) in source.iter_mut().enumerate() { *b = (i * 7 % 251) as u8; }
    let mut produced = vec![Block([0u8; 64]); max];
    let mut out = vec![[0u8; 32]; max];
    // Iterations a sample, as the bench sizes them: calls summing >= 2 us, from 4 calls after gaps on CPU 0.
    let mut iters = std::collections::HashMap::new();
    pin(0);
    for kind in [Kind::Servil, Kind::Official] {
        for &n in &NS {
            let m = clocks::measure_after_gaps_prepared(4, clocks::Gap::Busy(&work), GAP_NS, &mut produced[..n],
                |p| Block::bytes_mut(p).copy_from_slice(black_box(&source[..n * 64])),
                |p| call(kind, p, &mut out[..n]));
            let per = (m.calls.wall_ns / 4).max(1);
            iters.insert((kind as u8, n), (2000u64.div_ceil(per)).max(1));
        }
    }
    let mut cells: Vec<(Kind, usize)> = [Kind::Servil, Kind::Official].iter().flat_map(|&k| NS.iter().map(move |&n| (k, n))).collect();
    for round in 0..ROUNDS {
        rng.shuffle(&mut cells);
        for &(kind, n) in &cells {
            let mut cpus = CPUS;
            rng.shuffle(&mut cpus);
            let calls = iters[&(kind as u8, n)];
            let name = if kind == Kind::Servil { "servil" } else { "official" };
            for &cpu in &cpus {
                pin(cpu);
                // Timed, as the bench: wall and thread counts of the calls alone, summed.
                let m = clocks::measure_after_gaps_prepared(calls, clocks::Gap::Busy(&work), GAP_NS, &mut produced[..n],
                    |p| Block::bytes_mut(p).copy_from_slice(black_box(&source[..n * 64])),
                    |p| call(kind, p, &mut out[..n]));
                let ran = on_cpu();
                let (cyc, ins) = m.calls.counts.map(|c| (c.p.cycles + c.e.cycles, c.p.instructions + c.e.instructions)).unwrap_or((0, 0));
                println!("{mode}\t{proc_id}\t{round}\t{name}\t{n}\t{cpu}\ttimed\t{calls}\t{}\t{cyc}\t{ins}\t{ran}", m.calls.wall_ns);
                // Warm control: 200 calls back to back.
                Block::bytes_mut(&mut produced[..n]).copy_from_slice(&source[..n * 64]);
                for _ in 0..20 { call(kind, &produced[..n], &mut out[..n]); }
                let t = clocks::now();
                for _ in 0..200 { call(kind, &produced[..n], &mut out[..n]); }
                println!("{mode}\t{proc_id}\t{round}\t{name}\t{n}\t{cpu}\twarm\t200\t{}\t0\t0\t{}", clocks::since_ns(t), on_cpu());
                // Counted: each group read around each call, after the same gaps.
                for (gi, g) in groups.iter().enumerate() {
                    let mut sum = [0u64; 3];
                    let (mut en, mut run) = (0u64, 0u64);
                    clocks::measure_after_gaps_prepared(calls, clocks::Gap::Busy(&work), GAP_NS, &mut produced[..n],
                        |p| Block::bytes_mut(p).copy_from_slice(black_box(&source[..n * 64])),
                        |p| {
                            let (e0, r0, before) = g.read();
                            call(kind, p, &mut out[..n]);
                            let (e1, r1, after) = g.read();
                            en += e1 - e0; run += r1 - r0;
                            for i in 0..3 { sum[i] += after[i] - before[i]; }
                        });
                    // calls + 1 calls ran f (the first, untimed, too).
                    println!("{mode}\t{proc_id}\t{round}\t{name}\t{n}\t{cpu}\tcounted{}\t{}\t{en}\t{run}\t{}\t{}\t{}\t{}", ["A", "B"][gi], calls + 1, sum[0], sum[1], sum[2], on_cpu());
                }
            }
        }
    }
}
RUST_END
(cd probe && cargo build --release) > "$O/probe-build.log" 2>&1 || { echo "probe build failed" >> "$O/status.txt"; exit 2; }
grep -A2 -E '^name = "(blake3-servil|blake3|clocks)"$' probe/Cargo.lock > "$O/probe-lock.txt"
P="$R/probe/target/release/context"
# The cold context alone (pool and copy threads added nothing, run b069-context): six processes.
for k in 1 2 3 4 5 6; do
  "$P" cold "$k" "$((k * 7919 + 13))" >> "$O/samples.tsv" 2>> "$O/probe-stderr.txt" || echo "process $k failed" >> "$O/status.txt"
done
echo "context done" >> "$O/status.txt"
