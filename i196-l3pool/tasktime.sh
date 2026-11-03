#!/bin/bash
# BLAKE3 #196: where -r's extra ~0.6 us a 64 KiB message goes. Both sides (servil 68fd3e57, -r
# 8381f8d9) patched alike for this probe only: Task::run records its start and end (rdtscp, which
# also names the CPU) in a per-thread log (no shared writes while timing); the probe stream records
# each message's submit and its hand-back (collect). One caller on CPU 0, 64 KiB messages, 4 and 8
# in flight, 2 s, 3 rounds, interleaved.
set -u
R="$1"; O="$R/out"; mkdir -p "$O"; cd "$R"
. /root/.cargo/env
{ grep -m1 'model name' /proc/cpuinfo; nproc; for v in base r; do echo "$v $(git -C $v log -1 --format=%H)"; done; } > "$O/machine.txt"
for v in base r; do
  python3 - "$R/$v" <<'PY_PATCH_END' || { echo "patch $v failed" >> "$O/status.txt"; exit 2; }
import sys, pathlib
tree = pathlib.Path(sys.argv[1])
lanes = tree / "src/lanes.rs"; s = lanes.read_text()
a = "    pub(crate) fn run(self, platform: Platform) {\n        if self.members > 0 {"
b = "    pub(crate) fn run(self, platform: Platform) {\n        let probe_start = crate::probe::tsc().0;\n        if self.members > 0 {"
assert s.count(a) == 1, "run's head"; s = s.replace(a, b)
for a in ("            unsafe { &*self.left }.fetch_sub(self.members, Ordering::Release);\n",
          "        unsafe { &*self.left }.fetch_sub(1, Ordering::Release);\n"):
    assert s.count(a) == 1, a
    s = s.replace(a, a.replace("unsafe", "crate::probe::record(probe_start);\n" + a[:len(a) - len(a.lstrip())] + "unsafe", 1))
lanes.write_text(s)
lib = tree / "src/lib.rs"
lib.write_text(lib.read_text() + '''
/// Probe for #196 only: each task's start and end and CPU, a log a thread.
#[doc(hidden)]
pub mod probe {
    use std::cell::UnsafeCell;
    use std::sync::Mutex;
    pub struct Log(UnsafeCell<Vec<(u64, u64, u32)>>);
    // Sound for the probe: a thread writes only its own log; take() reads them when no task runs.
    unsafe impl Sync for Log {}
    static LOGS: Mutex<Vec<&'static Log>> = Mutex::new(Vec::new());
    std::thread_local! {
        static MINE: &'static Log = {
            let log: &'static Log = Box::leak(Box::new(Log(UnsafeCell::new(Vec::with_capacity(1 << 20)))));
            LOGS.lock().unwrap().push(log);
            log
        };
    }
    #[inline(always)]
    pub fn tsc() -> (u64, u32) {
        let mut aux = 0u32;
        // Sound: rdtscp exists on every x86-64 CPU this probe runs on.
        let t = unsafe { core::arch::x86_64::__rdtscp(&mut aux) };
        (t, aux & 0xfff)
    }
    #[inline]
    pub fn record(start: u64) {
        let (end, cpu) = tsc();
        MINE.with(|log| unsafe { (*log.0.get()).push((start, end, cpu)) });
    }
    /// Every thread's records, taken: call when no stream runs.
    pub fn take() -> Vec<(u64, u64, u32)> {
        let logs = LOGS.lock().unwrap();
        let mut out = Vec::new();
        for log in logs.iter() {
            unsafe { out.append(&mut *log.0.get()) };
        }
        out
    }
}
''')
print("patched", tree)
PY_PATCH_END
  git -C $v diff --stat >> "$O/patch-$v.txt"
  mkdir -p tc-$v/src
  cat > tc-$v/Cargo.toml <<TOML_END
[package]
name = "task-time"
version = "0.0.0"
edition = "2021"
[dependencies]
blake3-servil = { path = "../$v" }
libc = "0.2"
TOML_END
  cat > tc-$v/src/main.rs <<'RUST_END'
//! task-time SIZE SECS INFLIGHT OUT: one caller pinned to CPU 0 streaming SIZE-byte messages,
//! INFLIGHT places; writes OUT.tasks (start end cpu, ticks) and OUT.msgs (submit collect ticks),
//! and prints messages a second and ticks a ns.
use blake3_servil::performance::{stream, Block};
use blake3_servil::{probe, Hash, Mode};
use std::io::Write;
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
    let (size, secs, inflight, out): (usize, f64, usize, &str) = (a[1].parse().unwrap(), a[2].parse().unwrap(), a[3].parse().unwrap(), &a[4]);
    blake3_servil::initialize_multithreaded(None);
    pin(0);
    let mut b = vec![Block::ZERO; size.div_ceil(64)];
    for (i, x) in Block::bytes_mut(&mut b)[..size].iter_mut().enumerate() { *x = (i * 31) as u8; }
    let mut places = vec![Hash::from([0; 32]); inflight];
    let base = places.as_ptr() as usize;
    let submitted = std::cell::RefCell::new(vec![0u64; inflight]);
    let msgs = std::cell::RefCell::new(Vec::with_capacity(1 << 21));
    let free = std::cell::RefCell::new(places.iter_mut().collect::<Vec<_>>());
    probe::take();
    let (t0, i0) = (probe::tsc().0, Instant::now());
    let until = i0 + Duration::from_secs_f64(secs);
    stream(Mode::Plain, |p: &mut [Hash]| {
        let now = probe::tsc().0;
        let k = (p.as_ptr() as usize - base) / core::mem::size_of::<Hash>();
        msgs.borrow_mut().push((submitted.borrow()[k], now));
        std::hint::black_box(&p[0]);
        free.borrow_mut().push(&mut p[0]);
    }, |s| {
        while Instant::now() < until {
            for _ in 0..64 {
                let place = loop { if let Some(p) = free.borrow_mut().pop() { break p; } s.collect(); };
                let k = (place as *mut Hash as usize - base) / core::mem::size_of::<Hash>();
                submitted.borrow_mut()[k] = probe::tsc().0;
                s.submit(&b, size, place);
            }
        }
        s.finish();
    });
    let (t1, el) = (probe::tsc().0, i0.elapsed());
    let tasks = probe::take();
    let mut f = std::io::BufWriter::new(std::fs::File::create(format!("{out}.tasks")).unwrap());
    for (s, e, c) in &tasks { writeln!(f, "{s}\t{e}\t{c}").unwrap(); }
    let mut g = std::io::BufWriter::new(std::fs::File::create(format!("{out}.msgs")).unwrap());
    for (s, c) in msgs.borrow().iter() { writeln!(g, "{s}\t{c}").unwrap(); }
    println!("{:.0}\t{:.4}", msgs.borrow().len() as f64 / el.as_secs_f64(), (t1 - t0) as f64 / el.as_nanos() as f64);
}
RUST_END
  (cd tc-$v && cargo build --release) > "$O/tc-$v-build.log" 2>&1 || { echo "probe $v build failed" >> "$O/status.txt"; exit 2; }
  grep -A2 'name = "blake3-servil"' tc-$v/Cargo.lock > "$O/tc-$v-lock.txt"
done
for round in 1 2 3; do
  for n in 4 8; do
    for v in base r; do
      r=$("$R/tc-$v/target/release/task-time" 65536 2 $n "$O/$v-$n-$round"); echo "$v $n $round $r" >> "$O/results.txt"
    done
  done
done
gzip -9 "$O"/*.tasks "$O"/*.msgs
echo "tasktime done" >> "$O/status.txt"
