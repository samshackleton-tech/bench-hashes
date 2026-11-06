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
        for (metric,index) in [("wall_ns",0),("cpu_ns",1),("caller_cycles",2),("package_nj",3)]{
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
