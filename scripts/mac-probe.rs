use blake3_servil::{
    performance::{self, Block},
    Mode,
};
use hmac::{Hmac, HmacReset, KeyInit, Mac};
use sha2::Sha256;

fn check_hmac_vector() {
    let mut mac = Hmac::<Sha256>::new_from_slice(b"my secret and secure key").unwrap();
    mac.update(b"input message");
    let got = mac.finalize().into_bytes();
    let expected = "97d2a569059bbcd8ead4444ff99071f4c01d005bcefe0d3567e1be628e5fdcd9";
    for j in 0..32 {
        assert_eq!(
            got[j],
            u8::from_str_radix(&expected[2 * j..2 * j + 2], 16).unwrap()
        );
    }
}
fn run(shape: &str, lens: &[usize], reverse: bool) {
    let count = lens.len();
    let key: [u8; 32] = core::array::from_fn(|j| (j * 13 + 7) as u8);
    let blocks: Vec<Vec<Block>> = lens
        .iter()
        .enumerate()
        .map(|(i, &len)| {
            let mut b = vec![Block::ZERO; len.div_ceil(64).max(1)];
            for (j, x) in Block::bytes_mut(&mut b)[..len].iter_mut().enumerate() {
                *x = (i * 31 + j) as u8;
            }
            b
        })
        .collect();
    let items: Vec<(&[Block], usize)> =
        blocks.iter().zip(lens).map(|(b, &l)| (&b[..], l)).collect();
    let mut out = vec![[0u8; 32]; count];
    performance::hash_each(Mode::Keyed(&key), &items, &mut out);
    for ((b, l), digest) in items.iter().zip(&out) {
        assert_eq!(
            *digest,
            *blake3::keyed_hash(&key, &Block::bytes(b)[..*l]).as_bytes()
        );
    }
    // Both HMAC forms precompute the key pads once, outside the interval.
    let template = Hmac::<Sha256>::new_from_slice(&key).unwrap();
    let mut reset = HmacReset::<Sha256>::new_from_slice(&key).unwrap();
    for (b, l) in &items {
        let m = &Block::bytes(b)[..*l];
        let mut clone = template.clone();
        clone.update(m);
        reset.update(m);
        assert_eq!(
            clone.finalize().into_bytes(),
            reset.finalize_reset().into_bytes()
        );
    }
    let bytes = lens.iter().sum::<usize>();
    let algorithms = if reverse {
        ["hmac_sha256_clone", "hmac_sha256_reset", "b3keyed"]
    } else {
        ["b3keyed", "hmac_sha256_reset", "hmac_sha256_clone"]
    };
    for algo in algorithms {
        let mut work = || {
            if algo == "b3keyed" {
                performance::hash_each(Mode::Keyed(&key), std::hint::black_box(&items), &mut out);
            } else if algo == "hmac_sha256_reset" {
                for ((b, l), digest) in items.iter().zip(&mut out) {
                    reset.update(std::hint::black_box(&Block::bytes(b)[..*l]));
                    *digest = reset.finalize_reset().into_bytes().into();
                }
            } else {
                for ((b, l), digest) in items.iter().zip(&mut out) {
                    let mut mac = template.clone();
                    mac.update(std::hint::black_box(&Block::bytes(b)[..*l]));
                    *digest = mac.finalize().into_bytes().into();
                }
            }
            std::hint::black_box(&out);
        };
        let trial = clocks::measure(1, 10_000_000, &mut work);
        let calls = trial[0].calls * 10;
        let energy = clocks::energy::package_nj();
        let cpu = clocks::process_cpu_ns();
        let c = clocks::Counts::read();
        let t = clocks::now();
        for _ in 0..calls {
            work();
        }
        let wall = clocks::since_ns(t);
        let c = c.zip(clocks::Counts::read()).map(|(a, b)| b.since(a));
        let cpu = clocks::process_cpu_ns() - cpu;
        let energy = energy.zip(clocks::energy::package_nj()).map(|(a, b)| b - a);
        clocks::load::tick();
        println!(
            "{shape}\t{count}\t{bytes}\t{algo}\t{calls}\t{wall}\t{cpu}\t{}\t{}\t{}",
            c.map_or(0, |c| c.p.cycles + c.e.cycles),
            c.map_or(0, |c| c.p.instructions + c.e.instructions),
            energy.map_or_else(|| "NA".into(), |e| e.to_string())
        );
    }
}
fn main() {
    check_hmac_vector();
    blake3_servil::initialize();
    let reverse = std::env::args().nth(1).as_deref() == Some("reverse");
    println!(
        "shape\titems\tbytes\talgorithm\tcalls\twall_ns\tcpu_ns\tcycles\tinstructions\tpackage_nj"
    );
    for n in [16, 64, 1024] {
        for len in [16, 64, 256, 1024] {
            run(&len.to_string(), &vec![len; n], reverse);
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
