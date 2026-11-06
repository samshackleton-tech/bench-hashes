#!/bin/bash
set -euo pipefail
R="$1";O="$R/out";mkdir -p "$O";export HOME=/root;. /root/.cargo/env
{ date -u;uname -a;grep -m1 'model name' /proc/cpuinfo;rustc --version;cc --version | head -1;for repo in library bench isal;do echo "$repo $(git -C "$R/$repo" rev-parse HEAD)";done; } > "$O/identity.txt"
if ! command -v nasm >/dev/null;then apt-get update -qq && apt-get install -y nasm;fi
nasm -v >> "$O/identity.txt"
(cd "$R/isal" && make -f Makefile.unx -j8) > "$O/isal-build.log" 2>&1
cat > "$R/mb-sha.c" <<'MB_C_EOF'
// Benchmark adapter only. ISA-L Crypto performs standard multi-buffer SHA-256.
// This deliberately does not use its different mh_sha256 construction.
#include <isa-l_crypto/sha256_mb.h>
#include <assert.h>
#include <stdlib.h>
#include <stdio.h>
#include <stddef.h>

typedef struct {
    ISAL_SHA256_HASH_CTX_MGR manager;
    ISAL_SHA256_HASH_CTX *contexts;
    size_t count;
} Batch;
static void check(int status) {if(status)abort();}
void *mb_create(size_t count) {
    Batch *b=0;check(posix_memalign((void**)&b,64,sizeof(*b)));
    b->count=count;check(posix_memalign((void**)&b->contexts,64,count*sizeof(*b->contexts)));
    check(isal_sha256_ctx_mgr_init(&b->manager));
    for(size_t j=0;j<count;j++)isal_hash_ctx_init(&b->contexts[j]);
    return b;
}
void mb_destroy(void *opaque) {Batch *b=opaque;free(b->contexts);free(b);}
void mb_layout(void) {fprintf(stderr,"manager %zu align %zu; context %zu align %zu; standard SHA256 multi-buffer\n",sizeof(ISAL_SHA256_HASH_CTX_MGR),_Alignof(ISAL_SHA256_HASH_CTX_MGR),sizeof(ISAL_SHA256_HASH_CTX),_Alignof(ISAL_SHA256_HASH_CTX));}
static void store(Batch *b,ISAL_SHA256_HASH_CTX *ctx,unsigned char (*out)[32]) {
    assert(isal_hash_ctx_complete(ctx)&&!isal_hash_ctx_error(ctx));
    ptrdiff_t j=ctx-b->contexts;assert(j>=0&&(size_t)j<b->count);
    for(size_t w=0;w<8;w++) {
        uint32_t x=ctx->job.result_digest[w];
        out[j][4*w]=(unsigned char)(x>>24);out[j][4*w+1]=(unsigned char)(x>>16);
        out[j][4*w+2]=(unsigned char)(x>>8);out[j][4*w+3]=(unsigned char)x;
    }
}
void mb_hash(void *opaque,const unsigned char *const *data,const size_t *lengths,unsigned char (*out)[32]) {
    Batch *b=opaque;ISAL_SHA256_HASH_CTX *returned=0;size_t done=0;
    for(size_t j=0;j<b->count;j++) {
        assert(lengths[j]<=UINT32_MAX);
        check(isal_sha256_ctx_mgr_submit(&b->manager,&b->contexts[j],&returned,data[j],(uint32_t)lengths[j],ISAL_HASH_ENTIRE));
        if(returned){store(b,returned,out);done++;}
    }
    do {
        check(isal_sha256_ctx_mgr_flush(&b->manager,&returned));
        if(returned){store(b,returned,out);done++;}
    }while(returned);
    assert(done==b->count);
}

MB_C_EOF
cc -O3 -UNDEBUG -I"$R/isal/include" -c "$R/mb-sha.c" -o "$R/mb-sha.o"
for pair in 1 2 3 4;do
 P="$R/probe-$pair";mkdir -p "$P/src"
 printf '[package]
name="mbmatrix"
version="0.1.0"
edition="2021"
[dependencies]
blake3-servil={path="%s/library"}
blake3="=1.8.7"
sha2="=0.11.0"
clocks={path="%s/bench/clocks"}
' "$R" "$R" > "$P/Cargo.toml"
 cat > "$P/src/main.rs" <<'MB_RUST_EOF'
