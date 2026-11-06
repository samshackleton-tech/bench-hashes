#!/bin/bash
set -euo pipefail
R="$1"; O="$R/out"; mkdir -p "$O"; cd "$R"
export HOME=/root; . /root/.cargo/env
{ date -u; uname -a; grep -m1 'model name' /proc/cpuinfo; grep -m1 '^flags' /proc/cpuinfo; rustc --version; for s in old new bench;do echo "$s $(git -C "$s" rev-parse HEAD)";done; } > "$O/identity.txt"
for pair in 1 2 3 4;do
 for side in old new;do
  P="$R/probe-$side-$pair";mkdir -p "$P/src"
  printf '[package]
name="macmatrix"
version="0.1.0"
edition="2021"
[dependencies]
blake3-servil={path="%s/%s"}
blake3="=1.8.7"
sha2="=0.11.0"
hmac="=0.13.0"
clocks={path="%s/bench/clocks"}
' "$R" "$side" "$R" > "$P/Cargo.toml"
  cat > "$P/src/main.rs" <<'MAC_PROBE_EOF'
use blake3_servil::{
    performance::{self, Block},
    Mode,
};
use hmac::{Hmac, HmacReset, KeyInit, Mac};
use sha2::Sha256;

fn check_hmac_vector() {
    let mut mac = Hmac::<Sha256>::new_from_slice(b"my secret and secure key").unwrap();
    mac.update(b"input message");
    let got = mac.finalize().into_bytes();
    let expected = "97d2a569059bbcd8ead4444ff99071f4c01d005bcefe0d3567e1be628e5fdcd9";
    for j in 0..32 {
        assert_eq!(
            got[j],
            u8::from_str_radix(&expected[2 * j..2 * j + 2], 16).unwrap()
        );
    }
}
fn run(shape: &str, lens: &[usize], reverse: bool) {
    let count = lens.len();
    let key: [u8; 32] = core::array::from_fn(|j| (j * 13 + 7) as u8);
    let blocks: Vec<Vec<Block>> = lens
        .iter()
        .enumerate()
        .map(|(i, &len)| {
            let mut b = vec![Block::ZERO; len.div_ceil(64).max(1)];
            for (j, x) in Block::bytes_mut(&mut b)[..len].iter_mut().enumerate() {
                *x = (i * 31 + j) as u8;
            }
            b
        })
        .collect();
    let items: Vec<(&[Block], usize)> =
        blocks.iter().zip(lens).map(|(b, &l)| (&b[..], l)).collect();
    let mut out = vec![[0u8; 32]; count];
    performance::hash_each(Mode::Keyed(&key), &items, &mut out);
    for ((b, l), digest) in items.iter().zip(&out) {
        assert_eq!(
            *digest,
            *blake3::keyed_hash(&key, &Block::bytes(b)[..*l]).as_bytes()
        );
    }
    // Both HMAC forms precompute the key pads once, outside the interval.
    let template = Hmac::<Sha256>::new_from_slice(&key).unwrap();
    let mut reset = HmacReset::<Sha256>::new_from_slice(&key).unwrap();
    for (b, l) in &items {
        let m = &Block::bytes(b)[..*l];
        let mut clone = template.clone();
        clone.update(m);
        reset.update(m);
        assert_eq!(
            clone.finalize().into_bytes(),
            reset.finalize_reset().into_bytes()
        );
    }
    let bytes = lens.iter().sum::<usize>();
    let algorithms = if reverse {
        ["hmac_sha256_clone", "hmac_sha256_reset", "b3keyed"]
    } else {
        ["b3keyed", "hmac_sha256_reset", "hmac_sha256_clone"]
    };
    for algo in algorithms {
        let mut work = || {
            if algo == "b3keyed" {
                performance::hash_each(Mode::Keyed(&key), std::hint::black_box(&items), &mut out);
            } else if algo == "hmac_sha256_reset" {
                for ((b, l), digest) in items.iter().zip(&mut out) {
                    reset.update(std::hint::black_box(&Block::bytes(b)[..*l]));
                    *digest = reset.finalize_reset().into_bytes().into();
                }
            } else {
                for ((b, l), digest) in items.iter().zip(&mut out) {
                    let mut mac = template.clone();
                    mac.update(std::hint::black_box(&Block::bytes(b)[..*l]));
                    *digest = mac.finalize().into_bytes().into();
                }
            }
            std::hint::black_box(&out);
        };
        let trial = clocks::measure(1, 10_000_000, &mut work);
        let calls = trial[0].calls * 10;
        let energy = clocks::energy::package_nj();
        let cpu = clocks::process_cpu_ns();
        let c = clocks::Counts::read();
        let t = clocks::now();
        for _ in 0..calls {
            work();
        }
        let wall = clocks::since_ns(t);
        let c = c.zip(clocks::Counts::read()).map(|(a, b)| b.since(a));
        let cpu = clocks::process_cpu_ns() - cpu;
        let energy = energy.zip(clocks::energy::package_nj()).map(|(a, b)| b - a);
        clocks::load::tick();
        println!(
            "{shape}\t{count}\t{bytes}\t{algo}\t{calls}\t{wall}\t{cpu}\t{}\t{}\t{}",
            c.map_or(0, |c| c.p.cycles + c.e.cycles),
            c.map_or(0, |c| c.p.instructions + c.e.instructions),
            energy.map_or_else(|| "NA".into(), |e| e.to_string())
        );
    }
}
fn main() {
    check_hmac_vector();
    blake3_servil::initialize();
    let reverse = std::env::args().nth(1).as_deref() == Some("reverse");
    println!(
        "shape\titems\tbytes\talgorithm\tcalls\twall_ns\tcpu_ns\tcycles\tinstructions\tpackage_nj"
    );
    for n in [16, 64, 1024] {
        for len in [16, 64, 256, 1024] {
            run(&len.to_string(), &vec![len; n], reverse);
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

MAC_PROBE_EOF
  (cd "$P" && RUSTFLAGS="-C metadata=macmatrix_$pair" CARGO_TARGET_DIR="$R/target-$side-$pair" cargo build --release && cargo tree -p blake3-servil --depth 0) > "$O/build-$side-$pair.log" 2>&1
  cp "$R/target-$side-$pair/release/macmatrix" "$O/exe-$side-$pair";cp "$P/Cargo.lock" "$O/lock-$side-$pair.txt"
 done
done
mkdir -p "$R/judge/src"
printf '[package]
name="macjudge"
version="0.1.0"
edition="2021"
[dependencies]
clocks={path="%s/bench/clocks"}
' "$R" > "$R/judge/Cargo.toml"
cat > "$R/judge/src/main.rs" <<'MAC_JUDGE_EOF'
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

MAC_JUDGE_EOF
(cd "$R/judge" && CARGO_TARGET_DIR="$R/target-judge" cargo build --release) > "$O/build-judge.log" 2>&1
for pair in 1 2 3 4;do
 sides='old new'; order=forward; if [ "$((pair%2))" = 0 ];then sides='new old';order=reverse;fi
 for side in $sides;do taskset -c 2 "$O/exe-$side-$pair" "$order" > "$O/$side-$pair.tsv" 2> "$O/$side-$pair.err";done
done
"$R/target-judge/release/macjudge" "$O" b3keyed hmac_sha256_reset hmac_sha256_clone > "$O/judgments.tsv"
echo 'MAC matrix done' > "$O/status.txt"
