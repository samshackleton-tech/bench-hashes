#!/bin/bash
set -euo pipefail
R="$1"; O="$R/out"; mkdir -p "$O"; cd "$R"
export HOME=/root; . /root/.cargo/env
[ "$(cat /sys/devices/system/cpu/cpu0/topology/thread_siblings_list)" = '0,24' ]
[ "$(cat /sys/devices/system/cpu/cpu0/cache/index3/shared_cpu_list)" = '0-5,24-29' ]
{ date -u; uname -a; grep -m1 'model name' /proc/cpuinfo; nproc; for s in old new bench;do echo "$s $(git -C "$s" rev-parse HEAD)";done; } > "$O/identity.txt"
for layout in 1 2 3 4; do
 for side in old new; do
  P="$R/driver-$side-$layout"; mkdir -p "$P/src"
  printf '[package]
name="ringcopy"
version="0.1.0"
edition="2021"
[dependencies]
blake3-servil={path="%s/%s"}
libc="=0.2.189"
clocks={path="%s/bench/clocks"}
' "$R" "$side" "$R" > "$P/Cargo.toml"
  cat > "$P/src/main.rs" <<'COPY_DRIVER_EOF'
use blake3_servil::{
    performance::{stream, Block},
    Hash, Mode,
};
use std::cell::{Cell, RefCell};
#[repr(C, align(64))]
#[derive(Clone)]
struct Padded(Hash, [u8; 32]);
enum Places {
    Packed(Vec<Hash>),
    Padded(Vec<Padded>),
}
fn pin(cpu: usize) {
    unsafe {
        let mut set: libc::cpu_set_t = core::mem::zeroed();
        libc::CPU_SET(cpu, &mut set);
        assert_eq!(
            libc::sched_setaffinity(0, core::mem::size_of::<libc::cpu_set_t>(), &set),
            0
        );
    }
}
fn main() {
    let args: Vec<_> = std::env::args().collect();
    let size: usize = args[1].parse().unwrap();
    let offset: usize = args[2].parse().unwrap();
    let padded = args[3] == "padded";
    let initial_cpus = std::thread::available_parallelism().unwrap().get();
    blake3_servil::initialize_multithreaded(None);
    pin(0);
    let mut source = vec![Block::ZERO; (size + offset).div_ceil(64).max(1)];
    for (i, b) in Block::bytes_mut(&mut source)[offset..offset + size]
        .iter_mut()
        .enumerate()
    {
        *b = (i * 31) as u8;
    }
    let bytes = &Block::bytes(&source)[offset..offset + size];
    let address = bytes.as_ptr() as usize;
    let want = blake3_servil::convenience::hash(bytes);
    let mut places = if padded {
        Places::Padded(vec![Padded(Hash::from_bytes([0; 32]), [0; 32]); 8])
    } else {
        Places::Packed(vec![Hash::from_bytes([0; 32]); 8])
    };
    let refs: Vec<&mut Hash> = match &mut places {
        Places::Packed(p) => p.iter_mut().collect(),
        Places::Padded(p) => p.iter_mut().map(|p| &mut p.0).collect(),
    };
    let out_addresses: Vec<usize> = refs.iter().map(|p| &**p as *const Hash as usize).collect();
    let free = RefCell::new(refs);
    let rooms = RefCell::new(Vec::<usize>::new());
    let done = Cell::new(0u64);
    let mut quarters = [0u64; 4];
    let duration = 2_000_000_000u64;
    clocks::load::tick();
    let cpu0 = clocks::process_cpu_ns();
    let c0 = clocks::Counts::read();
    let e0 = clocks::energy::package_nj();
    let t = clocks::now();
    stream(
        Mode::Plain,
        |p: &mut [Hash]| {
            assert_eq!(p[0], want);
            done.set(done.get() + 1);
            free.borrow_mut().push(&mut p[0]);
        },
        |s| {
            let mut submitted = 0u64;
            while clocks::since_ns(t) < duration {
                for _ in 0..16 {
                    let place = loop {
                        if let Some(p) = free.borrow_mut().pop() {
                            break p;
                        }
                        s.collect();
                    };
                    let record = submitted < 64;
                    s.submit_with(
                        size,
                        |at, room| {
                            if record && at == 0 {
                                rooms.borrow_mut().push(room.as_ptr() as usize);
                            }
                            room.copy_from_slice(&bytes[at..][..room.len()]);
                            room.len()
                        },
                        place,
                    );
                    submitted += 1;
                }
                let q = (clocks::since_ns(t) * 4 / duration).min(3) as usize;
                quarters[q] = done.get();
                clocks::load::tick();
            }
            s.finish();
            assert_eq!(done.get(), submitted);
        },
    );
    let wall = clocks::since_ns(t);
    let cpu = clocks::process_cpu_ns() - cpu0;
    let c = c0.zip(clocks::Counts::read()).map(|(a, b)| b.since(a));
    let e = e0.zip(clocks::energy::package_nj()).map(|(a, b)| b - a);
    clocks::load::tick();
    println!(
        "totals\t{size}\t{offset}\t{}\t{}\t{wall}\t{cpu}\t{}\t{}",
        if padded { "padded" } else { "packed" },
        done.get(),
        c.map_or(0, |c| c.p.cycles + c.e.cycles),
        e.map_or_else(|| "NA".into(), |e| e.to_string())
    );
    println!(
        "quarters\t{}",
        quarters
            .iter()
            .map(|v| v.to_string())
            .collect::<Vec<_>>()
            .join(",")
    );
    println!("source\t{address:#x}\t{}", address % 4096);
    println!(
        "rooms\t{}",
        rooms
            .borrow()
            .iter()
            .map(|a| format!("{a:#x}"))
            .collect::<Vec<_>>()
            .join(",")
    );
    println!(
        "room-source-mod4096\t{}",
        rooms
            .borrow()
            .iter()
            .map(|a| (a.wrapping_sub(address) % 4096).to_string())
            .collect::<Vec<_>>()
            .join(",")
    );
    println!(
        "output-layout\t{}\t{}\t{}",
        core::mem::size_of::<Hash>(),
        core::mem::size_of::<Padded>(),
        core::mem::align_of::<Padded>()
    );
    println!(
        "outputs\t{}",
        out_addresses
            .iter()
            .map(|a| format!("{a:#x}"))
            .collect::<Vec<_>>()
            .join(",")
    );
    println!("initial-cpus\t{initial_cpus}");
    for task in std::fs::read_dir("/proc/self/task").unwrap().flatten() {
        let path = task.path();
        if let (Ok(name), Ok(stat)) = (
            std::fs::read_to_string(path.join("comm")),
            std::fs::read_to_string(path.join("stat")),
        ) {
            let fields: Vec<_> = stat
                .rsplit_once(')')
                .unwrap()
                .1
                .split_whitespace()
                .collect();
            println!(
                "thread-last-cpu\t{}\t{}\t{}",
                task.file_name().to_string_lossy(),
                name.trim(),
                fields[36]
            );
        }
    }
}

