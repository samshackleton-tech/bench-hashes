#[repr(C, align(64))]
struct Buffer([u32; 256]);
type Kernel = unsafe extern "C" fn(*const u32, *mut u32, *mut u32, *const *const u8);
unsafe extern "C" {
    fn parent_bridge_roundtrip(
        input: *const u32,
        output: *mut u32,
        scratch: *mut u32,
        pointers: *const *const u8,
    );
    fn parent_bridge_direct(
        input: *const u32,
        output: *mut u32,
        scratch: *mut u32,
        pointers: *const *const u8,
    );
    fn parent_bridge_bad(
        input: *const u32,
        output: *mut u32,
        scratch: *mut u32,
        pointers: *const *const u8,
    );
}
fn reference(input: &[u32; 256]) -> [u32; 256] {
    // Input rows: A's eight CV words across chunks 0..15, then B's 16..31.
    // Output rows: each of the 16 parent-message words across 16 parents.
    core::array::from_fn(|i| {
        let word = i / 16;
        let parent = i % 16;
        let chunk = 2 * parent + usize::from(word >= 8);
        input[((chunk / 16) * 8 + word % 8) * 16 + chunk % 16]
    })
}
fn main() {
    assert!(std::is_x86_feature_detected!("avx512f"));
    let mut input = Box::new(Buffer([0; 256]));
    let mut output = Box::new(Buffer([0; 256]));
    let mut scratch = Box::new(Buffer([0; 256]));
    let ptrs: [*const u8; 16] =
        core::array::from_fn(|i| unsafe { scratch.0.as_ptr().cast::<u8>().add(i * 64) });
    for seed in 1..=16u64 {
        let mut x = seed.wrapping_mul(0x9e3779b97f4a7c15);
        for v in &mut input.0 {
            x ^= x << 13;
            x ^= x >> 7;
            x ^= x << 17;
            *v = x as u32;
        }
        let expected = reference(&input.0);
        for kernel in [
            parent_bridge_roundtrip as Kernel,
            parent_bridge_direct as Kernel,
        ] {
            unsafe {
                kernel(
                    input.0.as_ptr(),
                    output.0.as_mut_ptr(),
                    scratch.0.as_mut_ptr(),
                    ptrs.as_ptr(),
                )
            };
            assert_eq!(
                output.0, expected,
                "native CV/message layout differs from adjacent-child reference"
            );
        }
        unsafe {
            parent_bridge_bad(
                input.0.as_ptr(),
                output.0.as_mut_ptr(),
                scratch.0.as_mut_ptr(),
                ptrs.as_ptr(),
            )
        };
        assert_ne!(
            output.0, expected,
            "odd-child substitution escaped the reference control"
        );
    }
    let expected = reference(&input.0);
    eprintln!("16 arbitrary-word fixtures verified; odd-child positive control passed");
    eprintln!("layout size={} align={} input={:#x} output={:#x} scratch={:#x} word_stride={} pointer_stride={}",std::mem::size_of::<Buffer>(),std::mem::align_of::<Buffer>(),input.0.as_ptr() as usize,output.0.as_ptr() as usize,scratch.0.as_ptr() as usize,std::mem::size_of::<u32>(),std::mem::size_of::<*const u8>());
    eprintln!("ownership: one caller; input/pointer table immutable, output/scratch privately written. Data layout only; compression is measured separately.");
    println!(
        "shape\titems\tbytes\talgorithm\tcalls\twall_ns\tcpu_ns\tcycles\tinstructions\tpackage_nj"
    );
    let mut algorithms = [
        ("roundtrip", Some(parent_bridge_roundtrip as Kernel)),
        ("direct", Some(parent_bridge_direct as Kernel)),
        ("barrier", None),
    ];
    if std::env::args().nth(1).as_deref() == Some("reverse") {
        algorithms.reverse();
    }
    for (label, kernel) in algorithms {
        let mut work = || {
            if let Some(kernel) = kernel {
                unsafe {
                    kernel(
                        std::hint::black_box(input.0.as_ptr()),
                        output.0.as_mut_ptr(),
                        scratch.0.as_mut_ptr(),
                        ptrs.as_ptr(),
                    )
                };
            }
            std::hint::black_box((&input, &output, &scratch));
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
            "32CV\t1\t1024\t{label}\t{calls}\t{wall}\t{cpu}\t{}\t{}\t{}",
            c.map_or(0, |c| c.p.cycles + c.e.cycles),
            c.map_or(0, |c| c.p.instructions + c.e.instructions),
            e.map_or_else(|| "NA".into(), |e| e.to_string())
        );
        if kernel.is_some() {
            assert_eq!(output.0, expected);
        }
    }
}
