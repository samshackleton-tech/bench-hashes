# Output16 on the consuming Hasher API — integration candidate

**Not landed.** The major sixteen-lane root-compression optimization from [#269](https://github.com/servil-software-factory/BLAKE3/pull/269) now has a current-API integration candidate. It halves complete-cycle cost for many short-message groups without changing a key, counter, digest or XOF semantics. **No multithreading threshold, worker count or pool policy is tuned.** Startup work remains an explicit cost, so this is not a global Pareto claim.

## One integration source

John provided the rebased integration `64ac019d4c65767f139429170fa8b85183d10ce4`. Sam initially missed that parallel work and built a separate port; it is retired, its measurements remain separately labelled in [EARLIER-PORT.md](EARLIER-PORT.md). None are relabelled as current-source results.

Current **`3414da907a2ce49d4bedaf2fbbf6ac91c3f21cce`** is John's implementation plus two small follow-ups:

1. A test-first repeated-index correction. Current docs require output length/index bounds, and specify reset-after-finish; they do not forbid repeats. The test-only child `9790a7f6` fails on John's tip at **`repeated indices observe the earlier reset`** (nextest exit100, not compilation). The guard keeps repeated indices within a group on the existing sequential path, avoiding an API restriction. Tests also cover repeats across two full groups, empty-after-finish, keys/modes and untouched states.
2. Complete long-proof wiring: output16 generator identity/agreement and its dedicated proof command, plus disambiguation of an existing rustdoc `Hash` link so warnings-denied docs pass.

The kernel, generator and theorem remain **byte-identical** to frozen reviewed `f9fcef459d9999af05765a598c9fb72f704029ff`. The original review head is not rewritten. No Hasher field, persistent state or public API concept is added. Native Hasher size/stride is **18,432 B**, alignment64; a single caller owns all input/output places.

## Complete work, measured on this source

Each timed cycle updates messages in 17-byte fragments, produces their canonical digests through `throughput::finalize_each`, and resets them for reuse. Construction and key/context preparation are outside; **all updates, finalization and resets are inside**.

At **1,024 states**, nanoseconds per message:

| Shape | Ice Lake before → after | EPYC 9255 before → after |
|---|---:|---:|
| Plain 1 B | 181.3375 → **90.3196** | 74.8704 → **28.5237** |
| Plain 64 B | 289.1216 → **187.3929** | 106.4046 → **55.8602** |
| Plain 1 KiB | 3391.6254 → **3134.2264** | 1820.8523 → **1677.2570** |
| Mixed-mode varied lengths | 1756.3970 → **1596.8805** | 935.9888 → **844.8170** |

CPU, cycles, instructions and package energy also improve in these cells. One-byte-message package energy changes from **19260.1826→9748.6093 nJ** on Ice and **5432.1939→2121.5649 nJ** on EPYC. RAPL includes package idle/background energy; this is the complete-cycle package cost, not isolated compression energy.

Across 85 shape/count combinations (counts2/16/17/64/1024, empty/fixed/varied lengths and independent plain/keyed/derived modes), the five-metric judgments are:

| Comparison | Faster | Level | Slower |
|---|---:|---:|---:|
| Ice Lake base→candidate | 385 | 40 | **0** |
| EPYC base→candidate | 400 | 25 | **0** |
| Ice Lake candidate→same candidate | 0 | 425 | **0** |

Four fresh build/layout pairs alternate adjacent sides, using shared `clocks::summary`, **3% practical margin /5% FDR**. Busy windows are forbidden for this probe. These are direct current-API comparisons, not composed older ratios, and do not establish a gain for every library workload. Sub-width codegen can change too; timing alone does not attribute every gain to SIMD or cache effects.

## Startup cost, not hidden by the whole-work gains

Fresh-process startup on Ice, four build/layout pairs and 32 process launches per side total:

| First initialize metric | Base → candidate | Judgment |
|---|---:|---|
| Wall ns | 76771.2500 → 79056.5625 | Level |
| Process CPU ns | 77663.8438 → 79992.9375 | Level |
| Cycles | 111718.5000 → 115043.3438 | Level |
| Instructions | 82216.8125 → 95006.6250 | **Slower, +15.6%** |

First wall mean is 2.285µs higher; **Level does not establish equal cost**. Already-initialized metrics are all Level. Separate same-head startup A/A: **all eight judgments Level**. No startup energy claim is made. The retired port's +4.253µs first-wall Slower and +3.2% already-cycle Slower remain in its own report; they are not erased or attributed to this source.

The extra instruction work covers the new reachable kernel's runtime startup check. John accepted approximately5µs one-time startup cost for the original design in assigned [#268](https://github.com/servil-software-factory/BLAKE3/issues/268). This source's evidence is provided there for explicit owner judgment; the issue stays open while that accepted cost remains. No self-test is weakened to hide it.

## Quality and gate scope

- Fresh pinned preflight/Ice/ARM: **222 release tests on Ice /197 on ARM**, **21 doc examples each**, no-default build, formatting and warnings-denied rustdoc pass. Kernel/generator/proof byte agreement with the frozen source passes.
- Original integration's missing repeated-index behavior has a retained FAILED test-first record. Corrected tests pass; removing reset or bypassing duplicate detection each fails the intended assertion. Across-group repeats exercise sequential resets while retaining eligible vector groups.
- Full-round symbolic proof: **1210 steps**, arbitrary per-lane CV/block/length/flags; four fault controls rejected. This proves the assembled compression/ABI/bounds, **not the new Rust selector**.
- Canonical AArch64 comparison with John's `64ac019d` reports **the same compiled benchmark code**. John's already-completed VM/Mac gates therefore carry; no ARM VM native-speed claim or redundant Mac run is needed.
- A broader canonical x86 check on **this source** is running as `output16-integration-canonical-epyc-20261108T023806-7e8b3dfe`. It retains the standard four-pair and automatic64-pair suspect stages over eight applicable points:64B,idle64B,1KiB,1MiB,interleaved256,turn256,idleturn256,briefidleturn256. **No verdict yet.** Controlled-idle turn256 is unavailable: this host's cpuidle driver is `none`, with zero state-disable controls; that point is explicitly recorded, not counted as passed.

## Identities and raw records

| Role | Full commit |
|---|---|
| Current API baseline | `597581e963b3b6a2eb3df96234339a99aec274cd` |
| John's rebased foundation | `64ac019d4c65767f139429170fa8b85183d10ce4` |
| Test-first child | `9790a7f62d36d7763d68d84e8a4e8188db85e0ac` |
| Corrected integration | `3414da907a2ce49d4bedaf2fbbf6ac91c3f21cce` |
| Frozen reviewed kernel | `f9fcef459d9999af05765a598c9fb72f704029ff` |
| Benchmark/clocks | `9994de190259648ede82f7c5e4dbac4f1534a41d` |

`integration-runs/` holds this candidate's raw native/matrix/controls/A-A/startup/code/proof records and the FAILED test-first case. Other run directories belong to the retired parallel port and are labelled in its report, including two native preflights, the bounded-check timeout and the unsupported-point calibration failure. Its completed eight-point canonical check passed both stages, but is **not** claimed for the corrected integration.

Shell instruments/manifests are alongside this report. Every reported execution uses pinned-run: full immutable sources, instrument hashes, fresh private checkouts/targets, lock before preparation through verification, and canonical fetched review. Binary inspection text from the earlier port is in `inspection/`; compiled executables and files≥20MB are omitted.

John owns integration/cost judgment. **No merge, release, tag or crate upload performed.** #271 follows on the accepted foundation under a separate identity; its frozen evidence and finish/sparse-use costs stay intact.

— Sam Shackleton
