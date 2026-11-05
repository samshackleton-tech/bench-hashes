#!/bin/bash
# bench PR #248 follow-up: on AVX-512, do 9-15 whole chunks pay on 16 lanes (v16), and 17-31 on the
# 32-input kernel where it runs (v32), against Devon's branch (base)? Warm hash() of 1-32 KiB, whole
# chunks, median of 200 samples of 50 calls, pinned to CPU 2; the sides alternate, 3 rounds. Each side
# prints a digest checksum over all sizes (the sides must agree).
set -u
R="$1"; O="$R/out"; mkdir -p "$O"; cd "$R"
export HOME=/root; . /root/.cargo/env
{ uname -a; nproc; grep -m1 'model name' /proc/cpuinfo; rustc --version; for s in base v16 v32; do echo "$s $(git -C $s rev-parse HEAD)"; done; } > "$O/machine.txt"
for side in base v16 v32; do
  mkdir -p "$R/probe-$side/src"
  cat > "$R/probe-$side/Cargo.toml" <<TOML_END
[package]
name = "laneprobe"
version = "0.1.0"
edition = "2021"
[dependencies]
blake3-servil = { path = "$R/$side" }
TOML_END
  cat > "$R/probe-$side/src/main.rs" <<'RS_END'
fn main() {
    blake3_servil::initialize();
    let input: Vec<u8> = (0..32 * 1024usize).map(|i| (i * 7 + i / 999) as u8).collect();
    let mut check = [0u8; 32];
    for kib in 1..=32usize {
        let m = &input[..kib * 1024];
        let d = blake3_servil::convenience::hash(m);
        for (c, b) in check.iter_mut().zip(d.as_bytes()) { *c ^= b; }
        for _ in 0..200 { std::hint::black_box(blake3_servil::convenience::hash(std::hint::black_box(m))); }
        let mut t: Vec<u64> = (0..200).map(|_| {
            let w = std::time::Instant::now();
            for _ in 0..50 { std::hint::black_box(blake3_servil::convenience::hash(std::hint::black_box(m))); }
            w.elapsed().as_nanos() as u64 / 50
        }).collect();
        t.sort_unstable();
        println!("{kib} {}", t[100]);
    }
    println!("check {}", check.iter().map(|b| format!("{b:02x}")).collect::<String>());
}
RS_END
  ( cd "$R/probe-$side" && CARGO_TARGET_DIR="$R/target-$side" cargo build --release && cargo tree -p blake3-servil --depth 0 ) > "$O/build-$side.log" 2>&1 || { echo "build $side failed" >> "$O/status.txt"; exit 2; }
done
for k in 1 2 3; do for side in base v16 v32; do
  taskset -c 2 "$R/target-$side/release/laneprobe" > "$O/$side-$k.txt" 2>&1; echo "$side $k exit $?" >> "$O/status.txt"
done; done
echo "probe done" >> "$O/status.txt"
