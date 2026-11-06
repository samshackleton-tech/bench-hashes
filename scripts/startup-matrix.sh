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
name="startupprobe"
version="0.1.0"
edition="2021"
[dependencies]
blake3-servil={path="%s/%s"}
clocks={path="%s/bench/clocks"}
' "$R" "$side" "$R" > "$P/Cargo.toml"
  cat > "$P/src/main.rs" <<'STARTUP_PROBE_EOF'
fn main(){
    // Initialize the measurement machinery before the first B3 call.
    clocks::load::tick();let _=clocks::Counts::read();let _=clocks::process_cpu_ns();let _=clocks::now();
    for phase in ["first","already_initialized"]{
        let c=clocks::Counts::read();let cpu=clocks::process_cpu_ns();let t=clocks::now();
        blake3_servil::initialize();
        let wall=clocks::since_ns(t);let cpu=clocks::process_cpu_ns()-cpu;let c=c.zip(clocks::Counts::read()).map(|(a,b)|b.since(a));
        clocks::load::tick();
        println!("{phase}\t{wall}\t{cpu}\t{}\t{}",c.map_or(0,|c|c.p.cycles+c.e.cycles),c.map_or(0,|c|c.p.instructions+c.e.instructions));
    }
}

STARTUP_PROBE_EOF
  (cd "$P" && CARGO_TARGET_DIR="$R/target-$side-$pair" RUSTFLAGS="-C metadata=startup_$pair" cargo build --release && cargo tree -p blake3-servil --depth 0) > "$O/build-$side-$pair.log" 2>&1
  cp "$R/target-$side-$pair/release/startupprobe" "$R/exe-$side-$pair"
 ) &
 pids+=("$!")
 done
done
failed=0;for pid in "${pids[@]}";do if ! wait "$pid";then failed=1;fi;done
[ "$failed" = 0 ]
printf 'shape	side	rep	calls	wall_ns	cpu_ns	cycles	instructions
' > "$O/processes.tsv"
for rep in $(seq 1 32);do
 pair=$(( (rep-1)%4+1 ));sides='old new';[ "$((rep%2))" != 0 ] || sides='new old'
 for side in $sides;do taskset -c 2 "$R/exe-$side-$pair" > "$O/$side-$rep.tsv" 2> "$O/$side-$rep.err";done
done
python3 - "$O" <<'STARTUP_FORMAT_EOF'
from pathlib import Path
import sys
D=Path(sys.argv[1])
with (D/'processes.tsv').open('a') as out:
 for side in ['old','new']:
  for rep in range(1,33):
   for line in (D/f'{side}-{rep}.tsv').read_text().splitlines():
    f=line.split();assert len(f)==5;print(*([f[0],side,str(rep),'1']+f[1:]),sep=chr(9),file=out)
STARTUP_FORMAT_EOF
mkdir -p "$R/judge/src"
printf '[package]
name="startupjudge"
version="0.1.0"
edition="2021"
[dependencies]
clocks={path="%s/bench/clocks"}
' "$R" > "$R/judge/Cargo.toml"
cat > "$R/judge/src/main.rs" <<'STARTUP_JUDGE_EOF'
use std::collections::BTreeMap;
use clocks::summary::{mean,discoveries};
fn main(){
    let text=std::fs::read_to_string(std::env::args().nth(1).unwrap()).unwrap();
    let mut rows:BTreeMap<(String,String,usize),(u64,[u64;4])>=BTreeMap::new();
    for line in text.lines().skip(1){
        let f:Vec<_>=line.split('\t').collect();
        rows.insert((f[0].into(),f[1].into(),f[2].parse().unwrap()),(f[3].parse().unwrap(),core::array::from_fn(|i|f[4+i].parse().unwrap())));
    }
    let mut cells=Vec::new();let mut labels=Vec::new();let mut totals=Vec::new();
    for ((shape,side,_),_) in &rows{
        if side!="old"{continue;}
        for (metric,index) in [("wall_ns",0),("cpu_ns",1),("cycles",2),("instructions",3)]{
            if labels.iter().any(|(s,m)|s==shape&&*m==metric){continue;}
            let mut pairs=Vec::new();let mut sum=(0u128,0u128,0u128,0u128);
            let mut layouts=[(0u64,0u64,0u64,0u64);4];
            for ((s,side,rep),(calls,v)) in &rows{
                if s!=shape||side!="old"{continue;}
                let (nc,n)=&rows[&(shape.clone(),"new".into(),*rep)];
                let group=&mut layouts[(rep-1)%4];group.0+=v[index];group.1+=*calls;group.2+=n[index];group.3+=*nc;
                sum.0+=v[index] as u128;sum.1+=*calls as u128;sum.2+=n[index] as u128;sum.3+=*nc as u128;
            }
            for (ot,oc,nt,nc) in layouts {assert!(oc>0&&nc>0);pairs.push((mean([(ot,oc)]),mean([(nt,nc)])));}
            labels.push((shape.clone(),metric));totals.push((pairs.len(),sum));cells.push(pairs);
        }
    }
    println!("shape\tmetric\tpairs\told_per_message\tnew_per_message\tratio_permille\tverdict");
    for (((shape,metric),(n,s)),j) in labels.into_iter().zip(totals).zip(discoveries(&cells,50,30)){
        println!("{shape}\t{metric}\t{n}\t{:.4}\t{:.4}\t{}\t{:?}",s.0 as f64/s.1 as f64,s.2 as f64/s.3 as f64,j.ratio_permille,j.verdict);
    }
}

STARTUP_JUDGE_EOF
(cd "$R/judge" && CARGO_TARGET_DIR="$R/target-judge" cargo run --release -- "$O/processes.tsv") > "$O/judgments.tsv" 2> "$O/build-judge.log"
echo 'startup matrix done' > "$O/status.txt"
