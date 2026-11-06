#!/bin/bash
set -euo pipefail
R="$1";O="$R/out";mkdir -p "$O";export HOME=/root;. /root/.cargo/env
{ date -u;uname -a;grep -m1 'model name' /proc/cpuinfo;rustc --version;cc --version | head -1;for repo in library bench;do echo "$repo $(git -C "$R/$repo" rev-parse HEAD)";done;echo 'Data-layout-only control; production hashing unchanged'; } > "$O/identity.txt"
cat > "$R/gen_bridge.py" <<'GEN_EOF'
#!/usr/bin/env python3
"""Benchmark-only CV/message layout controls; no compression or hash API.

Reuse current generator's output/transpose emitters for the round-trip path.
Compare that with register-only adjacent-child compaction. Both controls load
16 SoA CV vectors and store 16 SoA parent-message vectors. The round-trip also
materializes 32 canonical CVs and reloads them as 16 parent blocks.
"""
import ast
import pathlib
import sys

source = pathlib.Path(sys.argv[1]).read_text()
module = ast.parse(source)
names = {"emit", "transpose", "output_group"}
nodes = []
for node in module.body:
    if isinstance(node, ast.FunctionDef) and node.name in names:
        nodes.append(node)
    elif isinstance(node, ast.Assign) and any(isinstance(t, ast.Name) and t.id == "WORD" for t in node.targets):
        nodes.append(node)
assert len(nodes) == 4
namespace = {}
exec(compile(ast.Module(body=nodes, type_ignores=[]), "current_transpose_helpers", "exec"), namespace)
emit = namespace["emit"]
transpose = namespace["transpose"]
output_group = namespace["output_group"]
word = namespace["WORD"]

print('.intel_syntax noprefix\n.text')


def begin(name):
    print(f'.p2align 6\n.global {name}\n.hidden {name}\n.type {name}, @function\n{name}:\n.cfi_startproc')
    emit('endbr64')
    emit('push r15')
    print('.cfi_def_cfa_offset 16\n.cfi_offset r15, -16')
    # ABI: rdi = SoA CV input, rsi = SoA message output,
    # rdx = canonical CV scratch, rcx = 16 pointers into scratch.
    emit('mov r11, rsi')
    emit('mov r15, rdx')
    for r in range(16):
        emit(f'vmovdqa32 zmm{r}, ZMMWORD PTR [rdi + {64*r}]')


def end(name):
    emit('vzeroupper')
    emit('pop r15')
    print('.cfi_def_cfa_offset 8\n.cfi_restore r15')
    emit('ret')
    print(f'.cfi_endproc\n.size {name}, .-{name}')


name = 'parent_bridge_roundtrip'
begin(name)
output_group(0, 0)
output_group(8, 512)
for i in range(16):
    emit(f'mov rax, QWORD PTR [rcx + {8*i}]')
    emit(f'vmovdqu32 zmm{16+i}, ZMMWORD PTR [rax]')
rows = transpose(list(range(16, 32)), 8)
for w in range(16):
    emit(f'vmovdqa32 ZMMWORD PTR [r11 + {64*w}], zmm{rows[word[w]]}')
end(name)


def direct(name, odd):
    begin(name)
    emit('vmovdqa32 zmm30, ZMMWORD PTR [rip + .Leven]')
    emit(f'vmovdqa32 zmm31, ZMMWORD PTR [rip + {odd}]')
    for w in range(8):
        if w == 6:
            # The first child word's two source registers are now dead.
            emit('vmovdqa32 zmm0, zmm30')
            emit('vmovdqa32 zmm8, zmm31')
        even_index, odd_index = (30, 31) if w < 6 else (0, 8)
        a, b = w, 8+w
        left, right = 16+w, 24+w
        emit(f'vpermd zmm{left}, zmm{even_index}, zmm{a}')
        emit(f'vpermd zmm{right}, zmm{even_index}, zmm{b}')
        # 0x44 joins low eight words of each input, not repeated quarters.
        emit(f'vshufi32x4 zmm{left}, zmm{left}, zmm{right}, 0x44')
        emit(f'vpermd zmm{right}, zmm{odd_index}, zmm{a}')
        emit(f'vpermd zmm{b}, zmm{odd_index}, zmm{b}')
        emit(f'vshufi32x4 zmm{right}, zmm{right}, zmm{b}, 0x44')
    for w in range(16):
        emit(f'vmovdqa32 ZMMWORD PTR [r11 + {64*w}], zmm{16+w}')
    end(name)


direct('parent_bridge_direct', '.Lodd')
direct('parent_bridge_bad', '.Leven')
print('.section .rodata\n.p2align 6\n.Leven:\n.long ' + ', '.join(str(i) for i in list(range(0, 16, 2))*2))
print('.p2align 6\n.Lodd:\n.long ' + ', '.join(str(i) for i in list(range(1, 16, 2))*2))
print('.section .note.GNU-stack,"",@progbits')

GEN_EOF
python3 "$R/gen_bridge.py" "$R/library/tools/gen_avx512_32.py" > "$O/bridge.S"
cc -c "$O/bridge.S" -o "$R/bridge.o" > "$O/asm-build.log" 2>&1
pids=()
for pair in 1 2 3 4;do
 (
 P="$R/probe-$pair";mkdir -p "$P/src"
 printf '[package]
name="parentbridge"
version="0.1.0"
edition="2021"
[dependencies]
clocks={path="%s/bench/clocks"}
' "$R" > "$P/Cargo.toml"
 cat > "$P/src/main.rs" <<'PROBE_EOF'
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

PROBE_EOF
 (cd "$P" && CARGO_TARGET_DIR="$R/target-$pair" RUSTFLAGS="-C metadata=parentbridge_$pair -C link-arg=$R/bridge.o" cargo build --release) > "$O/build-$pair.log" 2>&1
 cp "$R/target-$pair/release/parentbridge" "$R/exe-$pair";cp "$P/Cargo.lock" "$O/lock-$pair.txt"
 ) &
 pids+=("$!")
done
failed=0;for pid in "${pids[@]}";do if ! wait "$pid";then failed=1;fi;done
[ "$failed" = 0 ]
mkdir -p "$R/judge/src"
printf '[package]
name="parentbridgejudge"
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
"$R/target-judge/release/parentbridgejudge" "$O" direct roundtrip > "$O/judgments.tsv"
echo 'parent layout bridge done' > "$O/status.txt"
