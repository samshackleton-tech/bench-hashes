#!/bin/bash
# BLAKE3 #196 / bench-hashes, the copy's cause on the 2x Xeon Gold 6330 (run i196-ctask3-xeon): as
# i196-ctask3, free and under taskset on socket 0 (0-27,56-83: one L3), 2 rounds each.
# (ctask2.sh's head:)
# BLAKE3 #196 / bench-hashes, the caller's side (run i196-ctask2): as i196-ctask, with submit_with's
# reserve, fill and hand-over marked (kinds 3, 5, 6, 4), bench 0.20.4, 2 rounds. (ctask.sh's head:)
# BLAKE3 #196 / bench-hashes: the bench's own servil mt ContinuousMessages 64 KiB cell (0.20 records:
# on the EPYC mt slower than st, 0.108 against 0.081 ns/B; 0.19.3's record read 0.0807), timed task by
# task. servil 0.8 (b5b988d8) patched for this probe only: Task::run logs each task's start, end and
# CPU (rdtscp); stream() logs its own begin and end, so each sample's stream is a segment; each
# process writes its logs at exit (a .fini_array entry) to $BLAKE3_PROBE_LOG.<pid>. Built against by
# bench-hashes 0.20.4 and by 0.19.7 (the same library: what the bench's change does), each run 3
# times, alternating: --contenders blake3-servil-mt,blake3-servil-st --points "continuous 64 KiB".
set -u
R="$1"; O="$R/out"; mkdir -p "$O"; cd "$R"
export HOME=/root; . /root/.cargo/env
{ grep -m1 'model name' /proc/cpuinfo; nproc; echo "fork $(git -C fork rev-parse HEAD)"; echo "bench20 $(git -C bench20 rev-parse HEAD)"; echo "bench19 $(git -C bench19 rev-parse HEAD)"; } > "$O/machine.txt"
python3 - "$R/fork" <<'PY_PATCH_END' || { echo "patch failed" >> "$O/status.txt"; exit 2; }
import sys, pathlib
tree = pathlib.Path(sys.argv[1])
lanes = tree / "src/lanes.rs"; s = lanes.read_text()
a = "    pub(crate) fn run(self, platform: Platform) {\n        if self.members > 0 {"
b = "    pub(crate) fn run(self, platform: Platform) {\n        let probe_start = crate::probe::tsc().0;\n        if self.members > 0 {"
assert s.count(a) == 1, "run's head"; s = s.replace(a, b)
for a in ("            unsafe { &*self.left }.fetch_sub(self.members, Ordering::Release);\n",
          "        unsafe { &*self.left }.fetch_sub(1, Ordering::Release);\n"):
    assert s.count(a) == 1, a
    s = s.replace(a, a.replace("unsafe", "crate::probe::record(0, probe_start);\n" + a[:len(a) - len(a.lstrip())] + "unsafe", 1))
lanes.write_text(s)
st = tree / "src/stream.rs"; s = st.read_text()
a = "    let mut stream = Stream::open(mode, done);\n    let result = body(&mut stream);\n"
b = "    crate::probe::record(1, crate::probe::tsc().0);\n    let mut stream = Stream::open(mode, done);\n    let result = body(&mut stream);\n    crate::probe::record(2, crate::probe::tsc().0);\n"
assert s.count(a) == 1, "stream's body"; s = s.replace(a, b)
# The caller's side of each piece: reserve (may wait for ring room), the fill, add_part (the hand-over).
for a, b in (
    ("            let at = self.reserve(part_len);\n", "            crate::probe::record(3, crate::probe::tsc().0);\n            let at = self.reserve(part_len);\n"),
    ("            fill_all(&mut fill, i * PIECE, room);\n            let end = self.head;\n            self.add_part(room.as_ptr(), part_len, part_kind(i, pieces, out), end, out as *mut u8);\n",
     "            crate::probe::record(5, crate::probe::tsc().0);\n            fill_all(&mut fill, i * PIECE, room);\n            crate::probe::record(6, crate::probe::tsc().0);\n            let end = self.head;\n            self.add_part(room.as_ptr(), part_len, part_kind(i, pieces, out), end, out as *mut u8);\n            crate::probe::record(4, crate::probe::tsc().0);\n"),
):
    assert s.count(a) == 1, a[:50]; s = s.replace(a, b)
