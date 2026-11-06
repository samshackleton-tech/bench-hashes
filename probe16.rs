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
