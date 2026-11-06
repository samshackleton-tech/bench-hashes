use blake3_servil::{
    performance::{self, Block},
    Mode,
};
use sha2::Digest;
fn run(shape: &str, lens: &[usize], reverse: bool) {
    let n = lens.len();
    let bytes = lens.iter().sum::<usize>();
    // The same allocation supports two byte-identical views, aligned and
    // shifted by one byte. Distinct values per message detect lane swaps.
    let storage: Vec<Vec<Block>> = lens
        .iter()
        .enumerate()
        .map(|(j, &l)| {
            let mut v = vec![Block::ZERO; (l + 64).div_ceil(64).max(1)];
            Block::bytes_mut(&mut v).fill((j * 37 + 1) as u8);
            v
        })
        .collect();
    let mut reuse: Vec<Vec<Block>> = lens
        .iter()
        .map(|&l| vec![Block::ZERO; l.div_ceil(64).max(1)])
        .collect();
    let mut out = vec![[0u8; 32]; n];
    let natural: Vec<&[u8]> = storage
        .iter()
        .zip(lens)
        .map(|(b, &l)| &Block::bytes(b)[1..1 + l])
        .collect();
    performance::hash_each(Mode::Plain, &natural, &mut out);
    for (m, h) in natural.iter().zip(&out) {
        assert_eq!(*h, *blake3::hash(m).as_bytes());
    }
    let mut algorithms = ["blocks", "bytes_aligned", "bytes_unaligned", "copy_reused", "copy_allocated", "sha256"];
    if reverse { algorithms.reverse(); }
    for algorithm in algorithms {
        let mut work = || {
            match algorithm {
                "blocks" => {
                    let items: Vec<(&[Block], usize)> = storage
                        .iter()
                        .zip(lens)
                        .map(|(b, &l)| (&b[..], l))
                        .collect();
                    performance::hash_each(Mode::Plain, std::hint::black_box(&items), &mut out);
                }
                "bytes_aligned" | "bytes_unaligned" => {
                    let off = usize::from(algorithm == "bytes_unaligned");
                    let items: Vec<&[u8]> = storage
                        .iter()
                        .zip(lens)
                        .map(|(b, &l)| &Block::bytes(b)[off..off + l])
                        .collect();
                    performance::hash_each(Mode::Plain, std::hint::black_box(&items), &mut out);
                }
                "copy_reused" => {
                    for ((src, &l), dst) in storage.iter().zip(lens).zip(&mut reuse) {
                        Block::bytes_mut(dst)[..l].copy_from_slice(&Block::bytes(src)[1..1 + l]);
                    }
                    let items: Vec<(&[Block], usize)> =
                        reuse.iter().zip(lens).map(|(b, &l)| (&b[..], l)).collect();
                    performance::hash_each(Mode::Plain, std::hint::black_box(&items), &mut out);
                }
                "copy_allocated" => {
                    let copied: Vec<Vec<Block>> = storage
                        .iter()
                        .zip(lens)
                        .map(|(src, &l)| {
                            let mut b = vec![Block::ZERO; l.div_ceil(64).max(1)];
                            Block::bytes_mut(&mut b)[..l]
                                .copy_from_slice(&Block::bytes(src)[1..1 + l]);
                            b
                        })
                        .collect();
                    let items: Vec<(&[Block], usize)> =
                        copied.iter().zip(lens).map(|(b, &l)| (&b[..], l)).collect();
                    performance::hash_each(Mode::Plain, std::hint::black_box(&items), &mut out);
                }
                "sha256" => {
                    for ((src, &l), digest) in storage.iter().zip(lens).zip(&mut out) {
                        *digest = sha2::Sha256::digest(std::hint::black_box(
                            &Block::bytes(src)[1..1 + l],
                        ))
                        .into();
                    }
                }
                _ => unreachable!(),
            }
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
            "{shape}\t{n}\t{bytes}\t{algorithm}\t{calls}\t{wall}\t{cpu}\t{}\t{}\t{}",
            c.map_or(0, |c| c.p.cycles + c.e.cycles),
            c.map_or(0, |c| c.p.instructions + c.e.instructions),
            e.map_or_else(|| "NA".into(), |e| e.to_string())
        );
        for (m, tag) in natural.iter().zip(&out) {
            let expected: [u8; 32] = if algorithm == "sha256" {
                sha2::Sha256::digest(m).into()
            } else {
                *blake3::hash(m).as_bytes()
            };
            assert_eq!(*tag, expected, "{algorithm} {shape}");
        }
    }
}
fn main() {
    blake3_servil::initialize();
    let reverse = std::env::args().nth(1).as_deref() == Some("reverse");
    println!(
        "shape\titems\tbytes\talgorithm\tcalls\twall_ns\tcpu_ns\tcycles\tinstructions\tpackage_nj"
    );
    for n in [16, 64, 1024] {
        for l in [64, 256, 1024] {
            run(&l.to_string(), &vec![l; n], reverse);
        }
        let mut x = 0x9e37_79b9u64;
        let lens: Vec<_> = (0..n)
            .map(|_| {
                x ^= x << 13;
                x ^= x >> 7;
                x ^= x << 17;
                100 + (x % 901) as usize
            })
            .collect();
        run("mixed", &lens, reverse);
    }
}
