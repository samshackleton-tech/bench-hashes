use blake3_servil::Mode;
fn expected(mode: Mode<'_>, data: &[u8], len: usize) -> Vec<u8> {
    let mut h = match mode {
        Mode::Plain => blake3::Hasher::new(),
        Mode::Keyed(k) => blake3::Hasher::new_keyed(k),
        _ => blake3::Hasher::new_derive_key("BLAKE3-Servil XOF occasional controls"),
    };
    h.update(data);
    let mut out = vec![0u8; len];
    h.finalize_xof().fill(&mut out);
    out
}
fn run(input_len: usize, flavor: usize, reverse: bool, arena: &[u8]) {
    let key = [0x42u8; 32];
    let mode = match flavor {
        0 => Mode::Plain,
        1 => Mode::Keyed(&key),
        _ => Mode::DeriveKey("BLAKE3-Servil XOF occasional controls"),
    };
    let data: Vec<_> = (0..input_len).map(|j| ((j * 17) % 251) as u8).collect();
    let mut operations = [
        ("first32", 32, 32),
        ("full64", 64, 64),
        ("byte4096", 4096, 1),
    ];
    if reverse {
        operations.reverse();
    }
    for (pattern, gap) in [
        ("idle", clocks::Gap::Idle),
        ("busy", clocks::Gap::Busy(arena)),
    ] {
        for (operation, total, chunk) in operations {
            let wanted = expected(mode, &data, total);
            let mut out = vec![0u8; total];
            let mut prepared = ();
            let measured = clocks::measure_after_gaps_prepared(
                24,
                gap,
                1_000_000,
                &mut prepared,
                |_| {},
                |_| {
                    let mut r =
                        blake3_servil::convenience::hash_xof(mode, std::hint::black_box(&data));
                    for part in out.chunks_mut(chunk) {
                        r.fill(std::hint::black_box(part));
                    }
                    std::hint::black_box(&out);
                },
            );
            let c = measured.calls.counts;
            println!(
                "{}_input{input_len}_{pattern}\t1\t{input_len}\t{operation}\t{}\t{}\tNA\t{}\t{}\tNA",
                ["plain", "keyed", "derived"][flavor],
                measured.calls.calls,
                measured.calls.wall_ns,
                c.map_or(0, |c| c.p.cycles + c.e.cycles),
                c.map_or(0, |c| c.p.instructions + c.e.instructions)
            );
            assert_eq!(out, wanted);
        }
    }
}
fn main() {
    blake3_servil::initialize();
    let reverse = std::env::args().nth(1).as_deref() == Some("reverse");
    let arena = vec![0x5au8; 128 * 1024 * 1024];
    eprintln!(
        "public convenience::hash_xof, input hashing and entire extraction inside call timing, outputs allocated outside; clocks24calls after1ms idle/busy work, no CPU/energy attribution in gap intervals; caller owns all state; reader_size={} align={}",
        std::mem::size_of::<blake3_servil::OutputReader>(),
        std::mem::align_of::<blake3_servil::OutputReader>()
    );
    println!(
        "shape\titems\tbytes\talgorithm\tcalls\twall_ns\tcpu_ns\tcycles\tinstructions\tpackage_nj"
    );
    for input_len in [0, 64, 1024, 16384] {
        for flavor in 0..3 {
            run(input_len, flavor, reverse, &arena);
        }
    }
}
