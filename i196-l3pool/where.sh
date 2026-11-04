#!/bin/bash
# BLAKE3 #196, where the Xeon's workers run (run i196-where-icelake; John's question): lineage.sh's
# driver with a sampler thread (CPU 27) noting each running worker's CPU every 2 ms; servil and -cores,
# 64 B at 0,1 / 0,28 / 0, 1 KiB at 0,1, 3 rounds. (lineage.sh's head:)
# BLAKE3 #196, which step of the probes costs the Xeon its 64 B cells (run i196-lineage-icelake):
# callwait.sh's driver with servil, -cores (95ebbe37) and -split (52f894f0), 64 B at 0,1 / 0 / 0,28 and
# 1 KiB at 0,1, 3 rounds. (callwait.sh's head:)
# BLAKE3 #196, the Xeon's small cells (run i196-callwait-icelake): splitwakex.sh's pinned callers alone
# (64 B at 0,1 and 0; 1 KiB and 64 KiB at 0,1), each caller printing its own run and run-queue wait
# (schedstat) and involuntary switches before it ends; every thread's wait too. Question: do -split's
# workers, pinned one a core, push the pinned callers off their CPUs? (splitwakex.sh's head:)
# BLAKE3 #196, splitwake on the 2x Xeon Gold 6330 (run i196-splitwake-icelake): splitwake.sh with two
# callers in two domains at CPUs 0,28 (socket 0 is 0-27,56-83; socket 1 28-55,84-111).
# (splitwake.sh's head:)
# BLAKE3 #196, splitwake (run i196-splitwake): split.sh with corepin replaced by splitwake (-split
# 52f894f0 with splitwake_patch.py inline: a stream's wakes for parked primaries only), its suite
# run first; the driver prints each thread's account (threads2.sh's). (split.sh's head:)
# BLAKE3 #196, John's -split (run i196-split): corepin.sh with -cores replaced by probe/l3-pool-split
# 52f894f0 (primaries take stream tasks, every worker job pieces); corepin's full runs without
# --expect-servil. (corepin.sh's head:)
# BLAKE3 #196, corepin's cost where SMT pays (run i196-corepin): l3v4's measurements with servil,
# -cores and corepin (-cores with one worker a physical core, corepin_patch.py inline).
# (cores.sh's head:)
# BLAKE3 #196: probe/l3-pool-cores (John's: on -r, a domain running as many stream tasks as it has
# physical cores leaves its streams' tasks to other domains) beside probe/l3-pool-r and servil
# 68fd3e57, on the EPYC (the commits are the manifest's). l3v4.sh's measurements:
# 1. One caller streaming (8 places, 2 s) at 16, 64 and 256 KiB, 5 rounds.
# 2. Callers pinned: one (CPU 0), two in one domain (0,1), two in two domains (0,6), at 64 B, 1 KiB
#    and 64 KiB, 3 rounds. (The program: twocallers.sh's, built the same way, once per checkout.)
# 3. Full runs of servil mt (--contenders blake3-servil-mt), each checkout built against, 2 rounds.
set -u
R="$1"; O="$R/out"; mkdir -p "$O"; cd "$R"
. /root/.cargo/env
{ grep -m1 'model name' /proc/cpuinfo; nproc; for v in base cores split; do echo "$v $(git -C $v log -1 --format=%H)"; done; git -C bench log -1 --format=%H; } > "$O/machine.txt"
for v in base cores; do
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
    // Probe (i196-where): a sampler on CPU 27 notes, every 2 ms, the CPU of each worker in state R.
    let done = std::sync::Arc::new(std::sync::atomic::AtomicBool::new(false));
    let sampler = {
        let done = done.clone();
        std::thread::spawn(move || {
            pin(27);
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
            // This caller's own account before it ends (probe i196-callwait): ns run, ns waiting
            // on a run queue (schedstat), involuntary switches.
            let st = std::fs::read_to_string("/proc/thread-self/schedstat").unwrap_or_default();
            let mut f = st.split_whitespace();
            let (run, wait) = (f.next().unwrap_or("0").to_owned(), f.next().unwrap_or("0").to_owned());
            let status = std::fs::read_to_string("/proc/thread-self/status").unwrap_or_default();
            let inv = status.lines().find_map(|l| l.strip_prefix("nonvoluntary_ctxt_switches:").map(|x| x.trim().to_owned())).unwrap_or_default();
            println!("caller\t{cpu}\t{run}\t{wait}\t{inv}");
            (cpu, count.get() as f64 / t.elapsed().as_secs_f64())
        })
    }).collect();
    for h in handles { let (cpu, rate) = h.join().unwrap(); println!("cpu {cpu}\t{rate:.0}"); }
    done.store(true, std::sync::atomic::Ordering::Relaxed);
    let (n, hist) = sampler.join().unwrap();
    println!("samples\t{n}");
    for (c, k) in hist { println!("ran\t{c}\t{k}"); }
    // Every thread's account (probe i196-threads): name, ns on a CPU (schedstat), voluntary switches.
    for e in std::fs::read_dir("/proc/self/task").unwrap() {
        let d = e.unwrap().path();
        let name = std::fs::read_to_string(d.join("comm")).unwrap_or_default();
        let sched = std::fs::read_to_string(d.join("schedstat")).unwrap_or_default();
        let run: u64 = sched.split_whitespace().next().unwrap_or("0").parse().unwrap_or(0);
        let wait: u64 = sched.split_whitespace().nth(1).unwrap_or("0").parse().unwrap_or(0);
        let status = std::fs::read_to_string(d.join("status")).unwrap_or_default();
        let field = |k: &str| status.lines().find_map(|l| l.strip_prefix(k).map(|x| x.trim().to_owned())).unwrap_or_default();
        let tid = d.file_name().unwrap().to_string_lossy().into_owned();
        // comm is cut at 15 bytes (blake3-worker-12 reads blake3-worker-1): the TID (creation order) and the CPUs name a worker.
        println!("thread\t{}\t{run}\t{}\t{tid}\t{}\t{wait}\t{}", name.trim(), field("voluntary_ctxt_switches:"), field("Cpus_allowed_list:"), field("nonvoluntary_ctxt_switches:"));
    }
}
RUST_END
  (cd tc-$v && cargo build --release) > "$O/tc-$v-build.log" 2>&1 || { echo "two-callers $v build failed" >> "$O/status.txt"; exit 2; }
  grep -A2 'name = "blake3-servil"' tc-$v/Cargo.lock > "$O/tc-$v-lock.txt"
done
for round in 1 2 3; do
  for c in 64:0,1 64:0,28 64:0 1024:0,1; do
    size=${c%%:*}; p=${c#*:}
    for v in base cores; do
      "$R/tc-$v/target/release/two-callers" $size 2 $p > "$O/$v-$size-$p-$round.txt" 2> "$O/$v-$size-$p-$round.err"
      echo "$v size $size cpus $p round $round exit $?" >> "$O/status.txt"
    done
  done
done
echo "where done" >> "$O/status.txt"
