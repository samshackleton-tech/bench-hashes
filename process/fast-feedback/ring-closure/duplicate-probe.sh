#!/bin/bash
set -euo pipefail
exec timeout -k 5s 240s bash -s -- "$1" <<'JOB'
set -euo pipefail
R="$1"
mkdir -p "$R/out" "$R/probe/src"
export HOME=/root
. /root/.cargo/env
export CARGO_TARGET_DIR="$R/target"
NEW=ddb7199d7f0b0f04390e923474b630ffc7ff2811
test "$(git -C "$R/fork" rev-parse HEAD)" = "$NEW"
{ echo "library $NEW";rustc -Vv;uname -m;grep -m1 -o 'avx512f' /proc/cpuinfo || true;} > "$R/out/identity.txt"
printf '[package]\nname="duplicate-index-audit"\nversion="0.0.0"\nedition="2024"\n[dependencies]\nblake3-servil={path="%s/fork"}\n' "$R" > "$R/probe/Cargo.toml"
cat > "$R/probe/src/main.rs" <<'RS'
// Release build: the documented distinct-index precondition is checked by
// debug_assert only. Observe what a caller who repeats an index receives.
use blake3_servil::{Mode, convenience::{self, Hasher}, throughput};
fn run(n: usize) {
    blake3_servil::initialize();
    let message = b"one message, finalized twice by a repeated index";
    let mut hashers: Vec<Hasher> = (0..1).map(|_| Hasher::new(Mode::Plain, None)).collect();
    hashers[0].update(message);
    let which = vec![0; n];
    let mut out = vec![[0u8; 32]; n];
    throughput::finalize_each(&mut hashers, &which, &mut out);
    let right = *convenience::hash(message).as_bytes();
    let empty = *convenience::hash(b"").as_bytes();
    let rights = out.iter().filter(|d| **d == right).count();
    let empties = out.iter().filter(|d| **d == empty).count();
    println!("repeated index x{n}: {rights} digests of the message, {empties} of the empty message, {} other", n - rights - empties);
}
fn main() {
    run(2);
    run(16);
}
RS
cargo run --release --manifest-path "$R/probe/Cargo.toml" > "$R/out/duplicates.log" 2>&1
test -z "$(git -C "$R/fork" status --porcelain)"
printf 'duplicate-index release behavior recorded\n' > "$R/out/status.txt"
JOB
