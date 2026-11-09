# The512-message Ice cost: bounded diagnosis

Sam Shackleton, November9,2026. John requested this diagnosis in #3256737782626. The production sources remain unchanged: current1cbdf5d72d70d8ed511870b18c7f017cce83da15, commonf13933376c8b8236adaeffe6aa9d25ad25f2af24, earlier independent source91d79d37d46e6116c12442673a6ba7c8f9f30a04. Original3f1 Ice preservation losses,1cbdf's whole-composition72s mutation-budget hold and Devon’s physicalAVX2 survivor report remain open. No canonical/adoption claim follows from these diagnostics.

## Finding

The Ice512 cost can be reproduced by changing the caller of **unchanged91**, without introducing the new independent backend or large stack workspace. Splitting one512-piece arrival into four adjacent128-piece calls makes the512complete-cycle wall cells Slower by4.1–4.4% in all four modes. EPYC is Level. The same split on unchanged1cbdf is Level on both hosts because its internal ready cadence is already128.

This identifies a caller/flush chronology and scratch-lifetime trigger. It does not yet separate scratch allocation/lifetime from memory-system effects. On91, the split also changes per-flush heap-scratch sizes and request/free lifetimes; complete-cycle counters include that work. Neither a cache cause nor a new library fix has been established.

## Counts and actual ownership

The matched count-only item `bounded-matched-held-work-counts-ice-20261109T113736-eb064f0f` isVERIFIED. Each source has897startup/update/finish records, including first/repeated cycles,128/512states,16/32KiB, four modes, whole/split callers, and identity/61-permuted indices over the same allocated states/data. Every row's actual digest matches the independent oracle; sources restore byte-exactly. The patches, symbols, full event logs and restoration records are retained.

At512×16KiB, final4KiB arrival,61-permuted order:

|Source/mode|Actual held cohorts|Observed native-entry invocations|Leaf chunks / parent compressions|
|---|---|---|---|
|91/plain, whole caller|1×512|516hash_many|8192 /7680|
|91/plain, split caller|4×128|528hash_many|8192 /7680|
|1cbdf/plain, either caller|4×128|528hash_many|8192 /7680|
|f139/plain, either caller|4×128|528hash_many|8192 /7680|
|91/shared, whole or split|1×512 or4×128|512hash_many+480output16|8192 /7680|
|1cbdf/shared, either caller|4×128|512hash_many+480output16|8192 /7680|
|f139/shared, either caller|512×1|2560hash_many|8192 /7680|

Native test-buildHasher size/stride18,432B, alignment64; core/key/stage offsets0/128/1,984. Stage storage is16,384B. These are actual addresses/offsets, not Rust declaration-order assumptions. One caller owns states, stage writes, descriptors, workspaces and outputs; there is no concurrent ownership in this diagnostic. No false-sharing attribution.

The original entry observer omitted ordinary scalar finalization. Its empty finish sets and the `RootBlock` counter do not establish zero finish work: RootBlock covers reader tails, and OutputGroupTurn records an attempted wide dispatch. A second item, `bounded-root-entry-counts-ice-20261109T120524-4f008431`, extends the **same** observer at scalar compress_in_place/compress_xof FFI entries. It isVERIFIED,449records/source. Every one of its64finish records/source observes exactly one **compress_in_place_avx512** call per selected message:512at512,128at128, across all modes/lengths/call partitions/repeated cycles. This corrects the earlier shorthand calling the gap an xof gap. These are Rust-to-kernel entry counts, not instruction traces.

The first, ordered count payload completed with restored sources and jobexit0 but its outer runner became lost: the manifest supplied an object where `forbid` accepts strings. Raw payload/manifest/phases remain underFAILED-bounded-held-work-counts-ice-20261109T112451-b393f1ea. The manifest was repaired once; the new matched item also adds the actual sampler order/data and its explicit identity-order control. No timing sample was rerun for green.

## Caller-only timing

