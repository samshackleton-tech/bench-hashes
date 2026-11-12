// Printed from Lean (Lang.lean). Not written or edited by hand.
#![no_std]
#![allow(unused_parens)]
#[repr(C, align(16))]
pub struct Aligned<const N: usize>([u8; N]);
extern "C" {
    fn blake3_servil_compress_in_place_avx512(a0: u64, a1: u64, a2: u64, a3: u64, a4: u64);
    fn blake3_servil_compress_in_place_sse41(a0: u64, a1: u64, a2: u64, a3: u64, a4: u64);
    fn blake3_servil_hash_many_avx512(a0: u64, a1: u64, a2: u64, a3: u64, a4: u64, a5: u64, a6: u64, a7: u64, a8: u64, a9: u64);
    fn blake3_servil_hash_many_avx2(a0: u64, a1: u64, a2: u64, a3: u64, a4: u64, a5: u64, a6: u64, a7: u64, a8: u64, a9: u64);
    fn blake3_servil_hash_many_sse41(a0: u64, a1: u64, a2: u64, a3: u64, a4: u64, a5: u64, a6: u64, a7: u64, a8: u64, a9: u64);
    fn blake3_servil_avx512_k32(a0: u64, a1: u64, a2: u64, a3: u64, a4: u64, a5: u64);
    fn blake3_servil_avx512_p16(a0: u64, a1: u64, a2: u64, a3: u64, a4: u64, a5: u64);
}
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
#[no_mangle]
#[allow(unused_mut, unused_assignments, unused_parens, unused_variables)]
pub unsafe extern "C" fn a_hash(mut out: u64, mut input: u64, mut len: u64, mut key: u64, mut flags: u64, mut plat: u64) -> u64 {
    let mut p: u64 = 0;
    let mut rem: u64 = 0;
    let mut counter: u64 = 0;
    let mut n: u64 = 0;
    let mut i: u64 = 0;
    let mut tc: u64 = 0;
    let mut top: u64 = 0;
    let mut first: u64 = 0;
    let mut f: u64 = 0;
    let mut j: u64 = 0;
    let mut lastp: u64 = 0;
    let mut pf: u64 = 0;
    let mut slen: u64 = 0;
    let mut t: u64 = 0;
    let mut done: u64 = 0;
    let mut kp: u64 = 0;
    let mut pp: u64 = 0;
    let mut st_store = core::mem::MaybeUninit::<Aligned<1792>>::uninit();
    let st: u64 = st_store.as_mut_ptr() as u64;
    let mut cvs_store = core::mem::MaybeUninit::<Aligned<1024>>::uninit();
    let cvs: u64 = cvs_store.as_mut_ptr() as u64;
    let mut par_store = core::mem::MaybeUninit::<Aligned<512>>::uninit();
    let par: u64 = par_store.as_mut_ptr() as u64;
    let mut ptrs_store = core::mem::MaybeUninit::<Aligned<256>>::uninit();
    let ptrs: u64 = ptrs_store.as_mut_ptr() as u64;
    let mut block_store = core::mem::MaybeUninit::<Aligned<64>>::uninit();
    let block: u64 = block_store.as_mut_ptr() as u64;
    let mut cv_store = core::mem::MaybeUninit::<Aligned<32>>::uninit();
    let cv: u64 = cv_store.as_mut_ptr() as u64;
    let mut pcv_store = core::mem::MaybeUninit::<Aligned<32>>::uninit();
    let pcv: u64 = pcv_store.as_mut_ptr() as u64;
    p = input;
    rem = len;
    counter = 0u64;
    slen = 0u64;
    done = 0u64;
    pf = ((flags) | (4u64));
    if plat == 5u64 {
        kp = ((flags) | (1073873152u64));
        pp = ((pf) | (1073741824u64));
        while 32768u64 < rem {
            i = 0u64;
            while i < 32u64 {
                core::ptr::write_unaligned(((ptrs).wrapping_add(((i) << 3))) as *mut u64, ((p).wrapping_add(((i) << 10))) as u64);
                i = (i).wrapping_add(1u64);
            }
            blake3_servil_avx512_k32(ptrs, 16u64, key, counter, kp, cvs);
            i = 0u64;
            while i < 16u64 {
                core::ptr::write_unaligned(((ptrs).wrapping_add(((i) << 3))) as *mut u64, ((cvs).wrapping_add(((i) << 6))) as u64);
                i = (i).wrapping_add(1u64);
            }
            blake3_servil_avx512_p16(ptrs, 1u64, key, 0u64, pp, par);
            i = 0u64;
            while i < 8u64 {
                core::ptr::write_unaligned(((ptrs).wrapping_add(((i) << 3))) as *mut u64, ((par).wrapping_add(((i) << 6))) as u64);
                i = (i).wrapping_add(1u64);
            }
            blake3_servil_hash_many_avx512(ptrs, 8u64, 1u64, key, 0u64, 0u64, pf, 0u64, 0u64, cvs);
            i = 0u64;
            while i < 4u64 {
                core::ptr::write_unaligned(((ptrs).wrapping_add(((i) << 3))) as *mut u64, ((cvs).wrapping_add(((i) << 6))) as u64);
                i = (i).wrapping_add(1u64);
            }
            blake3_servil_hash_many_avx512(ptrs, 4u64, 1u64, key, 0u64, 0u64, pf, 0u64, 0u64, par);
            i = 0u64;
            while i < 2u64 {
                core::ptr::write_unaligned(((ptrs).wrapping_add(((i) << 3))) as *mut u64, ((par).wrapping_add(((i) << 6))) as u64);
                i = (i).wrapping_add(1u64);
            }
            blake3_servil_hash_many_avx512(ptrs, 2u64, 1u64, key, 0u64, 0u64, pf, 0u64, 0u64, cvs);
            i = 0u64;
            while i < 1u64 {
                core::ptr::write_unaligned(((ptrs).wrapping_add(((i) << 3))) as *mut u64, ((cvs).wrapping_add(((i) << 6))) as u64);
                i = (i).wrapping_add(1u64);
            }
            blake3_servil_hash_many_avx512(ptrs, 1u64, 1u64, key, 0u64, 0u64, pf, 0u64, 0u64, par);
            t = par;
            tc = (((counter) >> 5)).wrapping_add(1u64);
            while ((tc) & (1u64)) == 0u64 {
                slen = (slen).wrapping_sub(1u64);
                top = ((st).wrapping_add(32u64)).wrapping_add(((slen) << 5));
                core::ptr::copy_nonoverlapping((top) as *const u8, (block) as *mut u8, 32);
                core::ptr::copy_nonoverlapping((t) as *const u8, ((block).wrapping_add(32u64)) as *mut u8, 32);
                core::ptr::copy_nonoverlapping((key) as *const u8, (pcv) as *mut u8, 32);
                if plat == 5u64 {
                    blake3_servil_compress_in_place_avx512(pcv, block, 64u64, 0u64, pf);
                } else {
                    blake3_servil_compress_in_place_sse41(pcv, block, 64u64, 0u64, pf);
                }
                core::ptr::copy_nonoverlapping((pcv) as *const u8, (t) as *mut u8, 32);
                tc = ((tc) >> 1);
            }
            core::ptr::copy_nonoverlapping((t) as *const u8, (((st).wrapping_add(32u64)).wrapping_add(((slen) << 5))) as *mut u8, 32);
            slen = (slen).wrapping_add(1u64);
            p = (p).wrapping_add(32768u64);
            rem = (rem).wrapping_sub(32768u64);
            counter = (counter).wrapping_add(32u64);
        }
    } else {
    }
    while 1024u64 < rem {
        n = ((rem) >> 10);
        if 16u64 < n {
            n = 16u64;
        } else {
        }
        i = 0u64;
        while i < n {
            core::ptr::write_unaligned(((ptrs).wrapping_add(((i) << 3))) as *mut u64, ((p).wrapping_add(((i) << 10))) as u64);
            i = (i).wrapping_add(1u64);
        }
        if plat == 5u64 {
            blake3_servil_hash_many_avx512(ptrs, n, 16u64, key, counter, 1u64, flags, 1u64, 2u64, cvs);
        } else {
            if plat == 4u64 {
                blake3_servil_hash_many_avx2(ptrs, n, 16u64, key, counter, 1u64, flags, 1u64, 2u64, cvs);
            } else {
                blake3_servil_hash_many_sse41(ptrs, n, 16u64, key, counter, 1u64, flags, 1u64, 2u64, cvs);
            }
        }
        p = (p).wrapping_add(((n) << 10));
        rem = (rem).wrapping_sub(((n) << 10));
        i = 0u64;
        while i < n {
            t = (cvs).wrapping_add(((i) << 5));
            tc = ((counter).wrapping_add(i)).wrapping_add(1u64);
            done = 0u64;
            if rem == 0u64 {
                if (i).wrapping_add(1u64) == n {
                    done = 1u64;
                } else {
                }
            } else {
            }
            if done == 1u64 {
                core::ptr::copy_nonoverlapping((t) as *const u8, (cv) as *mut u8, 32);
            } else {
                while ((tc) & (1u64)) == 0u64 {
                    slen = (slen).wrapping_sub(1u64);
                    top = ((st).wrapping_add(32u64)).wrapping_add(((slen) << 5));
                    core::ptr::copy_nonoverlapping((top) as *const u8, (block) as *mut u8, 32);
                    core::ptr::copy_nonoverlapping((t) as *const u8, ((block).wrapping_add(32u64)) as *mut u8, 32);
                    core::ptr::copy_nonoverlapping((key) as *const u8, (pcv) as *mut u8, 32);
                    if plat == 5u64 {
                        blake3_servil_compress_in_place_avx512(pcv, block, 64u64, 0u64, pf);
                    } else {
                        blake3_servil_compress_in_place_sse41(pcv, block, 64u64, 0u64, pf);
                    }
                    core::ptr::copy_nonoverlapping((pcv) as *const u8, (t) as *mut u8, 32);
                    tc = ((tc) >> 1);
                }
                core::ptr::copy_nonoverlapping((t) as *const u8, (((st).wrapping_add(32u64)).wrapping_add(((slen) << 5))) as *mut u8, 32);
                slen = (slen).wrapping_add(1u64);
            }
            i = (i).wrapping_add(1u64);
        }
        counter = (counter).wrapping_add(n);
    }
    if done == 0u64 {
        core::ptr::copy_nonoverlapping((key) as *const u8, (cv) as *mut u8, 32);
        first = 1u64;
        while 64u64 < rem {
            f = ((flags) | (first));
            if plat == 5u64 {
                blake3_servil_compress_in_place_avx512(cv, p, 64u64, counter, f);
            } else {
                blake3_servil_compress_in_place_sse41(cv, p, 64u64, counter, f);
            }
            first = 0u64;
            p = (p).wrapping_add(64u64);
            rem = (rem).wrapping_sub(64u64);
        }
        if rem == 64u64 {
            lastp = p;
        } else {
            core::ptr::write_unaligned(((block).wrapping_add(0u64)) as *mut u64, (0u64) as u64);
            core::ptr::write_unaligned(((block).wrapping_add(8u64)) as *mut u64, (0u64) as u64);
            core::ptr::write_unaligned(((block).wrapping_add(16u64)) as *mut u64, (0u64) as u64);
            core::ptr::write_unaligned(((block).wrapping_add(24u64)) as *mut u64, (0u64) as u64);
            core::ptr::write_unaligned(((block).wrapping_add(32u64)) as *mut u64, (0u64) as u64);
            core::ptr::write_unaligned(((block).wrapping_add(40u64)) as *mut u64, (0u64) as u64);
            core::ptr::write_unaligned(((block).wrapping_add(48u64)) as *mut u64, (0u64) as u64);
            core::ptr::write_unaligned(((block).wrapping_add(56u64)) as *mut u64, (0u64) as u64);
            j = 0u64;
            while j < rem {
                *(((block).wrapping_add(j)) as *mut u8) = ((*(((p).wrapping_add(j)) as *const u8) as u64)) as u8;
                j = (j).wrapping_add(1u64);
            }
            lastp = block;
        }
        f = ((((flags) | (first))) | (2u64));
        if slen == 0u64 {
            f = ((f) | (8u64));
        } else {
        }
        if plat == 5u64 {
            blake3_servil_compress_in_place_avx512(cv, lastp, rem, counter, f);
        } else {
            blake3_servil_compress_in_place_sse41(cv, lastp, rem, counter, f);
        }
        if slen == 0u64 {
            core::ptr::copy_nonoverlapping((cv) as *const u8, (out) as *mut u8, 32);
        } else {
        }
    } else {
    }
    if slen != 0u64 {
        t = cv;
        while 1u64 < slen {
            slen = (slen).wrapping_sub(1u64);
            top = ((st).wrapping_add(32u64)).wrapping_add(((slen) << 5));
            core::ptr::copy_nonoverlapping((top) as *const u8, (block) as *mut u8, 32);
            core::ptr::copy_nonoverlapping((t) as *const u8, ((block).wrapping_add(32u64)) as *mut u8, 32);
            core::ptr::copy_nonoverlapping((key) as *const u8, (pcv) as *mut u8, 32);
            if plat == 5u64 {
                blake3_servil_compress_in_place_avx512(pcv, block, 64u64, 0u64, pf);
            } else {
                blake3_servil_compress_in_place_sse41(pcv, block, 64u64, 0u64, pf);
            }
            core::ptr::copy_nonoverlapping((pcv) as *const u8, (t) as *mut u8, 32);
        }
        pf = ((pf) | (8u64));
        top = ((st).wrapping_add(32u64)).wrapping_add(((0u64) << 5));
        core::ptr::copy_nonoverlapping((top) as *const u8, (block) as *mut u8, 32);
        core::ptr::copy_nonoverlapping((t) as *const u8, ((block).wrapping_add(32u64)) as *mut u8, 32);
        core::ptr::copy_nonoverlapping((key) as *const u8, (pcv) as *mut u8, 32);
        if plat == 5u64 {
            blake3_servil_compress_in_place_avx512(pcv, block, 64u64, 0u64, pf);
        } else {
            blake3_servil_compress_in_place_sse41(pcv, block, 64u64, 0u64, pf);
        }
        core::ptr::copy_nonoverlapping((pcv) as *const u8, (out) as *mut u8, 32);
    } else {
    }
    0u64
}
