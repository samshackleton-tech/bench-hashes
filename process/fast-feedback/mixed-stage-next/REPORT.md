# Mixed-key held stages — current-tree work removal with a sparse cost

**Draft [PR304](https://github.com/servil-software-factory/BLAKE3/pull/304).** The existing parent compressors remove repeated key partitions. Distinct-key whole cycles improve on both AVX-512 hosts; a seven-active-state sparse EPYC cell is Slower and awaits explicit review under [assigned #280](https://github.com/servil-software-factory/BLAKE3/issues/280). No global Pareto or primary-AVX2 claim.

## Exact lineage

| Role | Full commit |
|---|---|
| Frozen candidate head | **`400847475c1241b22f2a967bc91e08174e103f79`** |
| Actual tested synthetic integration | **`a6fedec518aa7a32ba658c79ca7b41234c6e5d56`** |
| Direct baseline, real-eight stack plus owner ring fix | **`60a42e1e644aed262123ff5b285ac6812ea7e8a6`** |
| Owner-supplied four-commit stage | `eb393087852292af802875a1598d245641ecbd0f` |
| Current-next integration parent | `7ee5c1f8cfad7937fb490e6510f8f36fe5ce912f` |
| Frozen kernel/generator/theorem review | `b6770e33b1f153ba18e7341379f3ee53199d640c` |
| Benchmark/clocks | `9994de190259648ede82f7c5e4dbac4f1534a41d` |

The synthetic merge has verified parents `[7ee5c1f8,40084747]`, preserved personal ref `evidence/sam-mixed-stage-merge-a6fedec5`. Both compared sources include John's identical CPU ring ownership fix from cef8741e; this is not the earlier unsafe pipeline tree. His later Mac/GPU fixture corrections remain separate source identities and owner validation; the named trees are not relabelled as those revisions.

John's four existing commits were applied without implementation conflicts. An initial attempt to apply only the tip adaptation was aborted cleanly before applying the complete series; no run used that incomplete source. Frozen review heads remain unchanged. No organization merge/release/tag/upload occurred.

## Mechanism and inventory

Mixed-key held stages traverse the parent levels once, using independent CV/key/flag lanes through the existing output16/output8 compressors. Shared-key turns keep the existing homogeneous parent batching path. Each resulting subtree returns to its own core. Counter/flags, canonical digest and XOF semantics remain covered by native tests.

The change adds Rust traversal/input construction and a test-only actual-partition counter in the existing counting mechanism; **no new assembly, ABI, startup fixture, API, Hasher field, worker threshold or clock**. Its three transient vectors request `832 × held_states` bytes of payload (level, next level and final halves), in addition to vector/allocator overhead. They are library allocations inside timed work, not hidden caller setup. Key-dependent classification remains explicit; no new constant-time claim.

## Quality and actual-work controls

Fresh preflight plus Ice/ARM targets pass **229/201 release tests**, **21 docs each**, formatting/no-default/warnings-denied rustdoc. ARM VM supplies correctness only. Both assemblies/generators/theorems match frozen b677 bytes. Fresh assembled proofs pass **1193/1230 steps and all eight controls**, plus generator-key tests; this does not prove Rust selection or the entire pipeline.

The actual-work test checks independent modes/keys, boundaries, continuations, digests/XOF and one mixed held partition. Disabling the independent-key helper while retaining the old key-recursive fallback fails nextest100 at **"one held partition"**. The positive passes, and the control restores the exact clean input. This is a focused fault control, not a mutation campaign.

## Matching measurement boundaries

The modern probe reuses the existing clocks/paired-driver machinery. Primary cells: 2/8/16/17/24/128/512 states, 16/32 KiB messages, 4 KiB arrivals, plain/shared-key/distinct-key/mixed-mode workloads. Every distinct key is truly unique, including at512 states. Additional sparse cells use1024 open states with7/8/15/16 dispersed active states, plain/mixed modes and16 KiB messages: **64 cells per phase**.

Four fresh private build/layout pairs alternate adjacent sides; clocks3% practical margin/5%FDR; busy windows forbidden. Constructors, keys, data and caller capacity are outside counters. **Cycle includes descriptor refill, grouped updates, library allocations, digest production and reset.** Update-only includes selected resets and all refill/updates, then produces the digest outside counters. Finish-only prepares each cohort outside counters and consumes/resets it once, repeated for64 independently prepared samples; clock bookkeeping stays included and energy is NA. No pool workers/concurrent sharing are involved; native Hasher layout/stride is logged.

The old immutable-repeat finish instrument was not launched against the consuming API. Two fresh preflights failed compilation at our port's `reset()` missing its `Option<u64>` argument; `reset(None)` fixes the instrument, not the library. Both failed records remain; no fanout target launched from them.

| Phase | Ice Faster / Level / Slower | EPYC Faster / Level / Slower |
|---|---:|---:|
| Update,320 metrics |134 /186 /0 |134 /182 /**4** |
| Complete cycle,320 metrics |134 /186 /0 |134 /183 /**3** |
| Consume-once finish,256 metrics |11 /245 /0 |0 /256 /0 |
| Same-source A/A |all896 Level |all896 Level |

Primary **512 states ×32 KiB, ns/message**:

| Mode | Ice baseline→candidate cycle | EPYC baseline→candidate cycle |
|---|---:|---:|
| Distinct keys |16932.2020→12349.5388 Faster |6340.2756→4291.6282 Faster |
| Mixed modes |13355.7364→12376.6296 Faster |4808.1257→4284.5248 Faster |
| Plain |12260.4561→12255.5036 Level |4302.9328→4290.1114 Level |
| Shared key |12256.0447→12305.8983 Level |4300.3359→4282.4953 Level |

These are direct comparisons, not composed ratios. Each resource metric remains separate; package energy includes idle/background.

## Retained costs and controls

**EPYC,1024 open/7 active, mixed modes,16 KiB/4 KiB arrivals:** update2061.6714→2137.2242ns (+3.7%Slower), complete cycle2145.5630→2223.1598 (+3.6%Slower). All seven Slower metric rows remain in the raw review. The new vector payload and source traversal are observations, not an established causal explanation of this cost. Explicit exact-source acceptance is still needed; A/A does not erase it. No new persistent scratch state, clock or policy was added to rescue it.

A separate short first-chunk control covers8/16 states, plain/mixed modes,1 KiB/four256-byte arrivals. All20 update+20 cycle+16 finish metrics are Level on both hosts; matching EPYC A/A all56Level. EPYC plain8 update24.3723→24.3883nsLevel; Ice75.5052→79.5417nsLevel (+5.4%mean, not equal cost). These current-source controls do not erase the historical frozen #280 loss or relabel it a false positive.

Startup and startup A/A on EPYC are all8Level each; first wall37.5272→36.5256µsLevel, instructions130555.94→130559.56Level. No new entry registration or short-window energy claim. Level is not equal cost.

## Handoff and useful next investigation

PR304 stays draft for review of the explicit sparse cost, remaining source/integration gates and matching physical AVX2 evidence. Devon owns the i7 gate; missing authenticated Zen3 enrollment is still an external wait. Neither AVX-512 controls nor ARM VM throughput substitutes. John owns cost acceptance and integration; #268/#270/#300 prior costs remain separate.

One bounded follow-up can reuse the **already-tested8-wide entry for8..15 parent remainders on AVX-512**, instead of scalarizing them in this held traversal. For seven held states the four parent levels have56/28/14/7 parents; current16-wide batching scalarizes41 remainders. Three existing8-wide calls could cover24 of those scalar compressions, without a new kernel/startup fixture/state. This is a structural opportunity, **not a measured mitigation**, and will receive its own source identity and full costs. No padding/worker tuning or automatic promotion.

`mixed-stage-runs/` contains all native/proof/control/A-A/startup/phase records, including FAILED setup. The exact instruments/manifests accompany them. Pinned-run locks the physical host before preparation through verification, with fresh checkouts/targets; private binaries/operator data are omitted.

— Sam Shackleton
