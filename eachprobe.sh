#!/bin/bash
# hash_each by blocks (candidate/sam-each-by-blocks) against its base (#246's head): a collection of small items of
# mixed lengths, each hashed once, one thread on CPU 2: hash_each, hash() on each, SHA-256 on each. 3 runs a side,
# alternating (run each-probe).
set -u
R="$1"; O="$R/out"; mkdir -p "$O"; cd "$R"
export HOME=/root; . /root/.cargo/env
{ uname -a; nproc; grep -m1 'model name' /proc/cpuinfo; rustc --version; echo "base $(git -C base rev-parse HEAD)"; echo "change $(git -C change rev-parse HEAD)"; } > "$O/machine.txt"
for side in base change; do
  mkdir -p "$R/probe-$side/src"
  cat > "$R/probe-$side/Cargo.toml" <<TOML_END
[package]
name = "eachprobe"
version = "0.1.0"
edition = "2021"
[dependencies]
blake3-servil = { path = "$R/$side" }
sha2 = "=0.11.0"
TOML_END
  cat > "$R/probe-$side/src/main.rs" <<'RS_END'
// Probe (not a reported measurement): a collection of small items of mixed lengths (half to one and a
// half times LEN), each hashed once, one thread: performance::hash_each, hash() on each, SHA-256 on each.
use blake3_servil::{Mode, performance::Block};
use sha2::Digest;
fn main() {
    blake3_servil::initialize();
    for &len in &[100usize, 300, 700, 2000] {
        let mut x = 777u64; let mut lens = Vec::new(); let mut total = 0;
        while total < (32 << 20) { x ^= x << 13; x ^= x >> 7; x ^= x << 17; let l = len / 2 + (x % len as u64) as usize; lens.push(l); total += l; }
        let blocks: Vec<Vec<Block>> = lens.iter().enumerate().map(|(m, &l)| { let mut b = vec![Block::ZERO; l.div_ceil(64).max(1)]; for (i, x) in Block::bytes_mut(&mut b)[..l].iter_mut().enumerate() { *x = (m * 7 + i) as u8; } b }).collect();
        let items: Vec<(&[Block], usize)> = blocks.iter().zip(&lens).map(|(b, &l)| (&b[..], l)).collect();
        let mut out = vec![[0u8; 32]; items.len()];
        let mut sink = 0u8;
        let time = |f: &mut dyn FnMut()| { f(); let w = std::time::Instant::now(); f(); w.elapsed().as_nanos() as f64 / total as f64 };
        let e = time(&mut || { blake3_servil::performance::hash_each(Mode::Plain, &items, &mut out); sink ^= out[0][0]; });
        let h = time(&mut || for (b, l) in &items { sink ^= blake3_servil::convenience::hash(&Block::bytes(b)[..*l]).as_bytes()[0]; });
        let s = time(&mut || for (b, l) in &items { sink ^= sha2::Sha256::digest(&Block::bytes(b)[..*l])[0]; });
        std::hint::black_box(sink);
        println!("mixed ~{len:5} B x {:7}: hash_each {e:.3} ns/B | hash() {h:.3} | sha256 {s:.3}", items.len());
    }
}
RS_END
  ( cd "$R/probe-$side" && cargo build --release ) > "$O/build-$side.log" 2>&1 || { echo "build $side failed" >> "$O/status.txt"; exit 2; }
done
for k in 1 2 3; do for side in base change; do
  taskset -c 2 "$R/probe-$side/target/release/eachprobe" > "$O/each-$side-$k.txt" 2>&1; echo "each $side $k exit $?" >> "$O/status.txt"
done; done
echo "probe done" >> "$O/status.txt"
