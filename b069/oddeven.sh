#!/bin/bash
# bench-hashes #69 (John's two questions): on the EPYC 9255, are small batches slower on odd cores
# than on even ones in a plain loop too; does the gap stay with SMT off; and under perf stat, do the
# instructions match while cache and branch misses differ?
# Probe: blake3-servil 0.8 (b5b988d8) performance::hash_many of N x 64 B (N = 1, 2, 8, 64) and
# official 1.8.7 blake3::hash of 64 B, 2 s each, pinned to one CPU. CPUs 0, 1, 2, 3; SMT on, then
# off, then on again (restored on exit); each a fresh process; 3 rounds, order rotated.
set -u
R="$1"; O="$R/out"; mkdir -p "$O"; cd "$R"
. /root/.cargo/env
SMT0=$(cat /sys/devices/system/cpu/smt/control); restore() { echo "$SMT0" > /sys/devices/system/cpu/smt/control 2>/dev/null; }; trap restore EXIT
{ grep -m1 'model name' /proc/cpuinfo; nproc; perf --version; git -C fork log -1 --format=%H; for c in 0 1 2 3; do echo "cpu$c core $(cat /sys/devices/system/cpu/cpu$c/topology/core_id) siblings $(cat /sys/devices/system/cpu/cpu$c/topology/thread_siblings_list)"; done; } > "$O/machine.txt"
mkdir -p probe/src
cat > probe/Cargo.toml <<'TOML_END'
[package]
name = "oddeven"
version = "0.0.0"
edition = "2021"
[dependencies]
blake3-servil = { path = "../fork" }
blake3 = "=1.8.7"
TOML_END
cat > probe/src/main.rs <<'RUST_END'
//! oddeven KIND N SECS: KIND servil (hash_many of N x 64 B) or official (blake3::hash of 64 B, N
//! ignored); calls back to back for SECS seconds; prints ns a call (the median of 1 ms windows) and
//! the calls made, warm-up included (for perf's counts a call).
use blake3_servil::performance::{hash_many, Batch, Block};
use blake3_servil::Mode;
use std::time::{Duration, Instant};
fn main() {
    let a: Vec<String> = std::env::args().collect();
    let (kind, n, secs): (&str, usize, f64) = (&a[1], a[2].parse().unwrap(), a[3].parse().unwrap());
    blake3_servil::initialize();
    let blocks = vec![Block([3u8; 64]); n];
    let mut out = vec![[0u8; 32]; n];
    let one = [3u8; 64];
    let mut call = || match kind {
        "servil" => { hash_many(Mode::Plain, &Batch::from_blocks(&blocks, 64), &mut out); std::hint::black_box(&out); }
        _ => { std::hint::black_box(blake3::hash(std::hint::black_box(&one))); }
    };
    for _ in 0..10000 { call(); }
    let end = Instant::now() + Duration::from_secs_f64(secs);
    let mut windows = Vec::new();
    let mut calls = 10000u64;
    while Instant::now() < end {
        let t = Instant::now(); let mut k = 0u64;
        while t.elapsed() < Duration::from_millis(1) { call(); k += 1; }
        windows.push(t.elapsed().as_nanos() as f64 / k as f64);
        calls += k;
    }
    windows.sort_by(|a, b| a.partial_cmp(b).unwrap());
    println!("{:.2} {calls}", windows[windows.len() / 2]);
}
RUST_END
(cd probe && cargo build --release) > "$O/probe-build.log" 2>&1 || { echo "probe build failed" >> "$O/status.txt"; exit 2; }
grep -A2 'name = "blake3-servil"' probe/Cargo.lock > "$O/probe-lock.txt"; grep -A1 'name = "blake3"$' probe/Cargo.lock >> "$O/probe-lock.txt"
P="$R/probe/target/release/oddeven"
CASES="servil:1 servil:2 servil:8 servil:64 official:1"
for phase in on1 off on2; do
  case $phase in off) echo off > /sys/devices/system/cpu/smt/control ;; *) echo on > /sys/devices/system/cpu/smt/control ;; esac
  sleep 2; echo "$phase: smt $(cat /sys/devices/system/cpu/smt/control), $(nproc) CPUs" >> "$O/smt.txt"
  for round in 1 2 3; do
    L="0 1 2 3"; [ $round = 2 ] && L="3 2 1 0"; [ $round = 3 ] && L="1 0 3 2"
    for cpu in $L; do for c in $CASES; do
      k=${c%:*}; n=${c#*:}
      ns=$(taskset -c $cpu "$P" $k $n 1); echo "$phase $round $cpu $k $n $ns" >> "$O/times.txt"
    done; done
  done
  # perf stat, one 2 s run a CPU and case, user-mode counts.
  for cpu in 0 1; do for c in servil:2 servil:8 official:1; do
    k=${c%:*}; n=${c#*:}
    perf stat -x, -e cycles:u,instructions:u,L1-icache-load-misses:u,branch-misses:u,L1-dcache-load-misses:u -o "$O/perf-$phase-cpu$cpu-$k-$n.csv" taskset -c $cpu "$P" $k $n 2 > "$O/perf-$phase-cpu$cpu-$k-$n.ns"
  done; done
  echo "$phase done" >> "$O/status.txt"
done
restore; trap - EXIT; echo "smt at end: $(cat /sys/devices/system/cpu/smt/control)" >> "$O/smt.txt"
echo "oddeven done" >> "$O/status.txt"
