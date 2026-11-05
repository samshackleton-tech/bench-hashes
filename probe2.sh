#!/bin/bash
# Stream across and by blocks (candidate/sam-stream-across) against servil: one thread hashing N messages
# one after another, of equal lengths and of mixed ones (half to one and a half times), through hash() each, through a stream, and through sha2's SHA-256 (run
# across-probe). Builds the probe against servil ("base") and the branch ("change"); runs each 3 times,
# alternating, with a pool of one pinned to CPU 2 (one thread) and with the default pool.
set -u
R="$1"; O="$R/out"; mkdir -p "$O"; cd "$R"
export HOME=/root; . /root/.cargo/env
{ uname -a; nproc; grep -m1 'model name' /proc/cpuinfo; rustc --version; echo "base $(git -C base rev-parse HEAD)"; echo "change $(git -C change rev-parse HEAD)"; } > "$O/machine.txt"
for side in base change; do
  mkdir -p "$R/probe-$side/src"
  cat > "$R/probe-$side/Cargo.toml" <<TOML_END
[package]
name = "streamprobe"
version = "0.1.0"
edition = "2021"
[dependencies]
blake3-servil = { path = "$R/$side" }
sha2 = "=0.11.0"
TOML_END
  cat > "$R/probe-$side/src/main.rs" <<'RS_END'
// Probe (not a reported measurement): one thread hashing N messages of LEN bytes one after another,
// three ways: convenience::hash each, a stream on a pool of one, and sha2's Sha256. ns/B and CPU time.
use blake3_servil::{Hash, Mode};
use sha2::Digest;
fn cpu_ns() -> u128 { let mut t = libc_timespec { s: 0, ns: 0 }; unsafe { clock_gettime(2, &mut t) }; t.s as u128 * 1_000_000_000 + t.ns as u128 }
#[repr(C)] struct libc_timespec { s: i64, ns: i64 }
unsafe extern "C" { fn clock_gettime(clk: i32, t: *mut libc_timespec) -> i32; }
fn main() {
    let threads: usize = std::env::args().nth(1).and_then(|s| s.parse().ok()).unwrap_or(1);
    blake3_servil::initialize_multithreaded(std::num::NonZeroUsize::new(threads));
    for (mixed, len) in [(false, 64usize), (false, 256), (false, 1024), (false, 1536), (false, 4096), (true, 300), (true, 1000), (true, 2000)] {
        // Equal lengths, or (mixed) lengths from len/2 to 3*len/2, seeded.
        let mut x = 12345u64; let mut lens = Vec::new(); let mut total = 0;
        while total < (64 << 20) { let l = if mixed { x ^= x << 13; x ^= x >> 7; x ^= x << 17; len / 2 + (x % len as u64) as usize } else { len }; lens.push(l); total += l; }
        let n = lens.len();
        let msgs: Vec<u8> = (0..total).map(|i| (i * 7 + i / 999) as u8).collect();
        let mut offs = vec![0usize]; for l in &lens { let o = offs[offs.len()-1] + l; offs.push(o); }
        let mut sink = 0u8;
        let time = |f: &mut dyn FnMut()| { f(); let (w, c) = (std::time::Instant::now(), cpu_ns()); f(); (w.elapsed().as_nanos() as f64 / total as f64, (cpu_ns() - c) as f64 / total as f64) };
        let (hw, hc) = time(&mut || for m in offs.windows(2).map(|w| &msgs[w[0]..w[1]]) { sink ^= blake3_servil::convenience::hash(m).as_bytes()[0]; });
        let (sw, sc) = time(&mut || for m in offs.windows(2).map(|w| &msgs[w[0]..w[1]]) { sink ^= sha2::Sha256::digest(m)[0]; });
        let mut places = vec![Hash::from([0u8; 32]); 1024];
        let (tw, tc) = time(&mut || {
            let free = std::cell::RefCell::new(places.iter_mut().collect::<Vec<&mut Hash>>());
            let got = std::cell::Cell::new(0u8);
            blake3_servil::performance::stream(Mode::Plain, |p: &mut [Hash]| { got.set(got.get() ^ p[0].as_bytes()[0]); free.borrow_mut().push(&mut p[0]); }, |s| {
                for m in offs.windows(2).map(|w| &msgs[w[0]..w[1]]) {
                    let place = loop { if let Some(p) = free.borrow_mut().pop() { break p; } s.collect(); };
                    s.submit_with(m.len(), |at, room| { room.copy_from_slice(&m[at..][..room.len()]); room.len() }, place);
                }
                s.finish();
            });
            sink ^= got.get();
        });
        std::hint::black_box(sink);
        println!("{}{len:5} B x {n:7}: hash() {hw:.3} ns/B (cpu {hc:.3}) | stream {tw:.3} (cpu {tc:.3}) | sha256 {sw:.3} (cpu {sc:.3})", if mixed { "mixed " } else { "" });
    }
}
RS_END
  ( cd "$R/probe-$side" && cargo build --release ) > "$O/build-$side.log" 2>&1 || { echo "build $side failed" >> "$O/status.txt"; exit 2; }
done
for k in 1 2 3; do for side in base change; do
  taskset -c 2 "$R/probe-$side/target/release/streamprobe" 1 > "$O/one-$side-$k.txt" 2>&1; echo "one $side $k exit $?" >> "$O/status.txt"
  "$R/probe-$side/target/release/streamprobe" 0 > "$O/pool-$side-$k.txt" 2>&1; echo "pool $side $k exit $?" >> "$O/status.txt"
done; done
echo "probe done" >> "$O/status.txt"
