**Draft, stacked on #259; own delta starts at1fb068fe.** No merge/release or public API change. Keeps #259 frozen for its independent review.

## The opportunity

The fixed-length `performance::hash_many*` API still handled x86 messages with a partial final block one at a time. The new #259 kernels already prove the required full-round operation. This routes full native groups (8AVX2/16AVX512), lengths1..1024 not divisible by64, through their equal-ending entry. Smaller remainders keep their existing route. Existing whole-block paths, including the very fast64B batch kernel, stay separate.

A validated Batch already owns zero-padded slots. The adapter borrows those final blocks instead of zeroing/copying them again; AVX512's full group writes directly to the caller's16digests. No new assembly, instruction semantics, clock guess, round reduction or heap allocation. Counter remains zero, common key/mode, standard digests.

## Exact measured scope—not a universal win claim

Whole-source paired study1fb068fe→**8f3c06bd**, four distinct layouts/alternating runs,162equal-length/countcells (18lengths ×9counts), clocks3%margin/5%FDR. Input construction excluded for every contender; padding handling/compression/canonical digest stores timed. All answers independently reference-checked.

At1,024ready messages:

|CPU / length|old ns/item|new ns/item|new/old package energy|
|---|---:|---:|---:|
|9700X1B|70.48|5.13|0.078|
|9700X65B|108.98|9.61|0.095|
|9700X1023B|976.58|73.32|0.081|
|EPYC9255 1B|89.11|6.33|0.075|
|IceLake1B|109.78|18.88|~0.174|
|Zen3 1B|74.32|15.86|0.226|
|Zen3 1023B|931.35|192.30|0.216|

Whole-package RAPL includes background/idle costs, not incremental core-only energy. No specialized-SHA universal claim is made here. Existing whole-block64B batch speed is not a new gain attributed to this PR.

**Unresolved intended-pattern blocker:** 8f3's matrix holds on9700X/EPYC/IceLake, but Zen3 flags whole1024B ×8 **+3.1%** on an unchanged route. Checking partial length before other conditions (83cc613b) still flags that cell~+3.0%. I have NOT averaged that loss against the large partial-block gains. The current head isolates the new dispatch from the established implementation/frame; native188passes, but its Zen3 paired study still flags one unchanged whole512B ×8cell **+6.1%** (1024B ×8is no longer flagged). This is not claimed as a fix, and the moving unchanged-path loss has not been called a false positive or given a timing-only cache/layout explanation. This draft is **not ready for integration** until intended-pattern losses are resolved and current-head shared-path checks are read.

## Cold/misuse and startup are reported too

Official clocks gaps (1msidle and busy-code+128MiBwalk) at8f3: Zen3's50cells hold;9700X has five slower busy-small cells, up to~42% (performance API's inappropriate cold pattern under #253). Those costs remain in the record, not omitted. Cold processCPU/package-energy are unavailable at useful interval resolution; wall and hardware counts are recorded, not invented.

The earlier non-borrowed route has no measured extra startup cost versus1fb in its fresh-process study (~29.5us9700X, instructions level). That is not an exact startup claim for the current head.

## Correctness and contract

- Native188/188 on9700X/Zen3 at8f3,158/158ARMVM, no-default builds, doctests and warnings-denied rustdoc. Current dispatch-isolation head passes188nativeZen3 tests; the earlier8f3tree has the listed cross-platform records. ARM is correctness/build evidence only.
- A deterministic membership test asks whether the finishing entry actually ran around native-width boundaries, including remainders, and checks every output against the independent official reference. No timing/load-based test.
- Borrowed ABI tests inspect actual pointers, stride/prefix/last lengths, common key/mode, scratch and direct output before assembly runs. Input length is checked in every build; debug checks the Batch invariant that padding is zero. Batch's safe API protects that padding.
- Reuses #259's unchanged assembly and its32equal+32independently symbolic-ending proofs and fault controls. No claim of a new formal proof of the Rust adapter.

The earlier inline adapter's two small9700X losses, and the later unchanged-route Zen3 loss, are retained alongside the corrected attempts. No padding/layout magic or clock-based dispatch was added to hide them.

— Sam Shackleton
