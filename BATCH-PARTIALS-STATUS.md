**Stacked on #259; own delta starts at `1fb068fe`.** This draft is ready for integration review with an accepted, tracked Zen 3 performance tradeoff. John owns API/design and integration decisions.

## Fixed-length batches finish their partial last blocks in SIMD lanes

`performance::hash_many*` previously handled x86 partial-final-block messages one at a time. This adapter reuses #259’s full-round finishing kernels for complete native groups: eight AVX2 or sixteen AVX-512 messages, lengths 1–1024 not divisible by 64. Smaller remainders retain their existing route. Established whole-block paths remain separate.

A `Batch` already owns zero-padded slots. The adapter borrows those final blocks, saving redundant padding and payload copies. A full AVX-512 group writes directly to the caller’s sixteen digests. Standard BLAKE3 digests, flags and keyed semantics are preserved. The public API and assembly remain unchanged.

## Measured time and energy savings

Direct paired study **`1fb068fe` → `8f3c06bd`**, four independent builds per version, alternating runs, 162 fixed-length/count cells per host, shared clocks judgments at 3% margin / 5% FDR. Ready input construction is outside timing. Library padding handling, compression and canonical digest stores are inside, with official-reference output checks.

At **1,024 ready messages**:

| CPU / message length | Old ns/item | New ns/item | New/old package energy |
|---|---:|---:|---:|
| 9700X / 1 B | 70.48 | 5.13 | 0.078 |
| 9700X / 65 B | 108.98 | 9.61 | 0.095 |
| 9700X / 1023 B | 976.58 | 73.32 | 0.081 |
| EPYC 9255 / 1 B | 89.11 | 6.33 | 0.075 |
| Ice Lake / 1 B | 109.78 | 18.88 | 0.174 |
| Zen 3 / 1 B | 74.32 | 15.86 | 0.226 |
| Zen 3 / 1023 B | 931.35 | 192.30 | 0.216 |

Across the four warm matrices: **280 faster / 367 Level / 1 slower** cells. Process CPU is recorded separately. RAPL is whole-package energy, including background/idle costs.

These custom matrices exercise single-threaded `performance::hash_many`. Partial-length multithreaded performance remains a review scope for this shared adapter.

## Accepted Zen 3 cost and follow-up

Zen 3 **1024 B × 8** is about **3.1% slower**: 183.31 → 188.93 ns/message, roughly 45 ns per eight-message batch. Sam The User accepted that localized cost on November 6 because the larger partial-block benefits outweigh it.

**[Issue #263](https://github.com/servil-software-factory/BLAKE3/issues/263)** tracks diagnosis, assigned to Sam Shackleton. It collects the exact reproduction, raw wall/CPU/cycle/energy data, reverted attempts and controlled branch-counter profiling. Integration review can proceed while that issue remains open.

The condition-reordering and dispatch-isolation experiments were reverted after their results failed to earn their added complexity. Current **`8eba67f5` has the exact Git tree of measured `8f3c06bd`**, checked by tree-object equality. Timing records retain the measured identity.

## Correctness and verification

Fresh `8eba67f5` gates are VERIFIED: **188/188 on each of four x86 hosts, 158/158 on ARM VM**, plus no-default builds, doctests and warnings-denied rustdoc on all five.

Assembly verification covers 32 equal-ending and 32 independently symbolic mixed-ending cases, with planted-fault controls. ABI inspections, official-reference answers, guard pages and deterministic entry-membership tests check the Rust adapter. Batch’s safe API protects zero padding; input extent is checked in every build.

[Source/gate note](https://github.com/samshackleton-tech/bench-hashes/blob/22e403d493d40eca4f77d96c1203031b2a912903/MINIMAL-BATCH-8EBA67F5.md) and [complete retained measurements](https://github.com/samshackleton-tech/bench-hashes/tree/22e403d493d40eca4f77d96c1203031b2a912903/batch-runs) include gap workloads, startup studies, per-cell costs and earlier attempts. The source/gate note predates the user’s acceptance; #263 records the current decision.

— Sam Shackleton
