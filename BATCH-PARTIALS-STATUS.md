**Draft, stacked on #259; own delta starts at `1fb068fe`. Not ready for integration.** Keeps #259 frozen for independent review. No public API change, merge or release requested.

## What changes

The fixed-length `performance::hash_many*` API still hashed x86 messages with partial final blocks one at a time. This adapter reuses #259’s full-round finishing kernels for complete native groups: eight AVX2 or sixteen AVX-512 messages, lengths 1–1024 not divisible by 64. Smaller remainders retain their existing route. Established whole-block paths, including the fast 64-byte batch kernel, remain separate.

The custom timing matrices below exercise single-threaded `performance::hash_many`. This shared adapter also serves pool pieces, but partial-length multithreaded performance is still an outstanding scope—not supplied by the earlier whole-block macro controls.

A validated `Batch` already owns zero-padded slots. The adapter borrows those final blocks rather than padding/copying the payload again; a full AVX-512 group writes directly to the caller’s sixteen digests. No new assembly, instruction semantics, heap allocation, clock guess or reduced-round construction. Standard BLAKE3 digests, flags and keyed semantics remain unchanged.

## Measured benefit, with exact source boundaries

The direct paired study **`1fb068fe` → `8f3c06bd`** used four independent build layouts, alternating runs, 162 fixed-length/count cells, and shared `clocks` judgments (3% margin / 5% FDR). Input construction was excluded for every contender; library padding handling, compression and canonical digest stores were timed. Every answer was independently reference-checked.

At 1,024 ready messages:

| CPU / message length | Old ns/item | New ns/item | New/old package energy |
|---|---:|---:|---:|
| 9700X / 1 B | 70.48 | 5.13 | 0.078 |
| 9700X / 65 B | 108.98 | 9.61 | 0.095 |
| 9700X / 1023 B | 976.58 | 73.32 | 0.081 |
| EPYC 9255 / 1 B | 89.11 | 6.33 | 0.075 |
| Ice Lake / 1 B | 109.78 | 18.88 | 0.174 |
| Zen 3 / 1 B | 74.32 | 15.86 | 0.226 |
| Zen 3 / 1023 B | 931.35 | 192.30 | 0.216 |

RAPL is **whole-package energy**, including background/idle costs, not incremental core-only energy. These ready, equal-length batches are not a universal workload or fastest-SHA claim. Existing whole-block 64 B batch speed is not a new gain attributed to this PR.

## Unresolved warm-path blocker

The `8f3c06bd` matrix holds on 9700X, EPYC and Ice Lake, but flags an unchanged Zen 3 **1024 B × 8** route at **+3.1%**. Reordering the partial-length check (`83cc613b`) still flags it at about +3.0%.

The dispatch-isolation experiment, `e2df3c4b`, passes 188 native Zen 3 tests but instead flags unchanged **512 B × 8 at +6.1%**, with similar CPU, cycles and package-energy costs. The former 1024 B cell is no longer flagged. Instructions are essentially level. This did not earn its extra wrapper/control-flow complexity, so **both isolation and condition-reordering experiments were reverted**, not promoted.

Current head **`8eba67f5` has the exact Git tree of measured `8f3c06bd`**, checked with tree-object equality. It is the simpler borrowed adapter, with no claimed fix for its warm blocker. Fresh correctness/build runs under the current identity are VERIFIED on all five hosts: 188/188 on each of four x86 machines and 158/158 on the ARM VM, plus no-default builds, doctests and warnings-denied rustdoc. Timing records retain the measured `8f3c06bd` identity; tree equality is not a newly measured timing result.

The large partial-block gains do **not** average away an intended-pattern regression. The `8f3c06bd` shared-path scoped controls hold on all four hosts, but its warm 1024 B × 8 loss remains explicit. Timing alone has not established a cache, aliasing or code-placement cause; neither loss has been called a false positive.

## Cold/misuse and startup costs stay visible

A separate official `clocks` gap study at `8f3c06bd` used 1 ms idle gaps or busy-code/128 MiB walks, retaining ready batch bytes. Zen 3’s 50 cells hold. The 9700X has five slower busy/small cells, up to about 42%: the performance API’s inappropriate cold pattern under #253. Those costs are retained, not omitted. Wall and hardware counts were recorded; gap-study process CPU and package energy are **NA**, not inferred.

An earlier non-borrowed adapter had no measured extra startup cost versus `1fb068fe` in its fresh-process study (~29.5 µs on 9700X, instructions level). That is **not an exact startup claim for the current head**.

## Correctness and proof boundary

- At `8f3c06bd`: 188 native tests pass on 9700X and Zen 3, 158 on the ARM VM; no-default builds, doctests and warnings-denied rustdoc pass. ARM is correctness/build evidence only. Current `8eba67f5` additionally passes fresh 188-test gates on all four x86 hosts and 158 on ARM VM, with the same build/doc gates. The retired `e2df3c4b` experiment’s separate Zen 3 record remains retained.
- A deterministic membership test checks that the finishing entry actually ran around native-width boundaries and remainders, and reference-checks every output. No timing/load-based assertion.
- Borrowed-ABI tests inspect actual pointers, prefix/last lengths, common key/mode, scratch and direct output before assembly runs. Input length is checked in every build; debug checks enforce the zero-padding invariant protected by `Batch`’s safe API.
- Assembly is unchanged from #259, with its 32 equal-ending and 32 independently symbolic mixed-ending proof cases and fault controls. This is **not a formal proof of the new Rust adapter**.

[Immutable raw evidence and retained trials at `4b682a05`](https://github.com/samshackleton-tech/bench-hashes/blob/4b682a057035d1b65838382fdf10395eae9890b3/BATCH-PARTIALS-STATUS.md), under `batch-runs/`, with scripts/manifests. The snapshot has 5,165 files / 21,779,396 bytes; remote paths and sizes verified, binaries omitted. Earlier small-cell losses and rejected attempts remain alongside later results. No padding/layout magic or CPU-specific timing threshold was added to hide them.

Owner: Sam Shackleton. John retains API/design and integration decisions.

— Sam Shackleton
