use blake3_servil::{Mode, performance::{self, Batch, Block}};

fn main() {
    let len: usize = std::env::args().nth(1).expect("length").parse().unwrap();
    // The pinned script supplies whole-block lengths 512/1024 and count 8.
    // Keep both runtime-valued, as in the all-shape caller being diagnosed.
    let n: usize = std::env::args().nth(2).expect("count").parse().unwrap();
    let slot = len.div_ceil(64).max(1) * 64;
    let samples = 32u64;
    let calls_per_sample = 100_000u64;
    let warmup = 5_000u64;
    blake3_servil::initialize();
    let mut batch = Batch::new(len, n);
    for i in 0..n {
        for (j, b) in batch.message_mut(i).iter_mut().enumerate() { *b = (i * 31 + j * 17) as u8; }
    }
    let mut out = vec![[0u8; 32]; n];
    assert_eq!(std::mem::size_of::<[u8; 32]>(), 32);
    assert_eq!(std::mem::size_of::<Block>(), 64);
    eprintln!("layout input={:#x} output={:#x} input_mod4096={} output_mod4096={} input_slot={} output_stride={} output_type_alignment={} Block_alignment={}",
        batch.blocks().as_ptr() as usize, out.as_ptr() as usize,
        batch.blocks().as_ptr() as usize % 4096, out.as_ptr() as usize % 4096,
        slot, std::mem::size_of::<[u8; 32]>(), std::mem::align_of::<[u8; 32]>(), std::mem::align_of::<Block>());
    eprintln!("Single-threaded hash_many; arrays and outputs belong to this caller. No worker sharing. measured_calls={} warmup_calls={warmup}", samples * calls_per_sample);
    let mut work = || {
        performance::hash_many(Mode::Plain, std::hint::black_box(&batch), &mut out);
        std::hint::black_box(&out);
    };
    for _ in 0..warmup { work(); }
    let (mut wall, mut cpu) = (0u64, 0u64);
    let (mut cycles, mut instructions, mut energy) = (Some(0u64), Some(0u64), Some(0u64));
    for sample in 0..samples {
        let e = clocks::energy::package_nj();
        let p = clocks::process_cpu_ns();
        let c = clocks::Counts::read();
        let t = clocks::now();
        for _ in 0..calls_per_sample { work(); }
        let w = clocks::since_ns(t);
        let c = c.zip(clocks::Counts::read()).map(|(a, b)| b.since(a));
        let p = clocks::process_cpu_ns() - p;
        let e = e.zip(clocks::energy::package_nj()).map(|(a, b)| b - a);
        wall += w; cpu += p;
        cycles = cycles.zip(c).map(|(a, b)| a + b.p.cycles + b.e.cycles);
        instructions = instructions.zip(c).map(|(a, b)| a + b.p.instructions + b.e.instructions);
        energy = energy.zip(e).map(|(a, b)| a + b);
        clocks::load::tick();
        eprintln!("sample {sample} calls {calls_per_sample} wall_ns {w} cpu_ns {p}");
    }
    let metric = |x: Option<u64>| x.map_or_else(|| "NA".into(), |x| x.to_string());
    println!("shape\titems\tbytes\talgorithm\tcalls\twall_ns\tcpu_ns\tcycles\tinstructions\tpackage_nj");
    println!("{len}\t{n}\t{}\tb3\t{}\t{wall}\t{cpu}\t{}\t{}\t{}", len * n, samples * calls_per_sample, metric(cycles), metric(instructions), metric(energy));
    for (i, digest) in out.iter().enumerate() {
        assert_eq!(*digest, *blake3::hash(&Block::bytes(batch.blocks())[i * slot..][..len]).as_bytes());
    }
}
