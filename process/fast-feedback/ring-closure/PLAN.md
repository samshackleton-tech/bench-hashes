# Ring closure and cursory-reader safety audit

Authorized by Sam's user on 2026-11-08. Current source check: 14:27 UTC.

## First: John's requested ring gate

Candidate ddb7199d7f0b0f04390e923474b630ffc7ff2811, baseline fbfb319f3414ac7fac4b3d4bce266488a1fdee3b; both remain frozen. Bench/clocks 7ea20449cdc97540bfeecf35574b548d1a1f0d0d includes pipeline receiving in its regression scope. Previous 0df/alignment/40985 sources and verdicts stay separate. The owner excluded the alignment prototype; no second implementation or protocol change by Sam.

1. Fresh locked Ice native tests/docs/build checks, deterministic delayed-copy publication control, exact changed-line mutation gate. Use the registered tests unchanged first. Preserve live survivors, timeouts, equivalent names and the time budget separately.
2. Inspect the canonical check's scope and phase costs. Run complete ST/MT/pipeline receiving work with standard fresh pairs/suspect confirmation, retaining wall time, cycles, instructions, energy availability and busy-pair exclusions. Check actual fat-LTO machine code for the copy-elision hypothesis, and native layout/ownership for cache-line hypotheses. No cause inferred from timings or source field order.
3. Coordinate matching current-source i7 coverage with Devon. #306 remains open until the new source and explicit owner judgment address the costs; no transfer of old measurements.
4. Publish all raw evidence/failed controls and hand the exact source back to John. No organization merge/release/tag/upload, worker tuning, rental/deletion, or workflow development.

Individual jobs remain below ten minutes while the user is present. Keep normal test parallelism and comparison pair counts. If an intact confirmation exceeds the budget, leave the verdict pending and ask before the longer run. Quiet timing and unrelated compute use separate physical hosts. Use pinned-run before preparation through verification and strict ED25519 transport.

## Parallel reading track: safety audit requested by the user

Question: what can harm users when a competent programmer reads the quick start, skims the docs and makes ordinary assumptions? Cover current next first, then identify how queued integration stages alter the answer. Keep source identities separate.

Inspect silent wrong digests/lost or unfinished work/key and mode changes, memory safety, liveness and unbounded resource use. Trace reset/finalize/XOF, duplicate and out-of-range indices, partial batches, streaming readers and callbacks, error/cancellation/panic paths, completion/Drop, aliases/lifetimes, C API contracts, initialization/platform failures, and secret-bearing copies/zeroization.

For each finding: plausible caller code; reasonable assumption and docs visibility; actual behavior; concrete harm; executable positive/negative repro where safe; smallest remedy using existing mechanisms; severity and owner. Separate permitted but hazardous behavior, documentation mismatch, and implementation defect. A buried warning is evidence of a sharp edge, not automatic clearance. Findings are not a request for new APIs or a broad mutator/workflow campaign. Escalate credible safety blockers promptly; owner decides API changes.

Read locally while remote checks run. Audit correctness repros use a separate locked host and stay out of quiet timing. No arbitrary corrupt task execution or widening the known old unsafe ring schedule.
