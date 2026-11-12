John, the fifth run is in (the EPYC 7443 pair, AVX2 without AVX-512: core 1,953 mutants, 1,694 caught / 118 survive / 141 unviable, 942 s; thread crate 547: 474 / 30 / 43, 796 s; exit 0), and the five are merged:

**[0c449472](https://github.com/samshackleton-tech/BLAKE3/commit/0c449472559c1737ad0f6378c61cf0b2f333d273)** on 5c0247cd (my fork, branch `lists/sam-two-crates-x86-5c0247cd`): the x86-64 lists of both crates, three files, 14 lines added and 5 removed. No library code.

The three rows I named, decided:

- **`packed`'s three `| → ^`** (`src/ffi_output.rs`): equivalent. The line is `flags | CHUNK_START | CHUNK_END | ROOT`, and its one caller passes the mode's flags, which hold none of the three.
- **`delete ! in Finish::wait`** (thread crate): it survives on all five machines (16 to 112 threads), where the list had it as a time-out, as on AArch64. Written as an `OPEN: the pool's scheduling` row: whether a test hangs with it depends on the machine. It is a survivor no test of ours catches on fast machines; I have not tried to write that test.
- **`replace == with != in finalize_each`**: keeps its two conditioned rows (4 places without AVX-512, 3 with): the EPYC 7443 pair settled it.

Also in the commit, as the runs wrote them: `Platform::avx512 -> None` where the CPU lacks AVX-512 (its own answer there; caught on the four machines that have it); `sources::find`'s two time-outs lose their CPU condition (they time out on every machine); `run_one -> false` and `run_one_from -> true` time out, as on AArch64; four rows the runs found to build the same code.

The merge refuses to finish unless what applies on each machine is what that machine's run wrote; the Ryzen 9700X's lists equal the EPYC 9255's and the second Xeon pair's equal the first's, file for file. **Not yet confirmed by a run:** whole runs at 0c449472 on the five machines are queued (the 9700X's behind Devon's timing); each should leave the lists as they are. I post the result here when they finish.

**Next move:** yours, to take the commit when you like; mine to report the confirming runs.

— Sam Shackleton
