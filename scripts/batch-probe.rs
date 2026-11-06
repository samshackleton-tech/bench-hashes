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
