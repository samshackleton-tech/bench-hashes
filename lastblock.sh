#!/bin/bash
# BLAKE3 #247's ceiling (run lastblock): a probe, not for merging, of hashing many short messages of mixed
# lengths with every block side by side, last blocks included (AVX2, 8 lanes, each lane its own chaining
# value, lengths and flags), against servil's hash_each by blocks (#249's branch) and SHA-256; one
# thread on CPU 2; every digest checked against official BLAKE3. 3 runs.
set -u
R="$1"; O="$R/out"; mkdir -p "$O"; cd "$R"
export HOME=/root; . /root/.cargo/env
{ uname -a; nproc; grep -m1 'model name' /proc/cpuinfo; grep -o -w -m1 -E 'sha_ni' /proc/cpuinfo; rustc --version; echo "servil $(git -C servil rev-parse HEAD)"; } > "$O/machine.txt"
mkdir -p probe/src
cat > probe/Cargo.toml <<TOML_END
[package]
name = "lastblock"
version = "0.1.0"
edition = "2021"
[dependencies]
blake3 = "=1.8.7"
sha2 = "=0.11.0"
blake3-servil = { path = "$R/servil" }
TOML_END
cat > probe/src/main.rs <<'RS_END'
//! Probe for BLAKE3 #247 (not for merging): the ceiling of hashing many short messages of mixed lengths
//! (each up to a chunk) with every block side by side, last blocks included: 8 lanes (AVX2), each lane its
//! own message, chaining value, block lengths and flags; a lane whose message has ended keeps its value
//! (blend). Messages sorted by their block count, taken 8 at a time. Every digest checked against
//! official BLAKE3. One thread. Compared with servil's hash_each (by blocks, #249's branch) and SHA-256.
use core::arch::x86_64::*;
use blake3_servil::{Mode, performance::Block};
use sha2::Digest;

const IV: [u32; 8] = [0x6A09E667, 0xBB67AE85, 0x3C6EF372, 0xA54FF53A, 0x510E527F, 0x9B05688C, 0x1F83D9AB, 0x5BE0CD19];
const MSG_SCHEDULE: [[usize; 16]; 7] = [
    [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15],
    [2, 6, 3, 10, 7, 0, 4, 13, 1, 11, 12, 5, 9, 14, 15, 8],
    [3, 4, 10, 12, 13, 2, 7, 14, 6, 5, 9, 0, 11, 15, 8, 1],
    [10, 7, 12, 9, 14, 3, 13, 15, 4, 0, 11, 2, 5, 8, 1, 6],
    [12, 13, 9, 11, 15, 10, 14, 8, 7, 2, 5, 3, 0, 1, 6, 4],
    [9, 14, 11, 5, 8, 12, 15, 1, 13, 3, 0, 10, 2, 6, 4, 7],
    [11, 15, 5, 0, 1, 9, 8, 6, 14, 10, 2, 12, 3, 4, 7, 13],
];
const CHUNK_START: u32 = 1;
const CHUNK_END: u32 = 2;
const ROOT: u32 = 8;

#[inline(always)]
unsafe fn add(a: __m256i, b: __m256i) -> __m256i { _mm256_add_epi32(a, b) }
#[inline(always)]
unsafe fn xor(a: __m256i, b: __m256i) -> __m256i { _mm256_xor_si256(a, b) }
#[inline(always)]
unsafe fn rot16(x: __m256i) -> __m256i { _mm256_shuffle_epi8(x, _mm256_set_epi8(13, 12, 15, 14, 9, 8, 11, 10, 5, 4, 7, 6, 1, 0, 3, 2, 13, 12, 15, 14, 9, 8, 11, 10, 5, 4, 7, 6, 1, 0, 3, 2)) }
#[inline(always)]
unsafe fn rot12(x: __m256i) -> __m256i { _mm256_or_si256(_mm256_srli_epi32(x, 12), _mm256_slli_epi32(x, 20)) }
#[inline(always)]
unsafe fn rot8(x: __m256i) -> __m256i { _mm256_shuffle_epi8(x, _mm256_set_epi8(12, 15, 14, 13, 8, 11, 10, 9, 4, 7, 6, 5, 0, 3, 2, 1, 12, 15, 14, 13, 8, 11, 10, 9, 4, 7, 6, 5, 0, 3, 2, 1)) }
#[inline(always)]
unsafe fn rot7(x: __m256i) -> __m256i { _mm256_or_si256(_mm256_srli_epi32(x, 7), _mm256_slli_epi32(x, 25)) }

