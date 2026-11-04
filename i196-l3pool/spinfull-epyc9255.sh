#!/bin/bash
# BLAKE3 #196, SPIN's worth, full runs (run i196-spinfull): spin.sh's full runs alone (i196-spin's
# stopped at its executables check, which still counted 3 variants). (spin.sh's head:)
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
{ grep -m1 'model name' /proc/cpuinfo; nproc; for v in base basens splitfloat sfns; do echo "$v $(git -C $v log -1 --format=%H)"; done; git -C bench log -1 --format=%H; } > "$O/machine.txt"
for t in splitfloat sfns; do
python3 - "$R/$t" <<'PY_SPLITWAKE2_END' || { echo "patch $t failed" >> "$O/status.txt"; exit 2; }
"""Probe for #196 (splitwake), on probe/l3-pool-split 52f894f0: a stream's wakes go to parked
primaries only (a domain's first `cores` workers), so a domain whose primaries all run passes the
wake to the next domain, where -split's woke a second worker that may not take it. Job wakes are
unchanged. Usage: splitwake_patch.py TREE"""
import sys, pathlib

tree = pathlib.Path(sys.argv[1])


def sub(path, a, b, n=1):
    p = tree / path
    s = p.read_text()
    assert s.count(a) == n, f"{path}: {a[:60]!r} found {s.count(a)} times"
    p.write_text(s.replace(a, b))


# park.rs: wake one parked worker below `limit`.
sub("src/park.rs", """    /// Wake workers for `wanted` pieces of new work, given `workers`
""", """    /// Wake one parked worker of index below `limit`, if any (PROBE #196,
    /// splitwake: a stream's wake, for a primary).
    pub(crate) fn wake_one_below(&self, limit: usize) -> bool {
        for (w, (word, handles)) in self.parked.iter().zip(self.handles.chunks(64)).enumerate() {
            let below = limit.saturating_sub(w * 64);
            if below == 0 {
                break;
            }
            let mask = if below >= 64 { u64::MAX } else { (1u64 << below) - 1 };
            let mut bits = word.load(Ordering::SeqCst) & mask;
            while bits != 0 {
                let bit = 1u64 << bits.trailing_zeros();
                let before = word.fetch_and(!bit, Ordering::SeqCst);
                if before & bit != 0 {
                    handles[bit.trailing_zeros() as usize].get().expect("a parked worker has set its thread").unpark();
                    return true;
                }
                bits = before & !bit & mask;
            }
        }
        false
    }

    /// Wake workers for `wanted` pieces of new work, given `workers`
""")

# lanes.rs: the stream's wake.
sub("src/lanes.rs", """    /// Whether `domain` runs as many stream tasks as it has cores (PROBE
""", """    /// Domain `d`'s primaries: its first workers, one a core (all of them
    /// where the cores are unknown). PROBE #196, splitwake.
    fn primaries(&self, d: usize) -> usize {
        let c = self.core_cpus.get(d).map_or(0, |c| c.len());
        if c == 0 { usize::MAX } else { c }
    }

    /// Wake one parked primary for a stream's task: of `domain`, or, where
    /// it is busy, of another domain first (EVERY: of any). PROBE #196,
    /// splitwake.
    pub(crate) fn wake_stream(&self, domain: u32) -> bool {
        if self.one {
            return self.park.wake_one_below(self.primaries(0));
        }
        if domain == EVERY {
            return self.parks().enumerate().any(|(d, p)| p.wake_one_below(self.primaries(d)));
        }
        if self.busy(domain) {
            return self.parks().enumerate().any(|(d, p)| d != domain as usize && p.wake_one_below(self.primaries(d)))
                || self.park_of(domain as usize).wake_one_below(self.primaries(domain as usize));
        }
        self.park_of(domain as usize).wake_one_below(self.primaries(domain as usize))
    }

    /// Whether `domain` runs as many stream tasks as it has cores (PROBE
""")
sub("src/lanes.rs", """            if p + 1 - self.claimed.load(Ordering::Relaxed) >= 2 {
                pool.wake_one(domain);
            }""", """            if p + 1 - self.claimed.load(Ordering::Relaxed) >= 2 {
                pool.wake_stream(domain);
            }""")
