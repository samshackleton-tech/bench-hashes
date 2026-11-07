use blake3_servil::{
    Mode,
    throughput::{self, Hasher},
};

fn mode<'a>(i: usize, mixed: bool, keys: &'a [[u8; 32]]) -> Mode<'a> {
    if !mixed {
        return Mode::Plain;
    }
    match i % 3 {
        0 => Mode::Plain,
        1 => Mode::Keyed(&keys[i]),
        _ => Mode::DeriveKey("BLAKE3-Servil bulk prefix benchmark"),
    }
}
fn expected(i: usize, mixed: bool, keys: &[[u8; 32]], data: &[u8]) -> [u8; 32] {
    match mode(i, mixed, keys) {
        Mode::Plain => *blake3::hash(data).as_bytes(),
        Mode::Keyed(key) => *blake3::keyed_hash(key, data).as_bytes(),
        _ => blake3::derive_key("BLAKE3-Servil bulk prefix benchmark", data),
    }
}
fn feed<'a>(
    hashers: &mut [Hasher],
    data: &'a [Vec<u8>],
    pieces: &mut Vec<(usize, &'a [u8])>,
    width: usize,
) {
    for from in (0..data.iter().map(Vec::len).max().unwrap_or(0)).step_by(width) {
        pieces.clear();
        for (i, bytes) in data.iter().enumerate() {
            if from < bytes.len() {
                pieces.push((i, &bytes[from..(from + width).min(bytes.len())]));
            }
        }
        throughput::update_each(hashers, std::hint::black_box(pieces.as_slice()));
    }
}
fn run(shape: &str, lens: &[usize], mixed: bool, reverse: bool, width: usize) {
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
    let mut pieces = Vec::with_capacity(n);
    feed(&mut hashers, &data, &mut pieces, width);
    let which: Vec<_> = (0..n).collect();
    let wanted: Vec<_> = data
        .iter()
        .enumerate()
        .map(|(i, d)| expected(i, mixed, &keys, d))
        .collect();
    let mut out = vec![[0u8; 32]; n];
    let shape = format!(
        "{}_{}_piece{width}",
        if mixed { "mixed_mode" } else { "plain" },
        shape
    );
    let stride = if n > 1 {
        &hashers[1] as *const Hasher as usize - &hashers[0] as *const Hasher as usize
    } else {
        std::mem::size_of::<Hasher>()
    };
    eprintln!(
        "layout shape={shape} count={n} hasher_size={} hasher_align={} native_stride={stride} hasher_base={:#x} output_base={:#x} digest_stride=32",
        std::mem::size_of::<Hasher>(),
        std::mem::align_of::<Hasher>(),
        hashers.as_ptr() as usize,
        out.as_ptr() as usize
    );
    eprintln!(
        "ownership: single caller owns states, caller descriptors and outputs; reset+bulk update includes descriptor refill, updates and library allocations; cycle also includes finalization. Key/context creation and data allocation are outside. Finalize-only exposes deferred work separately."
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
            }
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
        if algorithm == "update" {
            throughput::finalize_each(&hashers, &which, &mut out);
        }
        assert_eq!(out, wanted, "{algorithm} {shape} {n}");
        assert!(
            hashers
                .iter()
                .zip(lens)
                .all(|(h, &l)| h.count() == l as u64)
        );
    }
}
fn main() {
    blake3_servil::initialize();
    let reverse = std::env::args().nth(1).as_deref() == Some("reverse");
    println!(
        "shape\titems\tbytes\talgorithm\tcalls\twall_ns\tcpu_ns\tcycles\tinstructions\tpackage_nj"
    );
    for n in [2, 16, 17, 64, 1024] {
        for l in [0, 1, 31, 63, 64, 65, 128, 255, 512, 1023, 1024, 2048] {
            run(&l.to_string(), &vec![l; n], false, reverse, 17);
        }
        let mut x = 0x9e3779b9u64;
        let lens: Vec<_> = (0..n)
            .map(|_| {
                x ^= x << 13;
                x ^= x >> 7;
                x ^= x << 17;
                1 + (x % 1024) as usize
            })
            .collect();
        run("varied_lengths", &lens, false, reverse, 17);
        for l in [1, 64, 1024] {
            run(&l.to_string(), &vec![l; n], true, reverse, 17);
        }
        run("varied_lengths", &lens, true, reverse, 17);
    }
}
