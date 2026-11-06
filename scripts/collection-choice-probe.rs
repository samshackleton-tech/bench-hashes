use blake3_servil::{Mode, throughput::{self, Block}};
use sha2::Digest;

fn run(shape: &str, lens: &[usize], reverse: bool) {
    let n = lens.len();
    let blocks: Vec<Vec<Block>> = lens.iter().enumerate().map(|(i, &len)| {
        let mut blocks = vec![Block::ZERO; len.div_ceil(64).max(1)];
        for (j, byte) in Block::bytes_mut(&mut blocks)[..len].iter_mut().enumerate() {
            *byte = (i * 31 + j * 17) as u8;
        }
        blocks
    }).collect();
    let items: Vec<(&[Block], usize)> = blocks.iter().zip(lens).map(|(b, &len)| (&b[..], len)).collect();
    let mut out = vec![[0u8; 32]; n];
    let mut algorithms = ["each", "serial_loop", "sha256"];
    if reverse { algorithms.reverse(); }
    for algorithm in algorithms {
        let mut work = || {
            match algorithm {
                "each" => throughput::hash_each(Mode::Plain, std::hint::black_box(&items), &mut out),
                "serial_loop" => {
                    for ((blocks, len), digest) in items.iter().zip(&mut out) {
                        *digest = *throughput::hash(Mode::Plain, std::hint::black_box(blocks), *len).as_bytes();
                    }
                }
                "sha256" => {
                    for ((blocks, len), digest) in items.iter().zip(&mut out) {
                        *digest = sha2::Sha256::digest(std::hint::black_box(&Block::bytes(blocks)[..*len])).into();
                    }
                }
                _ => unreachable!(),
            }
            std::hint::black_box(&out);
        };
        let calibration = clocks::measure(1, 10_000_000, &mut work);
        let calls = calibration[0].calls * 10;
        let energy = clocks::energy::package_nj();
        let cpu = clocks::process_cpu_ns();
        let counters = clocks::Counts::read();
        let start = clocks::now();
        for _ in 0..calls { work(); }
        let wall = clocks::since_ns(start);
        let counters = counters.zip(clocks::Counts::read()).map(|(a, b)| b.since(a));
        let cpu = clocks::process_cpu_ns() - cpu;
        let energy = energy.zip(clocks::energy::package_nj()).map(|(a, b)| b - a);
        clocks::load::tick();
        println!("{shape}\t{n}\t{}\t{algorithm}\t{calls}\t{wall}\t{cpu}\t{}\t{}\t{}", lens.iter().sum::<usize>(),
            counters.map_or(0, |c| c.p.cycles + c.e.cycles),
            counters.map_or(0, |c| c.p.instructions + c.e.instructions),
            energy.map_or_else(|| "NA".into(), |e| e.to_string()));
        for ((blocks, len), digest) in items.iter().zip(&out) {
            let bytes = &Block::bytes(blocks)[..*len];
            let expected: [u8; 32] = if algorithm == "sha256" { sha2::Sha256::digest(bytes).into() } else { *blake3::hash(bytes).as_bytes() };
            assert_eq!(*digest, expected, "{algorithm} {shape} {n}");
        }
    }
}

fn main() {
    // Both choices use the current throughput API. No library source change.
    blake3_servil::initialize();
    let reverse = std::env::args().nth(1).as_deref() == Some("reverse");
    println!("shape\titems\tbytes\talgorithm\tcalls\twall_ns\tcpu_ns\tcycles\tinstructions\tpackage_nj");
    for n in [1, 2, 4, 7, 8, 16, 64, 1024] {
        for len in [0, 1, 64, 256, 1024] { run(&len.to_string(), &vec![len; n], reverse); }
        let mut x = 0x9e37_79b9u64;
        let lengths: Vec<_> = (0..n).map(|_| { x ^= x << 13; x ^= x >> 7; x ^= x << 17; 100 + (x % 901) as usize }).collect();
        run("mixed", &lengths, reverse);
    }
}
