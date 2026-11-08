# Output16 integration — distinct-index contract, current `next`

[Integration PR #295](https://github.com/servil-software-factory/BLAKE3/pull/295), **not landed by Sam**. This stages the independently reviewed sixteen-lane full-round root compression from #269 before multithreading tuning. No worker count or threshold is tuned.

## Current source and contract

John chose **distinct indices** as `finalize_each`'s precondition: documented, checked in debug builds, no duplicate scan/fallback in the release path. Head **`ca36629a3cfa6a63d8c49099cebaae76756b41a9`** implements that decision on his `64ac019d` integration, retaining proof registration and the rustdoc-link correction. Positive tests cover digests, reset/key/mode preservation and unselected states; debug tests reject duplicates within/across groups. Removing the debug assertion or fast reset fails the intended test.

The old fallback proposals are **unselected**. [EARLIER-PORT.md](EARLIER-PORT.md) preserves `1d74d686`; [GUARD-ALTERNATIVE.md](GUARD-ALTERNATIVE.md) preserves `3414da90`. Their measurements and failed/positive controls are not relabelled as this version's results. John's API decision supersedes those duplicate-behavior tests; that history is retained, not hidden.

While this work ran, John landed #283/#285 on `next`. The current study therefore gates **the actual combined tree**:

| Role | Full commit |
|---|---|
| Current `next` baseline, including #283/#285 | `7ee5c1f8cfad7937fb490e6510f8f36fe5ce912f` |
| PR head, distinct-index foundation | `ca36629a3cfa6a63d8c49099cebaae76756b41a9` |
| Exact tested integration tree | **`d4f675f4967317b41546e8c8309d35eb384cbbaf`** |
| Frozen reviewed kernel/generator/theorem | `f9fcef459d9999af05765a598c9fb72f704029ff` |
| Benchmark/clocks | `9994de190259648ede82f7c5e4dbac4f1534a41d` |

`d4f675f4` is GitHub's synthetic PR merge, with verified parents `[7ee5c1f8, ca36629a]`, preserved at personal ref `evidence/sam-output16-merge-d4f675f4`. It is a reproducible test input, **not a merge into the organization's branch**. The implementation and measurements add no persistent Hasher field or API type. Native Hasher size/stride remains18,432B, alignment64; one caller owns all input/output places.

## Complete-work measurements

A timed cycle updates messages in17-byte fragments, produces their canonical digests with `finalize_each`, and resets the selected states for reuse. Construction and key/context preparation are outside; **all updates, digest production and resets are inside**.

At **1,024 states**, ns/message:

| Shape | Ice Lake before → after | EPYC9255 before → after |
|---|---:|---:|
| Plain1B | 181.0772 → **91.5479** | 74.6768 → **29.1250** |
| Plain64B | 287.8147 → **198.3636** | 106.4074 → **60.9162** |
| Plain1KiB | 3379.7417 →3349.8052, **Level** | 1818.8775 →1779.9037, **Level** |
| Mixed-mode varied lengths | 1764.0612 →1714.4107, **Level** | 934.2656 →**894.2409, Faster** |

One-byte-message package energy is **19225.4225→9723.6837nJ** on Ice and **5393.9863→2189.2793nJ** on EPYC, both Faster. RAPL includes package idle/background energy; this is complete-cycle package cost, not isolated compression energy. The varied EPYC wall gain does **not** imply an energy gain: package energy there is Level.

Four fresh build/layout pairs alternate adjacent old/new order, using shared `clocks::summary`, **3% practical margin /5% FDR**. Across85 shape/count combinations (2/16/17/64/1024 states, empty/fixed/varied lengths and independent plain/keyed/derived modes), five metrics per cell:

| Comparison | Faster | Level | Slower |
|---|---:|---:|---:|
| Ice Lake current baseline→integration | 254 |171 |**0** |
| EPYC current baseline→integration |257 |168 |**0** |
| Ice integration→same integration |0 |425 |**0** |

Busy windows are forbidden for this probe. These are **direct current-tree comparisons**, not products of old ratios or evidence for every library workload. In particular, this individual-update probe does not measure #271's grouped-update mechanism, which follows next. No gain from an earlier source is substituted for a Level cell here.

## Startup resources, explicitly retained

Ice Lake, four build/layout pairs,32 fresh process launches per side total:

| First initialize | Baseline → integration | Judgment |
|---|---:|---|
| Wall ns |77980.2500 →77849.0312 |Level |
| Process CPU ns |78356.1875 →78773.4062 |Level |
| Cycles |110685.9375 →115476.2812 |Level |
| Instructions |82246.8438 →95132.6875 |**Slower,+15.7%** |

All already-initialized metrics are Level; same-source startup A/A has **all8 judgments Level**. Level is not equal cost; no startup-energy claim is made. The implementation retains runtime startup coverage for the new reachable kernel. Assigned [#268](https://github.com/servil-software-factory/BLAKE3/issues/268) owns the accepted original approximately5µs startup tradeoff and this exact-source instruction-work follow-up. Owner judgment is requested; no global Pareto claim or weakened self-test.

## Validation and scope

- Fresh pinned preflight and independent targets: **224 release tests on Ice /199 on ARM**, **21 docs each**, formatting/no-default/warnings-denied rustdoc pass. Kernel, generator and theorem bytes agree with frozen f9.
- Two debug precondition tests and the release reset test pass. Dropping the precondition makes both debug `should_panic` tests fail; dropping reset fails its intended release assertion. Not compile failures.
- The current merged-tree assembled theorem passes1210 full-round steps and rejects all four fault controls (`output16-distinct-proof-ice-20261108T031526-9e466c02`). This proves the compression/ABI/bounds, **not the Rust selector**. No full proof campaign is claimed.
- John's rebased foundation had independent VM/Mac gates; fresh combined-tree ARM validation above is correctness/build coverage, not native ARM performance. The prior `3414`→`64ac` compiled-code identity remains historical, not a compiled-code claim about this new merged tree.
- The retired sources' broader canonical checks passed both stages, including64 suspect pairs; those are **not claimed for this source**. The current handoff is the exact-source native/complete-cycle/A-A/cost gate John requested. Integration review remains his.

## Raw records and continuation

`distinct-runs/` contains the current merged-tree records; scripts/manifests are alongside this report. `integration-runs/` belongs to the unselected fallback source, and the other run directories to the earlier port. Failed borrow/rustdoc/setup/unsupported-point cases are preserved. Their reports identify the boundaries. Compiled executables and files≥20MB are omitted.

All reported execution uses pinned-run with full immutable sources/instrument hashes, fresh private checkouts/targets and host lock before preparation through verification, followed by canonical fetched reviews. Original frozen optimization heads remain unchanged. John has supplied the rebased #271/#274/#277/#281 stack; each stage gets its own identity and measurements. Finish-only, sparse, occasional-use, instruction and package costs stay beside complete-work gains.

No organization merge/release/tag/crate upload was performed by Sam.

— Sam Shackleton
