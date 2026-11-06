#!/bin/bash
set -euo pipefail
R="$1"; O="$R/out"; mkdir -p "$O"; cd "$R"
export HOME=/root; . /root/.cargo/env
{ date -u; uname -a; grep -m1 'model name' /proc/cpuinfo; grep -m1 '^flags' /proc/cpuinfo; cat /sys/devices/system/cpu/cpu2/topology/physical_package_id; rustc --version; for s in old new bench; do echo "$s $(git -C "$s" rev-parse HEAD)"; done; } > "$O/machine.txt"
for pair in 1 2 3 4; do
 for side in old new; do
  P="$R/probe-$side-$pair"; mkdir -p "$P/src"
  printf '[package]
name="lastmatrix"
version="0.1.0"
edition="2021"
[dependencies]
blake3-servil={path="%s/%s"}
sha2="=0.11.0"
clocks={path="%s/bench/clocks"}
' "$R" "$side" "$R" > "$P/Cargo.toml"
  cat > "$P/src/main.rs" <<'MATRIX_RUST_EOF'
use blake3_servil::{Mode, performance::{self, Block}};
use sha2::Digest;

fn run(shape: &str, count: usize, lens: &[usize]) {
    let blocks: Vec<Vec<Block>> = lens.iter().enumerate().map(|(i, &len)| {
        let mut b = vec![Block::ZERO; len.div_ceil(64).max(1)];
        for (k, x) in Block::bytes_mut(&mut b)[..len].iter_mut().enumerate() { *x = (i * 31 + k) as u8; }
        b
    }).collect();
    let items: Vec<(&[Block], usize)> = blocks.iter().zip(lens).map(|(b, &len)| (&b[..], len)).collect();
    let bytes = lens.iter().sum::<usize>();
    let mut out = vec![[0u8; 32]; count];
    performance::hash_each(Mode::Plain, &items, &mut out);
    for (i, (b, len)) in items.iter().enumerate() {
        assert_eq!(out[i], *blake3_servil::convenience::hash(&Block::bytes(b)[..*len]).as_bytes(), "{shape}, {count} items, item {i}");
    }
    for algorithm in ["b3", "sha256"] {
        let mut work = || {
            if algorithm == "b3" {
                performance::hash_each(Mode::Plain, std::hint::black_box(&items), &mut out);
            } else {
                for ((b, len), digest) in items.iter().zip(&mut out) {
                    *digest = sha2::Sha256::digest(std::hint::black_box(&Block::bytes(b)[..*len])).into();
                }
            }
            std::hint::black_box(&out);
        };
        let trial = clocks::measure(1, 10_000_000, &mut work);
        let calls = trial[0].calls * 10;
        for _ in 0..2 { work(); }
        let e0 = clocks::energy::package_nj();
        let cpu0 = clocks::process_cpu_ns();
        let c0 = clocks::Counts::read();
        let start = clocks::now();
        for _ in 0..calls { work(); }
        let wall = clocks::since_ns(start);
        let c = c0.zip(clocks::Counts::read()).map(|(a,b)| b.since(a));
        let cpu = clocks::process_cpu_ns() - cpu0;
        let energy = e0.zip(clocks::energy::package_nj()).map(|(a,b)| b-a);
        clocks::load::tick();
        println!("{shape}\t{count}\t{bytes}\t{algorithm}\t{calls}\t{wall}\t{cpu}\t{}\t{}\t{}",
                 c.map_or(0, |c| c.p.cycles+c.e.cycles), c.map_or(0, |c| c.p.instructions+c.e.instructions),
                 energy.map_or_else(|| "NA".into(), |e| e.to_string()));
    }
}
fn main() {
    blake3_servil::initialize();
    println!("shape\titems\tbytes\talgorithm\tcalls\twall_ns\tcpu_ns\tcycles\tinstructions\tpackage_nj");
    for count in [2, 4, 8, 16, 32, 64, 128, 1024] {
        for len in [0, 1, 31, 63, 64, 65, 96, 128, 129, 255, 256, 257, 511, 512, 513, 768, 1024] {
            run(&len.to_string(), count, &vec![len; count]);
        }
        let mut x=0x9e37_79b9u64;
        let lens: Vec<usize> = (0..count).map(|_| { x ^= x<<13; x ^= x>>7; x ^= x<<17; 100+(x%901) as usize }).collect();
        run("mixed", count, &lens);
        run("near300", count, &(0..count).map(|i| 284+(i*37)%33).collect::<Vec<_>>());
        run("skew", count, &(0..count).map(|i| if i%16==0 {1024} else {1}).collect::<Vec<_>>());
        run("alternating", count, &(0..count).map(|i| if i%2==0 {1024} else {1}).collect::<Vec<_>>());
    }
}

