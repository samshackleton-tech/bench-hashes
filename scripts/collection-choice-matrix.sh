#!/bin/bash
set -euo pipefail
R="$1";O="$R/out";mkdir -p "$O";export HOME=/root;. /root/.cargo/env
{ date -u;uname -a;grep -m1 'model name' /proc/cpuinfo;rustc --version;for repo in library bench evidence;do echo "$repo $(git -C "$R/$repo" rev-parse HEAD)";done; } > "$O/identity.txt"
pids=()
for pair in 1 2 3 4;do
 (
 P="$R/probe-$pair";mkdir -p "$P/src"
 printf '[package]
name="collectionchoice"
version="0.1.0"
edition="2021"
[dependencies]
blake3-servil={path="%s/library"}
blake3="=1.8.7"
sha2="=0.11.0"
clocks={path="%s/bench/clocks"}
' "$R" "$R" > "$P/Cargo.toml"
 cat > "$P/src/main.rs" <<'PROBE_EOF'
use blake3_servil::{Mode, throughput::{self, Block}};
use sha2::Digest;

fn run(shape: &str, lens: &[usize], reverse: bool) {
    let n = lens.len();
    let blocks: Vec<Vec<Block>> = lens.iter().enumerate().map(|(i, &len)| {
        let mut blocks = vec![Block::ZERO; len.div_ceil(64).max(1)];
        for (j, byte) in Block::bytes_mut(&mut blocks)[..len].iter_mut().enumerate() {
            *byte = (i * 31 + j * 17) as u8;
        }
        blocks
    }).collect();
    let items: Vec<(&[Block], usize)> = blocks.iter().zip(lens).map(|(b, &len)| (&b[..], len)).collect();
    let mut out = vec![[0u8; 32]; n];
    let mut algorithms = ["each", "serial_loop", "sha256"];
    if reverse { algorithms.reverse(); }
    for algorithm in algorithms {
        let mut work = || {
            match algorithm {
                "each" => throughput::hash_each(Mode::Plain, std::hint::black_box(&items), &mut out),
                "serial_loop" => {
                    for ((blocks, len), digest) in items.iter().zip(&mut out) {
                        *digest = *throughput::hash(Mode::Plain, std::hint::black_box(blocks), *len).as_bytes();
                    }
                }
                "sha256" => {
                    for ((blocks, len), digest) in items.iter().zip(&mut out) {
                        *digest = sha2::Sha256::digest(std::hint::black_box(&Block::bytes(blocks)[..*len])).into();
                    }
                }
                _ => unreachable!(),
            }
            std::hint::black_box(&out);
        };
        let calibration = clocks::measure(1, 10_000_000, &mut work);
        let calls = calibration[0].calls * 10;
        let energy = clocks::energy::package_nj();
        let cpu = clocks::process_cpu_ns();
        let counters = clocks::Counts::read();
        let start = clocks::now();
        for _ in 0..calls { work(); }
        let wall = clocks::since_ns(start);
        let counters = counters.zip(clocks::Counts::read()).map(|(a, b)| b.since(a));
        let cpu = clocks::process_cpu_ns() - cpu;
        let energy = energy.zip(clocks::energy::package_nj()).map(|(a, b)| b - a);
        clocks::load::tick();
        println!("{shape}\t{n}\t{}\t{algorithm}\t{calls}\t{wall}\t{cpu}\t{}\t{}\t{}", lens.iter().sum::<usize>(),
            counters.map_or(0, |c| c.p.cycles + c.e.cycles),
            counters.map_or(0, |c| c.p.instructions + c.e.instructions),
            energy.map_or_else(|| "NA".into(), |e| e.to_string()));
        for ((blocks, len), digest) in items.iter().zip(&out) {
            let bytes = &Block::bytes(blocks)[..*len];
            let expected: [u8; 32] = if algorithm == "sha256" { sha2::Sha256::digest(bytes).into() } else { *blake3::hash(bytes).as_bytes() };
            assert_eq!(*digest, expected, "{algorithm} {shape} {n}");
        }
    }
}

fn main() {
    // Both choices use the current throughput API. No library source change.
    blake3_servil::initialize();
    let reverse = std::env::args().nth(1).as_deref() == Some("reverse");
    println!("shape\titems\tbytes\talgorithm\tcalls\twall_ns\tcpu_ns\tcycles\tinstructions\tpackage_nj");
    for n in [1, 2, 4, 7, 8, 16, 64, 1024] {
        for len in [0, 1, 64, 256, 1024] { run(&len.to_string(), &vec![len; n], reverse); }
        let mut x = 0x9e37_79b9u64;
        let lengths: Vec<_> = (0..n).map(|_| { x ^= x << 13; x ^= x >> 7; x ^= x << 17; 100 + (x % 901) as usize }).collect();
        run("mixed", &lengths, reverse);
    }
}

PROBE_EOF
 (cd "$P" && CARGO_TARGET_DIR="$R/target-$pair" RUSTFLAGS="-C metadata=collectionchoice_$pair" cargo build --release && cargo tree -p blake3-servil --depth 0) > "$O/build-$pair.log" 2>&1
 cp "$R/target-$pair/release/collectionchoice" "$R/exe-$pair";cp "$P/Cargo.lock" "$O/lock-$pair.txt"
 ) &
 pids+=("$!")
done
failed=0;for pid in "${pids[@]}";do if ! wait "$pid";then failed=1;fi;done
[ "$failed" = 0 ]
mkdir -p "$R/judge/src"
cp "$R/evidence/scripts/judge.rs" "$R/judge/src/main.rs"
printf '[package]
name="collectionchoicejudge"
version="0.1.0"
edition="2021"
[dependencies]
clocks={path="%s/bench/clocks"}
' "$R" > "$R/judge/Cargo.toml"
(cd "$R/judge" && CARGO_TARGET_DIR="$R/target-judge" cargo build --release) > "$O/build-judge.log" 2>&1
for pair in 1 2 3 4;do
 order=forward;[ "$((pair%2))" != 0 ] || order=reverse
 for side in old new;do taskset -c 2 "$R/exe-$pair" "$order" > "$O/$side-$pair.tsv" 2> "$O/$side-$pair.err";done
done
"$R/target-judge/release/collectionchoicejudge" "$O" serial_loop each sha256 > "$O/judgments.tsv"
echo 'collection choice matrix done' > "$O/status.txt"
