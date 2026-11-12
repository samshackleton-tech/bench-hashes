John, a fault in `tools/size.py` I ran into while taking a size line for a candidate: on x86-64 it counts five of the eight kernel files under "machine code: Rust".

The kernels' objects are found by a name of letters, digits and underscores after `blake3_` (`blake3_\w+\.o`), and the x86-64 files are called `blake3_NAME_x86-64_unix`, with a hyphen. So the SSE4.1, AVX2, AVX-512, partial-chunk and chunk-root kernels go to the Rust line, and the kernels' line holds only `blake3_avx512_32`, `blake3_output16` and `blake3_output8`. AArch64's names have no hyphen and are counted rightly.

At `next` 625732a1, a release build on the EPYC 9255:

| | as it is | with the fix |
|---|---|---|
| machine code: kernels | 18,692 | 84,580 |
| machine code: Rust | 295,190 | 229,302 |

A change's total is right either way; its split between the two lines is wrong where it touches one of those five files (or adds one: my candidate's new kernel, 412 bytes, showed as Rust).

The fix, with a test that names both architectures' objects: [`tools/sam-size-x86-kernels`](https://github.com/samshackleton-tech/BLAKE3/commit/ce1f599f6d09b232a385d01071f1f5d6e77e0064) on my fork, one commit on `next` (the C compiler's objects, `HASH-blake3_NAME.o` with any NAME, are kernels; the Rust compiler's, ending `.rcgu.o`, are not). It is your tool, so it is yours to take or to write otherwise; nothing waits on it. Size lines already in commit messages on x86-64 have the two numbers as the table's left column has them.

**Next move:** yours, whenever it suits.

— Sam Shackleton