#[inline(always)]
unsafe fn g(v: &mut [__m256i; 16], a: usize, b: usize, c: usize, d: usize, x: __m256i, y: __m256i) {
    v[a] = add(add(v[a], v[b]), x);
    v[d] = rot16(xor(v[d], v[a]));
    v[c] = add(v[c], v[d]);
    v[b] = rot12(xor(v[b], v[c]));
    v[a] = add(add(v[a], v[b]), y);
    v[d] = rot8(xor(v[d], v[a]));
    v[c] = add(v[c], v[d]);
    v[b] = rot7(xor(v[b], v[c]));
}

/// 8 lanes' blocks (each 64 bytes) to 16 vectors of message words, word i of every lane in m[i].
#[inline(always)]
unsafe fn load_transposed(blocks: &[*const u8; 8]) -> [__m256i; 16] {
    let mut m = [_mm256_setzero_si256(); 16];
    for half in 0..2 {
        let mut r = [_mm256_setzero_si256(); 8];
        for lane in 0..8 {
            r[lane] = _mm256_loadu_si256(blocks[lane].add(32 * half) as *const __m256i);
        }
        // 8x8 transpose of 32-bit words.
        let t0 = _mm256_unpacklo_epi32(r[0], r[1]); let t1 = _mm256_unpackhi_epi32(r[0], r[1]);
        let t2 = _mm256_unpacklo_epi32(r[2], r[3]); let t3 = _mm256_unpackhi_epi32(r[2], r[3]);
        let t4 = _mm256_unpacklo_epi32(r[4], r[5]); let t5 = _mm256_unpackhi_epi32(r[4], r[5]);
        let t6 = _mm256_unpacklo_epi32(r[6], r[7]); let t7 = _mm256_unpackhi_epi32(r[6], r[7]);
        let u0 = _mm256_unpacklo_epi64(t0, t2); let u1 = _mm256_unpackhi_epi64(t0, t2);
        let u2 = _mm256_unpacklo_epi64(t1, t3); let u3 = _mm256_unpackhi_epi64(t1, t3);
        let u4 = _mm256_unpacklo_epi64(t4, t6); let u5 = _mm256_unpackhi_epi64(t4, t6);
        let u6 = _mm256_unpacklo_epi64(t5, t7); let u7 = _mm256_unpackhi_epi64(t5, t7);
        m[8 * half] = _mm256_permute2x128_si256(u0, u4, 0x20);
        m[8 * half + 1] = _mm256_permute2x128_si256(u1, u5, 0x20);
        m[8 * half + 2] = _mm256_permute2x128_si256(u2, u6, 0x20);
        m[8 * half + 3] = _mm256_permute2x128_si256(u3, u7, 0x20);
        m[8 * half + 4] = _mm256_permute2x128_si256(u0, u4, 0x31);
        m[8 * half + 5] = _mm256_permute2x128_si256(u1, u5, 0x31);
        m[8 * half + 6] = _mm256_permute2x128_si256(u2, u6, 0x31);
        m[8 * half + 7] = _mm256_permute2x128_si256(u3, u7, 0x31);
    }
    m
}

/// Up to 8 messages of up to a chunk each, their root hashes.
#[target_feature(enable = "avx2")]
unsafe fn hash8(msgs: &[&[u8]], out: &mut [[u8; 32]]) {
    let n = msgs.len();
    let zero = [0u8; 64];
    let mut pads = [[0u8; 64]; 8];
    let mut blocks = [0usize; 8];
    for (l, m) in msgs.iter().enumerate() {
        blocks[l] = m.len().div_ceil(64).max(1);
        let last = blocks[l] - 1;
        pads[l][..m.len() - 64 * last].copy_from_slice(&m[64 * last..]);
    }
    let most = blocks[..n].iter().copied().max().unwrap();
    let mut cv: [__m256i; 8] = core::array::from_fn(|i| _mm256_set1_epi32(IV[i] as i32));
    for b in 0..most {
        let mut ptrs = [zero.as_ptr(); 8];
        let mut lens = [64i32; 8];
        let mut flags = [0i32; 8];
        let mut active = [0i32; 8];
        for l in 0..n {
            if b < blocks[l] {
                active[l] = -1;
                let last = b + 1 == blocks[l];
                ptrs[l] = if last { pads[l].as_ptr() } else { msgs[l].as_ptr().add(64 * b) };
                if last { lens[l] = (msgs[l].len() - 64 * b) as i32; }
                flags[l] = (if b == 0 { CHUNK_START } else { 0 } | if last { CHUNK_END | ROOT } else { 0 }) as i32;
            }
        }
        let m = load_transposed(&ptrs);
        let mut v = [_mm256_setzero_si256(); 16];
        v[..8].copy_from_slice(&cv);
        for i in 0..4 { v[8 + i] = _mm256_set1_epi32(IV[i] as i32); }
        v[12] = _mm256_setzero_si256(); // counter 0, low
        v[13] = _mm256_setzero_si256(); // counter 0, high
        v[14] = _mm256_loadu_si256(lens.as_ptr() as *const __m256i);
        v[15] = _mm256_loadu_si256(flags.as_ptr() as *const __m256i);
        for s in &MSG_SCHEDULE {
            g(&mut v, 0, 4, 8, 12, m[s[0]], m[s[1]]);
            g(&mut v, 1, 5, 9, 13, m[s[2]], m[s[3]]);
            g(&mut v, 2, 6, 10, 14, m[s[4]], m[s[5]]);
            g(&mut v, 3, 7, 11, 15, m[s[6]], m[s[7]]);
            g(&mut v, 0, 5, 10, 15, m[s[8]], m[s[9]]);
            g(&mut v, 1, 6, 11, 12, m[s[10]], m[s[11]]);
            g(&mut v, 2, 7, 8, 13, m[s[12]], m[s[13]]);
            g(&mut v, 3, 4, 9, 14, m[s[14]], m[s[15]]);
        }
        let mask = _mm256_loadu_si256(active.as_ptr() as *const __m256i);
        for i in 0..8 {
            cv[i] = _mm256_blendv_epi8(cv[i], xor(v[i], v[i + 8]), mask);
        }
    }
    let mut words = [[0u32; 8]; 8];
    for i in 0..8 { _mm256_storeu_si256(words[i].as_mut_ptr() as *mut __m256i, cv[i]); }
    for l in 0..n {
        for i in 0..8 { out[l][4 * i..4 * i + 4].copy_from_slice(&words[i][l].to_le_bytes()); }
    }
}

