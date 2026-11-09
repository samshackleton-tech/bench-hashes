# Independent-key integration: current-source minimal port

## Current checkpoint,04:12UTC

Personal candidate **69d9256b2ef3e0f14d0477bc0221c9498ae6cd6e**, `candidate/sam-independent-next`, minimally ports the existing independent-key backend onto reviewed next6eefdc65 plus its ordinary security tests. John has been asked to confirm the base; this remains a personal proposed-base draft, not an owner-selected shipping composition. Core/ring/stream/API files stay unchanged. First-chunk gathering and widened finalization are omitted.

**Direct preservation comparison against old fast nexta930b4c1:** plain18Level/shared-key14Level on each x86 host, no Slower in any of320cycle+320update+256finish judgments/host. Shared-cycle means Ice99.4–101.0% /EPYC99.3–102.5% of old; Level is not exact equality. Distinct/mixed gains do not waive common-workload costs.

**Direct recovery comparison against secure singleton6eefdc65:** shared-key14Faster each, cycle wall -3.2–8.2%Ice/-4.3–14.1%EPYC; plain18Level each; no Slower metric/phase. AA69d9256b has896Level each host. Frozen shared sampler3a0595df/clocks9994de19, fourfreshpairedlayouts/all64shapes/API_FAMILY=next. `timing-summary.tsv` and raw judgments give every phase/mode; ratios are not composed with released-main or other-source results.

**Quality is not a wholly green runner result:**234tests/22docs, builds and four rejecting/restored controls pass; final full change mutation106/no new survivor/57s onEPYC. The outer quality wrapper then fails on its own generated `?? tmp/` directory. That is the second setup failure after a control-driver anchor fix, so the quality item is stopped without another green-seeking rerun. Initial9bdfe0e9's missing narrow-startup work coverage/equivalent-flag metadata and227s mutation failure are retained. See [VALIDATION.md](VALIDATION.md) for exact sources, evidence and stops. Assembly proofs/eight controls/model cross-check passed on9bdfe0e9 and carry to69d9256b only through explicitly identical complete proof inputs/driver.

**Canonical gate is active:**69d9256b against old fasta930b4c1, frozenbench7ea20449,25namedplainpoints onIce/EPYC, default4layouts/full64pairconfirmation. No result inferred before completion. Startup cost is still open: initialization is outside calibration/cost counters, and earlier startup acceptance does not quantify this source. PhysicalAVX2/nativeARM/owner-selected composition/release acceptance remain separate.

**ARM work requested by John is ready, counting only:** [ARM-WORK.md](ARM-WORK.md). Test child5dcaff05, existing observers/meters, exactoldselector/restoration, separate rentedNEONVM. At512equal-key states/32KiB: allocation requests76→9240, cohort passes2→1024, requested bytes1,375,872→1,228,736. More requests, not more total bytes. Native SME2 execution and recovery remain John's; no new ARM timing or assembly.

## Completed independent safety prerequisite

John requested the following test-only children in #312 comment6730719183 during his separate native timing work. Sam's base request is6730811369; safety handoff6730982769; ARM/counting ack6731362729. These safety children remain independent of the optimization.

| Reviewed safety source | Personal test-only child | Branch | Native quality |
|---|---|---|---|
| Main7b1ba7b9da67e61dd53010de2054edfa32035170 | **100b494fbf8def2dcc258bb036aee0b65cd4c548** | test/sam-prefix-controls-released | EPYC190release tests,19runnable docs+1compile-fail |
| Next6eefdc657effe6002f9a001fccac9306699b3911 | **94ccdee88932148798d25e2907d37e1ed3789ff7** | test/sam-prefix-controls-next | Ice231release tests,21runnable docs+1compile-fail |

