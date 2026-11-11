#![allow(dead_code)]
pub mod x86_bits {
    pub const SSE41: u8 = 2;
    pub const AVX2: u8 = 4;
    pub const AVX512: u8 = 8;
    /// AVX-512 on a CPU where the 32-input kernels pay ([`super::wide_cpu`]).
    pub const WIDE: u8 = 16;
    pub const READ: u8 = 128;
}

#[derive(Clone, Copy, Default, PartialEq, Eq, Debug)]
pub struct CpuWords {
    /// CPUID leaf 1's EAX (the family) and ECX (SSE4.1, XSAVE, OSXSAVE, AVX).
    pub leaf1_eax: u32,
    pub leaf1_ecx: u32,
    /// XCR0's low half: the register sets the OS saves. Zero where unread.
    pub xcr0: u32,
    /// CPUID leaf 7's EBX (AVX2, AVX-512 F and VL). Zero where unread.
    pub leaf7_ebx: u32,
    /// The vendor is "AuthenticAMD" (leaf 0). False where unread.
    pub amd: bool,
}

pub const fn os_saves_avx(leaf1_ecx: u32) -> bool {
    let avx = (1 << 26) | (1 << 27) | (1 << 28);
    leaf1_ecx & avx == avx
}

pub const fn features_of(words: CpuWords) -> u8 {
    use x86_bits::*;
    let mut features = READ;
    if words.leaf1_ecx & (1 << 19) != 0 {
        features |= SSE41;
    }
    if os_saves_avx(words.leaf1_ecx) {
        let (ymm, zmm) = (0b110, 0b1110_0110);
        if words.xcr0 & ymm == ymm && words.leaf7_ebx & (1 << 5) != 0 {
            features |= AVX2;
        }
        let f_vl = (1 << 16) | (1 << 31);
        if words.xcr0 & zmm == zmm && words.leaf7_ebx & f_vl == f_vl {
            features |= AVX512;
            if wide_cpu(words.amd, family(words.leaf1_eax)) {
                features |= WIDE;
            }
        }
    }
    features
}

pub const fn family(eax: u32) -> u32 {
    let base = (eax >> 8) & 0xF;
    if base == 0xF { base + ((eax >> 20) & 0xFF) } else { base }
}

pub const fn wide_cpu(amd: bool, family: u32) -> bool {
    amd && family >= 0x1A
}

