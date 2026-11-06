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
