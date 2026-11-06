use blake3::hazmat::{HasherExt, Mode as RefMode};
use blake3_servil::{
    throughput::{self, Block},
    Mode,
};

type Cv = [u8; 32];
const IV: [u32; 8] = [
    0x6a09e667, 0xbb67ae85, 0x3c6ef372, 0xa54ff53a, 0x510e527f, 0x9b05688c, 0x1f83d9ab, 0x5be0cd19,
];
const PARENT: u8 = 4;
const ROOT: u8 = 8;
unsafe extern "C" {
    fn blake3_servil_avx512_k32(
        inputs: *const *const u8,
        blocks: u64,
        key: *const u32,
        counter: u64,
        packed_flags: u64,
        out: *mut u8,
    );
    fn blake3_servil_avx512_p16(
        inputs: *const *const u8,
        blocks: u64,
        key: *const u32,
        counter: u64,
        packed_flags: u64,
        out: *mut u8,
    );
    fn blake3_servil_hash_many_avx512(
        inputs: *const *const u8,
        count: usize,
        blocks: usize,
        key: *const u32,
        counter: u64,
        increment: bool,
        flags: u8,
        start: u8,
        end: u8,
        out: *mut u8,
    );
    fn blake3_servil_compress_xof_avx512(
        cv: *const u32,
        block: *const u8,
        block_len: u8,
        counter: u64,
        flags: u8,
        out: *mut u8,
    );
}
fn cv_view(blocks: &[Block]) -> &[Cv] {
    Block::bytes(blocks).as_chunks::<32>().0
}
fn cv_view_mut(blocks: &mut [Block]) -> &mut [Cv] {
    Block::bytes_mut(blocks).as_chunks_mut::<32>().0
}
fn cv_storage(count: usize) -> Vec<Block> {
    vec![Block::ZERO; count.div_ceil(2)]
}
fn packed(flags: u8, start: u8, end: u8) -> u64 {
    flags as u64 | (start as u64) << 8 | (end as u64) << 16 | 64u64 << 24
}

