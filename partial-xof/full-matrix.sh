#!/bin/bash
set -euo pipefail
R="$1";O="$R/out";mkdir -p "$O";export HOME=/root;. /root/.cargo/env
{ date -u;uname -a;grep -m1 'model name' /proc/cpuinfo;rustc --version;for repo in old mixed bench;do echo "$repo $(git -C "$R/$repo" rev-parse HEAD)";done; } > "$O/identity.txt"
pids=()
for pair in 1 2 3 4;do for side in old mixed;do
 (
 P="$R/probe-$side-$pair";mkdir -p "$P/src"
 printf '[package]
name="scalarroots"
version="0.1.0"
edition="2021"
[dependencies]
blake3-servil={path="%s/%s"}
blake3="=1.8.7"
clocks={path="%s/bench/clocks"}
' "$R" "$side" "$R" > "$P/Cargo.toml"
 cat > "$P/src/main.rs" <<'PROBE_EOF'
use blake3_servil::{Mode, throughput::Hasher};
fn reference(mode: Mode<'_>, data: &[u8], len: usize) -> Vec<u8> {
    let mut h = match mode {
        Mode::Plain => blake3::Hasher::new(),
        Mode::Keyed(k) => blake3::Hasher::new_keyed(k),
        _ => blake3::Hasher::new_derive_key("BLAKE3-Servil partial XOF reads"),
    };
    h.update(data);
    let mut out = vec![0u8; len];
    h.finalize_xof().fill(&mut out);
    out
}
fn run(n: usize, input_len: usize, chunk: usize, flavor: usize, reverse: bool) {
    let key = [0x42u8; 32];
    let mode = match flavor {
        0 => Mode::Plain,
        1 => Mode::Keyed(&key),
        _ => Mode::DeriveKey("BLAKE3-Servil partial XOF reads"),
    };
    let total = 4096;
    let data: Vec<Vec<u8>> = (0..n)
        .map(|i| {
            (0..input_len)
                .map(|j| ((i * 37 + j * 17) % 251) as u8)
                .collect()
        })
        .collect();
    let wanted: Vec<_> = data.iter().map(|d| reference(mode, d, total)).collect();
    let hashers: Vec<_> = data
        .iter()
        .map(|d| {
            let mut h = Hasher::new(mode);
            h.update(d);
            h
        })
        .collect();
    let mut readers: Vec<_> = hashers.iter().map(|h| h.finalize_xof()).collect();
    let mut out = vec![vec![0u8; total]; n];
    let shape = format!(
        "{}_input{input_len}_out{total}_read{chunk}",
        ["plain", "keyed", "derived"][flavor]
    );
    let stride = if n > 1 {
        &readers[1] as *const _ as usize - &readers[0] as *const _ as usize
    } else {
        std::mem::size_of::<blake3_servil::OutputReader>()
    };
    eprintln!(
        "layout shape={shape} items={n} reader_size={} reader_align={} native_stride={stride} readers={:#x} hashers={:#x}",
        std::mem::size_of::<blake3_servil::OutputReader>(),
        std::mem::align_of::<blake3_servil::OutputReader>(),
        readers.as_ptr() as usize,
        hashers.as_ptr() as usize
    );
    eprintln!(
        "ownership: one caller owns all states/outputs, no worker/cache-line sharing. Constructors, input hashing, independent references, allocations outside. ready_read resets an existing reader to offset0 per extraction; construct_read calls Hasher::finalize_xof then performs every read. convenience_read includes input hashing and all extraction; other two operations do not include input hashing. Cache/state footprint and full-block controls measured explicitly."
    );
    let mut operations = ["ready_read", "construct_read", "convenience_read"];
    if reverse {
        operations.reverse();
    }
    for operation in operations {
        let mut work = || {
            for i in 0..n {
                if operation == "convenience_read" {
                    readers[i] =
                        blake3_servil::convenience::hash_xof(mode, std::hint::black_box(&data[i]));
                } else if operation == "construct_read" {
                    readers[i] = std::hint::black_box(&hashers[i]).finalize_xof();
                } else {
                    readers[i].set_position(0);
                }
                for part in out[i].chunks_mut(chunk) {
                    readers[i].fill(std::hint::black_box(part));
                }
            }
            std::hint::black_box(&out);
        };
        let trial = clocks::measure(1, 10_000_000, &mut work);
        let calls = trial[0].calls * 10;
        let energy = clocks::energy::package_nj();
        let cpu = clocks::process_cpu_ns();
        let counts = clocks::Counts::read();
        let time = clocks::now();
        for _ in 0..calls {
            work();
        }
        let wall = clocks::since_ns(time);
        let counts = counts.zip(clocks::Counts::read()).map(|(a, b)| b.since(a));
        let cpu = clocks::process_cpu_ns() - cpu;
        let energy = energy.zip(clocks::energy::package_nj()).map(|(a, b)| b - a);
        clocks::load::tick();
        println!(
            "{shape}\t{n}\t{}\t{operation}\t{calls}\t{wall}\t{cpu}\t{}\t{}\t{}",
            n * total,
            counts.map_or(0, |x| x.p.cycles + x.e.cycles),
            counts.map_or(0, |x| x.p.instructions + x.e.instructions),
            energy.map_or_else(|| "NA".into(), |x| x.to_string())
        );
        assert_eq!(out, wanted, "{shape} {operation}");
        assert!(readers.iter().all(|r| r.position() == total as u64));
    }
}
fn main() {
    blake3_servil::initialize();
    let reverse = std::env::args().nth(1).as_deref() == Some("reverse");
    println!(
        "shape\titems\tbytes\talgorithm\tcalls\twall_ns\tcpu_ns\tcycles\tinstructions\tpackage_nj"
    );
    for n in [1, 64] {
        for input_len in [64, 16384] {
            for chunk in [1, 7, 16, 32, 63, 64, 65, 1024] {
                for flavor in 0..3 {
                    run(n, input_len, chunk, flavor, reverse);
                }
            }
        }
    }
}

PROBE_EOF
 (cd "$P" && CARGO_TARGET_DIR="$R/target-$side-$pair" RUSTFLAGS="-C metadata=scalarroots_$pair" cargo build --release && cargo tree -p blake3-servil --depth 0) > "$O/build-$side-$pair.log" 2>&1
 cp "$R/target-$side-$pair/release/scalarroots" "$R/exe-$side-$pair";cp "$P/Cargo.lock" "$O/lock-$side-$pair.txt"
 ) &
 pids+=("$!")
