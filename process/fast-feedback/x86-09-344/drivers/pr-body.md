The x86-64 work for 0.9 as one landing, as John asked on #304: 1cbdf5d7 carried onto today's `next` (a4095ba6), one commit, 807684c8.

**What it does.** `update_each`'s held stages of keyed, key-derivation and mixed-mode hashers hash together with a key per lane: sixteen lanes on AVX-512, eight on AVX2 (the new `c/blake3_output8.S`, with its generator and proof). Plain hashers keep the shared-key pass. Public mode and the platform choose the route; key values never decide grouping, dispatch or work (#312). 16 files, +1,809 −98, of which 1,252 are the generated assembly.

**How it was carried.** `next` already holds John's six commits of this line and the waiting list (0a91fdb7). The tree is the merge of `next` into 1cbdf5d7 (kept as c6cdbb6d on my fork): `update_turn`, `gather` and `drain` are `next`'s, `hash_held` is the candidate's, `next`'s outlasting-pieces test stands beside the candidate's pass-count tests. The assembly, generators and proof scripts are byte-for-byte 1cbdf5d7's, so its proofs' inputs are unchanged.

**Checked so far.** On an Apple M6: builds, 222 tests and the doc tests pass (the shared Rust; no x86 path runs there).

**Running now, results here when they end:** on an EPYC 9255 and an Ice Lake host (both AVX-512): format, `check-builds.sh`, the four suites, the change's mutation check with and without `--every-mutant`.

**Still to do before it lands (mine unless named):**

1. Speed, old `next` against this, on both x86 hosts, with the cells of the hold below.
2. **Hold: Ice Lake, 512 plain messages.** 1cbdf5d7's lineage measured +3.8% and +3.9% (512 × 16 and 32 KiB, plain) and +4.7% (shared) there. To be measured again on this tree; if it stands it needs a fix or an accepted-cost issue.
3. **Hold: AVX2 without AVX-512.** On the i7 twelve mutants in `src/ffi_output.rs` survive (`held_groups`, `input`, the `lanes` AVX-512 arm): the wrapper lines an AVX2 machine cannot reach. Tests or rows, my call; it needs one i7 run (Devon, #342 has the tool's side).
4. The Mac and VM regression checks CONTRIBUTING asks for.
5. A rebase after #331 and Devon's pipeline changes land.

Replaces #269, #271, #274, #277, #281, #296, #299, #301 and #304, which I am closing with a pointer here.

**Next move (Sam):** items 1 to 5; land by the end of November 12 (UTC) or say here that it moves to after 0.9.

— Sam Shackleton
