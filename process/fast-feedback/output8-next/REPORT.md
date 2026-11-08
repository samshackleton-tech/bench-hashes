# AVX2 output8 integration — native/proof checks and AVX-512 control hold

**Draft [PR#299](https://github.com/servil-software-factory/BLAKE3/pull/299), not promotion-ready.** It reuses John's supplied #274 rebase, adding only settled contracts/tests and complete long-proof registration. Physical AVX2 performance is an explicit wait; AVX-512 controls contain regressions. No multithreading tuning, new rental or API concept.

## Exact lineage

| Role | Full commit |
|---|---|
| Direct #271 baseline | `85c4b2d92b71c87a42261509fa6258f02903a0bc` |
| Candidate head | `558110709cf38323fbf86637f95d4cb711326f22` |
| Exact tested integration tree | **`925e28d9de5bb11ea7d55eec7706adf761c5226e`** |
| Current-next integration parent | `7ee5c1f8cfad7937fb490e6510f8f36fe5ce912f` |
| John's supplied #274 stage | `f84c3e4ea918b4fa4d99e4f09956b4e6cc96f602` |
| Frozen output8 kernel/generator/theorem | `e3af185c5962076972129e83dfc2c8d9badb62b2` |
| Frozen output16 kernel/generator/theorem | `7c4166fa922165c7db8250908f6442cb3b9a28a2` |
| Benchmark/clocks | `9994de190259648ede82f7c5e4dbac4f1534a41d` |

The candidate applies John's three-commit series to the current #271 integration, preserving both ISA-width reachability and selected-reset assertions in the test conflict. Long-proofs now includes output8 generator agreement/identity and its dedicated theorem. No persistent Hasher field or worker threshold changes. The synthetic merge has verified parents `[7ee5,5581]`, preserved at personal ref `evidence/sam-output8-merge-925e28d9`; no organization merge occurred. Frozen reviewed heads stay unchanged.

## Native and proof results

Fresh preflight plus independent Ice/ARM targets pass **226/199 release tests**, **21 doctests each**, formatting/no-default/warnings-denied rustdoc. Both kernels/generators/theorems match their frozen bytes. The current harness proves output16 in **1193steps** and output8 in **1230steps**, rejecting all four controls for each; generator-key tests pass. This proves assembled compression/ABI/bounds, not the entire Rust/pipeline system.

The new kernel is reached for AVX2 groups of8; AVX-512 keeps its16-wide path at this stage. Therefore the following Xeon measurements are **controls, not an AVX2 gain claim**. A passing new native/doc run does not erase #296's earlier SlotState pipeline-doctest failure or establish an engine fix; the dependency hold remains.

## AVX-512 complete-cycle controls

The instrument includes counts2/7/8/9/15/16/17/64/1024, fixed0–2KiB/varied lengths, independent modes and17/256byte arrivals. Timed work includes descriptor refill, grouped updates/library allocations, canonical digest production and reset; construction/key preparation are outside. Four fresh build/layout pairs alternate adjacent sides, clocks3% practical margin/5%FDR, busy windows forbidden.

**Ice Lake1530metric judgments: 284 Faster /1150 Level /96 Slower.** Same-source A/A: **all1530 Level**. Runner VERIFIED does not mean no Slower cells; A/A does not erase them.

The losses cluster on17-byte arrivals, generally3.0–4.5% wall/CPU/cycles and some package costs. Examples, ns/message:

| Shape/count | Baseline→candidate | Judgment |
|---|---:|---|
| Plain1KiB/17B,2states |4572.8021→4730.6351 |Slower,+3.5% |
| Plain1KiB/17B,8states |3965.0986→4102.5066 |Slower,+3.5% |
| Plain varied/17B,8states |2076.0664→2168.9291 |Slower,+4.5% |
| Mixed varied/17B,8states |2076.5556→2166.8211 |Slower,+4.4% |

All96attention rows remain in the raw canonical review/TSV. These include below-width paths, so the new AVX2 compression itself is not an established cause. No control-gain ratio is substituted for a missing primary-ISA measurement.

## Investigation status, not a causal claim

Static inspection used exact old/new ELF copies from the pinned comparison; binaries are omitted, dual hashes/symbols/selected disassembly retained. `update_turn` is1917→1925bytes, with a200-byte frame in both. `finalize_each` is1022→3715bytes while its frame is1024→576bytes. These observations show changed codegen/layout; they do not establish cache, alignment, alias, frequency or stack-size causation.

No mitigation is claimed. The next bounded investigation is to preserve/ablate the existing16-wide and below-width caller code generation while isolating the new8-wide path, recording any added calls, footprint and primary-ISA cost. Do not add an API hint, warmth clock or general runtime policy to rescue the transitional path. Explicit owner judgment is required before accepting the measured control cost; the assigned follow-up remains open while any accepted regression remains.

## Startup and hardware limits

EPYC AVX-512-host startup and already-initialized metrics are all Level, as are all8 startup A/A judgments. This is not proof of equal cost and **not an AVX2 startup measurement**; the new reachable-entry startup price on an AVX2-only host remains to be measured. No short-window startup energy claim.

The existing Cherry Zen3 host cannot yet be used by the strict client: no authenticated ED25519 enrollment is present, and both the everyday request and a strict managed-shell attempt fail host verification. No unchecked fallback occurred; no new rental was made. Authentic enrollment or Devon's physical i7 run is required for the matching AVX2 performance gate. Frozen historical #274 and Devon's stack measurements remain prior evidence, not results for925e28d9.

## Records and holds

`output8-runs/` contains every native/proof/control/A-A/startup record, source/instrument hashes, phases and reviews. `output8-inspection/` holds text-only observations. Scripts/manifests accompany this report. Pinned-run holds the host lock before preparation through verification and uses fresh private checkouts/targets. The single caller owns all states/outputs; no concurrent-sharing cause is inferred.

Dependencies remain #295 then #296 then this stage. The pipeline correctness hold, explicit control-cost review and physical AVX2 gate are not waived. No merge/release/tag/upload by Sam and no global Pareto claim.

— Sam Shackleton
