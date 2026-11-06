#!/bin/bash
set -euo pipefail
R="$1";O="$R/out";mkdir -p "$O";export HOME=/root;. /root/.cargo/env
{ date -u;uname -a;grep -m1 'model name' /proc/cpuinfo;rustc --version;for repo in library bench;do echo "$repo $(git -C "$R/$repo" rev-parse HEAD)";done;echo 'Benchmark-only full-round first-parent fusion; provisional ABI; production library unchanged. Modeled pipelines and current public API measured separately.'; } > "$O/identity.txt"
cat > "$R/gen_fused.py" <<'GEN_EOF'
#!/usr/bin/env python3
"""Benchmark-only full-round candidate: 32 complete chunks -> 16 parent CVs.

The leaf prefix is the pinned production k32 emitter. Keep its key pointer,
replace its final CV stores with the checked adjacent-child register bridge,
then perform the current seven-round parent compression in registers.
Common flags are mode flags (structural low four bits clear). Parent counter
is zero and ROOT stays with the caller. Production source is read-only.
"""
import pathlib
import sys

source = pathlib.Path(sys.argv[1]).read_text()


def exact(old, new, count=1):
    global source
    assert source.count(old) == count, (old, source.count(old))
    source = source.replace(old, new)


exact('blake3_servil_avx512_k32', 'bench_k32_parent16', 3)
exact('blake3_servil_avx512_p32', 'bench_unused_p32_parent16', 3)
exact("emit('xor r14d, r14d')  # Byte offset into every input.",
      "emit('mov r10, r14')  # Preserve the common key for the parent phase.\nemit('xor r14d, r14d')  # Byte offset into every input.")
exact('for k in range(2):\n    output_group(8*k, 512*k)', 'emit_fused_parent()')
exact("parent16()\nprint('.section .rodata", "print('.section .rodata")
namespace = {}


def fused_parent():
    emit = namespace['emit']
    g = namespace['g']
    perm = namespace['PERM']
    print('.Lfused_parent:')
    emit('vmovdqa32 zmm30, ZMMWORD PTR [rip + .Lfused_even]')
    emit('vmovdqa32 zmm31, ZMMWORD PTR [rip + .Lfused_odd]')
    for w in range(8):
        if w == 6:
            emit('vmovdqa32 zmm0, zmm30')
            emit('vmovdqa32 zmm8, zmm31')
        even, odd = (30, 31) if w < 6 else (0, 8)
        a, b, left, right = w, 8+w, 16+w, 24+w
        emit(f'vpermd zmm{left}, zmm{even}, zmm{a}')
        emit(f'vpermd zmm{right}, zmm{even}, zmm{b}')
        emit(f'vshufi32x4 zmm{left}, zmm{left}, zmm{right}, 0x44')
        emit(f'vpermd zmm{right}, zmm{odd}, zmm{a}')
        emit(f'vpermd zmm{b}, zmm{odd}, zmm{b}')
        emit(f'vshufi32x4 zmm{right}, zmm{right}, zmm{b}, 0x44')
    messages = list(range(16, 32))
    for w in range(8):
        emit(f'vpbroadcastd zmm{w}, DWORD PTR [r10 + {4*w}]')
    for w in range(4):
        emit(f'vpbroadcastd zmm{8+w}, DWORD PTR [rip + .Liv32 + {4*w}]')
    for w in [12, 13]:
        emit(f'vpxord zmm{w}, zmm{w}, zmm{w}')
    emit('mov eax, 64')
    emit('vpbroadcastd zmm14, eax')
    emit('movzx eax, bl')
    emit('or eax, 4')
    emit('vpbroadcastd zmm15, eax')

    def round_body(schedule):
        for half, positions in enumerate((namespace['COLS'], namespace['DIAGS'])):
            chains = [g(*[f'zmm{w}' for w in pos],
                        f'zmm{messages[schedule[8*half+2*i]]}',
                        f'zmm{messages[schedule[8*half+2*i+1]]}')
                      for i, pos in enumerate(positions)]
            for instructions in zip(*chains):
                for instruction in instructions:
                    emit(instruction)

    p2 = [perm[perm[i]] for i in range(16)]
    cycles, seen = [], set()
    for start in range(16):
        if start in seen:
            continue
        cycle, word = [], start
        while word not in seen:
            seen.add(word)
            cycle.append(word)
            word = p2[word]
        assert word == start
        cycles.append(cycle)
    assert len(cycles) == 4 and all(len(c) == 4 for c in cycles)
    emit('mov r11d, 3')
    print('.p2align 5\n.Lfused_pairs:')
    round_body(list(range(16)))
    round_body(perm)
    for i, cycle in enumerate(cycles):
        emit(f'vmovdqa32 ZMMWORD PTR [rsp + {64*i}], zmm{messages[cycle[0]]}')
        for a, b in zip(cycle, cycle[1:]):
            emit(f'vmovdqa32 zmm{messages[a]}, zmm{messages[b]}')
        emit(f'vmovdqa32 zmm{messages[cycle[-1]]}, ZMMWORD PTR [rsp + {64*i}]')
    emit('dec r11d')
    emit('jne .Lfused_pairs')
    round_body(list(range(16)))
    for w in range(8):
        emit(f'vpxord zmm{w}, zmm{w}, zmm{8+w}')
    namespace['output_group'](0, 0)


