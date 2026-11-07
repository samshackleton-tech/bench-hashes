use blake3_servil::{Mode, throughput::Hasher};
fn run(n: usize, len: usize, aged: bool, reverse: bool) {
    let data: Vec<Vec<u8>> = (0..n)
        .map(|i| (0..len).map(|j| (i * 37 + j * 17) as u8).collect())
        .collect();
    let wanted: Vec<[u8; 32]> = data.iter().map(|d| *blake3::hash(d).as_bytes()).collect();
    let mut hashers: Vec<_> = (0..n).map(|_| Hasher::new(Mode::Plain)).collect();
    if aged {
        let prime = vec![0xacu8; 65536];
        for h in &mut hashers {
            h.update(&prime);
            h.reset();
        }
    }
    for (h, bytes) in hashers.iter_mut().zip(&data) {
        for part in bytes.chunks(17) {
            h.update(part);
        }
    }
    let mut out = vec![[0u8; 32]; n];
    let shape = format!(
        "{}_{}",
        if aged { "after_tree_reset" } else { "fresh" },
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
        "ownership: one caller owns all states/outputs; direct Hasher finalization, not SIMD finalize_each. Fresh vs after-tree reset isolates initialized stale stack capacity. Construction/priming/reference outside timing; cycles reset/update/finalize inside."
    );
    let mut algorithms = ["finalize", "xof", "cycle"];
    if reverse {
        algorithms.reverse();
    }
    for algorithm in algorithms {
        let mut work = || {
            for (i, (h, bytes)) in hashers.iter_mut().zip(&data).enumerate() {
                if algorithm == "cycle" {
                    h.reset();
                    for part in bytes.chunks(17) {
                        h.update(std::hint::black_box(part));
                    }
                }
                if algorithm == "xof" {
                    h.finalize_xof().fill(&mut out[i]);
                } else {
                    out[i] = *h.finalize().as_bytes();
                }
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
            "{shape}\t{n}\t{}\t{algorithm}\t{calls}\t{wall}\t{cpu}\t{}\t{}\t{}",
            n * len,
            c.map_or(0, |x| x.p.cycles + x.e.cycles),
            c.map_or(0, |x| x.p.instructions + x.e.instructions),
            e.map_or_else(|| "NA".into(), |x| x.to_string())
        );
        assert_eq!(out, wanted, "{algorithm} {shape}");
        assert!(hashers.iter().all(|h| h.count() == len as u64));
    }
}
fn main() {
    blake3_servil::initialize();
    let reverse = std::env::args().nth(1).as_deref() == Some("reverse");
    println!(
        "shape\titems\tbytes\talgorithm\tcalls\twall_ns\tcpu_ns\tcycles\tinstructions\tpackage_nj"
    );
    for n in [1, 64] {
        for aged in [false, true] {
            for len in [0, 64, 1024, 2048, 16384] {
                run(n, len, aged, reverse);
            }
        }
    }
}
