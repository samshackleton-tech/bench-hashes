# Minimal next port: source, validation and retained stops

## Candidate boundary

Personal **69d9256b2ef3e0f14d0477bc0221c9498ae6cd6e**, `candidate/sam-independent-next`, proposed base reviewed next **6eefdc657effe6002f9a001fccac9306699b3911**, with ordinary security-test child94ccdee8 and test-first6502f1f3. John has been asked to confirm the integration base; no response selecting it yet. This source does not assume the separate ring fix is in its base and is not a shipping safety composition.

First runtime9bdfe0e97a2f8ad98870ef593322632090c9e326 ports the existing cd2880f1 backend minimally. Final child69d9256b removes repeated startup predicates, covers lower-platform startup and updates explained equivalent-flag mutation rows. No new x86 assembly design: output8/output16 bytes match cd2880f1 exactly. Root flags now belong explicitly to descriptors so the same existing output16 entry emits parent CVs too; Input layout stays24bytes. Private Params8 is the existing384byte/64aligned ABI, with compile-time offsets/size checks.

Only backend prerequisites are imported: output8 generator/build/proof/model registration; output16 raw-CV flags; per-message held-parent routing; startup/guard tests. No first-chunk gather, widened finalize_each, core/Hasher/ring/stream/API/state/worker changes. finalize_each retains its sixteen-lane-only dispatch and next reset semantics. Current Counted::HeldPass=5/OutputGroupTurn=4/TLS6 and RAN_ENTRIES are reused; no old slot collision or second kernel observer.

Plain turns select the existing shared-IV cohort by public flags. AVX2/AVX512 keyed/mixed turns use each message's own key/flags in existing descriptors; real8tails/scalar remainder are retained. SSE/NEON/SME2 retain reviewed public-mode singleton fallback. Thus correct portable fallback is present, not native ARM speed recovery.

New pieces relative to6eefdc65 earn their place by making this backend executable/testable: private Params8/entry and generic8or16 wrapper, held-parent traversal/two private vectors, startup/guard checks and proof registration. All are reused from reviewed prior implementation, not new public concepts or persistent state. Plain/ARM shared-cohort body remains intact; no speculative cleanup.

## Executed gates

- Test-first6502f1f3: new independent-pass test rejects the existing singleton remedy (nextest100, key-independent passes), pinnedrunindependent-next-test-first-20261109T024918-b9a0850c VERIFIED. This is an intended red, not a compiler/setup failure.
- 9bdfe0e9:233release/22docs, fmt/no-default/warnings-denied rustdoc and four exact rejecting/restored controls pass onIce. The quality job **FAILED** at mutation, not waived below.
- 69d9256b:234release/22docs and build/fmt/rustdoc pass onEPYC. Four controls reject secret equality routing, secret-dependent allocation, secret-dependent alternate valid kernel and restored singleton routing; source restored byte-for-byte, positives rerun.
- 69d9256b full change mutation: **106mutants, no new survivor,57s within60s onEPYC**. Raw outcomes/tests/diffs/logs retained. **Outer runner still FAILED** at final scratch-directory assertion; do not report this job VERIFIED or a wholly green quality gate.

### Original mutation failure and response

9bdfe0e9 / independent-next-quality-ice-20261109T030827-45aecb8c:108mutants; new surviving names self_test &&→|| (two places), held_groups |→^ (one), input |→^ (one beyond existing count),227s/60s. Runtime tests were green but this mutation gate was red.

For self_test, AVX2 selection was tested only through native AVX512 startup. Repeated && conditions could execute an unnecessary second8-lane check or misreport family count onAVX2. Removed repeated predicates/early-returned after the selected8family, and exercised self_test on every supported platform. No counter/observer was added.

OR/XOR cases are mathematically equivalent under documented mode/structural masks: mode0/16/32/64 never overlaps START1/END2/ROOT8 or PARENT4. Existing input row now counts3; held_groups row1 added; fixture shape row accounts for its two disjoint ORs. These are explained equivalents, not live behavioral survivors accepted for convenience. No functional mutant was listed away. Exact failure/corrective diffs retained; a full mutation gate is not replaced by a focused green run.

### Proofs

9bdfe0e9 / independent-next-proofs-epyc-20261109T030828-19b408c7 VERIFIED: both output proofs and four fault controls each, cache-input unit tests and native instruction-model cross-check pass. Assembly/proof-input tree and executing driver are byte-identical on69d9256b; `proof-carry.json` records the full tree and paired hashes. This is explicit carry-over, not relabelled execution or a rerun. No whole long-proof/status claim, Rust selection proof or whole-library constant-time claim.

## Setup and artifact stops (kept separate from library failures)

1. On69d9256b, quality2-epyc passes234tests/docs/builds then stops in the control driver: its four-space substring for `let width=lanes(platform)` also matched the new test's more-indented line. One repair anchors the complete production width/return-false block. Original driver archived asintegration-quality-v2.sh; corrected executing driver as-v3.sh.
2. Quality3-epyc then passes all controls and106mutation checks/57s, but final `git status --porcelain` is `?? tmp/`: the mutator created its own retained raw diagnostics. The wrapper incorrectly requires no generated untracked artifacts. **This is the second setup failure; this quality item is stopped, no fourth attempt or status-only green rerun.** Tracked source/control restores are intact. A later owner-controlled validation should distinguish generated diagnostics from source changes; no further wrapper repair applied this session.
3. Original mutation raw recovery: SFTP timed out after90s copying many small files. Partial copy is private duplicate material, not complete evidence. A pinned read-only recovery job validates original9bdfe0e9 identity and copies all retainedmutants-last files without rerunning tests: independent-next-recover-mutation-20261109T033231-8b6d75d9 VERIFIED. Its original-final-git-status also names onlytmp/. Complete raw recovery accompanies the original FAILED run.
4. Canonical launch prevalidation initially rejects an empty contains[] rule, before starting either remote job. Invalid manifests retained. One repair removes that redundant rule; wrapper still records actual exit0/1/2. No measurements or pairs were retried for this local validation error.

These stops are not counted as caught mutants, speed verdicts, or accepted costs. No test serialization, worker caps, shortened confirmation or failure suppression.

## Timing interpretation

One frozen shared sampler3a0595df (paired hashes in instrument manifest), clocks9994de19, API_FAMILY=next, all64shapes, fourfreshpairedlayouts, no extra finalize reset. AA on69d9256b has320cycle+320update+256finish Level each host. Direct comparisons are separate:
- recovery:6eefdc65→69d9256b;
- preservation:a930b4c1→69d9256b (old fast key-equality source, next API on both).

No ratios composed across these baselines or released-main/API families. Every accepted executable must report quiet load; busy abstentions/failures remain raw. Finish energyNA. Constructors/key/input/caller-capacity setup outside counters; refill/library allocation/updates/digests/reset inside complete cycles. Entry sets and digest tests are not constant-time proofs.

The named canonical25point gate is directlya930b4c1→69d9256b with frozenbench7ea20449, both hosts; default4layouts and full64pairconfirmation retained. Not every point, not physicalAVX2 or nativeARM. At this checkpoint canonical runs are active; inspect their actual check-exit/log, not VERIFIED alone.

**Startup remains an explicit open cost:** both entries receive the mandatory startup self-test; the matrix/canonical calibration excludes initialization. Earlier accepted startup costs do not quantify this source. No unsupported no-startup-regression claim or ad hoc legacy startup timing was added. NativeARM recovery, physicalAVX2, owner-selected composition and release acceptance remain separate.
