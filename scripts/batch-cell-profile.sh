#!/bin/bash
set -euo pipefail
R="$1";O="$R/out";mkdir -p "$O";export HOME=/root;. /root/.cargo/env
{ date -u;uname -a;grep -m1 'model name' /proc/cpuinfo;rustc --version;perf --version;for repo in old new bench;do echo "$repo $(git -C "$R/$repo" rev-parse HEAD)";done;echo 'Controlled one-cell profiling caller; not the original all-shape caller'; } > "$O/identity.txt"
pids=()
for pair in 1 2 3 4;do
 for side in old new;do
 (
 P="$R/probe-$side-$pair";mkdir -p "$P/src"
 printf '[package]
name="batchcell"
version="0.1.0"
edition="2021"
[dependencies]
blake3-servil={path="%s/%s"}
blake3="=1.8.7"
clocks={path="%s/bench/clocks"}
' "$R" "$side" "$R" > "$P/Cargo.toml"
 cat > "$P/src/main.rs" <<'PROBE_EOF'
use blake3_servil::{Mode, performance::{self, Batch, Block}};

fn main() {
    let len: usize = std::env::args().nth(1).expect("length").parse().unwrap();
    // The pinned script supplies whole-block lengths 512/1024 and count 8.
    // Keep both runtime-valued, as in the all-shape caller being diagnosed.
    let n: usize = std::env::args().nth(2).expect("count").parse().unwrap();
    let slot = len.div_ceil(64).max(1) * 64;
    let samples = 32u64;
    let calls_per_sample = 100_000u64;
    let warmup = 5_000u64;
    blake3_servil::initialize();
    let mut batch = Batch::new(len, n);
    for i in 0..n {
        for (j, b) in batch.message_mut(i).iter_mut().enumerate() { *b = (i * 31 + j * 17) as u8; }
    }
    let mut out = vec![[0u8; 32]; n];
    assert_eq!(std::mem::size_of::<[u8; 32]>(), 32);
    assert_eq!(std::mem::size_of::<Block>(), 64);
    eprintln!("layout input={:#x} output={:#x} input_mod4096={} output_mod4096={} input_slot={} output_stride={} output_type_alignment={} Block_alignment={}",
        batch.blocks().as_ptr() as usize, out.as_ptr() as usize,
        batch.blocks().as_ptr() as usize % 4096, out.as_ptr() as usize % 4096,
        slot, std::mem::size_of::<[u8; 32]>(), std::mem::align_of::<[u8; 32]>(), std::mem::align_of::<Block>());
    eprintln!("Single-threaded hash_many; arrays and outputs belong to this caller. No worker sharing. measured_calls={} warmup_calls={warmup}", samples * calls_per_sample);
    let mut work = || {
        performance::hash_many(Mode::Plain, std::hint::black_box(&batch), &mut out);
        std::hint::black_box(&out);
    };
    for _ in 0..warmup { work(); }
    let (mut wall, mut cpu) = (0u64, 0u64);
    let (mut cycles, mut instructions, mut energy) = (Some(0u64), Some(0u64), Some(0u64));
    for sample in 0..samples {
        let e = clocks::energy::package_nj();
        let p = clocks::process_cpu_ns();
        let c = clocks::Counts::read();
        let t = clocks::now();
        for _ in 0..calls_per_sample { work(); }
        let w = clocks::since_ns(t);
        let c = c.zip(clocks::Counts::read()).map(|(a, b)| b.since(a));
        let p = clocks::process_cpu_ns() - p;
        let e = e.zip(clocks::energy::package_nj()).map(|(a, b)| b - a);
        wall += w; cpu += p;
        cycles = cycles.zip(c).map(|(a, b)| a + b.p.cycles + b.e.cycles);
        instructions = instructions.zip(c).map(|(a, b)| a + b.p.instructions + b.e.instructions);
        energy = energy.zip(e).map(|(a, b)| a + b);
        clocks::load::tick();
        eprintln!("sample {sample} calls {calls_per_sample} wall_ns {w} cpu_ns {p}");
    }
    let metric = |x: Option<u64>| x.map_or_else(|| "NA".into(), |x| x.to_string());
    println!("shape\titems\tbytes\talgorithm\tcalls\twall_ns\tcpu_ns\tcycles\tinstructions\tpackage_nj");
    println!("{len}\t{n}\t{}\tb3\t{}\t{wall}\t{cpu}\t{}\t{}\t{}", len * n, samples * calls_per_sample, metric(cycles), metric(instructions), metric(energy));
    for (i, digest) in out.iter().enumerate() {
        assert_eq!(*digest, *blake3::hash(&Block::bytes(batch.blocks())[i * slot..][..len]).as_bytes());
    }
}

PROBE_EOF
 (cd "$P" && CARGO_TARGET_DIR="$R/target-$side-$pair" RUSTFLAGS="-C metadata=batchcell_$pair" cargo build --release && cargo tree -p blake3-servil --depth 0) > "$O/build-$side-$pair.log" 2>&1
 cp "$R/target-$side-$pair/release/batchcell" "$R/exe-$side-$pair";cp "$P/Cargo.lock" "$O/lock-$side-$pair.txt"
 ) &
 pids+=("$!")
 done
done
failed=0;for pid in "${pids[@]}";do if ! wait "$pid";then failed=1;fi;done
[ "$failed" = 0 ]
mkdir -p "$R/judge/src"
printf '[package]
name="batchcelljudge"
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
    // Compare two versions of one algorithm in one metric family.
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
 sides='old new';[ "$((pair%2))" != 0 ] || sides='new old'
 for len in 512 1024;do
  for side in $sides;do
   taskset -c 2 perf stat --no-big-num -x $'\t' -e '{branches:u,branch-misses:u}' -o "$O/perf-$side-$pair-$len.tsv" -- "$R/exe-$side-$pair" "$len" 8 > "$O/$side-$pair-$len.tsv" 2> "$O/$side-$pair-$len.err"
  done
 done
done
python3 - "$O" <<'PY'
from pathlib import Path
import sys,decimal
O=Path(sys.argv[1])
for pair in range(1,5):
 for side in ['old','new']:
  rows=[(O/f'{side}-{pair}-{n}.tsv').read_text().splitlines() for n in [512,1024]]
  assert rows[0][0]==rows[1][0]
  with (O/f'{side}-{pair}.tsv').open('w') as out:print(rows[0][0],rows[0][1],rows[1][1],sep=chr(10),file=out)
for p in O.glob('perf-*.tsv'):
 found=set()
 for line in p.read_text().splitlines():
  f=line.split(chr(9))
  if len(f)>=5 and f[2] in ['branches:u','branch-misses:u']:
   assert decimal.Decimal(f[0])>=0,(p,f)
   assert decimal.Decimal(f[4])>=99,(p,f)
   found.add(f[2])
 assert found=={'branches:u','branch-misses:u'},(p,found)
PY
"$R/target-judge/release/batchcelljudge" "$O" b3 > "$O/judgments.tsv"
echo 'controlled batch-cell profiling done' > "$O/status.txt"
