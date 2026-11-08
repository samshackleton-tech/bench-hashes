#!/bin/bash
set -euo pipefail
R="$1";O="$R/out";mkdir -p "$O";export HOME=/root;. /root/.cargo/env
{ date -u;uname -a;grep -m1 'model name' /proc/cpuinfo;rustc --version;for repo in old new bench;do echo "$repo $(git -C "$R/$repo" rev-parse HEAD)";done; } > "$O/identity.txt"
pids=()
pairs="1 2 3 4"
[ "${PINNED_RUN_PREFLIGHT:-0}" != 1 ] || pairs="1"
for pair in $pairs;do
 for side in old new;do
 (
 P="$R/probe-$side-$pair";mkdir -p "$P/src"
 printf '[package]
name="incrementalroots"
version="0.1.0"
edition="2021"
[dependencies]
blake3-servil={path="%s/%s"}
blake3="=1.8.7"
clocks={path="%s/bench/clocks"}
' "$R" "$side" "$R" > "$P/Cargo.toml"
 cat > "$P/src/main.rs" <<'PROBE_EOF'
use blake3_servil::{convenience::Hasher, throughput, Mode};
fn mode<'a>(i: usize, flavor: usize, keys: &'a [[u8; 32]]) -> Mode<'a> {
    match flavor {
        0 => Mode::Plain,
        1 => Mode::Keyed(&keys[0]),
        2 => Mode::Keyed(&keys[i]),
        _ => match i % 3 {
            0 => Mode::Plain,
            1 => Mode::Keyed(&keys[i]),
            _ => Mode::DeriveKey("BLAKE3-Servil mixed held-stage probe"),
        },
    }
}
fn expected(i: usize, flavor: usize, keys: &[[u8; 32]], bytes: &[u8]) -> [u8; 32] {
    match mode(i, flavor, keys) {
        Mode::Plain => *blake3::hash(bytes).as_bytes(),
        Mode::Keyed(key) => *blake3::keyed_hash(key, bytes).as_bytes(),
        _ => blake3::derive_key("BLAKE3-Servil mixed held-stage probe", bytes),
    }
}
// Released finalize_each reads without resetting; include the explicit
// reset in cycle/finish work on BOTH pinned sources.
fn finalize_and_reset(hs: &mut [Hasher], which: &[usize], out: &mut [[u8; 32]]) {
    throughput::finalize_each(hs, which, out);
    for &i in which { hs[i].reset(None); }
}
fn feed<'a>(hs: &mut [Hasher], data: &'a [Vec<u8>], which: &[usize], pieces: &mut Vec<(usize, &'a [u8])>, width: usize) {
    for from in (0..data[0].len()).step_by(width) {
        pieces.clear();
        for (i, bytes) in data.iter().enumerate() {
            pieces.push((which[i], &bytes[from..(from + width).min(bytes.len())]));
        }
        throughput::update_each(hs, std::hint::black_box(pieces.as_slice()));
    }
}
fn run(open: usize, active: usize, len: usize, width: usize, flavor: usize, reverse: bool) {
    let keys: Vec<[u8; 32]> = (0..open).map(|i| {
        let mut key = core::array::from_fn(|j| (j * 11 + 73) as u8);
        key[..8].copy_from_slice(&(i as u64).to_le_bytes());
        key
    }).collect();
    assert_eq!(keys.iter().collect::<std::collections::BTreeSet<_>>().len(), open);
    let which: Vec<_> = (0..active).map(|i| (i * 61) % open).collect();
    assert_eq!(which.iter().copied().collect::<std::collections::BTreeSet<_>>().len(), active);
    let mut hs: Vec<_> = (0..open).map(|i| Hasher::new(mode(i, flavor, &keys), None)).collect();
    let data: Vec<Vec<u8>> = (0..active).map(|i| (0..len).map(|j| (i * 31 + j * 17) as u8).collect()).collect();
    let wanted: Vec<_> = data.iter().enumerate().map(|(i, d)| expected(which[i], flavor, &keys, d)).collect();
    let mut out = vec![[0u8; 32]; active];
    let mut pieces = Vec::with_capacity(active);
    let shape = format!("{}_open{open}_len{len}_piece{width}", ["plain", "shared_key", "distinct_keys", "mixed_modes"][flavor]);
    eprintln!("ownership: one caller owns states/descriptors/outputs; open={open} active={active}; hasher_size={} align={} native_stride={} digest_stride=32; no concurrent sharing", std::mem::size_of::<Hasher>(), std::mem::align_of::<Hasher>(), if open > 1 { &hs[1] as *const Hasher as usize - &hs[0] as *const Hasher as usize } else { std::mem::size_of::<Hasher>() });
    eprintln!("constructors/keys/data/caller capacity outside counters; cycle includes descriptor refill, library allocations, updates, digest and explicit released-API reset; update includes selected reset+refill+updates, digest outside; finish prepares a cohort outside counters and consumes/resets it ONCE,64 samples,clock bookkeeping included,energy NA");
    let preflight = std::env::var_os("PINNED_RUN_PREFLIGHT").is_some_and(|v| v == "1");
    let mut algorithms = ["update", "cycle", "finish"];
    if reverse { algorithms.reverse(); }
    for algorithm in algorithms {
        let (calls, wall, cpu, cycles, instructions, energy);
        if algorithm != "finish" {
            let mut work = || {
                if algorithm == "update" { for &i in &which { hs[i].reset(None); } }
                feed(&mut hs, &data, &which, &mut pieces, width);
                if algorithm == "cycle" {
                    finalize_and_reset(std::hint::black_box(&mut hs), std::hint::black_box(&which), &mut out);
                    std::hint::black_box(&out);
                } else { std::hint::black_box(&hs); }
            };
            if preflight {
                work(); calls = 1; wall = 0; cpu = 0; cycles = 0; instructions = 0; energy = "NA".into();
            } else {
                let trial = clocks::measure(1, 10_000_000, &mut work); calls = trial[0].calls * 10;
                let e = clocks::energy::package_nj(); let p = clocks::process_cpu_ns(); let c = clocks::Counts::read(); let t = clocks::now();
                for _ in 0..calls { work(); }
                wall = clocks::since_ns(t); let c = c.zip(clocks::Counts::read()).map(|(a, b)| b.since(a)); cpu = clocks::process_cpu_ns() - p;
                cycles = c.map_or(0, |c| c.p.cycles + c.e.cycles); instructions = c.map_or(0, |c| c.p.instructions + c.e.instructions);
                energy = e.zip(clocks::energy::package_nj()).map_or_else(|| "NA".into(), |(a, b)| (b - a).to_string());
            }
            if algorithm == "update" { finalize_and_reset(&mut hs, &which, &mut out); }
        } else {
            calls = if preflight { 1 } else { 64 }; let (mut w, mut p, mut cy, mut ins) = (0, 0, 0, 0);
            for _ in 0..calls {
                feed(&mut hs, &data, &which, &mut pieces, width);
                let p0 = clocks::process_cpu_ns(); let c = clocks::Counts::read(); let t = clocks::now();
                finalize_and_reset(std::hint::black_box(&mut hs), std::hint::black_box(&which), &mut out);
                w += clocks::since_ns(t); let c = c.zip(clocks::Counts::read()).map(|(a, b)| b.since(a)); p += clocks::process_cpu_ns() - p0;
                cy += c.map_or(0, |c| c.p.cycles + c.e.cycles); ins += c.map_or(0, |c| c.p.instructions + c.e.instructions);
                assert_eq!(out, wanted, "consume-once finish canonical digest");
            }
            wall = w; cpu = p; cycles = cy; instructions = ins; energy = "NA".into();
        }
        clocks::load::tick();
        if !preflight { println!("{shape}\t{active}\t{}\t{algorithm}\t{calls}\t{wall}\t{cpu}\t{cycles}\t{instructions}\t{energy}", data.iter().map(Vec::len).sum::<usize>()); }
        assert_eq!(out, wanted, "{algorithm} canonical digest");
        assert!(hs.iter().all(|h| h.count() == 0), "selected states reset and idle states untouched");
    }
}
fn main() {
    blake3_servil::initialize(); let reverse = std::env::args().nth(1).as_deref() == Some("reverse");
    println!("shape\titems\tbytes\talgorithm\tcalls\twall_ns\tcpu_ns\tcycles\tinstructions\tpackage_nj");
    for n in [2, 8, 16, 17, 24, 128, 512] { for len in [16384, 32768] { for flavor in 0..4 { run(n, n, len, 4096, flavor, reverse); } } }
    for active in [7, 8, 15, 16] { for flavor in [0, 3] { run(1024, active, 16384, 4096, flavor, reverse); } }
}

