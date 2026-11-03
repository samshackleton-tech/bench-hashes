#!/bin/bash
# BLAKE3 #196, corepin's full runs (run i196-corefull): i196-corepin's full runs stopped at
# --expect-servil, which a patched tree cannot meet. Servil 68fd3e57 and corepin (probe/l3-pool-cores
# 95ebbe37 with corepin_patch.py, inline), each built against by bench-hashes 0.19.7, alternating,
# 2 rounds: --contenders blake3-servil-mt, servil with --expect-servil, corepin without (its samples'
# header names it dirty).
set -u
R="$1"; O="$R/out"; mkdir -p "$O"; cd "$R"
. /root/.cargo/env
{ grep -m1 'model name' /proc/cpuinfo; nproc; for v in base corepin; do echo "$v $(git -C $v log -1 --format=%H)"; done; git -C bench log -1 --format=%H; } > "$O/machine.txt"
python3 - "$R/corepin" <<'PY_COREPIN_END' || { echo "patch corepin failed" >> "$O/status.txt"; exit 2; }
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
PY_COREPIN_END
git -C corepin diff --stat > "$O/patch-corepin.txt"
cd "$R/bench"; cargo build --release > "$O/bench-build.log" 2>&1 || { echo "bench build failed" >> "$O/status.txt"; exit 2; }
for v in base corepin; do
  E=$(./target/release/bench-hashes build-against "$R/$v" 2> "$O/build-against-$v.err" | tail -1); [ -x "$E" ] || { echo "build-against $v failed" >> "$O/status.txt"; exit 3; }
  echo "$v $E" >> "$O/exes.txt"
done
[ "$(cut -d' ' -f2 "$O/exes.txt" | sort -u | wc -l)" = 2 ] || { echo "EXECUTABLES NOT DISTINCT" >> "$O/status.txt"; exit 3; }
for round in 1 2; do
  for v in base corepin; do
    E=$(grep "^$v " "$O/exes.txt" | cut -d' ' -f2); C=$(git -C "$R/$v" rev-parse HEAD)
    D="$R/scratch-$v-$round"; mkdir -p "$D"; cd "$D"
    X=""; [ $v = base ] && X="--expect-servil $C"
    "$E" --contenders blake3-servil-mt $X > "$O/full-$v-$round.out" 2> "$O/full-$v-$round.err"
    echo "full $v round $round exit $?" >> "$O/status.txt"
    cp "$D"/benchmark-results/*/bench-hashes.samples.tsv "$O/full-$v-$round.samples.tsv" 2>/dev/null || echo "full $v round $round: NO SAMPLES" >> "$O/status.txt"
    grep -m1 "source blake3-servil-mt" "$O/full-$v-$round.samples.tsv" >> "$O/identities.txt"
  done
  cd "$R/bench"
done
echo "corefull done" >> "$O/status.txt"
