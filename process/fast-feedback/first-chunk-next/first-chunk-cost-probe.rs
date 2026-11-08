use blake3_servil::{convenience::Hasher, throughput, Mode};
fn mode<'a>(i: usize, mixed: bool, keys: &'a [[u8; 32]]) -> Mode<'a> {
    if !mixed { Mode::Plain } else { match i % 3 { 0 => Mode::Plain, 1 => Mode::Keyed(&keys[i]), _ => Mode::DeriveKey("BLAKE3-Servil first-chunk cost probe") } }
}
fn expected(i: usize, mixed: bool, keys: &[[u8; 32]], bytes: &[u8]) -> [u8; 32] {
    match mode(i, mixed, keys) { Mode::Plain => *blake3::hash(bytes).as_bytes(), Mode::Keyed(key) => *blake3::keyed_hash(key, bytes).as_bytes(), _ => blake3::derive_key("BLAKE3-Servil first-chunk cost probe", bytes) }
}
fn feed<'a>(hs: &mut [Hasher], data: &'a [Vec<u8>], which: &[usize], pieces: &mut Vec<(usize, &'a [u8])>, width: usize) {
    for from in (0..data.iter().map(Vec::len).max().unwrap_or(0)).step_by(width) {
        pieces.clear();
        for (i, bytes) in data.iter().enumerate() { if from < bytes.len() { pieces.push((which[i], &bytes[from..(from + width).min(bytes.len())])); } }
        throughput::update_each(hs, std::hint::black_box(pieces.as_slice()));
    }
}
fn run(open: usize, active: usize, len: usize, width: usize, mixed: bool, reverse: bool) {
    let keys: Vec<[u8;32]> = (0..open).map(|i|core::array::from_fn(|j|(i*37+j*11)as u8)).collect();
    let which: Vec<_> = (0..active).map(|i|(i*61)%open).collect();
    assert_eq!(which.iter().copied().collect::<std::collections::BTreeSet<_>>().len(), active);
    let mut hs: Vec<_> = (0..open).map(|i|Hasher::new(mode(i,mixed,&keys),None)).collect();
    let data: Vec<Vec<u8>> = (0..active).map(|i|(0..len).map(|j|(i*31+j*17)as u8).collect()).collect();
    let wanted: Vec<_> = data.iter().enumerate().map(|(i,d)|expected(which[i],mixed,&keys,d)).collect();
    let mut out = vec![[0u8;32];active];
    let mut pieces = Vec::with_capacity(active);
    let shape = format!("{}_open{open}_len{len}_piece{width}",if mixed {"mixed_mode"}else{"plain"});
    eprintln!("ownership: single caller, open={open} active={active}, hasher_size={} align={} native_stride={} output_stride=32; active indices dispersed by61; no concurrent sharing",std::mem::size_of::<Hasher>(),std::mem::align_of::<Hasher>(),if open>1 {&hs[1]as *const Hasher as usize-&hs[0]as *const Hasher as usize}else{std::mem::size_of::<Hasher>()});
    eprintln!("cycle includes descriptor refill, updates, digest and reset; finish prepares the same cohort outside each timed call, then finishes/resets ONCE. Finish counters include clock bookkeeping; no short-window finish energy is claimed.");
    let preflight = std::env::var_os("PINNED_RUN_PREFLIGHT").is_some_and(|v|v=="1");
    let mut algorithms = ["cycle","finish"];
    if reverse {algorithms.reverse();}
    for algorithm in algorithms {
        let (calls,wall,cpu,cycles,instructions,energy);
        if algorithm=="cycle" {
            let mut work=|| {
                feed(&mut hs,&data,&which,&mut pieces,width);
                throughput::finalize_each(std::hint::black_box(&mut hs),std::hint::black_box(&which),&mut out);
                std::hint::black_box(&out);
            };
            if preflight {work();assert_eq!(out,wanted,"cycle canonical digest");assert!(hs.iter().all(|h|h.count()==0));continue;}
            let trial=clocks::measure(1,10_000_000,&mut work);calls=trial[0].calls*10;
            let e=clocks::energy::package_nj();let p=clocks::process_cpu_ns();let c=clocks::Counts::read();let t=clocks::now();
            for _ in 0..calls {work();}
            wall=clocks::since_ns(t);let c=c.zip(clocks::Counts::read()).map(|(a,b)|b.since(a));cpu=clocks::process_cpu_ns()-p;
            cycles=c.map_or(0,|c|c.p.cycles+c.e.cycles);instructions=c.map_or(0,|c|c.p.instructions+c.e.instructions);
            energy=e.zip(clocks::energy::package_nj()).map_or_else(||"NA".into(),|(a,b)|(b-a).to_string());
        } else {
            calls=if preflight {1}else{64};let(mut w,mut p,mut cy,mut ins)=(0,0,0,0);
            for _ in 0..calls {
                feed(&mut hs,&data,&which,&mut pieces,width);
                let p0=clocks::process_cpu_ns();let c=clocks::Counts::read();let t=clocks::now();
                throughput::finalize_each(std::hint::black_box(&mut hs),std::hint::black_box(&which),&mut out);
                w+=clocks::since_ns(t);let c=c.zip(clocks::Counts::read()).map(|(a,b)|b.since(a));p+=clocks::process_cpu_ns()-p0;
                cy+=c.map_or(0,|c|c.p.cycles+c.e.cycles);ins+=c.map_or(0,|c|c.p.instructions+c.e.instructions);
                assert_eq!(out,wanted,"finish canonical digest");
            }
            wall=w;cpu=p;cycles=cy;instructions=ins;energy="NA".into();
        }
        clocks::load::tick();
        if !preflight {println!("{shape}\t{active}\t{}\t{algorithm}\t{calls}\t{wall}\t{cpu}\t{cycles}\t{instructions}\t{energy}",data.iter().map(Vec::len).sum::<usize>());}
        assert_eq!(out,wanted,"{algorithm} canonical digest");assert!(hs.iter().all(|h|h.count()==0),"finish resets selected states and leaves idle states untouched");
    }
}
fn main() {
    blake3_servil::initialize();let reverse=std::env::args().nth(1).as_deref()==Some("reverse");
    println!("shape\titems\tbytes\talgorithm\tcalls\twall_ns\tcpu_ns\tcycles\tinstructions\tpackage_nj");
    for active in [1,2,7,8,15,16,17,64,1024] {for (len,width)in[(64,17),(1024,256)] {for mixed in [false,true] {run(1024,active,len,width,mixed,reverse);}}}
}
