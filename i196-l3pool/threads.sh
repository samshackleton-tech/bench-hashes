#!/bin/bash
# BLAKE3 #196, -split's two callers in one domain (run i196-threads): the driver of split.sh, which
# now prints each thread's CPU time and voluntary switches at exit; 64 KiB at CPUs 0 / 0,1 / 0,6, and
# 64 B at 0,1, servil, -split and corepin, 3 rounds. Question: do -split's second workers run (beside
# their primaries) when two callers share a domain? (split.sh's head:)
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
{ grep -m1 'model name' /proc/cpuinfo; nproc; for v in base split corepin; do echo "$v $(git -C $v log -1 --format=%H)"; done; git -C bench log -1 --format=%H; } > "$O/machine.txt"
python3 - "$R/corepin" <<'PY_COREPIN_END' || { echo "patch corepin failed" >> "$O/status.txt"; exit 2; }
"""Probe for #196 (corepin), on probe/l3-pool-cores: one worker a physical core, each pinned to its
core's hardware threads, so no two workers share a core (the placement half of the rule, by
construction). Usage: corepin_patch.py TREE"""
import sys, pathlib
tree = pathlib.Path(sys.argv[1])
p = tree / "src/lanes.rs"; s = p.read_text()
a = """    let workers = threads - 1;
    let n = domains.count;
    let weight: Vec<usize> = (0..n).map(|d| domains.cpus[d].len().max(1)).collect();
"""
b = """    let n = domains.count;
    // Probe (corepin): one worker a core, each domain's share its cores.
    let core_lists = |d: usize| -> Vec<String> {
        let mut cores: Vec<String> = domains.cpus[d]
            .iter()
            .filter_map(|c| std::fs::read_to_string(format!("/sys/devices/system/cpu/cpu{c}/topology/core_cpus_list")).ok())
            .map(|l| l.trim().to_owned())
            .collect();
        cores.sort();
        cores.dedup();
        cores
    };
    let weight: Vec<usize> = (0..n).map(|d| core_lists(d).len().max(1)).collect();
    let workers = weight.iter().sum::<usize>().min(threads - 1);
    let threads = workers + 1;
"""
assert s.count(a) == 1, "initialize's workers"; s = s.replace(a, b)
a = """            let mut mask = [0u64; 16];
            for &c in &pool.domains.cpus[d as usize] {
                mask[c / 64] |= 1 << (c % 64);
            }
"""
b = """            // Probe (corepin): this worker on one core's hardware threads.
            let mut cores: Vec<String> = pool.domains.cpus[d as usize]
                .iter()
                .filter_map(|c| std::fs::read_to_string(format!("/sys/devices/system/cpu/cpu{c}/topology/core_cpus_list")).ok())
                .map(|l| l.trim().to_owned())
                .collect();
            cores.sort();
            cores.dedup();
            let mut mask = [0u64; 16];
            match cores.get(local % cores.len().max(1)) {
                Some(list) => {
                    for range in list.split(',') {
                        let (a, b) = range.split_once('-').unwrap_or((range, range));
                        for c in a.trim().parse::<usize>().unwrap()..=b.trim().parse::<usize>().unwrap() {
                            if pool.domains.cpus[d as usize].contains(&c) {
                                mask[c / 64] |= 1 << (c % 64);
                            }
                        }
                    }
                }
                None => {
                    for &c in &pool.domains.cpus[d as usize] {
                        mask[c / 64] |= 1 << (c % 64);
                    }
                }
            }
"""
assert s.count(a) == 1, "worker_main's mask"; s = s.replace(a, b)
p.write_text(s)
print("corepin patched")
PY_COREPIN_END
for v in base split corepin; do
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
    // Every thread's account (probe i196-threads): name, ns on a CPU (schedstat), voluntary switches.
    for e in std::fs::read_dir("/proc/self/task").unwrap() {
        let d = e.unwrap().path();
        let name = std::fs::read_to_string(d.join("comm")).unwrap_or_default();
        let run: u64 = std::fs::read_to_string(d.join("schedstat")).unwrap_or_default().split_whitespace().next().unwrap_or("0").parse().unwrap_or(0);
        let vol = std::fs::read_to_string(d.join("status")).unwrap_or_default().lines().find_map(|l| l.strip_prefix("voluntary_ctxt_switches:").map(|x| x.trim().to_owned())).unwrap_or_default();
        println!("thread\t{}\t{run}\t{vol}", name.trim());
    }
}
RUST_END
  (cd tc-$v && cargo build --release) > "$O/tc-$v-build.log" 2>&1 || { echo "two-callers $v build failed" >> "$O/status.txt"; exit 2; }
  grep -A2 'name = "blake3-servil"' tc-$v/Cargo.lock > "$O/tc-$v-lock.txt"
done
for round in 1 2 3; do
  for c in 65536:0 65536:0,1 65536:0,6 64:0,1; do
    size=${c%%:*}; p=${c#*:}
    for v in base split corepin; do
      "$R/tc-$v/target/release/two-callers" $size 2 $p > "$O/$v-$size-$p-$round.txt" 2> "$O/$v-$size-$p-$round.err"
      echo "$v size $size cpus $p round $round exit $?" >> "$O/status.txt"
    done
  done
done
echo "threads done" >> "$O/status.txt"