st.write_text(s)
lib = tree / "src/lib.rs"
lib.write_text(lib.read_text() + '''
/// Probe for #196 only: tasks' and streams' times and CPUs, a log a thread, written at exit.
#[doc(hidden)]
pub mod probe {
    use std::cell::UnsafeCell;
    use std::sync::Mutex;
    pub struct Log(UnsafeCell<Vec<(u8, u64, u64, u32)>>);
    // Sound for the probe: a thread writes only its own log; dump() reads them at exit.
    unsafe impl Sync for Log {}
    static LOGS: Mutex<Vec<&'static Log>> = Mutex::new(Vec::new());
    std::thread_local! {
        static MINE: &'static Log = {
            let log: &'static Log = Box::leak(Box::new(Log(UnsafeCell::new(Vec::with_capacity(1 << 22)))));
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
    /// kind 0: a task (start, end, its CPU); 1, 2: a stream's begin and end (at, 0, the caller's CPU).
    #[inline]
    pub fn record(kind: u8, start: u64) {
        let (now, cpu) = tsc();
        let (a, b) = if kind == 0 { (start, now) } else { (start, 0) };
        let _ = MINE.try_with(|log| unsafe { (*log.0.get()).push((kind, a, b, cpu)) });
    }
    extern "C" fn dump() {
        let Ok(path) = std::env::var("BLAKE3_PROBE_LOG") else { return };
        let Ok(logs) = LOGS.lock() else { return };
        let mut out = String::new();
        for (t, log) in logs.iter().enumerate() {
            for &(k, a, b, c) in unsafe { &*log.0.get() } {
                out.push_str(&format!("{t}\\t{k}\\t{a}\\t{b}\\t{c}\\n"));
            }
        }
        let _ = std::fs::write(format!("{path}.{}", std::process::id()), out);
    }
    #[used]
    #[unsafe(link_section = ".fini_array")]
    static DUMP: extern "C" fn() = dump;
}
''')
print("patched")
PY_PATCH_END
git -C fork diff --stat > "$O/patch.txt"
for b in bench20 bench19; do
  (cd "$R/$b" && CARGO_TARGET_DIR="$R/target-$b" cargo build --release) > "$O/$b-build.log" 2>&1 || { echo "$b build failed" >> "$O/status.txt"; exit 2; }
  E=$(cd "$R/$b" && CARGO_TARGET_DIR="$R/target-$b" "$R/target-$b/release/bench-hashes" build-against "$R/fork" 2> "$O/$b-build-against.err" | tail -1)
  [ -x "$E" ] || { echo "$b build-against failed" >> "$O/status.txt"; exit 3; }
  echo "$b $E" >> "$O/exes.txt"
done
[ "$(cut -d' ' -f2 "$O/exes.txt" | sort -u | wc -l)" = 2 ] || { echo "EXECUTABLES NOT DISTINCT" >> "$O/status.txt"; exit 3; }
for round in 1 2; do
  for b in bench20 bench20one; do
    TS=""; [ $b = bench20one ] && TS="taskset -c 0-27,56-83"
    E=$(grep "^bench20 " "$O/exes.txt" | cut -d' ' -f2); D="$R/scratch-$b-$round"; mkdir -p "$D"; cd "$D"
    T0=$(python3 -c 'import time; print(time.time_ns())')
    BLAKE3_PROBE_LOG="$O/log-$b-$round" $TS "$E" --contenders blake3-servil-mt,blake3-servil-st --points "continuous 64 KiB" > "$O/run-$b-$round.out" 2> "$O/run-$b-$round.err"
    echo "$b round $round exit $?" >> "$O/status.txt"
    cp "$D"/benchmark-results/*/bench-hashes.samples.tsv "$O/run-$b-$round.samples.tsv" 2>/dev/null || echo "$b round $round: NO SAMPLES" >> "$O/status.txt"
    cd "$R"
  done
done
gzip -9 "$O"/log-*
echo "ctask3 done" >> "$O/status.txt"
