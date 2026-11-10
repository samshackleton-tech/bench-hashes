#!/bin/bash
# Does Intel's emulator make x86 width coverage independent of the machine (BLAKE3 #346)?
# The suites under three emulated CPUs, every test's outcome kept. Functional only.
set -euo pipefail
exec timeout -k 15s 3000s bash -s -- "$1" <<'JOB'
set -uo pipefail
R="$1";O="$R/out";mkdir -p "$O";export HOME=/root;. <home>/.cargo/env
export CARGO_TARGET_DIR="$R/target"
URL=https://downloadmirror.intel.com/859732/sde-external-9.58.0-2025-06-16-lin.tar.xz
curl -sSL -m 300 -o "$R/sde.tar.xz" "$URL"; sha256sum "$R/sde.tar.xz" | cut -d' ' -f1 > "$O/sde.sha256"
mkdir -p "$R/sde"; tar -xJf "$R/sde.tar.xz" -C "$R/sde" --strip-components=1
{ echo "library $(git -C "$R/library" rev-parse HEAD)"; echo "sde $URL $(cat "$O/sde.sha256")"; "$R/sde/sde64" -version 2>&1 | head -n 3; grep -m1 'model name' /proc/cpuinfo; grep -o -m1 avx512f /proc/cpuinfo || echo "no avx512f"; ls "$R/sde" | grep -i -E 'licen|notice' ; } > "$O/identity.txt"
cp "$R"/sde/*icen* "$O/" 2>/dev/null || true
cd "$R/library"
cargo nextest run --release --lib --tests --no-run > "$O/build.log" 2>&1
for cpu in native icx hsw nhm; do
  start=$SECONDS
  if [ $cpu = native ]; then cargo nextest run --release --lib --tests --no-fail-fast > "$O/$cpu.log" 2>&1; else
    CARGO_TARGET_X86_64_UNKNOWN_LINUX_GNU_RUNNER="$R/sde/sde64 -$cpu --" cargo nextest run --release --lib --tests --no-fail-fast > "$O/$cpu.log" 2>&1; fi
  echo "$cpu rc=$? $((SECONDS-start))s $(grep -E '^\s+Summary' "$O/$cpu.log" | tail -n 1 | sed 's/^ *//')" >> "$O/steps.txt"
  grep -E '^\s+(FAIL|SIGILL|SIGSEGV|SIGABRT|TIMEOUT|ABORT)' "$O/$cpu.log" | sed -E 's/^\s+(\S+)\s+\[[^]]*\]\s+(\([^)]*\)\s+)?/\1 /' | sort -u > "$O/$cpu.failed.txt"
done
# which kernels the suite reports under each CPU: the platform the library detects
for cpu in icx hsw nhm; do echo "$cpu: $("$R/sde/sde64" -$cpu -- grep -c . /dev/null 2>&1 | tail -n 1)"; done > /dev/null 2>&1
cat "$O/steps.txt"; echo "probe done" > "$O/status.txt"
JOB
