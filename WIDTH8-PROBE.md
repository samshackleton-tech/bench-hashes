# Separate experiment: fill an AVX2 group on an AVX-512 CPU

**Not in frozen #259 or current draft #262. No integration claim.** Current #262 retains the simpler borrowed adapter and its explicit Zen 3 warm blocker.

Branch `probe/sam-batch-width8`, worktree `~/work/b3-batch-width8`. Timed source `a072159cb25430846274faab8722108bb2b3998e`; native checked source `1b1fecd0cb4d25212817ebf7bbdc6ae7dab6e5ad`. The latter changes only the test’s expected entry, not the production adapter. Baseline for these direct whole-source studies: frozen `1fb068fe77dc571ec47241753a0c35663b514c2f`.

## Small, natural packing choice

The earlier adapter requires sixteen supplied messages on an AVX-512 machine. Eight to fifteen messages still fill an existing eight-lane AVX2 finishing group. This experiment selects that existing entry for those ready, partial-final-block batches; no fabricated lanes, new kernel, ISA requirement, warmth clock or calibrated threshold. For sixteen or more it keeps the native sixteen-lane route. The remainder keeps its existing route.

The change is based on the retired dispatch-isolation experiment, so **it does not resolve or supersede its Zen 3 warm whole-block blocker**. There is no Zen 3 timing claim for this experiment.

## Direct paired results

Same 162 length/count cells, four independent layouts, alternating processes/algorithms, ready Batch construction excluded, output stores included and all answers independently reference-checked. Shared clocks 3% margin / 5% FDR.

| CPU | Faster wall cells | Level | Slower |
|---|---:|---:|---:|
| 9700X | 77 | 85 | 0 |
| Xeon 6330 / Ice Lake | 77 | 85 | 0 |

These are two hosts only, not a universal no-regression result. The additional eligible count-8 partial-length cells now reach an AVX2 finishing entry and improve; whole-block 64/512/1024-byte routes are level in these runs.

At **eight ready messages**:

| CPU / length | Old ns/item | New ns/item | New/old package energy |
|---|---:|---:|---:|
| 9700X / 1 B | 71.32 | 14.40 | 0.213 |
| 9700X / 65 B | 110.00 | 25.39 | 0.243 |
| 9700X / 1023 B | 976.95 | 180.28 | 0.197 |
| Ice Lake / 1 B | 110.94 | 36.35 | 0.331 |
| Ice Lake / 65 B | 183.08 | 61.83 | 0.342 |
| Ice Lake / 1023 B | 1412.92 | 425.68 | 0.306 |

Whole-package RAPL includes background/idle costs. These ratios were directly measured against 1fb; they are not multiplied incremental improvements. Process CPU, cycles and instructions are separately retained in the judgments. No exact cold-gap, startup, macro shared-path or specialized-SHA claim for this source.

## Correctness and retained failure

The initial membership test still looked for the AVX-512 entry when the new code correctly selected AVX2. Both native jobs failed explicitly at `AVX512 len=1 n=8`, reached=false / expected=true; these FAILED records are retained, not relabeled. The correction checks the **selected** AVX2 entry and also rejects the **unselected** AVX-512 entry, with 7/8/9 and native-width boundary cases and independent output references. Production code was not changed to satisfy that test.

Corrected native runs on both 9700X and Ice Lake: **188/188**, no-default build, doctests and warnings-denied rustdoc pass. Assembly remains unchanged; no claim of a new formal proof of the Rust selection logic.

Pinned records under `batch-runs/`:
- `batch-width8-final-9700x-20261106T123422-3566efda`
- `batch-width8-final-icelake-20261106T123423-ed98713e`
- `batch-width8-checked-9700x-20261106T123634-4a9746ba`
- `batch-width8-checked-icelake-20261106T123634-80218a1d`
- `FAILED-batch-width8-native-*` retains both earlier failed test expectations.

— Sam Shackleton
