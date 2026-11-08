# Grouped first-chunk compression on current `next` — #271 stage

**Draft [PR#296](https://github.com/servil-software-factory/BLAKE3/pull/296), not promotion-ready.** The matching whole-work gains are large; explicit sparse/crossover costs and an unresolved pipeline correctness failure remain. No multithreading tuning, extra API type or persistent Hasher field.

## Sources and mechanism

This uses John's supplied five-commit #271 rebase, not a parallel implementation. It is applied on the distinct-index foundation from PR#295; the one textual conflict retains both contract and staged-prefix documentation.

| Role | Full commit |
|---|---|
| Direct foundation baseline | `d4f675f4967317b41546e8c8309d35eb384cbbaf` |
| Candidate head | `6a55b3ba734abd580ff0b95a4ba3b67815626dde` |
| Exact tested current-tree integration | **`85c4b2d92b71c87a42261509fa6258f02903a0bc`** |
| Current-next parent of candidate integration | `7ee5c1f8cfad7937fb490e6510f8f36fe5ce912f` |
| John's provided stage | `de9585b24e0b45cad822de80ee51bcb576911cc3` |
| Frozen reviewed #271 | `7c4166fa922165c7db8250908f6442cb3b9a28a2` |
| Benchmark/clocks | `9994de190259648ede82f7c5e4dbac4f1534a41d` |

The synthetic integration's parents are verified; it is preserved at personal ref `evidence/sam-first-chunk-merge-85c4b2d9`. No organization merge occurred. The assembly/generator/theorem bytes match frozen7c. The generic counter-zero compression entry uses each lane's flags, supporting prefix CVs and final roots without reduced rounds. Bulk updates retain the first block in the existing chunk buffer and suffix in the existing stage; finalization compresses each lane's remaining chain. Both ready and staged groups reset selected states after borrows end.

## Complete work — grouped updates, not individual Hasher calls

Timed cycles include caller descriptor refill, all `update_each` calls and library allocations, canonical digest production and reset. Construction/key/context preparation are outside. Input fragments are17 or256bytes. Four fresh build/layout pairs alternate adjacent sides; clocks judges wall/CPU/cycles/instructions/package energy at **3% practical margin /5% FDR**; busy windows are forbidden.

At1024messages, ns/message:

| Shape | Ice Lake baseline→candidate | EPYC9255 baseline→candidate |
|---|---:|---:|
| 1KiB/four256B arrivals | 1822.3376→**631.5811** |1169.6658→**188.6942** |
| 1KiB/17B arrivals |4544.6861→**2052.4306** |1904.2308→**516.5388** |
| Mixed-mode varied lengths/256B arrivals |1012.9636→**583.7880** |588.9157→**167.1723** |

CPU also improves. The first row's package energy is **192555.0401→67824.4047nJ** Ice, **81351.2339→14102.7768nJ** EPYC. RAPL includes package idle/background. These are direct stage comparisons, not products of #269's ratios.

Across170shape/count combinations, five metrics each:
- Ice: **626 Faster /224 Level /0 Slower**.
- EPYC: **624 Faster /212 Level /14 Slower**.
- Same-head grouped A/A: **all850 Level**.

Counts2/16/17/64/1024, empty through2KiB, varied lengths and independent modes are retained. This is not evidence that every workload improves.

## Costs retained for explicit review

### Beyond the first-chunk target

EPYC **2KiB in256B arrivals** is **3.0–3.3% Slower wall/CPU/cycles** at counts16/17/64/1024. At1024:2607.8427→2694.1763ns/message (+86.33ns). **Instructions decrease**15091.0585→14068.8672 (Faster), so more instructions are not an established explanation. Package energy is Slower at16 and Level at1024. The empty1024-message/256B-labelled control has one package-energy Slower cell,1126.9535→1167.6425nJ (+3.6%); no corresponding wall-time regression is established. All raw judgments stay visible.

No mitigation is claimed. The next focused investigation is the handoff when a gathered first chunk receives more input, with native codegen/layout and copy/ownership ablations; timing alone does not establish cache/alias/frequency causation. No new clock, API hint or policy mechanism is added to hide the cost.

### Many open states, few active

A separate study owns1024hashers and disperses1/2/7/8/15/16/17/64/1024 active indices. Complete cycles still include all work. Ice's180metric judgments are Faster. EPYC has **148 Faster /8 Level /24 Slower**; active7/8/15 one-KiB cycles are **5.7–6.8% Slower** in plain/mixed modes. Plain active15:1207.6631→1289.9235ns/message. At16 active, the same full cycle is Faster1158.0149→166.8268. These are distinct workload shapes, not a tuned threshold.

### Finish-only phase

The consuming API cannot repeatedly finish one immutable checkpoint. Each sample therefore prepares the same cohort **outside** its counter interval, then finishes/resets it **once**;64samples are accumulated per build. Clock bookkeeping remains in the finish counter intervals, important at small counts. No short-window finish package-energy claim is made; energy is NA, not zero.

Plain1KiB/256B arrivals:

| Active of1024 | Ice finish ns/message | EPYC finish ns/message |
|---|---:|---:|
|1 |173.8828→1519.4062 |113.3203→1314.9609 |
|16 |44.2585→426.8840 |14.9927→145.7007 |
|1024 |70.4349→454.4825 |15.8341→151.4137 |

Both hosts have **72 Slower /72 Level** finish metric judgments; the1KiB cells expose deferred prefix work, while64B controls are Level. Full-cycle gains above include that work and are not replaced by finish-only numbers. Sparse/finish same-source A/A: **all180cycle and144finish judgments Level**.

Assigned [#270](https://github.com/servil-software-factory/BLAKE3/issues/270) owns these follow-ups. John explicitly judged the original sparse trade acceptable with #270 watching it; **these exact-source sparse/crossover/empty-energy costs still require explicit review**, not automatic acceptance by analogy.

Startup first wall78.075→80.330us, CPU/cycles/instructions and all already-initialized metrics are Level. Startup A/A all8Level. Level is not equal cost; no startup-energy claim.

## Correctness hold — do not turn a FAILED gate green

Fresh preflight passed all226release tests/21docs. ARM passed its native/doc/build checks. A separate fresh Ice target passed **226release tests** and no-default build, then **20/21doctests** passed and `throughput::pipeline` failed:

```
blake3-worker-10: src/stream/receiver.rs:671:97
    a task claims one queued job
main: src/stream/receiver.rs:694:43
    Result::unwrap() on Err(PoisonError)
```

`first-chunk-native-ice-20261108T033429-1b340a88` remains FAILED. This is a SlotState claim assertion, not evidence of a numeric counter's cause. Stream receiver/frontend source bytes match the baseline. Sixteen ordinary parallel doctest repetitions on **each** source then observed0failures; the reproduction run is itself FAILED because it did not meet the required baseline-reproduction expectation. Neither a baseline reproduction nor a fix is claimed. No test serialization, worker cap or suppression was introduced. John owns the engine investigation; promotion remains held.

The current assembled proof passes **1193steps and four fault controls**. Frozen-byte agreement, full-round compression and descriptor guard-page coverage remain; this is not a Rust/whole-pipeline proof.

## Records

`first-chunk-runs/` retains every positive, FAILED and non-reproducing stage, identities, phases, logs and review cards. Instruments/manifests accompany it. Every reported run uses pinned-run with full sources/instrument hashes, fresh private checkouts/targets and lock before preparation through verification. Native Hasher layout/stride is recorded (18,432B/64alignment); one caller owns all data—no concurrent sharing cause is inferred.

The source stays a separate stage after#295. Frozen candidates and historical reports remain unchanged. No merge/release/tag/upload by Sam and no global Pareto claim.

— Sam Shackleton
