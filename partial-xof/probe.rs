use blake3_servil::{Mode, throughput::Hasher};
fn reference(mode: Mode<'_>, data: &[u8], len: usize) -> Vec<u8> {
    let mut h = match mode {
        Mode::Plain => blake3::Hasher::new(),
        Mode::Keyed(k) => blake3::Hasher::new_keyed(k),
        _ => blake3::Hasher::new_derive_key("BLAKE3-Servil partial XOF reads"),
    };
    h.update(data);
    let mut out = vec![0u8; len];
    h.finalize_xof().fill(&mut out);
    out
}
fn run(n: usize, input_len: usize, chunk: usize, flavor: usize, reverse: bool) {
    let key = [0x42u8; 32];
    let mode = match flavor {
        0 => Mode::Plain,
        1 => Mode::Keyed(&key),
        _ => Mode::DeriveKey("BLAKE3-Servil partial XOF reads"),
    };
    let total = 4096;
    let data: Vec<Vec<u8>> = (0..n)
        .map(|i| {
            (0..input_len)
                .map(|j| ((i * 37 + j * 17) % 251) as u8)
                .collect()
        })
        .collect();
    let wanted: Vec<_> = data.iter().map(|d| reference(mode, d, total)).collect();
    let hashers: Vec<_> = data
        .iter()
        .map(|d| {
            let mut h = Hasher::new(mode);
            h.update(d);
            h
        })
        .collect();
    let mut readers: Vec<_> = hashers.iter().map(|h| h.finalize_xof()).collect();
    let mut out = vec![vec![0u8; total]; n];
    let shape = format!(
        "{}_input{input_len}_out{total}_read{chunk}",
        ["plain", "keyed", "derived"][flavor]
    );
    let stride = if n > 1 {
        &readers[1] as *const _ as usize - &readers[0] as *const _ as usize
    } else {
        std::mem::size_of::<blake3_servil::OutputReader>()
    };
    eprintln!(
        "layout shape={shape} items={n} reader_size={} reader_align={} native_stride={stride} readers={:#x} hashers={:#x}",
        std::mem::size_of::<blake3_servil::OutputReader>(),
        std::mem::align_of::<blake3_servil::OutputReader>(),
        readers.as_ptr() as usize,
        hashers.as_ptr() as usize
    );
    eprintln!(
        "ownership: one caller owns all states/outputs, no worker/cache-line sharing. Constructors, input hashing, independent references, allocations outside. ready_read resets an existing reader to offset0 per extraction; construct_read calls Hasher::finalize_xof then performs every read. Neither includes input hashing. Cache/state footprint and full-block controls measured explicitly."
    );
    let mut operations = ["ready_read", "construct_read"];
    if reverse {
        operations.reverse();
    }
    for operation in operations {
        let mut work = || {
            for i in 0..n {
                if operation == "construct_read" {
                    readers[i] = std::hint::black_box(&hashers[i]).finalize_xof();
                } else {
                    readers[i].set_position(0);
                }
                for part in out[i].chunks_mut(chunk) {
                    readers[i].fill(std::hint::black_box(part));
                }
            }
            std::hint::black_box(&out);
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
            "{shape}\t{n}\t{}\t{operation}\t{calls}\t{wall}\t{cpu}\t{}\t{}\t{}",
            n * total,
            counts.map_or(0, |x| x.p.cycles + x.e.cycles),
            counts.map_or(0, |x| x.p.instructions + x.e.instructions),
            energy.map_or_else(|| "NA".into(), |x| x.to_string())
        );
        assert_eq!(out, wanted, "{shape} {operation}");
        assert!(readers.iter().all(|r| r.position() == total as u64));
    }
}
fn main() {
    blake3_servil::initialize();
    let reverse = std::env::args().nth(1).as_deref() == Some("reverse");
    println!(
        "shape\titems\tbytes\talgorithm\tcalls\twall_ns\tcpu_ns\tcycles\tinstructions\tpackage_nj"
    );
    for n in [1, 64] {
        for input_len in [64, 16384] {
            for chunk in [1, 7, 16, 32, 63, 64, 65, 1024] {
                for flavor in 0..3 {
                    run(n, input_len, chunk, flavor, reverse);
                }
            }
        }
    }
}
