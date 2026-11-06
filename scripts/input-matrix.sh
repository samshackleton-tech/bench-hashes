#!/bin/bash
set -euo pipefail
R="$1"; O="$R/out"; mkdir -p "$O"; cd "$R"
export HOME=/root; . /root/.cargo/env
{ date -u;uname -a;grep -m1 'model name' /proc/cpuinfo;echo "library $(git -C library rev-parse HEAD)";echo "bench $(git -C bench rev-parse HEAD)"; } > "$O/identity.txt"
for pair in 1 2 3 4;do
 P="$R/probe-$pair";mkdir -p "$P/src"
 printf '[package]
name="inputmatrix"
version="0.1.0"
edition="2021"
[dependencies]
blake3-servil={path="%s/library"}
blake3="=1.8.7"
sha2="=0.11.0"
clocks={path="%s/bench/clocks"}
' "$R" "$R" > "$P/Cargo.toml"
 cat > "$P/src/main.rs" <<'INPUT_PROBE_EOF'
use blake3_servil::{
    performance::{self, Block},
    Mode,
};
use sha2::Digest;
fn run(shape: &str, lens: &[usize], reverse: bool) {
    let n = lens.len();
    let bytes = lens.iter().sum::<usize>();
    // The same allocation supports two byte-identical views, aligned and
    // shifted by one byte. Distinct values per message detect lane swaps.
    let storage: Vec<Vec<Block>> = lens
        .iter()
        .enumerate()
        .map(|(j, &l)| {
            let mut v = vec![Block::ZERO; (l + 64).div_ceil(64).max(1)];
            Block::bytes_mut(&mut v).fill((j * 37 + 1) as u8);
            v
        })
        .collect();
    let mut reuse: Vec<Vec<Block>> = lens
        .iter()
        .map(|&l| vec![Block::ZERO; l.div_ceil(64).max(1)])
        .collect();
    let mut out = vec![[0u8; 32]; n];
    let natural: Vec<&[u8]> = storage
        .iter()
        .zip(lens)
        .map(|(b, &l)| &Block::bytes(b)[1..1 + l])
        .collect();
    performance::hash_each(Mode::Plain, &natural, &mut out);
    for (m, h) in natural.iter().zip(&out) {
        assert_eq!(*h, *blake3::hash(m).as_bytes());
    }
    let mut algorithms = ["blocks", "bytes_aligned", "bytes_unaligned", "copy_reused", "copy_allocated", "sha256"];
    if reverse { algorithms.reverse(); }
    for algorithm in algorithms {
        let mut work = || {
            match algorithm {
                "blocks" => {
                    let items: Vec<(&[Block], usize)> = storage
                        .iter()
                        .zip(lens)
                        .map(|(b, &l)| (&b[..], l))
                        .collect();
                    performance::hash_each(Mode::Plain, std::hint::black_box(&items), &mut out);
                }
                "bytes_aligned" | "bytes_unaligned" => {
                    let off = usize::from(algorithm == "bytes_unaligned");
                    let items: Vec<&[u8]> = storage
                        .iter()
                        .zip(lens)
                        .map(|(b, &l)| &Block::bytes(b)[off..off + l])
                        .collect();
                    performance::hash_each(Mode::Plain, std::hint::black_box(&items), &mut out);
                }
                "copy_reused" => {
                    for ((src, &l), dst) in storage.iter().zip(lens).zip(&mut reuse) {
                        Block::bytes_mut(dst)[..l].copy_from_slice(&Block::bytes(src)[1..1 + l]);
                    }
                    let items: Vec<(&[Block], usize)> =
                        reuse.iter().zip(lens).map(|(b, &l)| (&b[..], l)).collect();
                    performance::hash_each(Mode::Plain, std::hint::black_box(&items), &mut out);
                }
                "copy_allocated" => {
                    let copied: Vec<Vec<Block>> = storage
                        .iter()
                        .zip(lens)
                        .map(|(src, &l)| {
                            let mut b = vec![Block::ZERO; l.div_ceil(64).max(1)];
                            Block::bytes_mut(&mut b)[..l]
                                .copy_from_slice(&Block::bytes(src)[1..1 + l]);
                            b
                        })
                        .collect();
                    let items: Vec<(&[Block], usize)> =
                        copied.iter().zip(lens).map(|(b, &l)| (&b[..], l)).collect();
                    performance::hash_each(Mode::Plain, std::hint::black_box(&items), &mut out);
                }
                "sha256" => {
                    for ((src, &l), digest) in storage.iter().zip(lens).zip(&mut out) {
                        *digest = sha2::Sha256::digest(std::hint::black_box(
                            &Block::bytes(src)[1..1 + l],
                        ))
                        .into();
                    }
                }
                _ => unreachable!(),
            }
            std::hint::black_box(&out);
        };
        let trial = clocks::measure(1, 10_000_000, &mut work);
        let calls = trial[0].calls * 10;
        let e = clocks::energy::package_nj();
        let cpu = clocks::process_cpu_ns();
        let c = clocks::Counts::read();
        let t = clocks::now();
        for _ in 0..calls {
            work();
        }
        let wall = clocks::since_ns(t);
        let c = c.zip(clocks::Counts::read()).map(|(a, b)| b.since(a));
        let cpu = clocks::process_cpu_ns() - cpu;
        let e = e.zip(clocks::energy::package_nj()).map(|(a, b)| b - a);
        clocks::load::tick();
        println!(
            "{shape}\t{n}\t{bytes}\t{algorithm}\t{calls}\t{wall}\t{cpu}\t{}\t{}\t{}",
            c.map_or(0, |c| c.p.cycles + c.e.cycles),
            c.map_or(0, |c| c.p.instructions + c.e.instructions),
            e.map_or_else(|| "NA".into(), |e| e.to_string())
        );
        for (m, tag) in natural.iter().zip(&out) {
            let expected: [u8; 32] = if algorithm == "sha256" {
                sha2::Sha256::digest(m).into()
            } else {
                *blake3::hash(m).as_bytes()
            };
            assert_eq!(*tag, expected, "{algorithm} {shape}");
        }
    }
}
fn main() {
    blake3_servil::initialize();
    let reverse = std::env::args().nth(1).as_deref() == Some("reverse");
    println!(
        "shape\titems\tbytes\talgorithm\tcalls\twall_ns\tcpu_ns\tcycles\tinstructions\tpackage_nj"
    );
    for n in [16, 64, 1024] {
        for l in [64, 256, 1024] {
            run(&l.to_string(), &vec![l; n], reverse);
        }
        let mut x = 0x9e37_79b9u64;
        let lens: Vec<_> = (0..n)
            .map(|_| {
                x ^= x << 13;
                x ^= x >> 7;
                x ^= x << 17;
                100 + (x % 901) as usize
            })
            .collect();
        run("mixed", &lens, reverse);
    }
}

