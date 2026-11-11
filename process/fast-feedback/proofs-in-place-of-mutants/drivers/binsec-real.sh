#!/bin/bash
# Experiment (BLAKE3 #361): Binsec's constant-time check on the core crate's own machine code, as a
# second opinion on the Lean model's observer. A small binary links the crate; each check starts at
# one function with its inputs in globals marked secret:
#   hex:    Hash::to_hex of a secret hash (the Lean theorem says the table is read at its nibbles);
#   sse41:  the one-block SSE4.1 kernel on a secret chaining value and block;
#   avx512: the one-block AVX-512 kernel, the same;
#   keyed:  keyed_hash of a 64-byte message under a secret key, through the public API.
# Records each step; no step's failure hides the rest.
set -euo pipefail
exec timeout -k 15s 3300s bash -s -- "$1" <<'JOB'
set -uo pipefail
R="$1";O="$R/out";mkdir -p "$O";export HOME=/root;. <home>/.cargo/env
{ echo "library $(git -C "$R/library" rev-parse HEAD)"; grep -m1 '^name' "$R/library/Cargo.toml"; rustc -V; nproc; } > "$O/identity.txt"
step() { local n="$1"; shift; local s=$SECONDS; "$@" > "$O/$n.log" 2>&1 < /dev/null; echo "$n rc=$? $((SECONDS-s))s" >> "$O/steps.txt"; }
: > "$O/steps.txt"
export DEBIAN_FRONTEND=noninteractive OPAMROOT="$R/opam" OPAMYES=1 OPAMROOTISOK=1
step apt sh -c 'apt-get update -qq && apt-get install -y -qq opam m4 pkg-config libgmp-dev zlib1g-dev z3 build-essential unzip rsync'
step opam-init opam init --disable-sandboxing --bare --no-setup
step opam-switch opam switch create 4.14.2
step binsec-install sh -c 'eval $(opam env --switch=4.14.2) && opam install binsec bitwuzla unisim_archisec'
NAME=$(grep -m1 '^name' "$R/library/Cargo.toml" | sed 's/.*"\(.*\)".*/\1/'); CRATE=$(echo "$NAME" | tr - _)
mkdir -p "$R/p/src"; cd "$R/p"
cat > Cargo.toml <<TOML
[package]
name = "probe"
version = "0.0.0"
edition = "2021"
[dependencies]
$NAME = { path = "$R/library" }
[profile.release]
panic = "abort"
debug = false
TOML
cat > src/main.rs <<RS
use $CRATE as b3;
use core::ptr::addr_of;
#[no_mangle] pub static mut SECRET: [u8; 32] = [1; 32];
#[no_mangle] pub static mut CV: [u32; 8] = [2; 8];
#[no_mangle] pub static mut BLOCK: [u8; 64] = [3; 64];
#[no_mangle] pub static mut MSG: [u8; 64] = [4; 64];
#[no_mangle] pub static mut KEYW: [u32; 8] = [5; 8];
extern "C" {
    fn blake3_servil_compress_in_place_sse41(cv: *mut u32, block: *const u8, block_len: u8, counter: u64, flags: u8);
    fn blake3_servil_compress_in_place_avx512(cv: *mut u32, block: *const u8, block_len: u8, counter: u64, flags: u8);
}
#[no_mangle] #[inline(never)]
pub extern "C" fn main_hex() { unsafe { let h = b3::Hash::from_bytes(core::ptr::read_volatile(addr_of!(SECRET))); core::hint::black_box(h.to_hex()); } }
#[no_mangle] #[inline(never)]
pub extern "C" fn main_sse41() { unsafe { blake3_servil_compress_in_place_sse41(core::ptr::addr_of_mut!(CV) as *mut u32, addr_of!(BLOCK) as *const u8, 64, 0, 0) } }
#[no_mangle] #[inline(never)]
pub extern "C" fn main_avx512() { unsafe { blake3_servil_compress_in_place_avx512(core::ptr::addr_of_mut!(CV) as *mut u32, addr_of!(BLOCK) as *const u8, 64, 0, 0) } }
#[no_mangle] #[inline(never)]
pub extern "C" fn main_keyed() { unsafe { core::hint::black_box(b3::hash_serial(&*addr_of!(MSG), &*addr_of!(KEYW), b3::KEYED_HASH)); } }
fn main() { main_hex(); main_sse41(); main_avx512(); main_keyed(); }
RS
step build sh -c 'RUSTFLAGS="-C relocation-model=static -C target-feature=+crt-static" cargo build --release && nm target/release/probe | grep -E " (SECRET|CV|BLOCK|MSG|KEYW|main_hex|main_sse41|main_avx512|main_keyed)$"'
objdump -d --no-show-raw-insn -M intel target/release/probe | awk '/<main_hex>:/,/ret/' > "$O/main_hex.s" 2>/dev/null
for f in hex sse41 avx512 keyed; do
case $f in hex) secret="SECRET";; keyed) secret="KEYW";; *) secret="CV, BLOCK";; esac
cat > $f.ini <<INI
starting from <main_$f>
with concrete stack pointer
@[rsp, 8] := 0xdead00
secret global $secret
halt at 0xdead00
explore all
INI
step "ct-$f" sh -c "eval \$(opam env --switch=4.14.2) && timeout 600 binsec -sse -checkct -sse-script $f.ini -sse-depth 1000000 target/release/probe"
grep -h -E "Program status|instruction .* (secure|insecure)|leak|Unknown|unsupported|Cut|\[sse:(error|warning|result)\]" "$O/ct-$f.log" | head -n 20 > "$O/ct-$f.summary.txt"
done
cat "$O/steps.txt"; head -n 8 "$O"/ct-*.summary.txt; echo "binsec experiment done" > "$O/status.txt"
JOB
