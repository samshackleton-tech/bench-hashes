#!/bin/bash
# bench-hashes #96 on the EPYC 9255: John's script, the old arm without --expect-servil
# (his 09:19 correction), the code under test BLAKE3-Servil 0.8 (b5b988d8).
set -u
R="$1"; O="$R/out"; mkdir -p "$O"; cd "$R"
. /root/.cargo/env
E=b5b988d8982bea9490c38c79ec4b8c5c2428270c
{ grep -m1 'model name' /proc/cpuinfo; nproc; sort -u /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor; rustc -V; git -C fork log -1 --format=%H; git -C b-old log -1 --format=%H; git -C b-new log -1 --format=%H; } > "$O/machine.txt"
(cd b-old && cp "$(cargo run --release --quiet -- build-against ../fork)" ../bench-old) || exit 2
(cd b-new && cp "$(cargo run --release --quiet -- build-against ../fork)" ../bench-new) || exit 3
strings bench-old | grep -o "commit $E" | head -1 > "$O/bench-old-servil.txt"
mkdir settle-200 && (cd settle-200 && ../bench-new --all --quick --train 0,200 --nonstop-visits 1 --expect-servil $E > report.txt 2> err.txt)
./bench-new settle settle-200/benchmark-results/*/bench-hashes.samples.tsv > settle-200.txt
mkdir settle-2000 && (cd settle-2000 && ../bench-new --contenders blake3-servil-mt,blake3-servil-st,sha256-ring,blake3-official-mt \
  --points "continuous 1 KiB,continuous 64 KiB,continuous 1 MiB,continuous 16 MiB,continuous batch 4096" \
  --rounds 1 --train 0,2000 --nonstop-visits 1 --expect-servil $E > report.txt 2> err.txt)
./bench-new settle settle-2000/benchmark-results/*/bench-hashes.samples.tsv > settle-2000.txt
run() { mkdir "$1" && (cd "$1" && /usr/bin/time -p "${@:2}" > report.txt 2> time.txt); }
for c in 1 2 3; do
  if [ $c = 2 ]; then order="control new old"; else order="old new control"; fi
  for arm in $order; do
    case $arm in
      old) run ab-$c-old ../bench-old --all ;;
      new) run ab-$c-new ../bench-new --all --expect-servil $E ;;
      control) run ab-$c-control ../bench-new --all --train 0,1 --nonstop-visits 6 --expect-servil $E ;;
    esac
  done
done
s() { ls ab-[123]-$1/benchmark-results/*/bench-hashes.samples.tsv; }
./bench-new compare $(s old) -- $(s new) > compare-old-new.txt
./bench-new compare $(s old) -- $(s control) > compare-old-control.txt
./bench-new compare $(s control) -- $(s new) > compare-control-new.txt
mkdir -p "$O/data"; cp settle-200.txt settle-2000.txt compare-*.txt "$O/data/"
for d in settle-200 settle-2000 ab-*; do mkdir -p "$O/data/$d"; cp $d/*.txt "$O/data/$d/"; cp $d/benchmark-results/*/bench-hashes.samples.tsv $d/benchmark-results/*/bench-hashes.result.txt "$O/data/$d/"; done
grep -h "BLAKE3 servil mt:" ab-*/benchmark-results/*/bench-hashes.result.txt | grep -c "commit $E" > "$O/servil-lines.txt"
grep -h "load during the run" ab-*/benchmark-results/*/bench-hashes.result.txt settle-*/benchmark-results/*/bench-hashes.result.txt > "$O/load.txt"