namespace['emit_fused_parent'] = fused_parent
exec(compile(source, 'pinned_k32_with_parent_phase', 'exec'), namespace)
print('.section .rodata\n.p2align 6\n.Lfused_even:\n.long ' + ', '.join(str(i) for i in list(range(0, 16, 2))*2))
print('.p2align 6\n.Lfused_odd:\n.long ' + ', '.join(str(i) for i in list(range(1, 16, 2))*2))

GEN_EOF
python3 "$R/gen_fused.py" "$R/library/tools/gen_avx512_32.py" > "$O/fused.S"
cc -c "$O/fused.S" -o "$R/fused.o" > "$O/asm-build.log" 2>&1
pids=()
for pair in 1 2 3 4;do
 (
 P="$R/probe-$pair";mkdir -p "$P/src"
 printf '[package]
name="parentstages"
version="0.1.0"
edition="2021"
[dependencies]
blake3-servil={path="%s/library"}
blake3="=1.8.7"
clocks={path="%s/bench/clocks"}
' "$R" "$R" > "$P/Cargo.toml"
 cat > "$P/src/main.rs" <<'PROBE_EOF'
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

PROBE_EOF
 (cd "$P" && CARGO_TARGET_DIR="$R/target-$pair" RUSTFLAGS="-C metadata=parentfused_$pair -C link-arg=$R/fused.o" cargo build --release && cargo tree -p blake3-servil --depth 0) > "$O/build-$pair.log" 2>&1
 cp "$R/target-$pair/release/parentstages" "$R/exe-$pair";cp "$P/Cargo.lock" "$O/lock-$pair.txt"
 ) &
 pids+=("$!")