// All calls use complete chunks or parent blocks, the detected AVX-512 ISA,
// exactly-sized readable pointer tables, and disjoint live input/output storage.
fn leaves(ptrs: &[*const u8], output: &mut [Block]) {
    assert!(matches!(ptrs.len(), 16 | 32 | 64));
    assert!(Block::bytes(output).len() >= ptrs.len() * 32);
    if ptrs.len() == 16 {
        unsafe {
            blake3_servil_hash_many_avx512(
                ptrs.as_ptr(),
                16,
                16,
                IV.as_ptr(),
                0,
                true,
                0,
                1,
                2,
                Block::bytes_mut(output).as_mut_ptr(),
            )
        };
    } else {
        for (group, inputs) in ptrs.chunks_exact(32).enumerate() {
            unsafe {
                blake3_servil_avx512_k32(
                    inputs.as_ptr(),
                    16,
                    IV.as_ptr(),
                    (group * 32) as u64,
                    packed(0, 1, 2),
                    Block::bytes_mut(output).as_mut_ptr().add(group * 32 * 32),
                )
            };
        }
    }
}
fn parent_ptrs(ptrs: &[*const u8], output: &mut [Block]) {
    let count = ptrs.len();
    assert!(matches!(count, 2 | 4 | 8 | 16 | 32));
    assert!(Block::bytes(output).len() >= count * 32);
    if count >= 16 {
        for (group, inputs) in ptrs.chunks_exact(16).enumerate() {
            unsafe {
                blake3_servil_avx512_p16(
                    inputs.as_ptr(),
                    1,
                    IV.as_ptr(),
                    0,
                    packed(PARENT, 0, 0),
                    Block::bytes_mut(output).as_mut_ptr().add(group * 16 * 32),
                )
            };
        }
    } else {
        unsafe {
            blake3_servil_hash_many_avx512(
                ptrs.as_ptr(),
                count,
                1,
                IV.as_ptr(),
                0,
                false,
                PARENT,
                0,
                0,
                Block::bytes_mut(output).as_mut_ptr(),
            )
        };
    }
}
fn parent_level(input: &[Block], children: usize, output: &mut [Block]) {
    assert!(children <= 64 && children >= 4 && children.is_power_of_two());
    assert!(Block::bytes(input).len() >= children * 32);
    let count = children / 2;
    let ptrs: [*const u8; 32] = core::array::from_fn(|i| {
        // Spare pointers repeat the first readable parent, and are never passed.
        if i < count {
            unsafe { Block::bytes(input).as_ptr().add(i * 64) }
        } else {
            Block::bytes(input).as_ptr()
        }
    });
    parent_ptrs(&ptrs[..count], output);
}
fn root(input: &[Block], output: &mut [u8; 64]) {
    assert!(Block::bytes(input).len() >= 64);
    unsafe {
        blake3_servil_compress_xof_avx512(
            IV.as_ptr(),
            Block::bytes(input).as_ptr(),
            64,
            0,
            PARENT | ROOT,
            output.as_mut_ptr(),
        )
    };
}
fn pipeline(
    ptrs: &[*const u8],
    a: &mut [Block],
    b: &mut [Block],
    output: &mut [u8; 64],
    swap: bool,
) {
    leaves(ptrs, a);
    let (mut current, mut spare) = (a, b);
    let mut n = ptrs.len();
    while n > 2 {
        parent_level(current, n, spare);
        n /= 2;
        if swap {
            core::mem::swap(&mut current, &mut spare);
        } else {
            cv_view_mut(current)[..n].copy_from_slice(&cv_view(spare)[..n]);
        }
    }
    root(current, output);
}
// Provisional benchmark-only contract: 32 complete chunks -> 16 parent CVs.
unsafe extern "C" {
    fn bench_k32_parent16(
        inputs: *const *const u8,
        blocks: u64,
        key: *const u32,
        counter: u64,
        packed_flags: u64,
        out: *mut u8,
    );
}
fn fused_groups(ptrs: &[*const u8], output: &mut [Block]) {
    assert!(matches!(ptrs.len(), 32 | 64));
    assert!(Block::bytes(output).len() >= ptrs.len() / 2 * 32);
    for (group, inputs) in ptrs.chunks_exact(32).enumerate() {
        unsafe {
            bench_k32_parent16(
                inputs.as_ptr(),
                16,
                IV.as_ptr(),
                (group * 32) as u64,
                packed(0, 1, 2),
                Block::bytes_mut(output).as_mut_ptr().add(group * 16 * 32),
            )
        };
    }
}
fn pipeline_fused(ptrs: &[*const u8], a: &mut [Block], b: &mut [Block], output: &mut [u8; 64]) {
    if ptrs.len() == 16 {
        return pipeline(ptrs, a, b, output, false);
    }
    fused_groups(ptrs, a);
    let mut n = ptrs.len() / 2;
    while n > 2 {
        parent_level(a, n, b);
        n /= 2;
        cv_view_mut(a)[..n].copy_from_slice(&cv_view(b)[..n]);
    }
    root(a, output);
}
fn verify_fused_modes(ptrs: &[*const u8], blocks: &[Block]) {
    if ptrs.len() < 32 {
        return;
    }
    const CONTEXT: &str = "BLAKE3-Servil parent-fold benchmark context";
    let key: [u8; 32] = core::array::from_fn(|i| (i * 37 + 11) as u8);
    let cx = blake3::hazmat::hash_derive_key_context(CONTEXT);
    let words = |bytes: &[u8; 32]| {
        core::array::from_fn(|i| u32::from_le_bytes(bytes[4 * i..4 * i + 4].try_into().unwrap()))
    };
    let keys = [IV, words(&key), words(&cx)];
    for mode in 0..3 {
        let flags = [0u8, 16, 64][mode];
        let reference_mode = match mode {
            0 => RefMode::Hash,
            1 => RefMode::KeyedHash(&key),
            _ => RefMode::DeriveKeyMaterial(&cx),
        };
        for counter in [0u64, 32, 1u64 << 32, (1u64 << 54) - 64] {
            let expected_leaves: Vec<Cv> = (0..32)
                .map(|i| {
                    let mut h = match mode {
                        0 => blake3::Hasher::new(),
                        1 => blake3::Hasher::new_keyed(&key),
                        _ => blake3::Hasher::new_derive_key(CONTEXT),
                    };
                    h.set_input_offset((counter + i as u64) * 1024);
                    h.update(&Block::bytes(blocks)[i * 1024..(i + 1) * 1024]);
                    h.finalize_non_root()
                })
                .collect();
            let expected: Vec<Cv> = expected_leaves
                .chunks_exact(2)
                .map(|c| blake3::hazmat::merge_subtrees_non_root(&c[0], &c[1], reference_mode))
                .collect();
            let mut out = cv_storage(32);
            Block::bytes_mut(&mut out).fill(0xa5);
            unsafe {
                bench_k32_parent16(
                    ptrs.as_ptr(),
                    16,
                    keys[mode].as_ptr(),
                    counter,
                    packed(flags, 1, 2),
                    Block::bytes_mut(&mut out).as_mut_ptr(),
                )
            };
            assert_eq!(
                &cv_view(&out)[..16],
                &expected,
                "fused mode={mode} counter={counter}"
            );
            assert!(
                Block::bytes(&out)[512..].iter().all(|&b| b == 0xa5),
                "fused output exceeded 16 CVs"
            );
        }
    }
    eprintln!(
        "fused parent CVs verified: plain/keyed/derived, four counters, 512-byte output canary"
    );
}

