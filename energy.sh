#!/bin/bash
# BLAKE3 #248, energy: whole chunks on Devon's head (new: 9-15 on 16, 17-31 on 32 where wide, the
# remainder rule) against his 01c1beb5 (old: no rounding past 8). Warm hash() of N KiB in a loop of
# ~0.4 s, pinned to CPU 2; RAPL package energy (intel-rapl:0, the package with CPU 2) and wall time
# around it, per call. The sides alternate, 5 rounds. Digests checked across sides.
set -u
R="$1"; O="$R/out"; mkdir -p "$O"; cd "$R"
export HOME=/root; . /root/.cargo/env
{ uname -a; nproc; grep -m1 'model name' /proc/cpuinfo; rustc --version; for s in old new; do echo "$s $(git -C $s rev-parse HEAD)"; done; cat /sys/class/powercap/intel-rapl:0/name; } > "$O/machine.txt"
for side in old new; do
  mkdir -p "$R/probe-$side/src"
  cat > "$R/probe-$side/Cargo.toml" <<TOML_END
[package]
name = "energyprobe"
version = "0.1.0"
edition = "2021"
[dependencies]
blake3-servil = { path = "$R/$side" }
TOML_END
  cat > "$R/probe-$side/src/main.rs" <<'RS_END'
fn uj() -> u64 { std::fs::read_to_string("/sys/class/powercap/intel-rapl:0/energy_uj").unwrap().trim().parse().unwrap() }
fn main() {
    blake3_servil::initialize();
    let range: u64 = std::fs::read_to_string("/sys/class/powercap/intel-rapl:0/max_energy_range_uj").unwrap().trim().parse().unwrap();
    let input: Vec<u8> = (0..32 * 1024usize).map(|i| (i * 7 + i / 999) as u8).collect();
    let mut check = [0u8; 32];
    for kib in [8usize, 9, 11, 15, 16, 17, 19, 23, 24, 27, 31, 32] {
        let m = &input[..kib * 1024];
        for (c, b) in check.iter_mut().zip(blake3_servil::convenience::hash(m).as_bytes()) { *c ^= b; }
        // Calls in ~0.4 s, from a 20 ms trial.
        let t = std::time::Instant::now(); let mut n = 0u64;
        while t.elapsed().as_millis() < 20 { std::hint::black_box(blake3_servil::convenience::hash(std::hint::black_box(m))); n += 1; }
        let calls = n * 20;
        let (e0, t0) = (uj(), std::time::Instant::now());
        for _ in 0..calls { std::hint::black_box(blake3_servil::convenience::hash(std::hint::black_box(m))); }
        let (e1, ns) = (uj(), t0.elapsed().as_nanos() as f64);
        let e = if e1 >= e0 { e1 - e0 } else { e1 + range - e0 };
        println!("{kib} {:.1} {:.1}", ns / calls as f64, e as f64 * 1000.0 / calls as f64);
    }
    println!("check {}", check.iter().map(|b| format!("{b:02x}")).collect::<String>());
}
RS_END
  ( cd "$R/probe-$side" && CARGO_TARGET_DIR="$R/target-$side" cargo build --release && cargo tree -p blake3-servil --depth 0 ) > "$O/build-$side.log" 2>&1 || { echo "build $side failed" >> "$O/status.txt"; exit 2; }
done
for k in 1 2 3 4 5; do for side in old new; do
  taskset -c 2 "$R/target-$side/release/energyprobe" > "$O/$side-$k.txt" 2>&1; echo "$side $k exit $?" >> "$O/status.txt"
done; done
echo "probe done" >> "$O/status.txt"
