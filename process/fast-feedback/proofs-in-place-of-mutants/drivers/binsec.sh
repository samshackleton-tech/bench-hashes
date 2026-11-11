#!/bin/bash
# Experiment (BLAKE3 #361): Binsec's constant-time check on compiled code. Install it; check a
# small Rust loop (`scan`: the words and the seed secret, the length and the addresses public)
# and a planted leak (a branch on a word). Records each step; no step's failure hides the rest.
set -euo pipefail
exec timeout -k 15s 3300s bash -s -- "$1" <<'JOB'
set -uo pipefail
R="$1";O="$R/out";mkdir -p "$O";export HOME=/root;. <home>/.cargo/env
{ echo "library $(git -C "$R/library" rev-parse HEAD)"; nproc; } > "$O/identity.txt"
step() { local n="$1"; shift; local s=$SECONDS; "$@" > "$O/$n.log" 2>&1 < /dev/null; echo "$n rc=$? $((SECONDS-s))s" >> "$O/steps.txt"; }
: > "$O/steps.txt"
export DEBIAN_FRONTEND=noninteractive OPAMROOT="$R/opam" OPAMYES=1 OPAMROOTISOK=1
step apt sh -c 'apt-get update -qq && apt-get install -y -qq opam m4 pkg-config libgmp-dev zlib1g-dev z3 build-essential unzip rsync gcc-multilib'
step opam-init opam init --disable-sandboxing --bare --no-setup
step opam-switch opam switch create 4.14.2
step binsec-install sh -c 'eval $(opam env --switch=4.14.2) && opam install binsec bitwuzla unisim_archisec'
step binsec-version sh -c 'eval $(opam env --switch=4.14.2) && binsec -version && binsec -help 2>&1 | grep -i -E "checkct|sse|x86" | head -n 20'
mkdir -p "$R/p"; cd "$R/p"
cat > scan.rs <<'RS'
#![no_std]
#![no_main]
#[no_mangle] #[inline(never)]
pub extern "C" fn scan(words: *mut u32, n: usize, seed: u32) -> u32 {
    let words = unsafe { core::slice::from_raw_parts_mut(words, n) };
    let mut a = seed;
    for w in words.iter_mut() { a = a.rotate_left(5) ^ *w; *w = a; }
    a
}
#[no_mangle] #[inline(never)]
pub extern "C" fn leaky(words: *mut u32, n: usize, seed: u32) -> u32 {
    let words = unsafe { core::slice::from_raw_parts_mut(words, n) };
    let mut a = seed;
    for w in words.iter_mut() { if *w == 0x1234_5678 { break; } a = a.rotate_left(5) ^ *w; *w = a; }
    a
}
#[no_mangle] pub static mut BUF: [u32; 8] = [0; 8];
#[no_mangle] pub static mut SEED: u32 = 0;
#[no_mangle] #[inline(never)]
pub extern "C" fn main_scan() -> u32 { unsafe { scan(core::ptr::addr_of_mut!(BUF) as *mut u32, 8, SEED) } }
#[no_mangle] #[inline(never)]
pub extern "C" fn main_leaky() -> u32 { unsafe { leaky(core::ptr::addr_of_mut!(BUF) as *mut u32, 8, SEED) } }
#[no_mangle] pub extern "C" fn _start() -> ! { main_scan(); main_leaky(); loop {} }
#[panic_handler] fn panic(_: &core::panic::PanicInfo) -> ! { loop {} }
RS
step build sh -c 'rustc --edition 2021 -C opt-level=s -C panic=abort -C relocation-model=static -C link-arg=-nostdlib -C link-arg=-static -o scan.elf scan.rs && nm scan.elf | grep -E " (BUF|SEED|main_scan|main_leaky|scan|leaky|_start)$" ; nm -S scan.elf | grep -i -E "buf|seed"'
for f in scan leaky; do
cat > $f.ini <<INI
starting from <main_$f>
with concrete stack pointer
@[rsp, 8] := 0xdead00
secret global BUF, SEED
halt at 0xdead00
explore all
INI
step "ct-$f" sh -c "eval \$(opam env --switch=4.14.2) && binsec -sse -checkct -sse-script $f.ini -sse-depth 100000 scan.elf"
done
cat "$O/steps.txt"; echo "binsec experiment done" > "$O/status.txt"
JOB
