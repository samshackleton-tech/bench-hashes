# Existing eight-lane compressor for held-parent remainders

**Exact follow-up tip `4f1dd19c83122dfee2c62c1304eb593b812ee992`, not a rewritten PR304.** It reuses the already-covered output8 entry for8..15 parent remainders on AVX-512. No new kernel, ABI, startup fixture, persistent field, policy or tuning. The bounded native/matching-cycle studies contain no Slower judgments; this is not a global Pareto or integration claim.

## Identities

| Role | Full commit |
|---|---|
| Follow-up implementation | **`4f1dd19c83122dfee2c62c1304eb593b812ee992`** |
| Test-first reachability requirement, before implementation | **`ea40384e8efe6350673f923a60c62cd9a1a04e54`** |
| Direct #281 baseline | `a6fedec518aa7a32ba658c79ca7b41234c6e5d56` |
| Independent DIRECT aggregate baseline before #281 | `60a42e1e644aed262123ff5b285ac6812ea7e8a6` |
| Benchmark/clocks | `9994de190259648ede82f7c5e4dbac4f1534a41d` |

Personal branch`candidate/sam-mixed-parent-eight-tail`, existing PR304 head40084747 and its a6 integration remain frozen. Both baselines and candidate include John's identical CPU ring fix. Later owner Mac/GPU fixture revisions are separate; none of these measurements is relabelled as those trees. No organization merge/release/tag/upload occurred.

## Work removed and complexity inventory

The existing held traversal processes full16-wide parent groups on AVX-512. Previously it scalarized every remainder. It now sends eight real remainder blocks through the existing output8 entry, then handles1..7 scalars. The AVX2 check runs only when a16-wide traversal actually has at least8 remainder blocks. The AVX2-platform8-wide traversal is unchanged.

For7 held states the four parent levels contain56/28/14/7 parents. The old16-wide traversal left41 scalar compressions; three existing8-wide calls now cover24 of them. This is a structural work-count statement, not attribution of every measured timing difference. The change is eight added Rust lines/one changed binding plus a strengthened existing test. It adds no transient heap vector beyond #281's existing three, and no new entry registration. Existing checked descriptors/output bounds supply all8 inputs/stores.

## Test-first and native evidence

The existing held-key test already covers2/7/8/9/15/16/17/31/32/33 states, independent modes/keys, continuations and XOF. Its entry snapshot now happens immediately after updates, before later digest/XOF checks. It also requires the8-wide parent entry precisely when a16-wide traversal has an8..15 remainder.

Fresh test-first sourceea40384e fails nextest100 at **"eight-wide parent remainder: AVX512 n=2"** on the old selector. That job is VERIFIED because the specified red result occurred. Source4f1dd19c passes the strengthened test and full native preflight/Ice/ARM gates:229/201 release tests,21docs each,format/no-default/warnings-denied rustdoc and frozen-byte comparisons. ARM VM is correctness coverage only.

One earlier operator run used committed baselinea6 after a formatting check stopped the intended commit but a later shell command continued. It failed the required new-assertion expectation and remains FAILED. The corrected launch checks a clean committed tree containing the assertion, and uses stop-on-error shell execution. No library failure or red test is claimed from that setup record.

Both assembly/generator/theorem bytes stay frozen. A fresh current4f proof run passes1193/1230steps/all eight controls and generator-key tests; assembled semantics/bounds only, not a Rust/pipeline formal proof. No weakened test/startup coverage or mutation-tool campaign.

## Direct incremental and aggregate studies

Same modern probe/boundaries as [#281's current report](../mixed-stage-next/REPORT.md):64cells per phase,16/32KiB/4KiB arrivals, real8/16 widths/tails, plain/shared/distinct/mixed keys and sparse active subsets. Four fresh private layout pairs alternate adjacent sides; clocks3%margin/5%FDR; busy windows forbidden. Full cycles include descriptor refill/library allocations/updates/digest/reset. Update includes selected reset and refill/updates; digest outside. Finish-only prepares each cohort outside counters, consumes/resets it once,64samples; energyNA,clock bookkeeping included. Native object stride is logged; single caller owns all states/outputs, no concurrent sharing claim.

| Study/phase | Ice Faster/Level/Slower | EPYC Faster/Level/Slower |
|---|---:|---:|
| Incremental a6→4f update |10/310/0 |26/294/0 |
| Incremental a6→4f cycle |7/313/0 |26/294/0 |
| Incremental a6→4f finish |0/256/0 |0/256/0 |
| DIRECT aggregate60a→4f update |155/165/0 |155/165/0 |
| DIRECT aggregate60a→4f cycle |154/166/0 |154/166/0 |
| DIRECT aggregate60a→4f finish |0/256/0 |0/256/0 |
| Same-source4fA/A |all896Level |all896Level |

The aggregate is separately measured, not composed from ratios. Runner VERIFIED and A/A do not erase earlier-source losses or prove equal costs.

### Exact sparse-cost follow-up

EPYC1024open/7active, mixed16KiB/4KiB arrivals, **incremental**:

- Update2139.4052→2015.1449ns/message,5.8%Faster.
- Whole cycle2225.8411→2097.6896ns/message,5.8%Faster.

The **DIRECT pre-#281 baseline comparison** gives update2060.8367→2008.4422nsLevel and cycle2146.1288→2092.5975Level. Thus the earlier+3.6%Slower sparse judgment is not present in this separately measured candidate comparison. This is measured mitigation for this named source/scope, not deletion or reclassification of the earlier record. [Assigned#280](https://github.com/servil-software-factory/BLAKE3/issues/280) stays open for owner review/landing and historical cost disposition.

On Ice the same sparse cycle5375.7664→5226.2807ns is Level incrementally; aggregate5358.6704→5259.8069Level. No cross-host ratio composition or claim of universal benefit.

## Short/startup controls and remaining scope

Separate8/16-state1KiB/256B plain/mixed controls are all56Level on both hosts; EPYC short A/A all56Level. Startup and startup A/A are all8Level each on EPYC; first wall35.1531→34.8522µsLevel, instructions130539.63→130546.38Level. No new startup entry or short-window energy claim. Level is not equal cost, and no result erases historical frozen #280 cells.

Existing foundation/first-chunk/output8/real-eight costs under#268/#270/#300 remain distinct, as does the physical AVX2 matching gate owned by Devon. The ring's later Mac/GPU/source gates and final integration remain John's. The candidate removes work with existing machinery; it does not authorize worker tuning, a release or a global no-regression claim.

`parent8-runs/` retains all raw/preflight/test-first/FAILED/setup/phase/A-A/startup/proof records. Exact scripts/manifests accompany them. Pinned-run locks each physical host before preparation through verification, with fresh checkouts and targets; no private binaries/operator data are published.

— Sam Shackleton
