"""Probe for #196 (corepin), on probe/l3-pool-cores: one worker a physical core, each pinned to its
core's hardware threads, so no two workers share a core (the placement half of the rule, by
construction). Usage: corepin_patch.py TREE"""
import sys, pathlib
tree = pathlib.Path(sys.argv[1])
p = tree / "src/lanes.rs"; s = p.read_text()
a = """    let workers = threads - 1;
    let n = domains.count;
    let weight: Vec<usize> = (0..n).map(|d| domains.cpus[d].len().max(1)).collect();
"""
b = """    let n = domains.count;
    // Probe (corepin): one worker a core, each domain's share its cores.
    let core_lists = |d: usize| -> Vec<String> {
        let mut cores: Vec<String> = domains.cpus[d]
            .iter()
            .filter_map(|c| std::fs::read_to_string(format!("/sys/devices/system/cpu/cpu{c}/topology/core_cpus_list")).ok())
            .map(|l| l.trim().to_owned())
            .collect();
        cores.sort();
        cores.dedup();
        cores
    };
    let weight: Vec<usize> = (0..n).map(|d| core_lists(d).len().max(1)).collect();
    let workers = weight.iter().sum::<usize>().min(threads - 1);
    let threads = workers + 1;
"""
assert s.count(a) == 1, "initialize's workers"; s = s.replace(a, b)
a = """            let mut mask = [0u64; 16];
            for &c in &pool.domains.cpus[d as usize] {
                mask[c / 64] |= 1 << (c % 64);
            }
"""
b = """            // Probe (corepin): this worker on one core's hardware threads.
            let mut cores: Vec<String> = pool.domains.cpus[d as usize]
                .iter()
                .filter_map(|c| std::fs::read_to_string(format!("/sys/devices/system/cpu/cpu{c}/topology/core_cpus_list")).ok())
                .map(|l| l.trim().to_owned())
                .collect();
            cores.sort();
            cores.dedup();
            let mut mask = [0u64; 16];
            match cores.get(local % cores.len().max(1)) {
                Some(list) => {
                    for range in list.split(',') {
                        let (a, b) = range.split_once('-').unwrap_or((range, range));
                        for c in a.trim().parse::<usize>().unwrap()..=b.trim().parse::<usize>().unwrap() {
                            if pool.domains.cpus[d as usize].contains(&c) {
                                mask[c / 64] |= 1 << (c % 64);
                            }
                        }
                    }
                }
                None => {
                    for &c in &pool.domains.cpus[d as usize] {
                        mask[c / 64] |= 1 << (c % 64);
                    }
                }
            }
"""
assert s.count(a) == 1, "worker_main's mask"; s = s.replace(a, b)
p.write_text(s)
print("corepin patched")
