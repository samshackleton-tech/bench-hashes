use blake3_servil::{Mode, throughput::Hasher};
fn reference(mode: Mode<'_>, data: &[u8]) -> [u8; 64] {
    let mut h = match mode {
        Mode::Plain => blake3::Hasher::new(),
        Mode::Keyed(k) => blake3::Hasher::new_keyed(k),
        _ => blake3::Hasher::new_derive_key("BLAKE3-Servil XOF constructor controls"),
    };
    h.update(data);
    let mut out = [0u8; 64];
    h.finalize_xof().fill(&mut out);
    out
}
fn run(n: usize, len: usize, flavor: usize, reverse: bool) {
    let key = [0x42u8; 32];
    let mode = match flavor {
        0 => Mode::Plain,
        1 => Mode::Keyed(&key),
        _ => Mode::DeriveKey("BLAKE3-Servil XOF constructor controls"),
    };
    let data: Vec<Vec<u8>> = (0..n)
        .map(|i| (0..len).map(|j| ((i * 37 + j * 17) % 251) as u8).collect())
        .collect();
    let expected: Vec<_> = data.iter().map(|d| reference(mode, d)).collect();
    let hashers: Vec<_> = data
        .iter()
        .map(|d| {
            let mut h = Hasher::new(mode);
            h.update(d);
            h
        })
        .collect();
    let empty: Vec<_> = hashers.iter().map(|h| h.finalize_xof()).collect();
    let partial: Vec<_> = empty
        .iter()
        .map(|r| {
            let mut r = r.clone();
            r.fill(&mut [0u8; 1]);
            r
        })
        .collect();
    let mut readers = empty.clone();
    let mut out = vec![[0u8; 32]; n];
    let shape = format!("{}_input{len}", ["plain", "keyed", "derived"][flavor]);
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
        "ownership: one caller, all states/outputs exclusive. Hasher input setup and template-reader creation outside; constructor transport into reused slots, public Clone, seeking and first32 operations inside. convenience_first32/construct include one-shot input hashing; other construct operations finalize already-prepared Hasher state. Not a cold-start or long-output bandwidth claim."
    );
    let mut operations = [
        "construct",
        "construct_first32",
        "convenience_first32",
        "convenience_construct",
        "clone_empty",
        "clone_partial",
        "clone_partial_read32",
        "seek_read32",
    ];
    if reverse {
        operations.reverse();
    }
    for operation in operations {
        let mut work = || {
            for i in 0..n {
                match operation {
                    "construct" | "construct_first32" => {
                        readers[i] = std::hint::black_box(&hashers[i]).finalize_xof();
                        if operation == "construct_first32" {
                            readers[i].fill(&mut out[i]);
                        }
                    }
                    "convenience_construct" | "convenience_first32" => {
                        readers[i] = blake3_servil::convenience::hash_xof(
                            mode,
                            std::hint::black_box(&data[i]),
                        );
                        if operation == "convenience_first32" {
                            readers[i].fill(&mut out[i]);
                        }
                    }
                    "clone_empty" => readers[i] = std::hint::black_box(&empty[i]).clone(),
                    "clone_partial" | "clone_partial_read32" => {
                        readers[i] = std::hint::black_box(&partial[i]).clone();
                        if operation == "clone_partial_read32" {
                            readers[i].fill(&mut out[i]);
                        }
                    }
                    "seek_read32" => {
                        readers[i].set_position(17);
                        readers[i].fill(&mut out[i]);
                    }
                    _ => unreachable!(),
                }
                std::hint::black_box(&readers[i]);
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
            n * len,
            counts.map_or(0, |x| x.p.cycles + x.e.cycles),
            counts.map_or(0, |x| x.p.instructions + x.e.instructions),
            energy.map_or_else(|| "NA".into(), |x| x.to_string())
        );
        let offset = if operation == "clone_partial_read32" {
            1
        } else if operation == "seek_read32" {
            17
        } else {
            0
        };
        for i in 0..n {
            if operation.ends_with("32") {
                assert_eq!(
                    out[i].as_slice(),
                    &expected[i][offset..offset + 32],
                    "{shape} {operation}"
                );
            } else {
                let mut check = readers[i].clone();
                check.set_position(0);
                let mut bytes = [0u8; 32];
                check.fill(&mut bytes);
                assert_eq!(bytes.as_slice(), &expected[i][..32]);
            }
        }
    }
}
fn main() {
    blake3_servil::initialize();
    let reverse = std::env::args().nth(1).as_deref() == Some("reverse");
    println!(
        "shape\titems\tbytes\talgorithm\tcalls\twall_ns\tcpu_ns\tcycles\tinstructions\tpackage_nj"
    );
    for n in [1, 64] {
        for len in [0, 64, 2048, 16384] {
            for flavor in 0..3 {
                run(n, len, flavor, reverse);
            }
        }
    }
}
