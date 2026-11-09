# ARM public-mode held work: requests, cohorts and entry sets

## Question and exact sources

John #312 comment6731337336 requests work characterization before designing an ARM recovery for the native shared-key costs. This is **counting, not timing**.

Personal test-only child **5dcaff05bd90521f2f438541bcb8dc323f6fae31**, branch `test/sam-arm-held-work`, directly on94ccdee88932148798d25e2907d37e1ed3789ff7 / reviewed next6eefdc657effe6002f9a001fccac9306699b3911. Production hashing remains unchanged. The controller compares that public-mode selector with the **exact selector from a930b4c1a7ac94a77b6decd4a5bfd710391286b6**:

- empty-list guard;
- first key/flags;
- `held.iter().partition(...)` by key/flag equality;
- same `hash_cohort` body, then recursive remainder.

The controller asserts the entire body from Sme2Turn::take through take_held is byte-identical to the old source, applies only the routing substitution atomically, and restores source byte-for-byte. This control intentionally restores the known secret-dependent selector for characterization; it is not a proposed implementation or acceptable security contract.

Pinned run **arm-held-work-counts-20261109T035357-c90ea9c0**, separate rented ARM VM root@88.216.62.206, runner VERIFIED. No Sam work on John's Mac/VM, no new timing or ARM kernel. The machine supplies **NEON, not SME2**. Native SME2 observations remain for John.

## Work boundaries and observers

Plain and one equal secret key; n=1/2/8/16/17/128/512;16/32KiB messages in4KiB arrivals. Input/key/Hasher construction and caller descriptor capacity are outside allocation counters. This is update-work allocation, not process startup, constructors, complete-cycle time, peak heap or RSS. Fresh hashers' constructor storage is excluded.

- `tests/allocations.rs`: existing calling-thread BYTES/REQUESTS allocator, normal non-test library; no cohort/kernel observation allocations pollute it.
- `src/each.rs`: existing HeldPass, cfg(test) cohort trace, RAN_ENTRIES and Ran::TurnTaken; existing NEON/SME2 metadata names every observed entry. Counts before finalization/oracle.
- Both sources check all official digests. Current/old/restored variants run both ordinary tests through nextest without serializing them. Restored records match current after sorting by record identity, not process output order; restored prefix security tests pass.
- **Entry sets do not count invocations or instructions.** HeldPass counts actual hash_cohort calls; membership totals establish every held stage was observed.

## Measured requested work,32KiB/two stages

| Equal-key hashers | Old requests | Current requests | Old requested bytes | Current requested bytes | Old→current cohort passes |
|---|---:|---:|---:|---:|---|
|1|30|28|2,496|2,432|2→2|
|16|46|302|42,624|38,336|2→32|
|128|64|2,324|343,680|307,136|2→256|
|512|76|9,240|1,375,872|1,228,736|2→1,024|

Plain controls match the old selector in every recorded allocation/counter/entry-set cell. For example512plain states remain76requests/1,375,872requested bytes/two cohort passes.

The important distinction: **far more allocation requests, not more total requested bytes**. Singleton buffers are smaller and avoid growth of the large flattened refs vector. For32KiB the current equal-key request count is exactly18*n plus outer-turn/held-vector allocations in these samples: each singleton cohort creates level, refs, counters, next, halves and four parent-reference vectors (nine requests), twice per hasher. This links observed counts to source; it does not assign nanoseconds to allocations.

## NEON entries

For n>=8, the old equal-key cohort records:
`{c1, k10, k6, p8}`.

The current singleton path records:
`{c1, k1, k10, k6, p1, p2, p4, p8}`.

At n=1 both record the latter set. Plain retains the former for the large shapes. Thus the singleton route exposes narrow parent entries in addition to p8; the set alone says neither how many times each ran nor which dominated time. Every recorded case reports turn_taken=0.

## SME2: source facts, not executed measurements

In this unchanged body one cohort constructs a Sme2Turn, allocates its workspace, makes one SME2 hash_groups_at leaf call when its turn selects SME2, then four parent hash_many calls. A32KiB keyed turn therefore has2*n cohort/turn constructions rather than2. Actual SME2/NEON entry selection and dynamic call counts are not established by this NEON VM or by the entry sets. Reuse these same ordinary tests on native SME2; no new observer is needed.

Ownership: caller-thread-local counters and per-call vectors have one writer; no shared worker output was added. SME2's existing process-wide busy flag is isolated on its own128-byte-aligned object in platform.rs; the calling thread takes/releases it per cohort. The count run adds no cross-process lock/test serialization. These facts are not a timing or cache-line explanation for the native slowdown.

## Bounded next investigation for John

Counts justify testing **one reusable scratch workspace and one existing SME2 turn per public held turn**, iterating keyed groups independently. This could amortize allocation/admission while retaining key-independent work, existing kernels and public API. It is a candidate experiment, not an implemented recovery or promise: narrow-parent work may remain, hold-duration/concurrent costs need review, and native speed must be measured directly. Native independent-key parent lanes remain John's design decision. No alternate equality-leak contract or new scheduler/state/assembly proposed here.

Native command for the test child when John's quiet work permits:

`cargo nextest run --release --features serde,zeroize --lib --test allocations --nocapture -E 'test(characterize_arm_held_cohorts) | test(characterize_held_allocation_work)'`

`arm-work.sh` contains the exact old-selector comparison and restoration control; adapt its shell/environment supervision to the native runner rather than changing the Rust observers. All records and exact patches/restoration accompany this report.