sub("src/lanes.rs", """            if self.waiting() > 0 {
                pool.wake_one(self.domain.load(Ordering::Relaxed));
            }""", """            if self.waiting() > 0 {
                pool.wake_stream(self.domain.load(Ordering::Relaxed));
            }""")
sub("src/lanes.rs", """            if source.waiting() >= 2 {
                pool().wake_one(source.domain.load(Ordering::Relaxed));
            }""", """            if source.waiting() >= 2 {
                if source.ring.is_empty() {
                    pool().wake_one(source.domain.load(Ordering::Relaxed));
                } else {
                    pool().wake_stream(source.domain.load(Ordering::Relaxed));
                }
            }""")
print("splitwake patched")
PY_SPLITWAKE2_END
done
for t in splitfloat sfns; do
python3 - "$R/$t" <<'PY_SPLITFLOAT_END' || { echo "patch splitfloat $t failed" >> "$O/status.txt"; exit 2; }
"""Probe for #196 (splitfloat), on splitwake (splitwake_patch.py applied first): every worker pinned to
its domain's CPUs, as servil's are, not to one core's; primaries and second workers stay as they are
counted (a domain's first `cores` workers take stream tasks). Usage: splitfloat_patch.py TREE"""
import sys, pathlib
p = pathlib.Path(sys.argv[1]) / "src/lanes.rs"
s = p.read_text()
a = "            let cpus = if cores.is_empty() { &pool.domains.cpus[d as usize] } else { &cores[local % cores.len()] };\n"
assert s.count(a) == 1, "worker_main's mask"
s = s.replace(a, "            // Probe (splitfloat): the domain's CPUs, every worker.\n            let cpus = &pool.domains.cpus[d as usize];\n")
p.write_text(s)
print("splitfloat patched")
PY_SPLITFLOAT_END
done
for t in basens sfns; do
python3 - "$R/$t/src/lanes.rs" <<'PY_NOSPIN_END' || { echo "patch nospin $t failed" >> "$O/status.txt"; exit 2; }
import sys
p = sys.argv[1]; s = open(p).read()
a = "const SPIN: std::time::Duration = std::time::Duration::from_micros(5);"
assert s.count(a) == 1
open(p, "w").write(s.replace(a, "const SPIN: std::time::Duration = std::time::Duration::from_micros(0); // probe i196-spin"))
PY_NOSPIN_END
git -C "$R/$t" diff --stat > "$O/patch-$t.txt"
done
(cd splitfloat && CARGO_TARGET_DIR="$R/target-nextest" cargo nextest run --features serde,zeroize --lib --tests) > "$O/nextest-splitfloat.txt" 2>&1; echo "nextest splitfloat exit $?" >> "$O/status.txt"
for v in base basens splitfloat sfns; do
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
cd "$R/bench"; cargo build --release > "$O/bench-build.log" 2>&1 || { echo "bench build failed" >> "$O/status.txt"; exit 2; }
for v in base basens splitfloat sfns; do
  E=$(./target/release/bench-hashes build-against "$R/$v" 2> "$O/build-against-$v.err" | tail -1); [ -x "$E" ] || { echo "build-against $v failed" >> "$O/status.txt"; exit 3; }
  echo "$v $E" >> "$O/exes.txt"
done
[ "$(cut -d' ' -f2 "$O/exes.txt" | sort -u | wc -l)" = "$(wc -l < "$O/exes.txt")" ] || { echo "EXECUTABLES NOT DISTINCT" >> "$O/status.txt"; exit 3; }
for round in 1 2; do
  for v in base basens splitfloat sfns; do
    E=$(grep "^$v " "$O/exes.txt" | cut -d' ' -f2); C=$(git -C "$R/$v" rev-parse HEAD)
    D="$R/scratch-$v-$round"; mkdir -p "$D"; cd "$D"
    X="--expect-servil $C"; [ $v != base ] && X=""  # splitwake is a patched tree: its header names it
    "$E" --contenders blake3-servil-mt $X > "$O/full-$v-$round.out" 2> "$O/full-$v-$round.err"
    echo "full $v round $round exit $?" >> "$O/status.txt"
    cp "$D"/benchmark-results/*/bench-hashes.samples.tsv "$O/full-$v-$round.samples.tsv" 2>/dev/null || echo "full $v round $round: NO SAMPLES" >> "$O/status.txt"
  done
  cd "$R/bench"
done
echo "v3 done" >> "$O/status.txt"
