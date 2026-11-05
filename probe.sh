#!/bin/bash
# BLAKE3 #252: one message, warm, against SHA-256: hash() of 64 B to 1 KiB on servil (base) and on #252
# (gpr), and sha2's Sha256::digest (the CPU's SHA extensions) in each binary. Median of 200 samples of
# 50 calls, pinned to CPU 2; the sides alternate, 3 rounds; digests checked against each other.
set -u
R="$1"; O="$R/out"; mkdir -p "$O"; cd "$R"
export HOME=/root; . /root/.cargo/env
{ uname -a; nproc; grep -m1 'model name' /proc/cpuinfo; grep -o -m1 -w sha_ni /proc/cpuinfo; rustc --version; for s in base gpr; do echo "$s $(git -C $s rev-parse HEAD)"; done; } > "$O/machine.txt"
for side in base gpr; do
  mkdir -p "$R/probe-$side/src"
  cat > "$R/probe-$side/Cargo.toml" <<TOML_END
[package]
name = "shaprobe"
version = "0.1.0"
edition = "2021"
[dependencies]
blake3-servil = { path = "$R/$side" }
sha2 = "=0.11.0"
TOML_END
  cat > "$R/probe-$side/src/main.rs" <<'RS_END'
use sha2::Digest;
fn med(f: &mut dyn FnMut()) -> u64 {
    for _ in 0..200 { f(); }
    let mut t: Vec<u64> = (0..200).map(|_| { let w = std::time::Instant::now(); for _ in 0..50 { f(); } w.elapsed().as_nanos() as u64 / 50 }).collect();
    t.sort_unstable(); t[100]
}
fn main() {
    blake3_servil::initialize();
    let input: Vec<u8> = (0..1024usize).map(|i| (i * 7 + i / 99) as u8).collect();
    let mut check = [0u8; 32];
    for len in [64usize, 128, 256, 512, 768, 1024] {
        let m = &input[..len];
        for (c, b) in check.iter_mut().zip(blake3_servil::convenience::hash(m).as_bytes()) { *c ^= b; }
        let b3 = med(&mut || { std::hint::black_box(blake3_servil::convenience::hash(std::hint::black_box(m))); });
        let sha = med(&mut || { std::hint::black_box(sha2::Sha256::digest(std::hint::black_box(m))); });
        println!("{len} {b3} {sha}");
    }
    println!("check {}", check.iter().map(|b| format!("{b:02x}")).collect::<String>());
}
RS_END
  ( cd "$R/probe-$side" && CARGO_TARGET_DIR="$R/target-$side" cargo build --release && cargo tree -p blake3-servil --depth 0 ) > "$O/build-$side.log" 2>&1 || { echo "build $side failed" >> "$O/status.txt"; exit 2; }
done
for k in 1 2 3; do for side in base gpr; do
  taskset -c 2 "$R/target-$side/release/shaprobe" > "$O/$side-$k.txt" 2>&1; echo "$side $k exit $?" >> "$O/status.txt"
done; done
echo "probe done" >> "$O/status.txt"