MATRIX_RUST_EOF
  ( cd "$P" && RUSTFLAGS="-C metadata=lastmatrix_pair_$pair" CARGO_TARGET_DIR="$R/target-$side-$pair" cargo build --release && cargo tree -p blake3-servil --depth 0 ) > "$O/build-$side-$pair.log" 2>&1
  cp "$R/target-$side-$pair/release/lastmatrix" "$O/exe-$side-$pair"
  cp "$P/Cargo.lock" "$O/lock-$side-$pair.txt"
 done
 done
mkdir -p "$R/judge/src"
printf '[package]
name="judge"
version="0.1.0"
edition="2021"
[dependencies]
clocks={path="%s/bench/clocks"}
' "$R" > "$R/judge/Cargo.toml"
cat > "$R/judge/src/main.rs" <<'JUDGE_RUST_EOF'
use std::{collections::BTreeMap, fs, path::Path};
use clocks::summary::{mean, discoveries};
#[derive(Clone)]
struct Row { units: u64, metrics: BTreeMap<String,u64> }
type Key=(String,u64,String);
fn read(path: &Path) -> BTreeMap<Key,Row> {
    let text=fs::read_to_string(path).unwrap();
    let mut lines=text.lines();
    assert_eq!(lines.next(),Some("shape\titems\tbytes\talgorithm\tcalls\twall_ns\tcpu_ns\tcycles\tinstructions\tpackage_nj"));
    let mut rows=BTreeMap::new();
    for line in lines {
        let f:Vec<_>=line.split('\t').collect();assert_eq!(f.len(),10);
        let count:u64=f[1].parse().unwrap();let calls:u64=f[4].parse().unwrap();
        let mut metrics=BTreeMap::new();
        for (i,name) in [(5,"wall_ns"),(6,"cpu_ns"),(7,"cycles"),(8,"instructions"),(9,"package_nj")] {
            if f[i]!="NA" {metrics.insert(name.to_string(),f[i].parse().unwrap());}
        }
        assert!(rows.insert((f[0].into(),count,f[3].into()),Row{units:count*calls,metrics}).is_none());
    }
    rows
}
fn main() {
    let dir=std::env::args().nth(1).expect("directory");let dir=Path::new(&dir);
    let old:Vec<_>=(1..=4).map(|p|read(&dir.join(format!("old-{p}.tsv")))).collect();
    let new:Vec<_>=(1..=4).map(|p|read(&dir.join(format!("new-{p}.tsv")))).collect();
    let mut cells=Vec::new();let mut names=Vec::new();
    let mut costs=Vec::new();
    for (shape,count,algorithm) in old[0].keys() {
        if algorithm!="b3" {continue;}
        for metric in ["wall_ns","cpu_ns","cycles","instructions","package_nj"] {
            for versus in ["old-b3","sha256"] {
                let mut pairs=Vec::new();let mut old_tot=(0u128,0u128);let mut new_tot=(0u128,0u128);
                for p in 0..4 {
                    let a=if versus=="old-b3" {&old[p][&(shape.clone(),*count,"b3".into())]} else {&new[p][&(shape.clone(),*count,"sha256".into())]};
                    let b=&new[p][&(shape.clone(),*count,"b3".into())];
                    let (Some(&av),Some(&bv))=(a.metrics.get(metric),b.metrics.get(metric)) else {break;};
                    if av==0 || bv==0 {break;}
                    pairs.push((mean([(av,a.units)]),mean([(bv,b.units)])));
                    old_tot.0+=av as u128;old_tot.1+=a.units as u128;new_tot.0+=bv as u128;new_tot.1+=b.units as u128;
                }
                if pairs.len()==4 {
                    names.push((shape.clone(),*count,metric,versus));cells.push(pairs);
                    costs.push((old_tot,new_tot));
                }
            }
        }
    }
    let judged=discoveries(&cells,50,30);
    println!("shape\titems\tmetric\tversus\told_per_item\tnew_per_item\tratio_permille\tverdict");
    for (((shape,count,metric,versus),cost),j) in names.into_iter().zip(costs).zip(judged) {
        println!("{shape}\t{count}\t{metric}\t{versus}\t{:.4}\t{:.4}\t{}\t{:?}",
                 cost.0.0 as f64/cost.0.1 as f64,cost.1.0 as f64/cost.1.1 as f64,j.ratio_permille,j.verdict);
    }
}

JUDGE_RUST_EOF
(cd "$R/judge" && CARGO_TARGET_DIR="$R/target-judge" cargo build --release) > "$O/build-judge.log" 2>&1
for pair in 1 2 3 4; do
 sides='old new'; if [ "$((pair%2))" = 0 ]; then sides='new old'; fi
 for side in $sides; do
  taskset -c 2 "$O/exe-$side-$pair" > "$O/$side-$pair.tsv" 2> "$O/$side-$pair.err"
 done
 done
"$R/target-judge/release/judge" "$O" > "$O/judgments.tsv"
echo 'paired matrix done' > "$O/status.txt"
