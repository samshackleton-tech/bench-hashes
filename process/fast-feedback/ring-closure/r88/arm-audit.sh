#!/bin/bash
set -euo pipefail
exec timeout -k 5s 480s bash -s -- "$1" <<'JOB'
set -euo pipefail
R="$1"
mkdir -p "$R/out" "$R/probe/src"
export HOME=/root
. /root/.cargo/env
export CARGO_TARGET_DIR="$R/target"
NEW="$(git -C "$R/fork" rev-parse HEAD)"
{ echo "library $NEW";rustc -Vv;uname -m;grep -m1 -o -w 'sve\|sme2\|asimd' /proc/cpuinfo | sort -u || true;} > "$R/out/identity.txt"
printf '[package]\nname="arm-cursory-audit"\nversion="0.0.0"\nedition="2024"\n[dependencies]\nblake3-servil={path="%s/fork"}\nblake3-servil-c={path="%s/fork/capi"}\nblake3={version="=1.8.7",default-features=false,features=["std"]}\n' "$R" "$R" > "$R/probe/Cargo.toml"
cat > "$R/probe/src/main.rs" <<'RS'
// Ordinary public calls, release and debug builds; nothing here relies on
// undefined behavior. Each line states what a cursory caller would get.
use blake3_servil::{Mode, convenience::{self, Hasher}, throughput};
use core::mem::MaybeUninit;

fn duplicates(n: usize) {
    let message = b"one message, finalized twice by a repeated index";
    let mut hashers = vec![Hasher::new(Mode::Plain, None)];
    hashers[0].update(message);
    let mut out = vec![[0u8; 32]; n];
    throughput::finalize_each(&mut hashers, &vec![0; n], &mut out);
    let right = *convenience::hash(message).as_bytes();
    let empty = *convenience::hash(b"").as_bytes();
    let r = out.iter().filter(|d| **d == right).count();
    let e = out.iter().filter(|d| **d == empty).count();
    println!("repeated index x{n}: {r} digests of the message, {e} of the empty message, {} other", n - r - e);
}

fn c_reuse() {
    use b3_servil::*;
    let plain = b3_mode_plain();
    let mut h = MaybeUninit::<B3Hasher>::uninit();
    let p = h.as_mut_ptr();
    let hash = |m: &[u8]| *convenience::hash(m).as_bytes();
    let (first, again, continued) = unsafe {
        b3_hasher_new(p, &plain, 0, 0);
        b3_hasher_update(p, b"abc".as_ptr().cast(), 3);
        let first = b3_hasher_finalize(p).bytes;
        let again = b3_hasher_finalize(p).bytes;
        b3_hasher_update(p, b"xyz".as_ptr().cast(), 3);
        (first, again, b3_hasher_finalize(p).bytes)
    };
    println!("C: first {}; finalize again returns hash(abc): {}; update after finalize gives hash(abcxyz): {}", first == hash(b"abc"), again == hash(b"abc"), continued == hash(b"abcxyz"));
}

fn xof_end() {
    // Documented: past 2^64 - 1 output bytes the behavior is unspecified.
    // Check that a read across the end neither crashes in release nor
    // differs from official BLAKE3 1.8.7, and where it stands in debug.
    for (start, len) in [(u64::MAX - 63, 64usize), (u64::MAX - 10, 100), (u64::MAX - 200, 1000)] {
        let ours = std::panic::catch_unwind(|| {
            let mut r = convenience::hash_xof(Mode::Plain, b"abc");
            r.set_position(start);
            let mut out = vec![0u8; len];
            r.fill(&mut out);
            (out, r.position())
        });
        let official = std::panic::catch_unwind(|| {
            let mut r = blake3::Hasher::new().update(b"abc").finalize_xof();
            r.set_position(start);
            let mut out = vec![0u8; len];
            r.fill(&mut out);
            (out, r.position())
        });
        match (ours, official) {
            (Ok(a), Ok(b)) => println!("xof from {start} x {len}: completes; equals official 1.8.7: {}; position {}", a == b, a.1),
            (a, b) => println!("xof from {start} x {len}: ours panicked {}, official panicked {}", a.is_err(), b.is_err()),
        }
    }
}

fn main() {
    blake3_servil::initialize();
    println!("build: {}", if cfg!(debug_assertions) { "debug" } else { "release" });
    // The debug build stops at the first repeated index (its debug_assert), so it runs last.
    xof_end();
    c_reuse();
    for n in [2, 16, 17] {
        duplicates(n);
    }
}
RS
cargo run --release --manifest-path "$R/probe/Cargo.toml" > "$R/out/release.log" 2>&1
set +e
RUST_BACKTRACE=0 cargo run --manifest-path "$R/probe/Cargo.toml" > "$R/out/debug.log" 2>&1
echo "$?" > "$R/out/debug-exit.txt"
set -e
test -z "$(git -C "$R/fork" status --porcelain)"
printf 'arm cursory audit recorded\n' > "$R/out/status.txt"
JOB
