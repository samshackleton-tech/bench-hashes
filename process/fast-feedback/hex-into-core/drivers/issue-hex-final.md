John: this is the piece you named on #370 when you closed it ("your kernel, proved as assembled, is the next step for this call when its source, its compiler and its proof are in the tree"), now on 0.9's `next`. It is yours to take, change or refuse; nothing else of the experiment (#361) is offered with it.

**The candidate: `candidate/sam-hex-proved`, one commit `cb613e4d` on `next` 918921dc.**

**What it changes**
- `Hash::to_hex` calls a kernel of vector instructions on each architecture (x86-64: SSE2, 45 instructions; AArch64: NEON, 27) into a buffer and makes the string from it. No arithmetic is left behind a `cfg`: the assembly is always built where the crate builds.
- `c/blake3_hex_x86-64_unix.S`, `c/blake3_hex_aarch64.S` are printed from `tools/verify/hex/hex.ode`; `check-shipped.sh` (python3, under a second, a step of `tools/check-builds.sh`) fails if either side changes without the other.
- `tools/verify/hex/` holds the source, the printer, the contract (`spec/`, 3 files, naming no machine), the two machines' proofs and audits, and a README saying what is claimed, what is not and what is trusted. `prove.sh` goes from the source to checked theorems: minutes, meant for a release and a nightly job, not for every change.

**What is proved, of the instructions as assembled**
- One contract for both: the 64 bytes at `out` become the hexadecimal of the 32 at `hash`, which are unchanged; nothing else is written.
- An observer of addresses and control flow sees the same whatever the hash is.
- x86-64: `hex_meets_bytes`, on a model in the folder (435 lines). AArch64: `hex_neon_meets`, `hex_neon_quiet`, `hex_neon_observed`, on Google DeepMind's `arm64-semantics`, unchanged, fetched at a named commit (nothing of theirs is copied).
- Not proved: an instruction's own time (the vendors' DIT and DOIT are the promise there); that `to_hex` passes the right addresses (Rust's, and the tests'); on x86-64 the instruction table is my script's reading of `llvm-objdump`, not Lean's. Axioms beyond Lean's three: `bv_decide`'s, 5 and 8.

**What a call takes** (single runs through the library, a million hashes agreeing with the arithmetic first; inventory, not judged timing)

| machine | `next` (0.9's arithmetic) | the candidate |
|---|---|---|
| EPYC 9255 | 6.52 ns | 2.78 ns |
| Ryzen 9700X | 5.20 ns | 2.40 ns |
| a Neoverse virtual server | 8.22 ns | 6.91 ns |
| Apple M6 | 1.81 ns | **2.70 ns** |

**On the M6 it is slower by 0.9 ns a call**: the compiler makes inline vector code of the arithmetic that is as fast as the kernel alone, and the kernel adds a call and a copy. A measured regression; Sam (The User) accepts it in principle for the proof's sake; the library's cost is yours to weigh. If it weighs too much, AArch64 can keep the arithmetic and x86-64 take the kernel: say so and I make that candidate. The README has what was tried (not zeroing the buffer, `#[inline]`, a `tbl` kernel: 10.3 to 6.9 ns on the Neoverse, 3.35 to 2.70 on the M6).

**Size** (`tools/size.py`, in the commit message for both architectures): compiled Rust 1,856 bytes less on x86-64 and 546 less on AArch64; kernels 412 and 108 more; 10 mutants fewer; no public item; `tools/` 4,429 lines more (the folder).

**Checks at `cb613e4d`**
- The gate (format, the suites, doc tests, the test vectors, `check-builds.sh`, the tools' tests, the change's mutation check and `--every-mutant`): every step passes on the EPYC 9255, a Xeon 6330 pair and the ARM virtual server. (The ARM server could not pass `check-builds.sh` before today: it had no C compiler for x86-64. It has one now.)
- CI: run 43387027505, 12 jobs, all green.
- The Apple M6 (the runner's jobs): tests passed; the change's mutation check: no new survivor; `check` over every cell against `next`: no regression (36 minutes).
- `bench-hashes check` against `next` (bench ef57976d): no regression on the EPYC 9255 and the Ryzen 9700X (the points list of #344), and on the ARM virtual server over every cell. `to_hex` is not a cell of the benchmark: the table above is the measurement of the call itself.
- `tools/verify/hex/prove.sh` from nothing, on a 64-thread machine: both architectures checked, their audits' changes refused.

**What it commits us to: nothing.** This is an experiment's first piece inside the crate. Taking it promises no one that `tools/verify/hex`, the language, its printer or the proofs stay supported or unchanged; the kernels can be replaced by the arithmetic again in one commit, and I would say so in the changelog's line if you want one.

**Yours to decide**
1. Take it, take it for x86-64 only, or not.
2. Whether `prove.sh` joins `release-check.py` and a nightly job (my proposal), and on which machine (it needs Lean through `elan`, a C compiler, `llvm-objdump`; about a minute for x86-64, 8 for AArch64 on 64 threads, 27 on a 4-CPU AArch64 machine).
3. Whether `#[inline]` on `to_hex` stays (one line; without it 3.24, 3.09, 7.87 and about 2.9 ns in the table's order).

— Sam Shackleton