COPY_DRIVER_EOF
  (cd "$P" && RUSTFLAGS="-C metadata=ringcopy_$layout" CARGO_TARGET_DIR="$R/target-$side-$layout" cargo build --release && cargo tree -p blake3-servil --depth 0) > "$O/build-$side-$layout.log" 2>&1
  cp "$R/target-$side-$layout/release/ringcopy" "$O/exe-$side-$layout"
 done
 done
for size in 1048576 4194304; do
 for rep in $(seq 1 32); do
  layout=$(( (rep-1)%4+1 )); sides='old new'; [ "$((rep%2))" != 0 ] || sides='new old'
  for placement in with without; do
   cpus='0-5,24-29'; [ "$placement" = with ] || cpus='0-5,25-29'
   for side in $sides; do
    taskset -c "$cpus" "$O/exe-$side-$layout" "$size" 0 packed > "$O/$size-$placement-$side-$rep.txt" 2> "$O/$size-$placement-$side-$rep.err"
   done
  done
 done
 for rep in $(seq 1 8); do
  layout=$(( (rep-1)%4+1 )); sides='old new'; [ "$((rep%2))" != 0 ] || sides='new old'
  for control in offset padded; do
   off=2048; packing=packed; [ "$control" = offset ] || { off=0; packing=padded; }
   for placement in with without; do
    cpus='0-5,24-29'; [ "$placement" = with ] || cpus='0-5,25-29'
    for side in $sides; do
     taskset -c "$cpus" "$O/exe-$side-$layout" "$size" "$off" "$packing" > "$O/$size-$placement-$control-$side-$rep.txt" 2> "$O/$size-$placement-$control-$side-$rep.err"
    done
   done
  done
 done
 done
echo 'ring copy done' > "$O/status.txt"
