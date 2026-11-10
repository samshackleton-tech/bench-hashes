#!/bin/bash
# What a program sees under each emulated CPU: the features Rust's detection reports,
# and which kernels the library's own tests say ran (BLAKE3 #346).
set -euo pipefail
exec timeout -k 15s 1500s bash -s -- "$1" <<'JOB'
set -uo pipefail
R="$1";O="$R/out";mkdir -p "$O";export HOME=/root;. <home>/.cargo/env
export CARGO_TARGET_DIR="$R/target"
URL=https://downloadmirror.intel.com/859732/sde-external-9.58.0-2025-06-16-lin.tar.xz
curl -sSL -m 300 -o "$R/sde.tar.xz" "$URL"; echo "f849acecad4c9b108259c643b2688fd65c35723cd23368abe5dd64b917cc18c0  $R/sde.tar.xz" | sha256sum -c - > "$O/sde-check.txt" 2>&1 || exit 1
mkdir -p "$R/sde"; tar -xJf "$R/sde.tar.xz" -C "$R/sde" --strip-components=1
echo "library $(git -C "$R/library" rev-parse HEAD)" > "$O/identity.txt"
cat > "$R/features.rs" <<'RS'
fn main() {
    let f = [("sse4.1", is_x86_feature_detected!("sse4.1")), ("avx2", is_x86_feature_detected!("avx2")), ("avx512f", is_x86_feature_detected!("avx512f")), ("avx512vl", is_x86_feature_detected!("avx512vl"))];
    println!("{}", f.iter().map(|(n, b)| format!("{n}={}", *b as u8)).collect::<Vec<_>>().join(" "));
}
RS
rustc -O -o "$R/features" "$R/features.rs"
{ echo "native: $("$R/features")"; for cpu in icx hsw nhm skx spr; do echo "$cpu: $("$R/sde/sde64" -$cpu -- "$R/features" 2>&1 | tail -n 1)"; done; } > "$O/features.txt"
"$R/sde/sde64" -help 2>&1 | grep -E '^\s+-(icx|hsw|nhm|skx|spr|gnr|future|cpuid_in|znver)' | head -n 12 > "$O/sde-options.txt"
ls "$R/sde/misc/cpuid" 2>/dev/null | head -n 40 > "$O/cpuid-files.txt"
cd "$R/library"
# the tests that name kernels: which pass, and how many tests each CPU runs or skips
for cpu in icx hsw nhm; do CARGO_TARGET_X86_64_UNKNOWN_LINUX_GNU_RUNNER="$R/sde/sde64 -$cpu --" cargo nextest run --release --lib -E 'test(avx512) | test(avx2) | test(sse41) | test(platform) | test(wide)' --no-fail-fast > "$O/kernels-$cpu.log" 2>&1; echo "$cpu rc=$? $(grep -E '^\s+Summary' "$O/kernels-$cpu.log" | sed 's/^ *//')" >> "$O/kernel-tests.txt"; done
cat "$O/features.txt" "$O/kernel-tests.txt"; echo "probe2 done" > "$O/status.txt"
JOB