`caller-costs.sh` derives a diagnostic probe from frozen3a0595df sampler code. Library inputs are identical on each side of a comparison. It preserves constructors/preparation scopes, data, mode assignment, calibration, alternating sides, four fresh paired layouts, clocks wall/CPU/P+Ecycles/instructions/energy, digest assertions and the unchanged Rust judge. Scope is **16diagnostic shapes**,128controls and512targets in all modes/lengths, not the full64-shape preservation or canonical gate. Every run checks384counter/TSVrows and finish64consume-once samples/energyNA.

Both A/A studies have224Level metric/phase judgments. A generic early status sentence described the intended split even forAA; actual compiled probes/markers and metadata establish that bothAA sides used the whole caller. The later status is mode-specific. The linear protocol preserves that exactAA reference program byte-for-byte, verified locally.

### Whole512 turn versus four128-piece calls

|Unchanged source/host|Cycle wall at512, plain16/32KiB|Shared16/32KiB|All phase/metric outcomes|
|---|---|---|---|
|91/Ice|+4.14/+4.15%,Slower|+4.44/+4.20%,Slower|cycle32S48L;update32S48L;finish12S52L|
|91/EPYC|−0.63/+0.73%,Level|−0.45/+0.72%,Level|224Level|
|1cbdf/Ice|+0.03/+0.15%,Level|+0.10/+0.10%,Level|224Level|
|1cbdf/EPYC|−0.07/−0.52%,Level|−0.30/−0.13%,Level|224Level|

91/Ice updatewall: plain+4.66/+5.15%,shared+4.83/+4.95%,Slower. Its32KiBfinishwall is Slower in all modes,+4.37…+5.52%; the16KiBfinishwall cells areLevel. All128controls areLevel. `caller-split-summary.json` retains every Slower metric/phase cell; original raw judgments remain authoritative.

### Whole caller,61-permuted versus identity state order

This keeps capacities, caller partition and library unchanged. Both sources/hosts have all80cycle and80update judgmentsLevel. EPYCfinish64Level for each source. OnIce, finish has24Faster/40Level per source: all eight512wall cells improve, with instructionsLevel. At512:
-1cbdf finishwall−6.72…−8.56%,Faster;
-91 finishwall−8.55…−11.15%,Faster.

This establishes finish sensitivity to public access order; it does not identify a cache mechanism. There is no cross-baseline ratio composition and no claim that identity order repairs the original512cycle regression. Raw/summaries are `caller-linear-summary.json` and runs/bounded-caller-*-linear-*.

## Native2062 offline attribution

Owner evidence is pinned at e4953a0902e0794176627cd906cd555d981a4b6a,117textblobs/Gitblob+size checked. `owner-2062/OFFLINE-ATTRIBUTION.json` checks3,072AA/ABTSV/counterrows. Exactreader9994de19 uses thread_selfcounts per-performance-level on-CPU time. All four finish-cycle suspects have zero observed Etime/cycles/instructions on both sides. P effective cycles/ns decreases0.23–1.85%, while Ptime increases4.20–7.12% and instruction means are unchanged or+0.012/+0.037%. A fasterPclock is not the explanation.

The counter interval is wider than wall: Counts-read → wall-start → finalize/reset → wall-end → Counts-read. Ptime-minus-wall grows2.82/6.63/7.11/3.47ns/message for the four cells. Reader/timer bookkeeping after matched old/new preparation, including SME state, is an owner-run attribution control to test next; do not subtract those gaps into a green verdict. The four cycleSlower cells and independent VM finish-wall losses remain open. Sam performed no native Mac/VM execution.

## Next decision

John owns any scheduling/workspace change and any acceptance. Keep the current production source, capacities, placement and owners unchanged until that review. A useful next experiment must distinguish the chronology effect from per-flush scratch/allocation lifetime, and account for any scan/duplicate-handling work it adds. The withdrawn in-stage mechanism stays parked. The current handoff includes the full failures, costs and scopes rather than a second scheduler or a larger table.
