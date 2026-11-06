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