These port the previously reviewed4f9b6bb3 tests without production hashing changes. Each adds141lines in `src/each.rs` and `tests/allocations.rs`. Cohort trace is cfg(test); kernel-entry observation reuses the existing RAN_ENTRIES set. Calling-thread allocation bytes/requests use the existing thread-local allocator meter; a4096B/one-request positive control checks it. No worker caps, test serialization, new kernel observer, timing thresholds or library API changes.

`held_dispatch_ignores_key_equality_and_prefixes`: fixed public shapes, equal keys versus exactly0–7matching leading32bitwords, counts3/8/16/17/33, allkeyed/fixedmixedmodes, two16KiB stages/zero+nonzero chunk counters, every locally supported platform. Capture cohort membership/order, existing kernel-entry sets and HeldPass counts before finalization/oracle; check official digests afterward.

`held_allocations_ignore_key_equality_and_prefixes`: non-test library code, same key/public-shape matrix, caller key/constructor/capacity setup outside counters, actual library bytes/requests inside. Official1.8.7 digests afterward.

Both pinned quality jobs pass fmt, no-default-feature release build and warnings-denied rustdoc. Every test runs through nextest; docs through cargo test --doc. Both jobs are runner VERIFIED. No setup failure or retry. Separate rented x86 hosts ran concurrently under their machine locks; no ARM VM or native Mac work and no timing jobs by Sam.

## Rejecting controls

The exact executing `safety-controls.sh` and per-fault patches/restorations accompany the runs. Each valid fault is applied through exact atomic replacement, tested, restored byte-for-byte, and the three positive tests run again. Final git status is empty.

1. Secret-equality cohorts restored: both fail the dispatch-independence assertion onSSE41,n=3,allkeyed,prefix7. No invalid task or memory reference is constructed.
2. Secret-last-word-dependent32B allocation: both fail allocation-independence atn=3,prefix7; two stages add64B/two requests.
3. Secret-last-word-dependent valid AVX2 rather than AVX512 route: both fail onAVX512,n=3,prefix7. The change leaves cohort membership/pass counts alone; it is rejected by existing kernel-entry observation, not a second observer.

Original distinct/equal600-hasher tests remain in the suite. Test-only changes require no performance or assembly-proof rerun: production code is removed by cfg or resides in the separate integration test binary. Mutation of production behavior is not added by these children; rejecting controls demonstrate these tests' reach directly.

These are work-structure regression tests, not a formal constant-time proof: entry sets do not record every invocation or full instruction trace, and unused comparisons can evade them. Scope is native x86; earlier ARM tests on other sources are not relabelled as validation of these children.

Runs:
- safety-prefix-main-x86-20261109T023727-b685582b (EPYC)
- safety-prefix-next-x86-20261109T023730-538d2604 (Ice)

## Integration boundary

The user wants the existing independent-key implementation integrated and plain/shared-key performance retained. John owns the base/integration and nativeARM design. The draft uses reviewed next6eefdc65 provisionally; owner confirmation/safety-composed successor remains pending. Organization next was5d966a0c9f2f1f53bc53a266e7913addcb936873 at refresh, and #323 open at6eefdc65. The draft does not assume this reviewed next source contains the separate ring correction.

The minimum backend prerequisites appear narrower than the historical optimization stack: output8 registration, existing output16 raw-CV mode, per-message held-parent descriptors, public plain-mode fast path, startup/guard/security tests and proof registration. First-chunk gathering/grouped-finalization changes, old ring/protocol code and unrelated proof/mutation-driver rewrites should stay out unless demonstrated necessary. Reuse existing code; no second backend/new assembly design. Do not merge historicalb817ac85 wholesale over current safety fixes.

The direct results above belong only to the named personal draft and the stated machines/scopes. Canonical completion, a clean outer quality-run protocol result, startup cost, nativeARM speed and owner-selected integration/release acceptance remain open. The released7b1ba7b9 shared-key/finish costs remain the separate exact-source findings in the released-bundle report. Nothing merged, released, tagged, uploaded, yanked or advised by Sam.
