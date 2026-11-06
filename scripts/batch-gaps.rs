use blake3_servil::{Mode,performance::{self,Batch,Block}};
use sha2::Digest;
fn run(len:usize,n:usize,reverse:bool,arena:&[u8]){
    let mut batch=Batch::new(len,n);for i in 0..n{for(j,b)in batch.message_mut(i).iter_mut().enumerate(){*b=(i*31+j*17)as u8;}}
    let slot=len.div_ceil(64).max(1)*64;
    let mut out=vec![[0u8;32];n];let mut algs=["b3","sha256"];if reverse{algs.reverse();}
    for (pattern,gap) in [("idle",clocks::Gap::Idle),("busy",clocks::Gap::Busy(arena))]{
        for algorithm in algs{
            let measured=clocks::measure_after_gaps_prepared(24,gap,1_000_000,&mut batch,|_|{},|batch|{
                if algorithm=="b3"{performance::hash_many(Mode::Plain,std::hint::black_box(batch),&mut out);}
                else{for(i,h)in out.iter_mut().enumerate(){*h=sha2::Sha256::digest(std::hint::black_box(&Block::bytes(batch.blocks())[i*slot..][..len])).into();}}
                std::hint::black_box(&out);
            });
            let c=measured.calls.counts;
            println!("{pattern}-{len}\t{n}\t{}\t{algorithm}\t{}\t{}\tNA\t{}\t{}\tNA",len*n,measured.calls.calls,measured.calls.wall_ns,c.map_or(0,|c|c.p.cycles+c.e.cycles),c.map_or(0,|c|c.p.instructions+c.e.instructions));
            for(i,h)in out.iter().enumerate(){let m=&Block::bytes(batch.blocks())[i*slot..][..len];let expected:[u8;32]=if algorithm=="b3"{*blake3::hash(m).as_bytes()}else{sha2::Sha256::digest(m).into()};assert_eq!(*h,expected);}
        }
    }
}
fn main(){
    blake3_servil::initialize();let reverse=std::env::args().nth(1).as_deref()==Some("reverse");
    let arena=vec![0x5au8;128*1024*1024];
    println!("shape\titems\tbytes\talgorithm\tcalls\twall_ns\tcpu_ns\tcycles\tinstructions\tpackage_nj");
    for len in [1,63,65,129,1023]{for n in [2,16,17,64,1024]{run(len,n,reverse,&arena);}}
}