done;done
failed=0;for pid in "${pids[@]}";do if ! wait "$pid";then failed=1;fi;done
[ "$failed" = 0 ]
mkdir -p "$R/judge/src"
printf '[package]
name="scalarrootjudge"
version="0.1.0"
edition="2021"
[dependencies]
clocks={path="%s/bench/clocks"}
' "$R" > "$R/judge/Cargo.toml"
cat > "$R/judge/src/main.rs" <<'JUDGE_EOF'
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
    // Compare the same scalar operation across pinned source heads.
    // Each candidate/operation has its own shared paired-judgment family.
    let old_label = format!("old-{main_algorithm}");
    let comparators = [old_label.as_str()];
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

JUDGE_EOF
(cd "$R/judge" && CARGO_TARGET_DIR="$R/target-judge" cargo build --release) > "$O/build-judge.log" 2>&1
for pair in 1 2 3 4;do
 variants='mixed';order=forward;[ "$((pair%2))" != 0 ] || { variants='mixed';order=reverse; }
 for variant in $variants;do
  sides="old $variant";[ "$((pair%2))" != 0 ] || sides="$variant old"
  for side in $sides;do
   label=new;[ "$side" != old ] || label=old
   taskset -c 2 "$R/exe-$side-$pair" "$order" > "$O/$variant-$label-$pair.tsv" 2> "$O/$variant-$label-$pair.err"
  done
 done
done
for variant in mixed;do
 mkdir -p "$R/compare-$variant"
 for pair in 1 2 3 4;do for side in old new;do ln -s "$O/$variant-$side-$pair.tsv" "$R/compare-$variant/$side-$pair.tsv";done;done
 for algorithm in ready_read construct_read convenience_read;do "$R/target-judge/release/scalarrootjudge" "$R/compare-$variant" "$algorithm" > "$O/judgments-$variant-$algorithm.tsv";done
done
echo 'scalar variants done' > "$O/status.txt"