fn hash_all(msgs: &[&[u8]], order: &[usize], out: &mut [[u8; 32]]) {
    let mut group: Vec<&[u8]> = Vec::with_capacity(8);
    let mut res = [[0u8; 32]; 8];
    for idx in order.chunks(8) {
        group.clear();
        group.extend(idx.iter().map(|&i| msgs[i]));
        unsafe { hash8(&group, &mut res) };
        for (k, &i) in idx.iter().enumerate() { out[i] = res[k]; }
    }
}

fn main() {
    assert!(is_x86_feature_detected!("avx2"));
    blake3_servil::initialize();
    for &len in &[100usize, 300, 700] {
        let mut x = 777u64; let mut lens = Vec::new(); let mut total = 0;
        while total < (32 << 20) { x ^= x << 13; x ^= x >> 7; x ^= x << 17; let l = (len / 2 + (x % len as u64) as usize).min(1024); lens.push(l); total += l; }
        let data: Vec<Vec<u8>> = lens.iter().enumerate().map(|(m, &l)| (0..l).map(|i| (m * 7 + i) as u8).collect()).collect();
        let msgs: Vec<&[u8]> = data.iter().map(|d| &d[..]).collect();
        let mut out = vec![[0u8; 32]; msgs.len()];
        let mut sink = 0u8;
        let time = |f: &mut dyn FnMut()| { f(); let w = std::time::Instant::now(); f(); w.elapsed().as_nanos() as f64 / total as f64 };
        // Sorting by block count is part of the work: counted.
        let lanes = time(&mut || {
            let mut order: Vec<usize> = (0..msgs.len()).collect();
            order.sort_unstable_by_key(|&i| msgs[i].len().div_ceil(64));
            hash_all(&msgs, &order, &mut out);
            sink ^= out[0][0];
        });
        for (m, o) in msgs.iter().zip(&out) { assert_eq!(o, blake3::hash(m).as_bytes(), "{} bytes", m.len()); }
        let blocks: Vec<Vec<Block>> = data.iter().map(|d| { let mut b = vec![Block::ZERO; d.len().div_ceil(64).max(1)]; Block::bytes_mut(&mut b)[..d.len()].copy_from_slice(d); b }).collect();
        let items: Vec<(&[Block], usize)> = blocks.iter().zip(&lens).map(|(b, &l)| (&b[..], l)).collect();
        let mut out2 = vec![[0u8; 32]; items.len()];
        let each = time(&mut || { blake3_servil::performance::hash_each(Mode::Plain, &items, &mut out2); sink ^= out2[0][0]; });
        let sha = time(&mut || for m in &msgs { sink ^= sha2::Sha256::digest(m)[0]; });
        std::hint::black_box(sink);
        println!("mixed ~{len:4} B x {:7}: all blocks in lanes (AVX2, 8) {lanes:.3} ns/B | servil hash_each by blocks {each:.3} | sha256 {sha:.3}", msgs.len());
    }
}
RS_END
( cd probe && cargo build --release ) > "$O/build.log" 2>&1 || { echo "build failed" >> "$O/status.txt"; exit 2; }
for k in 1 2 3; do taskset -c 2 probe/target/release/lastblock > "$O/run-$k.txt" 2>&1; echo "run $k exit $?" >> "$O/status.txt"; done
echo "lastblock done" >> "$O/status.txt"
