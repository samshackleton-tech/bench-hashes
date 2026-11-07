## Reuse independent compression for heterogeneous held-stage parents

The incremental bulk path can hash parents with their own key/CV/flags in the
**existing** output8/16 lanes, instead of recursively regrouping every remaining
Hasher by key. Keep the old shared-key saturated path; make the supported
heterogeneous turn one partition rather than N partitions for N distinct keys.

**Frozen measured head:** `b6770e33b1f153ba18e7341379f3ee53199d640c`.
**Direct measured baseline:** `f47d9e5d284aafcbabf7b6b2105bdedde4832261` (#278).
No ratios from preceding candidates are composed into the result.

[Full report, source-labeled alternatives and raw records](https://github.com/samshackleton-tech/bench-hashes/blob/aff3ca599c15f80196a406289c388b59a5c11879/MIXED-KEY-STAGES.md)
— **63 run folders: 59 VERIFIED / 4 FAILED warning-gate attempts**; all 16,350
publication paths/sizes and the report's exact bytes remotely verified.

### Design scope

- One new private Rust helper with a shared traversal and real width8/16 parent
  batches. Three linear temporary CV buffers; no key sorting/hash map.
- Each stage's leaf call already fills sixteen chunk lanes. Each parent borrows
  its own message key and flags, length64, counter0, PARENT without ROOT.
- Existing initial-group two-half commit and later-group CV commit unchanged.
- **No new API, named state type, Hasher field/capacity, kernel, assembly, ABI,
  worker, startup fixture or warmth clock.** Full standard BLAKE3 rounds,
  keyed/derive modes and canonical digest/XOF behavior remain.
- No buffering or update/finalization work-deferral change. ARM/SSE fallback
  retains its existing grouped strategy; existing #269/#274 primitives are reused
  from this measured ancestry, not claimed newly merged upstream.

A first generic-width traversal duplicated setup/leaf/commit code. The selected
shared traversal removes3,476 GNU-size text-aggregate bytes against that version,
with all960 scoped EPYC/Zen3 comparison metrics Level. Its helper symbol is8,918B;
the direct consumer GNU-size text aggregate grows9,900B over baseline. That
footprint is explicit for design review, not hidden by the runtime benefit.

### Complete-cycle result, not just a finishing phase

`update_each` / `finalize_each`, 2,048 distinct-key messages ×16KiB, four4KiB
arrivals; reset, descriptor refill, every update and finalization all timed:

| Host | Wall ns/message old → new | Package nJ/message old → new |
|---|---:|---:|
|9700X|5090.8022 →2356.3005|287952.4604 →130072.4223|
|EPYC9255|5457.2620 →2462.3581|420475.3786 →193414.3715|
|Ice Lake6330|14581.6616 →6934.1531|1344329.8638 →632550.5674|
|Zen3 EPYC7443|10747.3755 →5448.7371|843041.3902 →435033.6269|

**49–55% less complete time**, **48–55% less whole-package energy**. At512
messages, complete time23–32% lower. Mixed modes at2,048 improve12–16%, not the
distinct-key-only factor. Plain/shared-key complete controls and ready finishing
are Level. RAPL includes package idle/background activity; CPU, wall, cycles,
instructions and energy remain separate in the raw records.

Four-host primary72-shape/op matrix: complete wall **99F/189L/0S**; ready finishing
all288Level. Actualmultithreaded API cohort: completewall26F/38L/0S, all960metrics
noSlower. Held-stage work still executes on the caller; not a parallel scaling
claim. Four fresh layouts, alternating adjacent order, clocks3%margin/5%FDR;
lock held before preparation through verification. Current-head A/A2160metrics
allLevel (9700X/Zen3); separateEPYCtargetAA30Level. Startup24metrics allLevel.

### Retained cost: explicit acceptance pending

**[Sam-owned follow-up #280](https://github.com/servil-software-factory/BLAKE3/issues/280)**
contains exact reproduction, raw evidence, attempted checks and a bounded next
investigation. EPYCplain1KiB×8/four256Barrivals, update-only:
**23.4637 →24.2384ns/message,+3.3%**, CPU/cycles/package also+3.3%; instructions
and the completecycleLevel. About6ns per eight-message update operation, not per
callback. This short control does not execute the new held-parent helper.

The scoped repeat is+3.2% mean butLevel; its controls/A/A areLevel. These do not
erase the original wide Slower cell or establish a cache/layout cause. My
recommendation is to weigh the small phase-only cost with the complete-cycle
controls and many-key gain. **Review acceptance is still required.** Praise or
acceptance of earlier candidates is not acceptance of this cost.

### Correctness and deterministic work protection

Exacthead191/191tests each4x86,163/163ARMVM; serde/zeroize/no-default/19doctests/
warnings-denied rustdoc all5. New targeted cases covercounts2/7/8/9/15/16/17/31/32/33,
independentkeys/modes, zero/nonzero group counters, continuation/XOF and actual
selected parent entry. One actual nonempty held-partition entry per supported
mixed-key turn is counted through the existing release-no-op work framework.

The pinned negative control bypasses only this route. Canonical, continuation
and XOF assertions pass, then actual partitions **2 versus1** fail atAVX2,n2.
It catches a value-equivalent algorithmic regression without a timing assertion.

Allc/tools/build snapshot bytes are identical: existing arbitrary-CV/flags,
compression/ABI/memory proofs bind unchanged assembly/harness/models. The new
Rust indexing/dispatch/commit is natively exercised, not called a formal Rust
proof. Earlier direct-core and all-general-parent attempts/costs remain in the
report, outside the selected source.

### Review boundary and #267 / #279

This draft targets`servil` but has measured #278→#277→#274→#271→#269 ancestry;
none of those review heads is modified. Integration belongs to John.

I have read the new convenience-Hasher / Rust-only-throughput direction in#267
and#279. This candidate is measured on the prior bulk-Hasher API spelling and
changes no public contract. **Please review its fit with that migration before
integration.** In particular it retains one legacy key-equality partition; it is
not presented as satisfying#267's future key-value-independent control-flow
contract or as a redesign of the single-Mode background pipeline. The private
independent-parent mechanism may be reusable; if the transitional bulk path is
to disappear, parking this measured candidate is preferable to adding an API
solely to preserve it.

John Servil: independent design/proof/cost/migration fit and integration. Sam
Shackleton: implementation/evidence and#280 follow-up. Devon Jonte: peer/Intel
review. No merge, tag, release or crate upload authorized or performed.

— Sam Shackleton
