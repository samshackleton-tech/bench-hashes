## Owned performance follow-up; acceptance pending

**Owner: Sam Shackleton.** The mixed-key staged-parent candidate keeps its
49–55% complete-cycle many-key time savings with one retained short update-phase
cost. This issue owns that cost; it is not a request to erase it by rerunning,
and not an automatic veto of the larger change. Independent reviewer acceptance
is still required before integration.

Exact direct comparison:
- baseline `f47d9e5d284aafcbabf7b6b2105bdedde4832261` (frozen #278);
- candidate `b6770e33b1f153ba18e7341379f3ee53199d640c`;
- clocks/bench source `415e7df398d42d6cc34b965a4c033a02798a9dd6`.

[Report and mechanism](https://github.com/samshackleton-tech/bench-hashes/blob/aff3ca599c15f80196a406289c388b59a5c11879/MIXED-KEY-STAGES.md)
— all 16,350 evidence paths/sizes and report bytes remotely verified.

## Retained cost and weight

EPYC 9255, `update_each`, eight plain 1-KiB messages, four 256-byte arrivals,
**update-only** (reset and all four arrivals included):

| Metric | Baseline → candidate, per message |
|---|---:|
| wall ns | 23.4637 → 24.2384 (+3.3%) |
| process CPU ns | 23.4638 → 24.2376 (+3.3%) |
| cycles | 101.5752 → 104.9205 (+3.3%) |
| whole-package nJ | 1774.2255 → 1833.1761 (+3.3%) |

Instructions and the **complete reset/update/finalize cycle are Level**. The
absolute delta is about six ns for the eight-message update operation, not per
individual callback. Package energy includes package idle/background activity.
This case does **not** execute the new 16-KiB held-parent helper. No cache,
aliasing or code-layout cause has been established.

[Original exact-head wide update judgments](https://github.com/samshackleton-tech/bench-hashes/blob/aff3ca599c15f80196a406289c388b59a5c11879/stage-parent/archive-runs/parent-single-final-matrix-epyc9255-20261107T053302-147f4a13/out/judgments-mixed-update.tsv)

The main complete-cycle matrix has 99 Faster / 189 Level / 0 Slower wall cells
across four hosts. At 2,048 distinct keys ×16 KiB, complete time is roughly
49–55% lower and package energy 48–55% lower. Plain/shared-key complete controls
and ready finishing remain Level. The small short-message update-phase cost
should be weighed against those matching complete workloads, not hidden.

## Reproduction and attempted checks

From the published `stage-parent/` directory, using the pinned runner and a host
with the same ISA (host/key configuration can be adapted without changing source
commits or instrument bytes):

```
pinned-run launch parent-matrix-epyc9255.json   # original 72-shape/op instrument
pinned-run launch short-cell.json              # scoped C8 target/C16 control
pinned-run launch short-aa.json                # current-head A/A
```

Each manifest fixes full source commits, script SHA, private source/targets and a
host lock before preparation through verification. Four fresh build layouts,
alternating adjacent executions, shared 3% practical margin / 5% FDR.

The scoped C8 repeat is **24.0435 → 24.8243 ns**, +3.2% mean, judged Level;
C16 is +2.8% mean, Level. All 30 scoped comparison metrics and all 30 target/control
A/A metrics are Level. These do **not** reclassify the original wide Slower cell
as a false positive.

- [Scoped reproduction](https://github.com/samshackleton-tech/bench-hashes/tree/aff3ca599c15f80196a406289c388b59a5c11879/stage-parent/archive-runs/parent-short-update-reproduction-20261107T054251-dbec4ee5)
- [Scoped A/A](https://github.com/samshackleton-tech/bench-hashes/tree/aff3ca599c15f80196a406289c388b59a5c11879/stage-parent/archive-runs/parent-short-update-aa-20261107T054252-0c4d7fa3)
- Current-head full A/A: 2,160 metrics all Level on 9700X/Zen 3, separately sourced.

Other attempts are retained in the report: direct per-core absorption lost useful
common-key parent batching; independent parents for homogeneous turns cost the
small C2 common-key case, so the old common-key route is retained. Sharing the
selected traversal removes 3,476 GNU-size text-aggregate bytes versus the
const-width full-traversal version; the EPYC/Zen3 960-metric direct comparison is
all Level. Those are earlier design checks, not a claimed causal fix for this
specific short update control.

## Bounded next investigation (20-minute equivalent budget)

1. Compare the unchanged short path's actual dispatch/instruction sequence in
   pinned disassemblies; keep native layout/ownership and code placement explicit.
2. Test at most one evidence-led small simplification or placement ablation,
   retaining C8/C16 short controls and 512/2048 distinct-key complete gains.
3. Use the same practical/FDR rule and preserve every attempted loss. Stop and
   return the cost to review if no simple mitigation earns its place. No padding
   heuristic, warmth clock, new API/kernel, or serialized-test workaround.

John Servil owns independent design/cost acceptance and integration; Sam owns this
follow-up; Devon Jonte is requested for peer/Intel review. No merge or release is
implied by the evidence.

— Sam Shackleton
