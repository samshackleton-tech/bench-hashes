#!/bin/bash
# bench-hashes #106: do the after-pause modes follow the idle state, causally?
# Devon's idle_probe (2026-11-01/mysteries-i7/place-probe/idle_probe.rs), generalized:
# any number of cpuidle states (none on a machine without a cpuidle driver), any CPU,
# each state's usage and time (us) around the 1 ms pause, outside the timed call; and a
# second call straight after the first, warm. blake3-servil 0.8 (b5b988d8), hash_many of
# 16 x 64 B, as bench-hashes' IdleManyMessages 16.
# Run 3: how long the slow state lasts after waking (spins of 0-2000 us), with and without
# C1E, and a steady reference: the 201st call of the visit, back to back. Run 2 (run 1 found the counter reads themselves change the call). Conditions,
# each the same probe, in rotated order, 2 rounds (listed below). Run 1's list was:
#   free      states as the machine has them, counters read
#   noread    the same, counters not read (does reading them change the mix?)
#   sibbusy   the SMT sibling spins (a core enters C6 only with both threads idle:
#             does the per-CPU counter still say C6?)
#   noC6      the deepest state disabled on the CPU and its sibling (sysfs, root)
#   C1only    every state deeper than C1 disabled
# The machine's states are restored at the end (trap), and checked.
set -u
R="$1"; O="$R/out"; mkdir -p "$O"; cd "$R"
. /root/.cargo/env
CPU=2
SIB=$(cut -d, -f2 /sys/devices/system/cpu/cpu$CPU/topology/thread_siblings_list | cut -d- -f2)
{ grep -m1 'model name' /proc/cpuinfo; nproc; uname -r; sort -u /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor
  echo "cpuidle driver: $(cat /sys/devices/system/cpu/cpuidle/current_driver) governor: $(cat /sys/devices/system/cpu/cpuidle/current_governor)"
  for s in /sys/devices/system/cpu/cpu$CPU/cpuidle/state*; do [ -d "$s" ] && echo "$(basename $s) $(cat $s/name) latency $(cat $s/latency) us residency $(cat $s/residency) us disable $(cat $s/disable)"; done
  echo "cpu $CPU sibling $SIB"; git -C fork log -1 --format=%H; } > "$O/machine.txt"

mkdir -p probe/src
cat > probe/Cargo.toml <<'TOML_END'
[package]
name = "idle-probe"
version = "0.0.0"
edition = "2021"
[dependencies]
blake3-servil = { path = "../fork" }
[profile.release]
debug = false
TOML_END
cat > probe/src/main.rs <<'RUST_END'
//! Per visit: the 1 ms pause, the cpuidle counters of CPU `cpu` (each state's usage and
//! time in us) read before and after it unless `noread`, outside the timed calls; then
//! the timed call and a second, warm call. Columns: visit, first ns, second ns, usage
//! deltas (comma-separated), time deltas (comma-separated).
use blake3_servil::performance::{hash_many, Batch, Block};
use blake3_servil::Mode;
use std::time::{Duration, Instant};

fn states(cpu: usize) -> usize {
    (0..).take_while(|s| std::path::Path::new(&format!("/sys/devices/system/cpu/cpu{cpu}/cpuidle/state{s}")).exists()).count()
}
fn read(cpu: usize, n: usize, what: &str) -> Vec<u64> {
    (0..n)
        .map(|s| std::fs::read_to_string(format!("/sys/devices/system/cpu/cpu{cpu}/cpuidle/state{s}/{what}")).unwrap().trim().parse().unwrap())
        .collect()
}
fn main() {
    // cpu visits read delay_us: read = before (after the pause, before the timed calls:
    // Devon's placement), after (after the timed calls) or none; delay_us = a spin
    // between the pause and the timed calls.
    let a: Vec<String> = std::env::args().collect();
    let cpu: usize = a[1].parse().unwrap();
    let visits: usize = a[2].parse().unwrap();
    let read_at = a[3].as_str();
    let delay = Duration::from_micros(a[4].parse().unwrap());
    assert!(matches!(read_at, "before" | "after" | "none"), "{read_at}");
    blake3_servil::initialize();
    let n = if read_at == "none" { 0 } else { states(cpu) };
    let mut blocks = vec![Block([0u8; 64]); 16];
    let mut out = vec![[0u8; 32]; 16];
    let j = |v: &[u64]| v.iter().map(u64::to_string).collect::<Vec<_>>().join(",");
    for v in 0..visits {
        let (u0, t0) = (read(cpu, n, "usage"), read(cpu, n, "time"));
        std::thread::sleep(Duration::from_millis(1));
        let (mut u1, mut t1) = (Vec::new(), Vec::new());
        if read_at == "before" {
            (u1, t1) = (read(cpu, n, "usage"), read(cpu, n, "time"));
        }
        let s = Instant::now();
        while s.elapsed() < delay {}
        for (i, b) in blocks.iter_mut().enumerate() {
            b.0.fill((v + i) as u8);
        }
        let t = Instant::now();
        hash_many(Mode::Plain, &Batch::from_blocks(&blocks, 64), &mut out);
        let first = t.elapsed().as_nanos();
        std::hint::black_box(&out);
        let t = Instant::now();
        hash_many(Mode::Plain, &Batch::from_blocks(&blocks, 64), &mut out);
        let second = t.elapsed().as_nanos();
        std::hint::black_box(&out);
        for _ in 0..199 {
            hash_many(Mode::Plain, &Batch::from_blocks(&blocks, 64), &mut out);
            std::hint::black_box(&out);
        }
        let t = Instant::now();
        hash_many(Mode::Plain, &Batch::from_blocks(&blocks, 64), &mut out);
        let steady = t.elapsed().as_nanos();
        std::hint::black_box(&out);
        if read_at == "after" {
            (u1, t1) = (read(cpu, n, "usage"), read(cpu, n, "time"));
        }
        let du: Vec<u64> = u0.iter().zip(&u1).map(|(b, a)| a - b).collect();
        let dt: Vec<u64> = t0.iter().zip(&t1).map(|(b, a)| a - b).collect();
        println!("{v}\t{first}\t{second}\t{}\t{}\t{steady}", j(&du), j(&dt));
    }
}
RUST_END
(cd probe && cargo build --release --locked 2>/dev/null || cargo build --release) > "$O/probe-build.log" 2>&1 || { echo "probe build failed" >> "$O/status.txt"; exit 2; }
grep -m1 "blake3-servil" probe/Cargo.lock > /dev/null && grep -A2 'name = "blake3-servil"' probe/Cargo.lock > "$O/probe-lock.txt"
P="$R/probe/target/release/idle-probe"

