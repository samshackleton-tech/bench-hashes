# Physical i7 matching-stage records and ring-fix cost

**Published-record review, not a new benchmark execution or a Sam pinned-run verdict.** Devon supplied the i7-12700K runs. Sam fetched immutable publication **`bbcea09bfdd6bd824f5cf78c7d8bff3528b6a313`** from `devonjonte/bench-hashes`, verified every file’s Git blob/mode/size in the three prefixes and both supplied SHA-256/BLAKE3 manifests, then checked every old/new sample header against the requested full source identities. All313files/10,089,030bytes pass integrity checks. The CPU headers report physical i7-12700K/AVX2, no AVX-512, not ARM VM or AVX-512 control timing.

All records use bench/clocks **`49f45960ff276558e707cb777a357679332788fe`** (bench-hashes #157), rustc1.98.1 and clean source headers. This is **not** Sam’s earlier9994de19 instrument/compiler identity; no pooling or ratio composition. Canonical verdicts below are Devon’s retained outputs, not recomputed significance. The dataset does not supply Sam runner lock/preparation receipts, so integrity verification is not relabelled runner verification. No short-window startup/package-energy claim; unavailable short-cell CPU/energy columns remain NA.

## #299 AVX2 output8: exact source, native benefit delivered

**925e28d9de5bb11ea7d55eec7706adf761c5226e vs85c4b2d92b71c87a42261509fa6258f02903a0bc**. [Immutable143files/2,040,343bytes](https://github.com/devonjonte/bench-hashes/tree/bbcea09bfdd6bd824f5cf78c7d8bff3528b6a313/2026-11-08/output8-299-i7).

`bench-hashes check` measures9named points of that instrument’s276: turn256, turn1024×1KiB, idle variants, brief-idle small arrivals, interleaved256,64B,1KiB and git objects. Four fresh pairs, alternating adjacent sides; second stage64fresh pairs on four suspects only. **No cell Slower** in either stage. This is not full276-point coverage or the full17/256B/count/mode matrix.

1024messages×1KiB in256B pieces, whole-cycle time:

| Arrival context | st | mt |
|---|---:|---:|
| after other work | −40.8% | −40.0% |
| after5ms idle | −38.1% | −38.0% |
| after brief idle | −44.3% | −44.7% |

These six cells are Faster in every first-stage pair. The64-pair selected one-message1KiB mt cell reads−3.8%; it is a different workload, not the main whole-cycle benefit. Other named controls Level. First-stage output also records three−49.4% instruction movements in its Level-cell diagnostic; the selected second stage reports none. Do not summarize that as globally identical instructions.

The exact instrument source was inspected at49f45960: `SMALL_ARRIVALS` has1024open messages,256B pieces and a1MiB call budget, hence four complete turns. `each_interleaved` refills descriptors and its receive buffers, calls update_each/update_each_multithreaded, then finalize_each/digest consumption/reset inside the call. Caller vectors and library allocations in this path are included. Hashers/schedule/buffer state are kept between calls after preparation. Thus this is real complete work, not kernel-only or repeated immutable finishing. Its caller allocations/schedule bookkeeping differ from Sam’s controlled matrix.

The matching physical AVX2 request is **delivered**, not still waiting for a run. Strict Zen3 host enrollment remains separately unavailable; no unchecked SSH or new rental. Native AVX2 startup and the full mixed/sparse/17B matrix are not supplied here. **#300’s original96AVX-512 control Slower judgments remain**, requiring explicit cost judgment beside this benefit. Frozen source/head/evidence are not rewritten.

## #304 mixed-key stage: physical Plain controls, not distinct-key benefit

**a6fedec518aa7a32ba658c79ca7b41234c6e5d56 vs60a42e1e644aed262123ff5b285ac6812ea7e8a6**. [Immutable142files/900,597bytes](https://github.com/devonjonte/bench-hashes/tree/bbcea09bfdd6bd824f5cf78c7d8bff3528b6a313/2026-11-08/s304-i7).

Four pairs of the named turn/interleaved/1KiB/git-object controls, then64fresh pairs for the sole mt idle-turn256suspect. **No cell Faster or Slower; no Level instructions moved beyond0.5%**. The source headers in second-stage files correctly contain only the selected mt contender; they are not missing an st run.

These are **Plain/shared-key controls**. Distinct-key and mixed-mode benefits/costs are outside this physical study; do not turn Level controls into a primary matching-benefit claim. Sam’s earlier matching Ice/EPYC mixed-key data and assigned#280cost remain separate. The later4f parent8follow-up likewise does not relabel a6results or erase the original sparse loss.

## #303 safety fix and whole-stack i7 cost: assigned #306

[Immutable28files/7,148,090bytes](https://github.com/devonjonte/bench-hashes/tree/bbcea09bfdd6bd824f5cf78c7d8bff3528b6a313/2026-11-08/ring-fix-stream-cost-i7).

- **40985bbc7178b4d879b1ab719aaeb6e5d52db921 vsd4f675f4967317b41546e8c8309d35eb384cbbaf**, four pairs of named continuous-message/batch points. mt64B **+8.2% Slower**,128B **+5.7% Slower**, all four directions positive;256B/1KiB/batch controls Level. Not a64-pair result or a cef-source measurement.
- Separate direct endpoint **4f1dd19c83122dfee2c62c1304eb593b812ee992 vs7ee5c1f8cfad7937fb490e6510f8f36fe5ce912f**, canonical`--cells all`: mt continuous128B **+6.6% Slower**, the sole slower cell in its emitted verdict. Four accepted pairs; the retired pair remains in`retried/`, its new-side header says busy. The quiet mate is retained with it; no one side was cherry-picked. Metadata says idle control unavailable, so no full controlled-idle coverage is invented. Whole-cycle small arrivals are38–43% Faster alongside this cost, not an erasure.

**Assigned open [#306](https://github.com/servil-software-factory/BLAKE3/issues/306), John Servil**, owns explicit cost review/follow-up beside the safety benefit. Correct ownership must not be reverted for timing. Devon’s three3-pair CAS/slot-order/store-only probes are retained as alternatives, not verdicts or fixes; her no-wait counting probe has no retained samples and is not independently verified here.

Source ownership: producer writes TaskSlot.task/acquires next before reuse; successful CPU claimer copies task/release-stores next; GPU release follows its borrow. Claimers also CAS claimed. These are real ownership transfers. Native TaskSlot stride/field offsets/cache-line overlap are **not** established from Rust source field order or timing. Next useful owner investigation records layout and reproducible path counts, then tests a focused safe ownership ablation with footprint/copy costs accounted for. No established cache/alignment/frequency cause, no competing scheduler/ring design, no more stress against the old unsafe window.

Owner acceptance/Mac-GPU/integration/source gates remain separate. Sam has not merged, released, tagged, uploaded or tuned workers.

— Sam Shackleton