PROBE_EOF
 (cd "$P" && CARGO_TARGET_DIR="$R/target-$side-$pair" RUSTFLAGS="-C metadata=incrementalroots_$pair" cargo build --release && cargo tree -p blake3-servil --depth 0) > "$O/build-$side-$pair.log" 2>&1
 cp "$R/target-$side-$pair/release/incrementalroots" "$R/exe-$side-$pair";cp "$P/Cargo.lock" "$O/lock-$side-$pair.txt"
 ) &
 pids+=("$!")
 done
done
failed=0;for pid in "${pids[@]}";do if ! wait "$pid";then failed=1;fi;done
[ "$failed" = 0 ]
mkdir -p "$R/judge/src"
printf '[package]
name="incrementalrootjudge"
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
    // Compare the same algorithm across the two pinned library versions.
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
if [ "${PINNED_RUN_PREFLIGHT:-0}" = 1 ]; then
 for side in old new;do "$R/exe-$side-1" > "$O/preflight-$side.txt" 2> "$O/preflight-$side.err";done
 echo "pinned-run preflight complete" > "$O/preflight.txt"
 echo "incremental root complete-cycle preflight done" > "$O/status.txt"
 exit 0
fi
for pair in 1 2 3 4;do
 sides='old new';order=forward;[ "$((pair%2))" != 0 ] || { sides='new old';order=reverse; }
 for side in $sides;do taskset -c 2 "$R/exe-$side-$pair" "$order" > "$O/$side-$pair.tsv" 2> "$O/$side-$pair.err";done
done
for algorithm in update cycle finish;do "$R/target-judge/release/incrementalrootjudge" "$O" "$algorithm" > "$O/judgments-$algorithm.tsv";done
echo 'incremental root complete-cycle matrix done' > "$O/status.txt"
