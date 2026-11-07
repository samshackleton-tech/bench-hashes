use blake3_servil::{
    throughput::{self, Hasher},
    Mode,
};

fn mode<'a>(i: usize, mixed: bool, keys: &'a [[u8; 32]]) -> Mode<'a> {
    if !mixed {
        return Mode::Plain;
    }
    match i % 3 {
        0 => Mode::Plain,
        1 => Mode::Keyed(&keys[i]),
        _ => Mode::DeriveKey("BLAKE3-Servil incremental bulk benchmark"),
    }
}
fn expected(i: usize, mixed: bool, keys: &[[u8; 32]], data: &[u8]) -> [u8; 32] {
    match mode(i, mixed, keys) {
        Mode::Plain => *blake3::hash(data).as_bytes(),
        Mode::Keyed(key) => *blake3::keyed_hash(key, data).as_bytes(),
        _ => blake3::derive_key("BLAKE3-Servil incremental bulk benchmark", data),
    }
}
fn run(shape: &str, lens: &[usize], mixed: bool, reverse: bool) {
    let n = lens.len();
    let keys: Vec<[u8; 32]> = (0..n)
        .map(|i| core::array::from_fn(|j| (i * 37 + j * 11) as u8))
        .collect();
    let data: Vec<Vec<u8>> = lens
        .iter()
        .enumerate()
        .map(|(i, &l)| (0..l).map(|j| (i * 31 + j * 17) as u8).collect())
        .collect();
    let mut hashers: Vec<Hasher> = (0..n).map(|i| Hasher::new(mode(i, mixed, &keys))).collect();
    for (h, data) in hashers.iter_mut().zip(&data) {
        for part in data.chunks(17) {
            h.update(part);
        }
    }
    let which: Vec<usize> = (0..n).collect();
    let wanted: Vec<[u8; 32]> = data
        .iter()
        .enumerate()
        .map(|(i, d)| expected(i, mixed, &keys, d))
        .collect();
    let mut out = vec![[0u8; 32]; n];
    let prefix = if mixed { "mixed_mode" } else { "plain" };
    let shape = format!("{prefix}_{shape}");
    let stride = if n > 1 {
        &hashers[1] as *const Hasher as usize - &hashers[0] as *const Hasher as usize
    } else {
        std::mem::size_of::<Hasher>()
    };
    eprintln!("layout shape={shape} count={n} hasher_size={} hasher_align={} native_stride={stride} hasher_base={:#x} output_base={:#x} digest_stride={}",std::mem::size_of::<Hasher>(),std::mem::align_of::<Hasher>(),hashers.as_ptr() as usize,out.as_ptr() as usize,std::mem::size_of::<[u8;32]>());
    eprintln!("ownership: one caller owns all states/outputs; finalize borrows states; cycle resets and updates them. Creation/filling are excluded only from the finalize rows.");
    let mut algorithms = ["finalize", "cycle"];
    if reverse {
        algorithms.reverse();
    }
    for algorithm in algorithms {
        let mut work = || {
            if algorithm == "cycle" {
                for (h, data) in hashers.iter_mut().zip(&data) {
                    h.reset();
                    for part in data.chunks(17) {
                        h.update(std::hint::black_box(part));
                    }
                }
            }
            throughput::finalize_each(
                std::hint::black_box(&hashers),
                std::hint::black_box(&which),
                &mut out,
            );
            std::hint::black_box(&out);
        };
        let trial = clocks::measure(1, 10_000_000, &mut work);
        let calls = trial[0].calls * 10;
        let e = clocks::energy::package_nj();
        let cpu = clocks::process_cpu_ns();
        let c = clocks::Counts::read();
        let t = clocks::now();
        for _ in 0..calls {
            work();
        }
        let wall = clocks::since_ns(t);
        let c = c.zip(clocks::Counts::read()).map(|(a, b)| b.since(a));
        let cpu = clocks::process_cpu_ns() - cpu;
        let e = e.zip(clocks::energy::package_nj()).map(|(a, b)| b - a);
        clocks::load::tick();
        println!(
            "{shape}\t{n}\t{}\t{algorithm}\t{calls}\t{wall}\t{cpu}\t{}\t{}\t{}",
            lens.iter().sum::<usize>(),
            c.map_or(0, |c| c.p.cycles + c.e.cycles),
            c.map_or(0, |c| c.p.instructions + c.e.instructions),
            e.map_or_else(|| "NA".into(), |e| e.to_string())
        );
        assert_eq!(out, wanted, "{algorithm} {shape} {n}");
        assert!(hashers
            .iter()
            .zip(lens)
            .all(|(h, &l)| h.count() == l as u64));
    }
}
fn main() {
 blake3_servil::initialize();let reverse=std::env::args().nth(1).as_deref()==Some("reverse");
 println!("shape\titems\tbytes\talgorithm\tcalls\twall_ns\tcpu_ns\tcycles\tinstructions\tpackage_nj");
 for n in [2,7,8,9,16,1024] {
  for len in [0,1,63,64,65,255,1024,2048] {run(&len.to_string(),&vec![len;n],false,reverse);}
  run("1024",&vec![1024;n],true,reverse);
  let lens:Vec<_>=(0..n).map(|i|1+(i*277+73)%1024).collect();run("varied_lengths",&lens,true,reverse);
 }
}
