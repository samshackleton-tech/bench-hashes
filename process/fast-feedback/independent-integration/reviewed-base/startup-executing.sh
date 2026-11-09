#!/bin/bash
set -euo pipefail
exec timeout -k 5s 900s bash -s -- "$1" <<'STARTUP_JOB_EOF'
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
    let _=clocks::Counts::read();let _=clocks::process_cpu_ns();let _=clocks::now();
    clocks::load::tick();
    if let Err(reason)=clocks::load::quiet_for(1){eprintln!("startup abstained before measurement: {reason}");std::process::exit(2);}
    clocks::load::tick();
    for phase in ["first","already_initialized"]{
        let c=clocks::Counts::read();let cpu=clocks::process_cpu_ns();let t=clocks::now();
        blake3_servil::initialize();
        let wall=clocks::since_ns(t);let cpu=clocks::process_cpu_ns()-cpu;let c=c.zip(clocks::Counts::read()).map(|(a,b)|b.since(a));
        clocks::load::tick();
        let c=c.expect("startup study requires per-thread core counters");
        eprintln!("core_counts phase={phase} calls=1 p_cycles={} p_instructions={} e_cycles={} e_instructions={}",c.p.cycles,c.p.instructions,c.e.cycles,c.e.instructions);
        println!("{phase}\t{wall}\t{cpu}\t{}\t{}",c.p.cycles+c.e.cycles,c.p.instructions+c.e.instructions);
    }
    let windows=clocks::load::windows();
    assert!(!windows.is_empty(),"startup samples need a completed load window");
    eprintln!("load: {}",clocks::load::describe(&windows));
    if windows.iter().any(|w|w.busy()){std::process::exit(2);}
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
fn per_call(total:u128,calls:u128)->String{
    assert!(calls>0);
    let rounded=total.checked_mul(10_000).and_then(|x|x.checked_add(calls/2)).expect("decimal display fits u128")/calls;
    format!("{}.{:04}",rounded/10_000,rounded%10_000)
}
#[test]
fn decimal_rounding(){
    assert_eq!(per_call(1,3),"0.3333");
    assert_eq!(per_call(1,20_000),"0.0001");
    assert_eq!(per_call(19_999,20_000),"1.0000");
    assert_eq!(per_call(u64::MAX as u128,1),"18446744073709551615.0000");
}
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
        println!("{shape}\t{metric}\t{n}\t{}\t{}\t{}\t{:?}",per_call(s.0,s.1),per_call(s.2,s.3),j.ratio_permille,j.verdict);
    }
}

STARTUP_JUDGE_EOF
(cd "$R/judge" && CARGO_TARGET_DIR="$R/target-judge" cargo nextest run --release) > "$O/judge-tests.log" 2>&1
(cd "$R/judge" && CARGO_TARGET_DIR="$R/target-judge" cargo run --release -- "$O/processes.tsv") > "$O/judgments.tsv" 2> "$O/build-judge.log"
echo 'startup matrix done' > "$O/status.txt"

for side in old new;do for pair in 1 2 3 4;do nm -S --size-sort "$R/exe-$side-$pair" > "$O/symbols-$side-$pair.txt";size -A "$R/exe-$side-$pair" > "$O/size-$side-$pair.txt";done;done
STARTUP_JOB_EOF