done
failed=0;for pid in "${pids[@]}";do if ! wait "$pid";then failed=1;fi;done
[ "$failed" = 0 ]
mkdir -p "$R/judge/src"
printf '[package]
name="parentstagejudge"
version="0.1.0"
edition="2021"
[dependencies]
clocks={path="%s/bench/clocks"}
' "$R" > "$R/judge/Cargo.toml"
cat > "$R/judge/src/main.rs" <<'JUDGE_EOF'
use clocks::summary::{discoveries, mean};
use std::{collections::BTreeMap, fs, path::Path};
#[derive(Clone)]
struct Row {
    units: u64,
    metrics: BTreeMap<String, u64>,
}
type Key = (String, u64, String);
fn read(path: &Path) -> BTreeMap<Key, Row> {
    let text = fs::read_to_string(path).unwrap();
    let mut lines = text.lines();
    assert_eq!(lines.next(),Some("shape\titems\tbytes\talgorithm\tcalls\twall_ns\tcpu_ns\tcycles\tinstructions\tpackage_nj"));
    let mut rows = BTreeMap::new();
    for line in lines {
        let f: Vec<_> = line.split('\t').collect();
        assert_eq!(f.len(), 10);
        let count: u64 = f[1].parse().unwrap();
        let calls: u64 = f[4].parse().unwrap();
        let mut metrics = BTreeMap::new();
        for (i, name) in [
            (5, "wall_ns"),
            (6, "cpu_ns"),
            (7, "cycles"),
            (8, "instructions"),
            (9, "package_nj"),
        ] {
            if f[i] != "NA" {
                metrics.insert(name.to_string(), f[i].parse().unwrap());
            }
        }
        assert!(rows
            .insert(
                (f[0].into(), count, f[3].into()),
                Row {
                    units: count * calls,
                    metrics
                }
            )
            .is_none());
    }
    rows
}
fn main() {
    let dir = std::env::args().nth(1).expect("directory");
    let dir = Path::new(&dir);
    let main_algorithm = std::env::args().nth(2).unwrap_or_else(|| "b3".into());
    let mut reference_algorithms: Vec<String> = std::env::args().skip(3).collect();
    if reference_algorithms.is_empty() {
        reference_algorithms.push("sha256".into());
    }
    let old_label = format!("old-{main_algorithm}");
    let mut comparators = vec![old_label.as_str()];
    comparators.extend(reference_algorithms.iter().map(String::as_str));
    let old: Vec<_> = (1..=4)
        .map(|p| read(&dir.join(format!("old-{p}.tsv"))))
        .collect();
    let new: Vec<_> = (1..=4)
        .map(|p| read(&dir.join(format!("new-{p}.tsv"))))
        .collect();
    let mut cells = Vec::new();
    let mut names = Vec::new();
    let mut costs = Vec::new();
    for (shape, count, algorithm) in old[0].keys() {
        if algorithm != &main_algorithm {
            continue;
        }
        for metric in ["wall_ns", "cpu_ns", "cycles", "instructions", "package_nj"] {
            for &versus in &comparators {
                let mut pairs = Vec::new();
                let mut old_tot = (0u128, 0u128);
                let mut new_tot = (0u128, 0u128);
                for p in 0..4 {
                    let a = if versus == old_label {
                        &old[p][&(shape.clone(), *count, main_algorithm.clone())]
                    } else {
                        &new[p][&(shape.clone(), *count, versus.to_string())]
                    };
                    let b = &new[p][&(shape.clone(), *count, main_algorithm.clone())];
                    let (Some(&av), Some(&bv)) = (a.metrics.get(metric), b.metrics.get(metric))
                    else {
                        break;
                    };
                    if av == 0 || bv == 0 {
                        break;
                    }
                    pairs.push((mean([(av, a.units)]), mean([(bv, b.units)])));
                    old_tot.0 += av as u128;
                    old_tot.1 += a.units as u128;
                    new_tot.0 += bv as u128;
                    new_tot.1 += b.units as u128;
                }
                if pairs.len() == 4 {
                    names.push((shape.clone(), *count, metric, versus));
                    cells.push(pairs);
                    costs.push((old_tot, new_tot));
                }
            }
        }
    }
    let judged = discoveries(&cells, 50, 30);
    println!("shape\titems\tmetric\tversus\told_per_item\tnew_per_item\tratio_permille\tverdict");
    for (((shape, count, metric, versus), cost), j) in names.into_iter().zip(costs).zip(judged) {
        println!(
            "{shape}\t{count}\t{metric}\t{versus}\t{:.4}\t{:.4}\t{}\t{:?}",
            cost.0 .0 as f64 / cost.0 .1 as f64,
            cost.1 .0 as f64 / cost.1 .1 as f64,
            j.ratio_permille,
            j.verdict
        );
    }
}

JUDGE_EOF
(cd "$R/judge" && CARGO_TARGET_DIR="$R/target-judge" cargo build --release) > "$O/build-judge.log" 2>&1
for pair in 1 2 3 4;do
 order=forward;[ "$((pair%2))" != 0 ] || order=reverse
 for side in old new;do taskset -c 2 "$R/exe-$pair" "$order" > "$O/$side-$pair.tsv" 2> "$O/$side-$pair.err";done
done
"$R/target-judge/release/parentstagejudge" "$O" pipeline_fused pipeline_copy public_hash > "$O/judgments.tsv"
echo 'parent fused model done' > "$O/status.txt"
