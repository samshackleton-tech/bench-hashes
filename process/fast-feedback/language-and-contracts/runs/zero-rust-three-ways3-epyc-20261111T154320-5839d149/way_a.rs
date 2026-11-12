// Printed from Lean (Lang.lean). Not written or edited by hand.
#![no_std]
#![allow(unused_parens)]
#[repr(C, align(16))]
pub struct Aligned<const N: usize>([u8; N]);
#[no_mangle]
#[allow(unused_mut, unused_assignments, unused_parens, unused_variables)]
pub unsafe extern "C" fn a_push(mut st: u64, mut cv: u64) -> u64 {
    let mut len: u64 = 0;
    len = (core::ptr::read_unaligned((st) as *const u64) as u64);
    if len < 55u64 {
    } else {
        core::arch::asm!("ud2", options(noreturn));
    }
    core::ptr::copy_nonoverlapping((cv) as *const u8, (((st).wrapping_add(32u64)).wrapping_add(((len) << 5))) as *mut u8, 32);
    core::ptr::write_unaligned((st) as *mut u64, ((len).wrapping_add(1u64)) as u64);
    0u64
}
extern "C" {
    fn blake3_servil_compress_in_place_avx512(a0: u64, a1: u64, a2: u64, a3: u64, a4: u64);
    fn blake3_servil_compress_in_place_sse41(a0: u64, a1: u64, a2: u64, a3: u64, a4: u64);
}
#[no_mangle]
#[allow(unused_mut, unused_assignments, unused_parens, unused_variables)]
pub unsafe extern "C" fn a_merge(mut st: u64, mut key: u64, mut flags: u64, mut plat: u64, mut target: u64) -> u64 {
    let mut len: u64 = 0;
    let mut pf: u64 = 0;
    let mut at: u64 = 0;
    let mut block_store = core::mem::MaybeUninit::<Aligned<64>>::uninit();
    let block: u64 = block_store.as_mut_ptr() as u64;
    let mut cv_store = core::mem::MaybeUninit::<Aligned<32>>::uninit();
    let cv: u64 = cv_store.as_mut_ptr() as u64;
    len = (core::ptr::read_unaligned((st) as *const u64) as u64);
    pf = ((flags) | (4u64));
    while target < len {
        if len < 2u64 {
            core::arch::asm!("ud2", options(noreturn));
        } else {
        }
        at = ((st).wrapping_add(32u64)).wrapping_add((((len).wrapping_sub(2u64)) << 5));
        core::ptr::copy_nonoverlapping((at) as *const u8, (block) as *mut u8, 64);
        core::ptr::copy_nonoverlapping((key) as *const u8, (cv) as *mut u8, 32);
        if plat == 5u64 {
            blake3_servil_compress_in_place_avx512(cv, block, 64u64, 0u64, pf);
        } else {
            blake3_servil_compress_in_place_sse41(cv, block, 64u64, 0u64, pf);
        }
        core::ptr::copy_nonoverlapping((cv) as *const u8, (at) as *mut u8, 32);
        len = (len).wrapping_sub(1u64);
        core::ptr::write_unaligned((st) as *mut u64, (len) as u64);
    }
    len
}
#[no_mangle]
#[allow(unused_mut, unused_assignments, unused_parens, unused_variables)]
pub unsafe extern "C" fn a_to_hex(mut out: u64, mut hash: u64) -> u64 {
    let mut i: u64 = 0;
    let mut b: u64 = 0;
    i = 0u64;
    while i < 32u64 {
        b = (*(((hash).wrapping_add(i)) as *const u8) as u64);
        *(((out).wrapping_add(((i) << 1))) as *mut u8) = (((((b) >> 4)).wrapping_add(48u64)).wrapping_add((((0u64).wrapping_sub((((((b) >> 4)).wrapping_add(6u64)) >> 4))) & (39u64)))) as u8;
        *((((out).wrapping_add(((i) << 1))).wrapping_add(1u64)) as *mut u8) = (((((b) & (15u64))).wrapping_add(48u64)).wrapping_add((((0u64).wrapping_sub((((((b) & (15u64))).wrapping_add(6u64)) >> 4))) & (39u64)))) as u8;
        i = (i).wrapping_add(1u64);
    }
    64u64
}
