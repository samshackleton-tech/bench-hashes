#!/bin/bash
# BLAKE3 #196, the one-L3 cost on the AmpereOne VM (run i196-onel3-ampereone): onel3.sh unconfined
# (the VM is one L3), full runs 2 rounds. (onel3.sh's head:)
# BLAKE3 #196, the one-L3 cost (run i196-onel3; John's ask): servil 354d71d1 and probe/l3-pool-splitfloat
# de0451dc confined to the EPYC's domain 0 (taskset 0-5,24-29: one L3, 6 cores, SMT), so the pool takes
# its one-domain path. One caller streaming 256 KiB-16 MiB messages (8 in flight), with each thread's
# CPU time and voluntary switches; then full runs of servil mt under the same taskset, 3 rounds.
# (cand.sh's head:)
# BLAKE3 #196, John's candidate (run i196-cand): probe/l3-pool-splitfloat de0451dc against servil
# 354d71d1 (its base), both clean commits (--expect-servil each), the driver with the sampler of
# where.sh (on the last CPU). (spin.sh's head:)
# BLAKE3 #196, SPIN's worth (run i196-spin): servil and John's candidate splitfloat (splitwake +
# floating workers), each as is and with SPIN 0 (basens, sfns): idle workers park at once. (The
# splitfloat script's head:)
# BLAKE3 #196, splitfloat (run i196-splitfloat): as the script below with -split replaced by splitfloat
# (splitwake with every worker pinned to its domain, splitfloat_patch.py): base, splitwake,
# splitfloat. (The script's head:)
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
{ grep -m1 'model name' /proc/cpuinfo; nproc; for v in base cand; do echo "$v $(git -C $v log -1 --format=%H)"; done; git -C bench log -1 --format=%H; } > "$O/machine.txt"
(cd cand && CARGO_TARGET_DIR="$R/target-nextest" cargo nextest run --features serde,zeroize --lib --tests) > "$O/nextest-cand.txt" 2>&1; echo "nextest cand exit $?" >> "$O/status.txt"
for v in base cand; do
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
    // Probe (i196-where): a sampler on the last CPU notes, every 2 ms, the CPU of each worker in state R.
    let done = std::sync::Arc::new(std::sync::atomic::AtomicBool::new(false));
    let sampler = {
        let done = done.clone();
        std::thread::spawn(move || {
            pin(std::thread::available_parallelism().map_or(1, |n| n.get()) - 1);
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
        let run: u64 = std::fs::read_to_string(d.join("schedstat")).unwrap_or_default().split_whitespace().next().unwrap_or("0").parse().unwrap_or(0);
        let status = std::fs::read_to_string(d.join("status")).unwrap_or_default();
        let field = |k: &str| status.lines().find_map(|l| l.strip_prefix(k).map(|x| x.trim().to_owned())).unwrap_or_default();
        let tid = d.file_name().unwrap().to_string_lossy().into_owned();
        // comm is cut at 15 bytes (blake3-worker-12 reads blake3-worker-1): the TID (creation order) and the CPUs name a worker.
        println!("thread\t{}\t{run}\t{}\t{tid}\t{}", name.trim(), field("voluntary_ctxt_switches:"), field("Cpus_allowed_list:"));
    }
}
RUST_END
  (cd tc-$v && cargo build --release) > "$O/tc-$v-build.log" 2>&1 || { echo "two-callers $v build failed" >> "$O/status.txt"; exit 2; }
  grep -A2 'name = "blake3-servil"' tc-$v/Cargo.lock > "$O/tc-$v-lock.txt"
done
TS=""   # the VM is one L3 already (AmpereOne, 4 vCPUs, no SMT)
echo "one domain: $TS" >> "$O/machine.txt"
for round in 1 2 3 4 5; do
  for size in 262144 1048576 4194304 16777216; do
    for v in base cand; do
      $TS "$R/tc-$v/target/release/two-callers" $size 2 0 > "$O/one-$v-$size-$round.txt" 2> "$O/one-$v-$size-$round.err"
      echo "one $v size $size round $round exit $?" >> "$O/status.txt"
    done
  done
done
cd "$R/bench"; cargo build --release > "$O/bench-build.log" 2>&1 || { echo "bench build failed" >> "$O/status.txt"; exit 2; }
for v in base cand; do
  E=$(./target/release/bench-hashes build-against "$R/$v" 2> "$O/build-against-$v.err" | tail -1); [ -x "$E" ] || { echo "build-against $v failed" >> "$O/status.txt"; exit 3; }
  echo "$v $E" >> "$O/exes.txt"
done
[ "$(cut -d' ' -f2 "$O/exes.txt" | sort -u | wc -l)" = "$(wc -l < "$O/exes.txt")" ] || { echo "EXECUTABLES NOT DISTINCT" >> "$O/status.txt"; exit 3; }
for round in 1 2; do
  for v in base cand; do
    E=$(grep "^$v " "$O/exes.txt" | cut -d' ' -f2); C=$(git -C "$R/$v" rev-parse HEAD)
    D="$R/scratch-$v-$round"; mkdir -p "$D"; cd "$D"
    $TS "$E" --contenders blake3-servil-mt --expect-servil $C > "$O/full-$v-$round.out" 2> "$O/full-$v-$round.err"
    echo "full $v round $round exit $?" >> "$O/status.txt"
    cp "$D"/benchmark-results/*/bench-hashes.samples.tsv "$O/full-$v-$round.samples.tsv" 2>/dev/null || echo "full $v round $round: NO SAMPLES" >> "$O/status.txt"
  done
  cd "$R/bench"
done
echo "onel3 done" >> "$O/status.txt"
