## Owned partial-XOF reader state/copy and package costs

**Owner: Sam Shackleton. Acceptance pending.** Retaining the current partial
64-byte XOF block gives large short-read savings, but grows native Reader state
and has a few measured copy-only/package-energy costs. This issue owns them;
benefits are not blanket acceptance and a flagged metric is not an automatic veto.

Exact direct sources:
- baseline `f47d9e5d284aafcbabf7b6b2105bdedde4832261`;
- candidate `762b0227939e60a0f2d4f3da5cfc8742d8c01697`;
- bench/clocks `415e7df398d42d6cc34b965a4c033a02798a9dd6`.

[Report and 30 source-labeled records](https://github.com/samshackleton-tech/bench-hashes/blob/034790cde31f08d3189ac898b687d6be708d171e/PARTIAL-XOF-CACHE.md)
— all18,519publicationpaths/sizes and report/index/inventorybytes remotelyverified.
28VERIFIED;2FAILED gap-probe compilation attempts retained, no timing in failures.

## Retained costs

Native Reader size/alignment/stride: **192 →256bytes, align64**. Two private fields
hold a64-byte cache/validity bit; no new public API/type/kernel/ABI/unsafe code.

- Ice Lake: four64-reader partial-clone wall cells +4.6–8.0%, roughly0.43–0.75ns
  per copy;14Slower wall/CPU/cycle/package metrics. Example keyed64Binput:
  **9.3861 →10.1364ns/copy,+8.0%**.
- Zen3: four empty-reader batch-clone wall cells +3.2–7.9%,~0.19–0.45ns;
  one partial-clone +5.3%,~0.30ns.17Slower clone metrics. Example plainempty:
  **5.6998 →6.1497ns,+7.9%**.
- Zen3: derivedemptyinput/C1constructor-only package
  **1546.5593 →1604.7252nJ,+3.8%**, wallLevel.
- Ice: prepared-Hasher construct/read,derived64Binput/C1,4096outputin64Breadcalls:
  package **505393.5607 →522949.3637nJ,+3.5%**, wall/CPULevel.

These remain costs, not labeled false positives. Package energy is whole-package,
including idle/background activity; no causal attribution to cache-line effects
or background noise is claimed. One caller owns every Reader/output in these
measurements, so no concurrent false-sharing explanation is asserted.

## Matching benefits and controls

Complete `convenience::hash_xof` including input hashing/reader construction and
4096outputB in1Breadcalls,plain64Binput,C1:
9700X192147→15505ns;EPYC241598→18147;Ice374603→45575;Zen3218445→27989.
**7.8–13.3× faster**;CPU/energybettertoo. NotgenericcanonicalhashingorlongXOFBW.
Clonefollowedbyread32 is Faster in every24-cell/host cohort, as the copied cache
avoids the next compression. Constructor/first32 and convenience/first32 wall
controls areLevelorFaster. Primarywhole-block64/1024BreadwallcontrolsLevel.
Current-headA/A4800metricsallLevel acrossprimary+constructor instruments.
After1msidle/busywork,conveniencefirst32/full64judgmentsallLevel;1Bread4096allFaster.
GapCPU/energyNA. LargeLevelgapmeansremaininreport;Leveldoesnotproveidenticalcost.

## Reproduction and attempted mitigation

From published `partial-xof/`:

```
pinned-run launch final-ctor-icelake.json
pinned-run launch head-constructor-zen3.json
pinned-run launch final-stream-icelake.json
pinned-run launch ctor-aa-zen3.json
```

Fixedsource/scriptSHA,privatecheckouts/targets,fourfreshlayouts,adjacent
alternatingorder,hostlockbeforepreparationthroughverification,clocks3%margin/
5%FDR. Host/keyconfigurationmayadaptwithoutchangingsource/instrumentidentities.

The initialcache-onlysource `911c40267a1224b246116b03de9c4cb2e8a52cc5` had Zen3
seek/read32costs~3.4–3.6%. The selectedthree-lineearlyreturnafterapartialhead
consumestherequestavoidsazerolengthxof_manycall; selectedseekwallcontrolsLevel
orFaster. That is an attempted mitigation with its own source-labeled evidence,
not a reason to erase the remaining clone/package cells.

Explicit zeroization wipes all cache bytes even when invalid;Debugrevealsposition
only. An initializedarray+validitybitkeepsproductioncode safe/simple. No padding,
clock heuristic or new lifetime/API is proposed solely to hide tiny copy costs.

## Bounded next investigation (20-minute equivalent budget)

1. Bind actual Reader copy/constructor generated code and native field/stride to
   the selected artifacts; distinguish added copy footprint from timing-only
   explanations. Keep package measurements separate from caller CPU work.
2. If a small safe simplification is supported, test one ablation with clone-only,
   clone/read32, seek, full-block and complete convenience controls. Preserve
   partial-read gains and explicit inactive-cache zeroization.
3. Stop and return the trade-off to review if reducing sub-nanosecond copy phases
   would need extra representations/unsafe placement/dispatch mechanisms.

Recommendation: weigh the small copy-only costs and isolated package costs with
matching clone/read and extraction savings, not by an automatic veto or automatic
noise dismissal. Explicit acceptance still required. John owns independent
cost/design/migration-fit review and integration; Sam owns this follow-up; Devon
is requested for peer/Intel review. No merge or release implied.

— Sam Shackleton