struct Level {
    input: Vec<Block>,
    ptrs: Vec<*const u8>,
    expected: Vec<Cv>,
}
#[derive(Clone, Copy)]
enum Stage {
    Leaves,
    FusedGroup,
    PipelineFused,
    Parent(usize),
    Root,
    PipelineCopy,
    PipelineSwap,
    Public,
    CopyOnly,
    Barrier,
}
fn run(chunks: usize, reverse: bool) {
    let mut blocks = vec![Block::ZERO; chunks * 16];
    let mut x = 0x9e3779b97f4a7c15u64;
    for b in Block::bytes_mut(&mut blocks) {
        x ^= x << 13;
        x ^= x >> 7;
        x ^= x << 17;
        *b = x as u8;
    }
    let bytes = Block::bytes(&blocks);
    let expected_root = *blake3::hash(bytes).as_bytes();
    let leaf_ptrs: Vec<*const u8> = bytes.chunks_exact(1024).map(|c| c.as_ptr()).collect();
    verify_fused_modes(&leaf_ptrs, &blocks);
    let mut expected_leaves = Vec::new();
    for (i, chunk) in bytes.chunks_exact(1024).enumerate() {
        let mut h = blake3::Hasher::new();
        h.set_input_offset((i * 1024) as u64);
        h.update(chunk);
        expected_leaves.push(h.finalize_non_root());
    }
    let mut levels = Vec::new();
    let mut cvs = expected_leaves.clone();
    while cvs.len() > 2 {
        let mut input = cv_storage(cvs.len());
        cv_view_mut(&mut input)[..cvs.len()].copy_from_slice(&cvs);
        let ptrs: Vec<*const u8> = Block::bytes(&input)
            .chunks_exact(64)
            .map(|b| b.as_ptr())
            .collect();
        let expected: Vec<Cv> = cvs
            .chunks_exact(2)
            .map(|c| blake3::hazmat::merge_subtrees_non_root(&c[0], &c[1], RefMode::Hash))
            .collect();
        levels.push(Level {
            input,
            ptrs,
            expected: expected.clone(),
        });
        cvs = expected;
    }
    assert_eq!(
        *blake3::hazmat::merge_subtrees_root(&cvs[0], &cvs[1], RefMode::Hash).as_bytes(),
        expected_root
    );
    let mut root_input = cv_storage(2);
    cv_view_mut(&mut root_input)[..2].copy_from_slice(&cvs);
    let mut a = cv_storage(chunks);
    let mut b = cv_storage(chunks / 2);
    let mut output = [0u8; 64];
    leaves(&leaf_ptrs, &mut a);
    assert_eq!(&cv_view(&a)[..chunks], &expected_leaves);
    for level in &levels {
        parent_ptrs(&level.ptrs, &mut b);
        assert_eq!(&cv_view(&b)[..level.expected.len()], &level.expected);
    }
    root(&root_input, &mut output);
    assert_eq!(&output[..32], &expected_root);
    for swap in [false, true] {
        pipeline(&leaf_ptrs, &mut a, &mut b, &mut output, swap);
        assert_eq!(&output[..32], &expected_root);
    }
    // A positive control: corrupt a leaf CV and verify the independent oracle moves.
    leaves(&leaf_ptrs, &mut a);
    cv_view_mut(&mut a)[0][0] ^= 1;
    let mut count = chunks;
    while count > 2 {
        parent_level(&a, count, &mut b);
        count /= 2;
        cv_view_mut(&mut a)[..count].copy_from_slice(&cv_view(&b)[..count]);
    }
    root(&a, &mut output);
    assert_ne!(
        &output[..32],
        &expected_root,
        "corrupted leaf escaped the reference check"
    );
    eprintln!("reference verified chunks={chunks}; corrupted-leaf positive control passed");
    eprintln!("layout chunks={chunks} Block_size={} Block_align={} CV_size={} CV_align={} input={:#x} cv_a={:#x} cv_b={:#x} root={:#x}",std::mem::size_of::<Block>(),std::mem::align_of::<Block>(),std::mem::size_of::<Cv>(),std::mem::align_of::<Cv>(),blocks.as_ptr() as usize,a.as_ptr() as usize,b.as_ptr() as usize,output.as_ptr() as usize);
    eprintln!("ownership: single calling thread; input/leaf/parent snapshots immutable, a/b/root privately written; no worker counters or outputs shared");
    for (i, l) in levels.iter().enumerate() {
        eprintln!("level {i} children={} snapshot={:#x} snapshot_bytes={} output_bytes={} pointer_table={:#x} pointer_stride={}",l.ptrs.len()*2,l.input.as_ptr() as usize,Block::bytes(&l.input).len(),l.expected.len()*32,l.ptrs.as_ptr() as usize,std::mem::size_of::<*const u8>());
    }
    let mut stages = vec![("leaves".to_string(), Stage::Leaves)];
    for (i, l) in levels.iter().enumerate() {
        stages.push((
            format!("parents_{}_to_{}", l.ptrs.len() * 2, l.ptrs.len()),
            Stage::Parent(i),
        ));
    }
    if chunks >= 32 {
        stages.push(("leaf_plus_first_parent".into(), Stage::FusedGroup));
    }
    stages.push(("pipeline_fused".into(), Stage::PipelineFused));
    stages.extend([
        ("root".into(), Stage::Root),
        ("pipeline_copy".into(), Stage::PipelineCopy),
        ("pipeline_swap".into(), Stage::PipelineSwap),
        ("public_hash".into(), Stage::Public),
        ("copy_cvs_only".into(), Stage::CopyOnly),
        ("barrier".into(), Stage::Barrier),
    ]);
    if reverse {
        stages.reverse();
    }
    for (label, stage) in stages {
        let mut work = || {
            match stage {
                Stage::Leaves => leaves(std::hint::black_box(&leaf_ptrs), &mut a),
                Stage::FusedGroup => fused_groups(std::hint::black_box(&leaf_ptrs), &mut a),
                Stage::PipelineFused => pipeline_fused(
                    std::hint::black_box(&leaf_ptrs),
                    &mut a,
                    &mut b,
                    &mut output,
                ),
                Stage::Parent(i) => parent_ptrs(std::hint::black_box(&levels[i].ptrs), &mut b),
                Stage::Root => root(std::hint::black_box(&root_input), &mut output),
                Stage::PipelineCopy => pipeline(
                    std::hint::black_box(&leaf_ptrs),
                    &mut a,
                    &mut b,
                    &mut output,
                    false,
                ),
                Stage::PipelineSwap => pipeline(
                    std::hint::black_box(&leaf_ptrs),
                    &mut a,
                    &mut b,
                    &mut output,
                    true,
                ),
                Stage::Public => output[..32].copy_from_slice(
                    throughput::hash(Mode::Plain, std::hint::black_box(&blocks), chunks * 1024)
                        .as_bytes(),
                ),
                Stage::CopyOnly => cv_view_mut(&mut a)[..chunks]
                    .copy_from_slice(std::hint::black_box(&expected_leaves)),
                Stage::Barrier => {
                    std::hint::black_box(&leaf_ptrs);
                }
            }
            std::hint::black_box((&a, &b, &output));
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
            "{chunks}\t1\t{}\t{label}\t{calls}\t{wall}\t{cpu}\t{}\t{}\t{}",
            chunks * 1024,
            c.map_or(0, |c| c.p.cycles + c.e.cycles),
            c.map_or(0, |c| c.p.instructions + c.e.instructions),
            e.map_or_else(|| "NA".into(), |e| e.to_string())
        );
        match stage {
            Stage::Leaves | Stage::CopyOnly => assert_eq!(&cv_view(&a)[..chunks], &expected_leaves),
            Stage::FusedGroup => assert_eq!(&cv_view(&a)[..chunks / 2], &levels[0].expected),
            Stage::Parent(i) => assert_eq!(
                &cv_view(&b)[..levels[i].expected.len()],
                &levels[i].expected
            ),
            Stage::Root
            | Stage::PipelineCopy
            | Stage::PipelineSwap
            | Stage::PipelineFused
            | Stage::Public => {
                assert_eq!(&output[..32], &expected_root)
            }
            Stage::Barrier => {}
        }
    }
}
fn main() {
    assert!(std::is_x86_feature_detected!("avx512f") && std::is_x86_feature_detected!("avx512vl"));
    assert_eq!(std::mem::size_of::<Cv>(), 32);
    assert_eq!(std::mem::size_of::<Block>(), 64);
    blake3_servil::initialize();
    let reverse = std::env::args().nth(1).as_deref() == Some("reverse");
    println!(
        "shape\titems\tbytes\talgorithm\tcalls\twall_ns\tcpu_ns\tcycles\tinstructions\tpackage_nj"
    );
    for chunks in [16, 32, 64] {
        run(chunks, reverse);
    }
}
