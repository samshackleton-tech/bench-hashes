# Real eight-message groups on AVX-512 — exact-current-tree stage

**Draft [PR301](https://github.com/servil-software-factory/BLAKE3/pull/301).** This reuses John's one-commit #277 stage, not a new kernel. Complete grouped cycles gain at eight states and16+8tails, with explicit sixteen-state and startup costs. It is not a global Pareto result or pipeline safety approval.

## Identities and mechanism

- Frozen PR head **`794741322121ddc31054a77e4d7663d9397c0e2e`**, owner source`e673ae1506fcc194a3fdb0605f200e01253626b9` applied to55811070; the one test conflict keeps both width-specific reachability and selected-reset assertions.
- Exact tested synthetic integration **`6e74ed36d683a634f193cb101cf26eaca72e0e3c`**, verified parents `[7ee5c1f8cfad7937fb490e6510f8f36fe5ce912f,79474132]`, preserved personal ref`evidence/sam-small8-merge-6e74ed36`.
- Direct incremental baseline#274 **`925e28d9de5bb11ea7d55eec7706adf761c5226e`**; independent DIRECT aggregate baseline#271 **`85c4b2d92b71c87a42261509fa6258f02903a0bc`**. The aggregate numbers are measured, not composed ratios.
- Benchmark/clocks **`9994de190259648ede82f7c5e4dbac4f1534a41d`**.
- Both kernels/generators/theorems match frozen#277 **`6630e56573f4907e5f691347dba8778a2ffb2b05`** byte-for-byte. Existing16-wide and8-wide kernels run full seven rounds; no padded sixteen-lane invocation for eight real messages, new kernel, API, Hasher field or worker threshold.

AVX-512 calls finish full groups of16, then real groups of8 through the existing AVX2 entry, then scalar tails1..7. Startup coverage now includes both reachable entries. The distinct-index debug contract and proof registration remain intact. No organization merge/release/tag/upload occurred.

## Current-source checks

Fresh pinned native preflight/Ice/ARM pass226/199release tests,21docs each,formatting/no-default/warnings-denied rustdoc and frozen-byte checks. These runs finished before the later ownership-protocol analysis confirmed the pipeline safety hold. Passing does not erase the original failed#296 job. A fresh current6e74 assembled proof run passes1193/1230steps and all eight fault controls, plus generator-key unit tests. No Rust-selector/whole-pipeline formal proof is claimed.

## Complete grouped cycles

Twelve counts2/7/8/9/15/16/17/24/31/32/64/1024 include both the first real-eight threshold and16+8tails. Arrivals17/256bytes,0–2KiB/varied lengths and independent modes give408shape/count cells ×five metrics=2040judgments per comparison. Descriptor refill, grouped updates, library allocations, digest production and reset are timed; construction/key preparation are outside. Four fresh private build/layout pairs alternate adjacent sides, clocks3% practical margin/5%FDR; busy windows forbidden. Wall/CPU/cycles/instructions/package energy stay separate. Package energy includes idle/background.

| Comparison | Ice Faster/Level/Slower | EPYC Faster/Level/Slower |
|---|---:|---:|
| Incremental925e→6e74 |880/1140/**20** |812/1191/**37** |
| DIRECT aggregate85c→6e74 |1154/867/**19** |1147/872/**21** |
| Same-source6e74A/A |0/2040/0 |not run |

Examples, plain1KiB/four256B arrivals, **incremental ns/message**:

| States | Ice baseline→candidate | EPYC baseline→candidate |
|---:|---:|---:|
|8 |1607.7892→691.0415 Faster |1216.1895→321.4192 Faster |
|24 |843.1528→572.7430 Faster |542.8377→225.3095 Faster |
|1024 |630.1739→630.4134 Level |188.2027→193.4166 Level |

Corresponding package-energy cells at8/24 are Faster on both. In the separate aggregate run,8states1602.1583→692.8774Ice and1217.3024→320.3785EPYC;24states841.4101→571.9260 and542.6924→224.4906. These are distinct measured windows, not interchangeable numerators.

## Costs are holds, not hidden by A/A

Incremental losses include sixteen-state small-message17B arrivals: Ice plain31B58.5293→60.9890ns(+4.2%); EPYC plain63B28.6900→30.8631(+7.6%),plain64B28.7061→30.8540(+7.5%). EPYC15states/2KiB/256B2588.5324→2670.0405(+3.1%) also remains Slower.

The DIRECT aggregate still has Ice sixteen-state17B losses:128B189.1008→197.7829(+4.6%),512B640.1585→666.2675(+4.1%),1023B1219.4978→1270.7332(+4.2%),1KiB1231.3976→1270.3402(+3.2%). EPYC aggregate losses include sixteen-state1023B+3.6% and seventeen-state65B/17B+5.0%. All raw attention rows stay public.

For the96original#300 Slower metric keys, this separate DIRECT combined-tree Ice study judges54Faster/34Level/**8stillSlower** (512/1023B,count16,17B arrivals:wall/CPU/cycles/package). This is a cross-study outcome inventory, not ratio composition or a causal explanation. New Slower cells also exist. [Assigned#300](https://github.com/servil-software-factory/BLAKE3/issues/300) remains open; explicit owner acceptance is still needed. Same-source2040Level does not erase costs.

## Startup

On EPYC, first initialization **34.1926→36.3228µs wall,+6.2%Slower**, CPU34.4798→36.6091µsSlower, cycles124512.69→134478.66(+8.0%)Slower, instructions125505.66→130601.50(+4.1%)Slower. All four already-initialized metrics Level; startup A/A all8Level. This is additional now-reachable-entry coverage, not permission to weaken self-tests. [#268](https://github.com/servil-software-factory/BLAKE3/issues/268) needs exact-source cost judgment. No short-window energy claim.

## Safety and ownership

Devon identified and independently reproduced the queued-job failure after widening the successful-claim/before-copy interval. John confirmed it and owns the single per-slot completion/sequence implementation. [#302](https://github.com/servil-software-factory/BLAKE3/issues/302) is assigned to him; native real-path deterministic test/pipeline validation follows his exact pushed tip. Sam has added no competing ring design and runs no further unfixed pipeline stress. Single-caller grouped-hasher timings here do not use that ring and are not safety evidence.

#295/#296/#299 remain dependencies. Foundation ARM speed checks/owner landing, the pipeline fix, exact-source costs and #299's physical AVX2 gate are not waived by this stage's gains. John owns integration/cost judgment. No multithreading tuning, rental or relabelled historical evidence.

## Separate work-removal follow-up

Candidate **`ec08884ff386cb7927f03d08af8133ab84473dfb`** is a separate child of6e74, not a rewritten PR301. It checks the already-qualified maximum width before probing AVX2, avoiding that repeated ISA check when the original16-/8-wide condition already suffices. No new state or policy. Isolated output/startup tests plus two deterministic selector/startup controls pass on EPYC; no pipeline execution or claim of a fresh full native gate. Two operator harness failures are retained: an initially assumed unset runner environment, then an ambiguous reverse replacement. The final instrument restores the exact input and checks it clean. Four fresh-layout follow-up cycles give **Ice44Faster/1988Level/8Slower; EPYC2040Level**. Ice sixteen-state1023B/17B wall1270.6804→1231.2338nsFaster, instructions8346.6941→8320.0064Level; the repeated check is removed, but new seventeen-state single-block losses remain: plain64B/256B49.6937→51.2501ns(+3.1%Slower), mixed64B49.7437→51.3222(+3.2%Slower), plus package costs. EPYC includes variable mean differences that Level does not prove equal. This is **not an established general mitigation** and stays unpromoted; no A/A or aggregate claim for this follow-up, no claim the predicate alone explains all timing. Do not transfer6e74results toec08884f.

`small8-runs/` contains all sources/instrument hashes/phase logs/reviews including those FAILED controls. Scripts/manifests accompany the report. Pinned-run owns the physical-host lock before preparation through verification; compute and quiet timing use different hosts. No compiled binaries/private operator files are published.

— Sam Shackleton
