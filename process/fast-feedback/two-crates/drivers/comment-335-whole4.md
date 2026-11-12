John, the whole mutation runs of `trial/two-crates-squashed` at cb03835c, on three x86-64 machines (single executions: inventory, no speed verdict). Two things are yours to take or decide; the rest waits for the trial's rebase onto `next`.

**1. The thread crate's whole run stops at once: 72 rows of its lists name mutants the source no longer has** (59 of `src/stream.rs`, 13 of `src/lanes.rs`; over all three architectures' lists), since the GPU's code left the tree. A commit that removes exactly those rows, as a change's check with `--write` would: [ded60a04](https://github.com/samshackleton-tech/BLAKE3/commit/ded60a04f7c70d7e694f402ad034e61482b86fdb), branch `lists/sam-trial-stale-rows` on my fork, on top of cb03835c. Please take it into the trial.

With it the thread crate runs whole: 548 mutants, 472 caught, 33 survive, 43 unviable; 718 s on the EPYC 9255 host, 736 s on the Ryzen 9700X. Against the x86-64 lists the run adds 17 rows and drops 14, all in `src/lanes.rs`, the same on both machines. One is unclassified and yours: `delete ! in sources::Source::take_claimed` stops the clock in `stream::test::a_publication_never_meets_a_claimed_uncopied_task` (a time-out).

**2. The core: one new survivor without a reason, yours to decide.** `src/each.rs`: `replace prepare_thread with ()`. The storage it reserves is then made at first use, and no test of the core sees the difference.

The core's run otherwise: 1,902 mutants, 1,662 caught, 101 survive, 139 unviable (one more survives on the Xeon 6330 pair); 784 s on the EPYC 9255 host, 1,073 s on the 9700X, 1,543 s on the Xeons. Its x86-64 list lacks 63 rows that `next` has since #362 (the x86-only functions' same-code rows of `src/each.rs` and `src/self_test.rs`, mostly), lacks four more that the run classifies by itself as the same code (two in `hash_all_at_once`, two of `Platform::neon`), and carries 11 whose mutants are now caught or gone. The 63 come with the rebase: #362, #365 and #366 are on `next` and not in the trial. When the trial is on `next`, I run both crates on four machines and land the lists as the runs write them.

**Next move:** yours (the commit, the two rows).

— Sam Shackleton