# Each state's original disable flag, for CPU and sibling; restored on any exit.
NS=$(ls -d /sys/devices/system/cpu/cpu$CPU/cpuidle/state* 2>/dev/null | wc -l)
for c in $CPU $SIB; do for s in $(seq 0 $((NS-1))); do echo "$c $s $(cat /sys/devices/system/cpu/cpu$c/cpuidle/state$s/disable)"; done; done > "$O/disable-before.txt"
SPIN=""
# (Local names: a bare `read c` here once overwrote the loop's condition `$c`.)
restore() {
  local rc rs rd
  [ -n "$SPIN" ] && kill $SPIN 2>/dev/null
  while read rc rs rd; do echo $rd > /sys/devices/system/cpu/cpu$rc/cpuidle/state$rs/disable; done < "$O/disable-before.txt"
}
trap restore EXIT
setdis() { # $1: first state to disable (states >= $1 disabled, below enabled as before)
  local dc ds dd
  while read dc ds dd; do if [ $ds -ge $1 ]; then echo 1; else echo $dd; fi > /sys/devices/system/cpu/cpu$dc/cpuidle/state$ds/disable; done < "$O/disable-before.txt"
}
# C1's index, by name (POLL is state0 on intel_idle).
C1=$(for s in $(seq 0 $((NS-1))); do [ "$(cat /sys/devices/system/cpu/cpu$CPU/cpuidle/state$s/name)" = C1 ] && echo $s; done | head -1)

# Condition: name = read placement, states, sibling, delay.
#   before        Devon's placement (replicates run 1's "free")
#   none          no reads: what the bench itself does
#   after         reads after the timed calls: option 1 without touching the call
#   none-noC6     no reads, the deepest state disabled
#   none-C1only   no reads, every state below C1 disabled
#   after-sibbusy reads after, the SMT sibling spinning (core C6 needs both threads idle)
#   none-d20      no reads, a 20 us spin between the pause and the timed calls
if [ "$NS" -gt 0 ]; then CONDS="none-d0 none-d50 none-d100 none-d200 none-d500 none-d2000 none-C1only-d0 none-C1only-d500"; else CONDS="none-d0 none-d500"; fi
VISITS=1500
for round in 1 2; do
  [ $round = 2 ] && CONDS_R=$(echo $CONDS | tr ' ' '\n' | tac | tr '\n' ' ') || CONDS_R=$CONDS
  for c in $CONDS_R; do
    restore; SPIN=""
    [ -n "$c" ] || { echo "EMPTY CONDITION" >> "$O/status.txt"; exit 3; }
    rd=${c%%-*}; dl=0
    case $c in
      *-noC6) setdis $((NS-1)) ;;
      *-C1only*) setdis $((C1+1)) ;;
      *-sibbusy) taskset -c $SIB sh -c 'while :; do :; done' & SPIN=$! ; sleep 0.2 ;;
    esac
    case $c in *-d[0-9]*) dl=${c##*-d} ;; esac
    { for s in /sys/devices/system/cpu/cpu$CPU/cpuidle/state*; do [ -d "$s" ] && printf '%s=%s ' $(cat $s/name) $(cat $s/disable); done; echo "read=$rd delay_us=$dl spin=${SPIN:-none}"; } > "$O/$c-$round.states"
    taskset -c $CPU "$P" $CPU $VISITS $rd $dl > "$O/$c-$round.tsv" 2> "$O/$c-$round.err"
    echo "$c round $round exit $?" >> "$O/status.txt"
    [ -n "$SPIN" ] && { kill $SPIN; wait $SPIN 2>/dev/null; SPIN=""; }
  done
done
restore; trap - EXIT
for c in $CPU $SIB; do for s in $(seq 0 $((NS-1))); do echo "$c $s $(cat /sys/devices/system/cpu/cpu$c/cpuidle/state$s/disable)"; done; done > "$O/disable-after.txt"
cmp -s "$O/disable-before.txt" "$O/disable-after.txt" && echo "states restored" >> "$O/status.txt" || echo "STATES NOT RESTORED" >> "$O/status.txt"
echo "idle done" >> "$O/status.txt"