use blake3_servil::{Mode,performance::{self,Block}};
use sha2::Digest;
use std::ffi::c_void;
unsafe extern "C" {
    fn mb_create(count:usize)->*mut c_void;
    fn mb_destroy(batch:*mut c_void);
    fn mb_layout();
    fn mb_hash(batch:*mut c_void,data:*const *const u8,lengths:*const usize,out:*mut [u8;32]);
}
fn run(shape:&str,lens:&[usize],reverse:bool){
    let n=lens.len();let bytes=lens.iter().sum::<usize>();
    let blocks:Vec<Vec<Block>>=lens.iter().enumerate().map(|(i,&l)|{
        let mut b=vec![Block::ZERO;l.div_ceil(64).max(1)];
        for (j,x) in Block::bytes_mut(&mut b)[..l].iter_mut().enumerate(){*x=(i*31+j*17) as u8;}b
    }).collect();
    let items:Vec<(&[Block],usize)>=blocks.iter().zip(lens).map(|(b,&l)|(&b[..],l)).collect();
    let pointers:Vec<*const u8>=items.iter().map(|(b,_)|Block::bytes(b).as_ptr()).collect();
    let mut out=vec![[0u8;32];n];let batch=unsafe{mb_create(n)};assert!(!batch.is_null());
    let mut algorithms=["b3","mb_sha256","sha256"];
    if reverse {algorithms.reverse();}
    for algorithm in algorithms {
        let mut work=||{
            match algorithm {
                "b3"=>performance::hash_each(Mode::Plain,std::hint::black_box(&items),&mut out),
                "mb_sha256"=>unsafe{mb_hash(batch,std::hint::black_box(pointers.as_ptr()),lens.as_ptr(),out.as_mut_ptr());},
                "sha256"=>{for ((b,l),tag) in items.iter().zip(&mut out){*tag=sha2::Sha256::digest(std::hint::black_box(&Block::bytes(b)[..*l])).into();}},
                _=>unreachable!(),
            }
            std::hint::black_box(&out);
        };
        let trial=clocks::measure(1,10_000_000,&mut work);let calls=trial[0].calls*10;
        let e=clocks::energy::package_nj();let cpu=clocks::process_cpu_ns();let c=clocks::Counts::read();let t=clocks::now();
        for _ in 0..calls{work();}
        let wall=clocks::since_ns(t);let c=c.zip(clocks::Counts::read()).map(|(a,b)|b.since(a));let cpu=clocks::process_cpu_ns()-cpu;
        let e=e.zip(clocks::energy::package_nj()).map(|(a,b)|b-a);clocks::load::tick();
        println!("{shape}\t{n}\t{bytes}\t{algorithm}\t{calls}\t{wall}\t{cpu}\t{}\t{}\t{}",c.map_or(0,|c|c.p.cycles+c.e.cycles),c.map_or(0,|c|c.p.instructions+c.e.instructions),e.map_or_else(||"NA".into(),|e|e.to_string()));
        for ((b,l),tag) in items.iter().zip(&out){let message=&Block::bytes(b)[..*l];let expected:[u8;32]=if algorithm=="b3"{*blake3::hash(message).as_bytes()}else{sha2::Sha256::digest(message).into()};assert_eq!(*tag,expected,"{algorithm} {shape}");}
    }
    unsafe{mb_destroy(batch)};
}
fn main(){
    blake3_servil::initialize();unsafe{mb_layout()};
    let reverse=std::env::args().nth(1).as_deref()==Some("reverse");
    println!("shape\titems\tbytes\talgorithm\tcalls\twall_ns\tcpu_ns\tcycles\tinstructions\tpackage_nj");
    for n in [2,4,8,16,64,1024]{
        for l in [0,1,64,256,1024]{run(&l.to_string(),&vec![l;n],reverse);}
        let mut x=0x9e37_79b9u64;let lens:Vec<_>=(0..n).map(|_|{x^=x<<13;x^=x>>7;x^=x<<17;100+(x%901) as usize}).collect();run("mixed",&lens,reverse);
    }
}

MB_RUST_EOF
 (cd "$P" && CARGO_TARGET_DIR="$R/target-$pair" RUSTFLAGS="-C metadata=mbmatrix_$pair -C link-arg=$R/mb-sha.o -C link-arg=$R/isal/bin/isa-l_crypto.a" cargo build --release && cargo tree -p blake3-servil --depth 0) > "$O/build-$pair.log" 2>&1
 cp "$R/target-$pair/release/mbmatrix" "$R/exe-$pair";cp "$P/Cargo.lock" "$O/lock-$pair.txt"
done
mkdir -p "$R/judge/src"
printf '[package]
name="mbjudge"
version="0.1.0"
edition="2021"
[dependencies]
clocks={path="%s/bench/clocks"}
' "$R" > "$R/judge/Cargo.toml"
cat > "$R/judge/src/main.rs" <<'MB_JUDGE_EOF'
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

MB_JUDGE_EOF
(cd "$R/judge" && CARGO_TARGET_DIR="$R/target-judge" cargo build --release) > "$O/build-judge.log" 2>&1
for pair in 1 2 3 4;do
 order=forward;[ "$((pair%2))" != 0 ] || order=reverse
 for side in old new;do taskset -c 2 "$R/exe-$pair" "$order" > "$O/$side-$pair.tsv" 2> "$O/$side-$pair.err";done
done
"$R/target-judge/release/mbjudge" "$O" b3 mb_sha256 sha256 > "$O/judgments.tsv"
echo 'multibuffer matrix done' > "$O/status.txt"
