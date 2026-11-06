#!/bin/bash
set -euo pipefail
R="$1";O="$R/out";mkdir -p "$O";export HOME=/root;. /root/.cargo/env
{ date -u;uname -a;grep -m1 'model name' /proc/cpuinfo;rustc --version;for repo in old new bench;do echo "$repo $(git -C "$R/$repo" rev-parse HEAD)";done; } > "$O/identity.txt"
pids=()
for pair in 1 2 3 4;do
 for side in old new;do
 (
  P="$R/probe-$side-$pair";mkdir -p "$P/src"
  printf '[package]
name="batchprobe"
version="0.1.0"
edition="2021"
[dependencies]
blake3-servil={path="%s/%s"}
blake3="=1.8.7"
sha2="=0.11.0"
clocks={path="%s/bench/clocks"}
' "$R" "$side" "$R" > "$P/Cargo.toml"
  cat > "$P/src/main.rs" <<'BATCH_PROBE_EOF'
use blake3_servil::{Mode,performance::{self,Batch,Block}};
use sha2::Digest;
fn run(len:usize,n:usize,reverse:bool){
    let mut batch=Batch::new(len,n);
    for i in 0..n {for (j,b) in batch.message_mut(i).iter_mut().enumerate(){*b=(i*31+j*17) as u8;}}
    let slot=len.div_ceil(64).max(1)*64;
    let items:Vec<(&[Block],usize)>=batch.blocks().chunks_exact(slot/64).map(|b|(b,len)).collect();
    let mut out=vec![[0u8;32];n];let bytes=len*n;
    let mut algorithms=["b3","each","sha256"];if reverse{algorithms.reverse();}
    for algorithm in algorithms {
        let mut work=||{
            match algorithm{
                "b3"=>performance::hash_many(Mode::Plain,std::hint::black_box(&batch),&mut out),
                "each"=>performance::hash_each(Mode::Plain,std::hint::black_box(&items),&mut out),
                "sha256"=>{for ((b,l),h) in items.iter().zip(&mut out){*h=sha2::Sha256::digest(std::hint::black_box(&Block::bytes(b)[..*l])).into();}},
                _=>unreachable!(),
            }
            std::hint::black_box(&out);
        };
        let trial=clocks::measure(1,10_000_000,&mut work);let calls=trial[0].calls*10;
        let e=clocks::energy::package_nj();let cpu=clocks::process_cpu_ns();let c=clocks::Counts::read();let t=clocks::now();
        for _ in 0..calls{work();}
        let wall=clocks::since_ns(t);let c=c.zip(clocks::Counts::read()).map(|(a,b)|b.since(a));let cpu=clocks::process_cpu_ns()-cpu;
        let e=e.zip(clocks::energy::package_nj()).map(|(a,b)|b-a);clocks::load::tick();
        println!("{len}\t{n}\t{bytes}\t{algorithm}\t{calls}\t{wall}\t{cpu}\t{}\t{}\t{}",c.map_or(0,|c|c.p.cycles+c.e.cycles),c.map_or(0,|c|c.p.instructions+c.e.instructions),e.map_or_else(||"NA".into(),|e|e.to_string()));
        for ((b,l),h) in items.iter().zip(&out){let m=&Block::bytes(b)[..*l];let expected:[u8;32]=if algorithm=="sha256"{sha2::Sha256::digest(m).into()}else{*blake3::hash(m).as_bytes()};assert_eq!(*h,expected,"{algorithm} {len} {n}");}
    }
}
fn main(){
    blake3_servil::initialize();let reverse=std::env::args().nth(1).as_deref()==Some("reverse");
    println!("shape\titems\tbytes\talgorithm\tcalls\twall_ns\tcpu_ns\tcycles\tinstructions\tpackage_nj");
    for len in [0,1,31,63,64,65,96,128,129,255,256,257,511,512,513,768,1023,1024]{
        for n in [2,4,8,16,17,32,64,128,1024]{run(len,n,reverse);}
    }
}

BATCH_PROBE_EOF
  (cd "$P" && CARGO_TARGET_DIR="$R/target-$side-$pair" RUSTFLAGS="-C metadata=batch_$pair" cargo build --release && cargo tree -p blake3-servil --depth 0) > "$O/build-$side-$pair.log" 2>&1
  cp "$R/target-$side-$pair/release/batchprobe" "$R/exe-$side-$pair";cp "$P/Cargo.lock" "$O/lock-$side-$pair.txt"
 ) &
 pids+=("$!")
 done
done
failed=0;for pid in "${pids[@]}";do if ! wait "$pid";then failed=1;fi;done
[ "$failed" = 0 ]
mkdir -p "$R/judge/src"
printf '[package]
name="batchjudge"
version="0.1.0"
edition="2021"
[dependencies]
clocks={path="%s/bench/clocks"}
' "$R" > "$R/judge/Cargo.toml"
cat > "$R/judge/src/main.rs" <<'BATCH_JUDGE_EOF'
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

BATCH_JUDGE_EOF
(cd "$R/judge" && CARGO_TARGET_DIR="$R/target-judge" cargo build --release) > "$O/build-judge.log" 2>&1
for pair in 1 2 3 4;do
 sides='old new';order=forward;[ "$((pair%2))" != 0 ] || { sides='new old';order=reverse; }
 for side in $sides;do taskset -c 2 "$R/exe-$side-$pair" "$order" > "$O/$side-$pair.tsv" 2> "$O/$side-$pair.err";done
done
"$R/target-judge/release/batchjudge" "$O" b3 each sha256 > "$O/judgments.tsv"
echo 'batch matrix done' > "$O/status.txt"
