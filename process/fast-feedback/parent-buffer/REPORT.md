# Reuse the final parent input buffer — memory/simplicity follow-up

**Optional owner review, not a new speed-win claim or a landing.** Candidate **`b817ac85c985582ed600208e02a380ece730c4a2`**, personal branch`candidate/sam-parent-no-halves`, is a direct child of the frozen handed-off parent8endpoint **`4f1dd19c83122dfee2c62c1304eb593b812ee992`**. Worktree`~/work/b3-parent-no-halves`. It does not include the parked a5pointer-gather experiment, rewrite a frozen PR head, merge an organization branch or change thread tuning.

## What the deletion does

`held_groups` has exactly16leaf CVs per held message and four parent depths (PER==16 is statically asserted). Before depth3, `level[..2*n]` is each final parent’s two child CVs. The final compression writes the other buffer and swaps them. Consequently, after the fourth swap **`next[..2*n]` still holds those exact input children**.

Copy those existing64bytes per first-stage root instead of snapshotting them into another vector. Later-stage/nonzero-counter CV handling remains unchanged. Owned `level` and `next` allocations stay disjoint; compression descriptors borrow the current level only during the call; copying into a Hasher does not let a reference escape. The arrays are initialized byte arrays and `next` has room for8*nCVs, more than the2*nread. No new unsafe code, selector/predicate, lifetime extension, state, API, kernel, startup fixture or policy.

**Inventory:** remove one vector, its zeroing, a snapshot conditional/copy and eventual free. Add one short invariant comment and use the existing next buffer. Source-level concurrent CV payload **832*n→768*nbytes**,64*nless (7.7%); allocator overhead/RSS are not inferred from that figure.

## Measured allocation requests, using the existing allocator

Pinned job **`parent-buffer-allocations-epyc-20261108T095913-18d8ca40` VERIFIED** uses the project’s existing `tests/allocations.rs` counting allocator/`allocated` helper. The same diagnostic test is temporarily inserted into each exact checkout, then restored byte-for-byte with empty tracked diffs; runtime library sources are untouched. Hasher/key/input/descriptor construction is outside the counted call. Four4KiB arrivals fill a16KiBstage, tested at the first and second stage, for2/7/8/16/128/512held messages.

All12cells record **64bytes less requested per held message per stage**:

| Held messages | Old total requested bytes | New total | Saved |
|---:|---:|---:|---:|
|2|1952|1824|128|
|7|6720|6272|448|
|8|7648|7136|512|
|16|15328|14304|1024|
|128|122848|114656|8192|
|512|491488|458720|32768|

First/later-stage values agree. These totals include the calls’ other bookkeeping allocations: at512messages the total requested-byte reduction is about6.7%, not the7.7% CV-payload figure. They are **requested bytes, not peak RSS, allocation-call counts or time**.

An earlier diagnostic **FAILED**`095640-8bd95dfd`: it supplied one16KiBarrival, which used the existing direct path rather than filling held stages. Both sides requested only24*nbytes and the expected64*nreduction assertion failed. The raw zero-delta record is retained as a pattern control, not a library failure or a result later renamed successful. The corrected diagnostic uses the actual fragmented-arrival workload; no runtime hint/alternate library path was added to force it.

## Timing: all Level, not a broad practical speed benefit

Direct **4f→b817**, bench/clocks **`9994de190259648ede82f7c5e4dbac4f1534a41d`**, four fresh layout pairs/alternating adjacent sides, shared clocks3%margin/5%FDR. All jobs hold the runner lock before preparation through verification with fresh private inputs/targets; timing on a host is separate from its build/proof work. No local i7 compute or ad hoc clocks.

| Scope | Ice | EPYC |
|---|---:|---:|
|16/32KiB/4KiBpieces large update|320Level|320Level|
|large complete cycle|320Level|320Level|
|consume-once finish|256Level|256Level|
|small complete-cycle matrix|2040Level|not run|
|1KiB8/16-state short controls|covered by small study|56Level|
|same-source small A/A|2040Level|not run|
|same-source large A/A|not run|896Level|
|startup comparison/A-A|not run|8Level each|

Update/cycle includes descriptor refill, updates and library allocations; complete cycle produces canonical digests and resets. Construction/key preparation/caller capacity outside counters are disclosed in the unchanged modern instrument. Finish prepares64fresh states outside counters and consumes/resets each once, bookkeeping included, energy **NA**. Small cycles include the existing17/256B/count/mode matrix. Wall/CPU/cycles/instructions/package energy remain separate rows. No Slower judgment in these studies; **Level is not equal cost**, and this is not a throughput-win claim.

EPYC startup is an AVX-512-host control, not physical AVX2 startup. There is no current-source native-i7 speed gate, direct original-next aggregate or full canonical-cell gate here. Old4f/925e/a6 results and Devon’s bench49f45960 records are not this source’s measurements. Earlier #268/#270/#280/#300/#306 costs remain open as applicable; none is erased or accepted by an incremental Level result.

## Correctness and negative control

Exact nativeIce **229release tests**, ARM VM **201**,21docs each, formatting/no-default/warnings-deniedrustdoc/frozen generator/assembly checks pass. ARM VM is correctness coverage, not native ARM speed.

The focused existing test covers independent keys/modes, differing input counters,16KiB roots, continuations, canonical digests and XOF, plus8/16-lane reachability. `parent-buffer-controls-epyc-20261108T093938-7b8a3172` passes it, substitutes initialized final-output CVs for the saved input children, and gets nextest100 at the intended **n=2 lane=0 mixed=false canonical-root assertion**. Restoring exact source passes again; tracked inputs match. This neither widens an unsafe source-ring window nor executes arbitrary corrupt payloads.

Fresh assembled proofs1193/1230steps and eight controls pass at b817. They prove the unchanged assembly inputs, **not Rust selectors or the whole pipeline**. This candidate predates the separate foundation test/registry child18027259: no claim that its exact-f16 mutation gate covers this later buffer use. John integrates/retests one current source, including the previously noted test-counter slot collision; no competing foundation port is made here.

## Owner handoff

The demonstrated benefit is **less storage/allocation work and one fewer temporary representation**, while tested timing stays Level. The two-CV reuse invariant is stated where it is used. John can weigh that simpler storage against the invariant and decide whether to take exact b817 on the current integration line. No landing, release, tag, crate upload, worker tuning, hardware rental/deletion or accepted-cost decision by Sam.

`parent-buffer-runs/` retains the wrong-buffer red control, failed one-arrival allocation expectation, corrected diagnostic, all native/proof/A-B/A-A/startup records and complete manifests/instruments. Executables/private operator files/files>=20MB are excluded.

— Sam Shackleton
