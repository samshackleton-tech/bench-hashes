# Eligibility before pointer gathering — frozen, unpromoted experiment

**No integration offered.** This three-added/two-removed-line Rust experiment was started before the foundation mutation priority was seen. It is frozen at **`a5d1d3e82429df33ef411cb657e88067dfd87d02`**, personal branch`candidate/sam-output-precheck`, worktree`~/work/b3-output-precheck`. Baseline **`4f1dd19c83122dfee2c62c1304eb593b812ee992`** is the previously handed-off whole stack. The experiment does not replace that endpoint or any frozen PR head. No further implementation/testing was launched for it after the priority switch.

## Hypothesis and source change

`ffi_output::staged_group<W>` previously gathered all W Hasher pointers before its existing eligibility predicate could reject the first unsupported state. The experiment checks the same predicate through `which` first, then builds the same states array only if eligible. No new predicate/case/API/state/policy; successful paths still gather the pointers. This removes unnecessary source-level work on rejected groups, but its role in prior finish timing is a hypothesis, not established causation.

## Exact instrumentation / work

All reported jobs use pinned-runC4, full source identities, fresh private checkouts/targets, locks before preparation through verification, and quiet timing separated by physical host. Bench/clocks **`9994de190259648ede82f7c5e4dbac4f1534a41d`**. Four fresh layout pairs, alternating adjacent sides, shared clocks summary3% practical margin/5%FDR. No local i7 compute, physical AVX2 substitute, thread cap/serialization or timing outside the runner.

- Large update includes descriptor refill/selected reset/updates; complete cycle includes library allocations/updates/canonical digests/reset. Caller construction/key preparation are outside these counters as documented in the unchanged modern mixed-stage probe.
- Finish prepares a64-sample cohort outside counters and consumes/resets each prepared state once, bookkeeping included; energy **NA**, not zero. Not repeated immutable finishing.
- Small cycles use the existing17/256B/count/mode matrix, full grouped work. Startup uses the unchanged initialize instrument and reports wall/CPU/cycles/instructions separately; no short-window energy claim.

## Incremental4f→a5: no broad measured benefit, one retained cost

| Study | Ice | EPYC |
|---|---:|---:|
| large update |320Level|320Level|
| large complete cycle |320Level|320Level|
| consume-once finish |256Level|256Level|
| small complete cycles |2039Level/**1Slower**|not run|
| exact small A/A |2040Level|not run|
| exact large A/A |not run|896Level|

The Slower small cell is **Plain128B/256Bpieces,32messages, package energy9504.3896→9792.6845nJ, +3.0%**. Current-source A/A does not erase it or establish its cause. Package energy includes background/idle energy; no cache/frequency/alias/stack cause is claimed.

A representative Ice finish row removes roughly9instructions: distinct-key128×16KiB,685.8781→676.5017instructions/message,−1.4%, **Level** at the3% practical margin. This is not a broad finish-speed win or equal cost.

Exact jobs: largeIce`075708-66a372c6`,EPYC`075708-a0292096`;smallIce`080006-9ecc4a34`;smallAA`081231-670c6498`;largeEPYCAA`080210-210bd382`. Full run names and all rows are retained in `output-precheck-runs/`.

## Separate direct aggregate, not composed ratios

Direct **original-next7ee5c1f8cfad7937fb490e6510f8f36fe5ce912f→a5**:

- Ice update152Faster/168Level;complete cycles155Faster/165Level;finish12Faster/243Level/**1Slower**.
- EPYC update154Faster/166Level;complete cycles154Faster/166Level;finish256Level.
- Remaining Ice finish Slower: Plain16×16KiB/4KiBpieces, wall134.3501→138.6570ns/message,+3.2%.

These current-source aggregate distributions differ from the earlier4f aggregate finish distribution. **That does not prove the pointer-gather change fixed those prior costs**: the direct incremental comparisons above are all Level. No independent ratios are composed, no earlier Slower result is deleted/called noise, and no new startup/kernel/canonical whole-suite claim is inferred from this aggregate.

Aggregate jobsIce`080931-48919b48`,EPYC`080532-49cbc5be`. This experiment has no native physical-i7 speed gate. It is not Devon’s925e/a6/4f record or benchmark49f45960.

## Correctness and startup scope

Exact nativeIce229/ARM VM201release tests and21docs each pass, plus formatting/no-default/warnings-deniedrustdoc/frozen checks. Fresh assembled output16/output8 proofs1193/1230steps and eight fault controls pass; they prove the assembly, **not Rust selectors or the pipeline**. Native jobs `075520-4f38ba11`, `075521-3486690e`, preflight`075449-15da4a6f`; proofEPYC`080957-281f498a`.

EPYC startup comparison`080931-3906b115` and A/A`080944-c849a944`:all8Level each. EPYC is an AVX-512 host here, not a native AVX2 startup result. Earlier whole-stack startup Slower cells/#268 are not erased or accepted by this Level incremental comparison.

This prototype predates the separate foundation test/registry child18027259. Its passing assembly/native checks are not substituted for that later exact-f16 Rust-wrapper mutation gate, and the latter is not relabelled as this prototype’s coverage. Any revival must use the owner’s current integration source and appropriate exact-source quality/cost gates.

## Decision

**Parked, unpromoted.** The code removes apparent work, but the direct study establishes no broad practical speed benefit and retains a new energy cost. No owner cost acceptance is presumed, no mitigation of #270/#300 is claimed, and no new runtime policy is added to rescue the idea. The later-foundation priority and owner integration remain ahead of further optimization; the separately sketched scratch-halves deletion was never implemented.

Raw positive/A-A/aggregate/startup/proof records and complete manifests/instruments are published for review, not offered as a landing gate. No binaries/files>=20MB/private operator data. No organization merge, release, tag, crate upload, worker tuning, rental or deletion.

— Sam Shackleton
