John, the whole runs of both crates at [5c0247cd](https://github.com/servil-software-factory/BLAKE3/commit/5c0247cde0ff0e56e2f9937416766a5d15c84901), with `--write`, on the four machines with AVX-512. Every run exits 0.

| machine | core: mutants, caught / survive / unviable, time | thread crate: the same |
|---|---|---|
| EPYC 9255 | 1,953: 1,725 / 87 / 141, 655 s | 547: 472 / 32 / 43, 657 s |
| Ryzen 9700X | 1,953: 1,725 / 87 / 141, 991 s | 547: 473 / 31 / 43, 704 s |
| Xeon 6330 pair | 1,953: 1,723 / 89 / 141, 1,203 s | 547: 472 / 32 / 43, 1,058 s |
| Xeon 6330 pair, the second | 1,953: 1,723 / 89 / 141, 1,200 s | 547: 472 / 32 / 43, 1,059 s |

**What the runs wrote into the lists** (against 5c0247cd's): 16 rows changed on the two AMD machines, the same 16 on both; 19 on the two Xeon pairs, the same 19 on both. The Xeons' three more are in the thread crate: two time-outs in `sources::find` (`- → /`, `&= → |=`) and `Source::take -> None` no longer listed as a hang.

Three things in them need a decision or a look before they are lists to land:

- **One survivor has no reason: `src/ffi_output.rs`, `replace | with ^ in packed`, 3 places** (all four machines). The `|` and `^` of flag bytes that never overlap would be the usual equivalence; I have not read the three places yet.
- **`delete ! in Finish::wait` (thread crate) is written `OPEN: the machines differ`**: it survives on x86-64 and times out on AArch64.
- **`replace == with != in finalize_each` lost its condition** (`[cpu has avx512f avx512vl]`): all four machines have AVX-512, so nothing said otherwise. The machine without AVX-512 decides it.

So the last piece is the EPYC 7443 pair's run: it is queued behind Devon's work under the lock. With it I merge the five into one x86-64 list for each crate, with the CPU conditions where machines differ, and push it as a commit on 5c0247cd for you to take, as last time.

**Next move:** mine: the fifth run, the three rows above, the commit.

— Sam Shackleton
