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
{ echo "library $NEW";rustc -Vv;uname -m;} > "$R/out/identity.txt"
printf '[package]\nname="capi-reuse-audit"\nversion="0.0.0"\nedition="2024"\n[dependencies]\nblake3-servil-c={path="%s/fork/capi"}\nblake3-servil={path="%s/fork"}\n' "$R" "$R" > "$R/probe/Cargo.toml"
cat > "$R/probe/src/main.rs" <<'RS'
// The C API's calls, as a C program makes them, through their Rust items.
// The caller's memory holds a b3_hasher; nothing is read from it directly.
use b3_servil::*;
use core::mem::MaybeUninit;
fn main() {
    let plain = b3_mode_plain();
    let mut h = MaybeUninit::<B3Hasher>::uninit();
    let p = h.as_mut_ptr();
    let hash = |m: &[u8]| *blake3_servil::convenience::hash(m).as_bytes();
    // Sound: initialized by b3_hasher_new; Hasher owns nothing to drop.
    let (first, again, continued) = unsafe {
        b3_hasher_new(p, &plain, 0, 0);
        b3_hasher_update(p, b"abc".as_ptr().cast(), 3);
        let first = b3_hasher_finalize(p).bytes;
        // A cursory reading of "finished and holds no message": finalize
        // again, and feed the next message without b3_hasher_new.
        let again = b3_hasher_finalize(p).bytes;
        b3_hasher_update(p, b"xyz".as_ptr().cast(), 3);
        (first, again, b3_hasher_finalize(p).bytes)
    };
    println!("first finalize is hash(abc): {}", first == hash(b"abc"));
    println!("second finalize without new returns hash(abc) again: {}", again == hash(b"abc"));
    println!("update after finalize without new gives hash(xyz): {}; hash(abcxyz): {}", continued == hash(b"xyz"), continued == hash(b"abcxyz"));
}
RS
cargo run --release --manifest-path "$R/probe/Cargo.toml" > "$R/out/reuse.log" 2>&1
test -z "$(git -C "$R/fork" status --porcelain)"
printf 'C API reuse-after-finalize behavior recorded\n' > "$R/out/status.txt"
JOB
