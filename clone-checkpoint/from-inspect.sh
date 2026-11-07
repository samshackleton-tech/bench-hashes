#!/bin/bash
set -euo pipefail
R="$1";O="$R/out";mkdir -p "$O";export HOME=/root;. /root/.cargo/env
for side in old new;do echo "$side $(git -C "$R/$side" rev-parse HEAD)";done > "$O/identity.txt"
python3 - "$R" <<'IDENTITY_EOF'
from pathlib import Path
import hashlib,sys,json
R=Path(sys.argv[1]);maps=[]
for side in ['old','new']:
 d=R/side;paths=[d/'build.rs']+[p for top in ['c','tools']for p in (d/top).rglob('*')if p.is_file()];maps.append({str(p.relative_to(d)):hashlib.sha256(p.read_bytes()).hexdigest()for p in paths})
assert maps[0]==maps[1],'assembly/generator/proof/model snapshot changed'
(R/'out/unchanged-assembly-proof-model.json').write_text(json.dumps(maps[0],sort_keys=True,indent=2))
print('unchanged assembly/generator/proof/model files:',len(maps[0]))
IDENTITY_EOF
pids=()
for side in old new;do
 (
 P="$R/consumer-$side";mkdir -p "$P/src"
 printf '[package]\nname="parentinspect"\nversion="0.1.0"\nedition="2021"\n[dependencies]\nblake3-servil={path="%s/%s"}\nblake3="=1.8.7"\nclocks={path="%s/bench/clocks"}\n' "$R" "$side" "$R" > "$P/Cargo.toml"
 cat > "$P/src/main.rs" <<'CONSUMER_EOF'
use blake3_servil::{Mode, throughput::Hasher};
fn reference(mode: Mode<'_>, data: &[u8]) -> [u8; 32] {
    match mode {
        Mode::Plain => *blake3::hash(data).as_bytes(),
        Mode::Keyed(k) => *blake3::keyed_hash(k, data).as_bytes(),
        _ => blake3::derive_key("BLAKE3-Servil initialized prefix clone", data),
    }
}
fn run(n: usize, len: usize, aged: bool, flavor: usize, reverse: bool) {
    let key = [0x42u8; 32];
    let mode = match flavor {
        0 => Mode::Plain,
        1 => Mode::Keyed(&key),
        _ => Mode::DeriveKey("BLAKE3-Servil initialized prefix clone"),
    };
    let data: Vec<Vec<u8>> = (0..n)
        .map(|i| (0..len).map(|j| ((i * 37 + j * 17) % 251) as u8).collect())
        .collect();
    let suffix: Vec<Vec<u8>> = (0..n)
        .map(|i| (0..17).map(|j| (i * 37 + j * 11) as u8).collect())
        .collect();
    let expected: Vec<[u8; 32]> = data.iter().map(|d| reference(mode, d)).collect();
    let branches: Vec<[u8; 32]> = data
        .iter()
        .zip(&suffix)
        .map(|(d, s)| {
            let mut all = d.clone();
            all.extend_from_slice(s);
            reference(mode, &all)
        })
        .collect();
    let mut sources: Vec<_> = (0..n).map(|_| Hasher::new(mode)).collect();
    if aged {
        let prime = vec![0xacu8; 65536];
        for h in &mut sources {
            h.update(&prime);
            h.reset();
        }
    }
    for (h, d) in sources.iter_mut().zip(&data) {
        for part in d.chunks(17) {
            h.update(part);
        }
    }
    let mut copies: Vec<_> = sources.iter().map(Clone::clone).collect();
    let mut out = vec![[0u8; 32]; n];
    let shape = format!(
        "{}_{}_{}",
        ["plain", "keyed", "derived"][flavor],
        if aged { "after_tree_reset" } else { "fresh" },
        len
    );
    let stride = if n > 1 {
        &sources[1] as *const Hasher as usize - &sources[0] as *const Hasher as usize
    } else {
        std::mem::size_of::<Hasher>()
    };
    eprintln!(
        "layout shape={shape} items={n} hasher_size={} hasher_align={} native_stride={stride} sources={:#x} copies={:#x} output={:#x}",
        std::mem::size_of::<Hasher>(),
        std::mem::align_of::<Hasher>(),
        sources.as_ptr() as usize,
        copies.as_ptr() as usize,
        out.as_ptr() as usize
    );
    eprintln!(
        "ownership: one caller owns all states/outputs, no workers/shared counters. Source construction, optional 64KiB prime/reset, 17B-arrival prefix setup, refs and output-slot allocation outside. clone_slot measures public Clone plus move into a reused slot; branch adds suffix update and canonical finalization. Neither includes allocation or prefix hashing."
    );
    let mut operations = ["clone_slot", "branch", "clone_from", "clone_from_branch"];
    if reverse {
        operations.reverse();
    }
    for operation in operations {
        let mut work = || {
            for i in 0..n {
                if operation.starts_with("clone_from") {
                    copies[i].clone_from(std::hint::black_box(&sources[i]));
                } else {
                    copies[i] = std::hint::black_box(&sources[i]).clone();
                }
                if operation.ends_with("branch") {
                    copies[i].update(std::hint::black_box(&suffix[i]));
                    out[i] = *copies[i].finalize().as_bytes();
                }
                std::hint::black_box(&copies[i]);
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
        for i in 0..n {
            assert_eq!(
                *sources[i].finalize().as_bytes(),
                expected[i],
                "source immutable"
            );
            assert_eq!(
                *copies[i].finalize().as_bytes(),
                if operation.ends_with("branch") {
                    branches[i]
                } else {
                    expected[i]
                },
                "{shape} n{n} {operation}"
            );
            assert_eq!(
                copies[i].count(),
                (len + if operation.ends_with("branch") { 17 } else { 0 }) as u64
            );
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
        for len in [0, 64, 1024, 2048, 16383, 16384] {
            for aged in [false, true] {
                for flavor in 0..3 {
                    run(n, len, aged, flavor, reverse);
                }
            }
        }
    }
}

CONSUMER_EOF
 (cd "$P";CARGO_TARGET_DIR="$R/target-$side" RUSTFLAGS='-C metadata=held_parent_inspect' cargo build --release) > "$O/build-$side.log" 2>&1
 E="$R/target-$side/release/parentinspect"
 size "$E" > "$O/size-$side.txt"
 nm -S --size-sort -C "$E" > "$O/symbols-$side.txt"
 objdump -d -C "$E" > "$O/disasm-$side.txt"
 # Build and inspect only; no ad hoc timing run.
 ) &
 pids+=("$!")
done
failed=0;for pid in "${pids[@]}";do if ! wait "$pid";then failed=1;fi;done
[ "$failed" = 0 ]
echo 'held parent identities and size inspection done' > "$O/status.txt"
