use blake3_servil::{
    Mode,
    throughput::{self, Hasher},
};
fn mode<'a>(i: usize, flavor: usize, keys: &'a [[u8; 32]]) -> Mode<'a> {
    match flavor {
        0 => Mode::Plain,
        1 => Mode::Keyed(&keys[0]),
        2 => Mode::Keyed(&keys[i]),
        _ => match i % 3 {
            0 => Mode::Plain,
            1 => Mode::Keyed(&keys[i]),
            _ => Mode::DeriveKey("BLAKE3-Servil held stage benchmark"),
        },
    }
}
fn expected(i: usize, flavor: usize, keys: &[[u8; 32]], data: &[u8]) -> [u8; 32] {
    match mode(i, flavor, keys) {
        Mode::Plain => *blake3::hash(data).as_bytes(),
        Mode::Keyed(key) => *blake3::keyed_hash(key, data).as_bytes(),
        _ => blake3::derive_key("BLAKE3-Servil held stage benchmark", data),
    }
}
fn feed<'a>(
    hashers: &mut [Hasher],
    data: &'a [Vec<u8>],
    pieces: &mut Vec<(usize, &'a [u8])>,
    width: usize,
) {
    for start in (0..data[0].len()).step_by(width) {
        pieces.clear();
        for (i, d) in data.iter().enumerate() {
            pieces.push((i, &d[start..(start + width).min(d.len())]));
        }
        throughput::update_each(hashers, std::hint::black_box(pieces.as_slice()));
    }
}
fn run(n: usize, len: usize, width: usize, flavor: usize, reverse: bool) {
    let keys: Vec<[u8; 32]> = (0..n)
        .map(|i| {
            let mut k = core::array::from_fn(|j| (j * 11 + 73) as u8);
            k[..8].copy_from_slice(&(i as u64).to_le_bytes());
            k
        })
        .collect();
    let data: Vec<Vec<u8>> = (0..n)
        .map(|i| (0..len).map(|j| (i * 37 + j * 17) as u8).collect())
        .collect();
    let wanted: Vec<[u8; 32]> = data
        .iter()
        .enumerate()
        .map(|(i, d)| expected(i, flavor, &keys, d))
        .collect();
    let mut hashers: Vec<_> = (0..n)
        .map(|i| Hasher::new(mode(i, flavor, &keys)))
        .collect();
    let mut pieces = Vec::with_capacity(n);
    feed(&mut hashers, &data, &mut pieces, width);
    let which: Vec<_> = (0..n).collect();
    let mut out = vec![[0u8; 32]; n];
    let shape = format!(
        "{}_{}_piece{width}",
        ["plain", "shared_key", "distinct_keys", "mixed_modes"][flavor],
        len
    );
    let stride = if n > 1 {
        &hashers[1] as *const Hasher as usize - &hashers[0] as *const Hasher as usize
    } else {
        std::mem::size_of::<Hasher>()
    };
    eprintln!(
        "layout shape={shape} items={n} hasher_size={} hasher_align={} native_stride={stride} hashers={:#x} output={:#x} digest_stride=32",
        std::mem::size_of::<Hasher>(),
        std::mem::align_of::<Hasher>(),
        hashers.as_ptr() as usize,
        out.as_ptr() as usize
    );
    eprintln!(
        "ownership: one caller owns all states/descriptors/outputs; constructors, key/context preparation, allocation and refs outside repeated timing; update/cycle include resets, descriptor refill and all grouped updates; cycle includes canonical finalization. No pool workers used by these caller-thread API calls."
    );
    let mut algorithms = ["update", "finalize", "cycle"];
    if reverse {
        algorithms.reverse();
    }
    for algorithm in algorithms {
        let mut work = || {
            if algorithm != "finalize" {
                for h in &mut hashers {
                    h.reset();
                }
                feed(&mut hashers, &data, &mut pieces, width);
            }
            if algorithm != "update" {
                throughput::finalize_each(
                    std::hint::black_box(&hashers),
                    std::hint::black_box(&which),
                    &mut out,
                );
                std::hint::black_box(&out);
            } else {
                std::hint::black_box(&hashers);
            }
        };
        let trial = clocks::measure(1, 10_000_000, &mut work);
        let calls = trial[0].calls * 10;
        let energy = clocks::energy::package_nj();
        let cpu = clocks::process_cpu_ns();
        let counts = clocks::Counts::read();
        let time = clocks::now();
        for _ in 0..calls {
            work();
        }
        let wall = clocks::since_ns(time);
        let counts = counts.zip(clocks::Counts::read()).map(|(a, b)| b.since(a));
        let cpu = clocks::process_cpu_ns() - cpu;
        let energy = energy.zip(clocks::energy::package_nj()).map(|(a, b)| b - a);
        clocks::load::tick();
        println!(
            "{shape}\t{n}\t{}\t{algorithm}\t{calls}\t{wall}\t{cpu}\t{}\t{}\t{}",
            n * len,
            counts.map_or(0, |x| x.p.cycles + x.e.cycles),
            counts.map_or(0, |x| x.p.instructions + x.e.instructions),
            energy.map_or_else(|| "NA".into(), |x| x.to_string())
        );
        if algorithm == "update" {
            throughput::finalize_each(&hashers, &which, &mut out);
        }
        assert_eq!(out, wanted, "{algorithm} {shape} n{n}");
        assert!(hashers.iter().all(|h| h.count() == len as u64));
    }
}
fn main() {
    blake3_servil::initialize();
    let reverse = std::env::args().nth(1).as_deref() == Some("reverse");
    println!(
        "shape\titems\tbytes\talgorithm\tcalls\twall_ns\tcpu_ns\tcycles\tinstructions\tpackage_nj"
    );
    for n in [2, 16, 128, 512] {
        for len in [16384, 32768] {
            for flavor in 0..4 {
                run(n, len, 4096, flavor, reverse);
            }
        }
    }
}
