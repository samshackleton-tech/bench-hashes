# Bin counting, and the one-time startup cost

## Counting a finite key domain instead of general sorting

Baseline e448e3ca; measured candidate **d2704d1a2c483ff457c5513e7f6641a150be1364**.
The same tree was cherry-picked into draft #259 at
**936b8ec637ab87f8f2e6e744cd3cffd935e760b5** (empty git diff verified).
Assembly and proof-model files are unchanged by this packing change.

The64-item window has only16 possible whole-prefix counts, so it uses a16-byte
count/position array and active-bin mask. Uniform windows skip the histogram.
No new ISA, size threshold, clock, API or heap allocation. Ordering within equal
bins is stable; final digests still map to original item positions. All storage
is thread-private; no cache-line-sharing cause is inferred from these timings.

Four-layout168-cell paired matrix at3% margin/5% FDR:

| CPU | Faster wall cells | Level | Slower |
|---|---:|---:|---:|
|9700X|23|145|0|
|EPYC9255|23|145|0|
|Ice Lake|16|152|0|
|Zen3|40|128|0|

At1,024 mixed100–1,000B messages, new/old ratios:

| CPU | Wall/processCPU | Instructions | Whole-package energy |
|---|---:|---:|---:|
|9700X|0.931|0.886|0.937|
|EPYC9255|0.932|0.886|0.927|
|Ice Lake|0.920|0.887|0.921|
|Zen3|0.952|0.939|0.953|

All displayed cells are Faster. Alternating-short/long batches also improve.
The first trial3f5c2902 updated the histogram even for uniform input and exposed
four small uniform-cell losses on9700X. That trial was not promoted. The uniform
bypass version is the one judged above. The repeated per-bin memory dependency
was a hypothesis for the first trial's cost, not a cache-line diagnosis from
elapsed time alone.

In this probe, six general-sort functions totaling12,455bytes disappear and
.text shrinks13,040bytes (686,272→673,232); this is a measured linked-probe size,
not a promise of the same byte delta in every consuming executable.

Scoped stable-bench0.20.4 shared-path regressions e448→d270 show no slower cell on
all four machines, including relevant stream/collection and unchanged-path
controls under contention. Native187/1879700X and158/158ARM, no-default builds,
doctests and warnings-denied rustdoc pass. Independent-reference/counting/ABI
row tests remain. This does not convert Rust packing tests into a formal proof.

## Startup: an actual cost, not a free improvement

The added runtime entry checks have a one-time cost. The startup study compares
#249 **1ea61832** with **e448e3ca**, not d270/936. It uses32 fresh process pairs,
four layouts, alternating order. Clocks are initialized before the first B3 call;
only the `initialize()` interval is timed, not process launch. A second call
provides an already-initialized control. Samples aggregate within layout for the
same simultaneous judgment. Raw per-process wall, processCPU, cycles and
instructions are retained.

| CPU | Old first initialize | New first initialize | Paired wall verdict |
|---|---:|---:|---|
|9700X|23.237us|29.383us|1.261, Slower|
|Zen3|30.504us|34.835us|1.141, Level|

9700X processCPU23.480→29.621us (1.258,Slower); instructions109,946→150,629
(1.370,Slower). Zen3 processCPU31.812→36.226us is level; cycles/instructions are
~29%/~36% higher and flagged. The added startup work is therefore real even
where the short timing study cannot resolve a wall verdict.

Already-initialized wall controls are41→47ns9700X and50→54nsZen3. Instruction
counts are identical within each CPU; the tiny absolute differences are close
to the measurement/layout floor, not a demonstrated new hash-work mechanism.
No startup energy claim is made: these intervals are too short for useful
whole-package-counter resolution.

The runtime tests were NOT reduced to hide this cost. Their role differs from
the universal assembly proof; changing their coverage needs review. The first
startup attempt completed raw samples but failed its embeddedPython formatter;
that FAILED record remains separate, and the formatter was parsed before the
corrected rerun. Only the corrected VERIFIED runs supply this table.

— Sam Shackleton