INPUT_PROBE_EOF
 (cd "$P" && RUSTFLAGS="-C metadata=inputmatrix_$pair" CARGO_TARGET_DIR="$R/target-$pair" cargo build --release && cargo tree -p blake3-servil --depth 0) > "$O/build-$pair.log" 2>&1
 cp "$R/target-$pair/release/inputmatrix" "$R/exe-$pair";cp "$P/Cargo.lock" "$O/lock-$pair.txt"
done
mkdir -p "$R/judge/src"
printf '[package]
name="inputjudge"
version="0.1.0"
edition="2021"
[dependencies]
clocks={path="%s/bench/clocks"}
' "$R" > "$R/judge/Cargo.toml"
cat > "$R/judge/src/main.rs" <<'INPUT_JUDGE_EOF'
use clocks::summary::{discoveries, mean};
use std::{collections::BTreeMap, fs, path::Path};
#[derive(Clone)]
struct Row {
    units: u64,
    metrics: BTreeMap<String, u64>,
}
type Key = (String, u64, String);
fn read(path: &Path) -> BTreeMap<Key, Row> {
    let text = fs::read_to_string(path).unwrap();
    let mut lines = text.lines();
    assert_eq!(lines.next(),Some("shape\titems\tbytes\talgorithm\tcalls\twall_ns\tcpu_ns\tcycles\tinstructions\tpackage_nj"));
    let mut rows = BTreeMap::new();
    for line in lines {
        let f: Vec<_> = line.split('\t').collect();
        assert_eq!(f.len(), 10);
        let count: u64 = f[1].parse().unwrap();
        let calls: u64 = f[4].parse().unwrap();
        let mut metrics = BTreeMap::new();
        for (i, name) in [
            (5, "wall_ns"),
            (6, "cpu_ns"),
            (7, "cycles"),
            (8, "instructions"),
            (9, "package_nj"),
        ] {
            if f[i] != "NA" {
                metrics.insert(name.to_string(), f[i].parse().unwrap());
            }
        }
        assert!(rows
            .insert(
                (f[0].into(), count, f[3].into()),
                Row {
                    units: count * calls,
                    metrics
                }
            )
            .is_none());
    }
    rows
}
fn main() {
    let dir = std::env::args().nth(1).expect("directory");
    let dir = Path::new(&dir);
    let main_algorithm = std::env::args().nth(2).unwrap_or_else(|| "b3".into());
    let mut reference_algorithms: Vec<String> = std::env::args().skip(3).collect();
    if reference_algorithms.is_empty() {
        reference_algorithms.push("sha256".into());
    }
    let old_label = format!("old-{main_algorithm}");
    let mut comparators = vec![old_label.as_str()];
    comparators.extend(reference_algorithms.iter().map(String::as_str));
    let old: Vec<_> = (1..=4)
        .map(|p| read(&dir.join(format!("old-{p}.tsv"))))
        .collect();
    let new: Vec<_> = (1..=4)
        .map(|p| read(&dir.join(format!("new-{p}.tsv"))))
        .collect();
    let mut cells = Vec::new();
    let mut names = Vec::new();
    let mut costs = Vec::new();
    for (shape, count, algorithm) in old[0].keys() {
        if algorithm != &main_algorithm {
            continue;
        }
        for metric in ["wall_ns", "cpu_ns", "cycles", "instructions", "package_nj"] {
            for &versus in &comparators {
                let mut pairs = Vec::new();
                let mut old_tot = (0u128, 0u128);
                let mut new_tot = (0u128, 0u128);
                for p in 0..4 {
                    let a = if versus == old_label {
                        &old[p][&(shape.clone(), *count, main_algorithm.clone())]
                    } else {
                        &new[p][&(shape.clone(), *count, versus.to_string())]
                    };
                    let b = &new[p][&(shape.clone(), *count, main_algorithm.clone())];
                    let (Some(&av), Some(&bv)) = (a.metrics.get(metric), b.metrics.get(metric))
                    else {
                        break;
                    };
                    if av == 0 || bv == 0 {
                        break;
                    }
                    pairs.push((mean([(av, a.units)]), mean([(bv, b.units)])));
                    old_tot.0 += av as u128;
                    old_tot.1 += a.units as u128;
                    new_tot.0 += bv as u128;
                    new_tot.1 += b.units as u128;
                }
                if pairs.len() == 4 {
                    names.push((shape.clone(), *count, metric, versus));
                    cells.push(pairs);
                    costs.push((old_tot, new_tot));
                }
            }
        }
    }
    let judged = discoveries(&cells, 50, 30);
    println!("shape\titems\tmetric\tversus\told_per_item\tnew_per_item\tratio_permille\tverdict");
    for (((shape, count, metric, versus), cost), j) in names.into_iter().zip(costs).zip(judged) {
        println!(
            "{shape}\t{count}\t{metric}\t{versus}\t{:.4}\t{:.4}\t{}\t{:?}",
            cost.0 .0 as f64 / cost.0 .1 as f64,
            cost.1 .0 as f64 / cost.1 .1 as f64,
            j.ratio_permille,
            j.verdict
        );
    }
}

INPUT_JUDGE_EOF
(cd "$R/judge" && CARGO_TARGET_DIR="$R/target-judge" cargo build --release) > "$O/build-judge.log" 2>&1
for pair in 1 2 3 4;do
 order=forward;[ "$((pair%2))" != 0 ] || order=reverse
 for side in old new;do taskset -c 2 "$R/exe-$pair" "$order" > "$O/$side-$pair.tsv" 2> "$O/$side-$pair.err";done
done
"$R/target-judge/release/inputjudge" "$O" bytes_unaligned blocks bytes_aligned copy_reused copy_allocated sha256 > "$O/judgments.tsv"
echo 'input matrix done' > "$O/status.txt"
