# Independent-key integration: safety-source test children

## Completed prerequisite

John requested test-only children of the reviewed safety sources in #312 comment6730719183 while his separate native timing runs use the user's three-hour quiet window. Sam's integration-base request is comment6730811369. The independent-key runtime integration has not yet been prepared or measured in this checkpoint.

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

## Next: owner-coordinated runtime integration

The user wants the existing independent-key implementation integrated and plain/shared-key performance retained. John owns the base/integration and nativeARM design. Proposed reviewed next6eefdc65 or an owner-selected successor; confirmation pending at this checkpoint. Current organization next is5d966a0c9f2f1f53bc53a266e7913addcb936873, and #323 remains open at6eefdc65. The reviewed next source is not assumed to contain the separate ring correction.

The minimum backend prerequisites appear narrower than the historical optimization stack: output8 registration, existing output16 raw-CV mode, per-message held-parent descriptors, public plain-mode fast path, startup/guard/security tests and proof registration. First-chunk gathering/grouped-finalization changes, old ring/protocol code and unrelated proof/mutation-driver rewrites should stay out unless demonstrated necessary. Reuse existing code; no second backend/new assembly design. Do not merge historicalb817ac85 wholesale over current safety fixes.

Until an integrated source exists and is checked directly, its speed, mutation budget, nativeARM portability and release acceptance are open. The released7b1ba7b9 shared-key/finish costs remain the separate exact-source findings in the released-bundle report. Nothing merged, released, tagged, uploaded, yanked or advised by Sam.
