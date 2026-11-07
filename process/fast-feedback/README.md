# Fast-feedback pilot — November 7, 2026

Program [#146](https://github.com/servil-software-factory/bench-hashes/issues/146) seeks faster development feedback at the same quality. Pilot [#147](https://github.com/servil-software-factory/bench-hashes/issues/147) supplies reserved physical capacity and an end-to-end pinned workflow.

## Current delivery

The deployed runner preflights an instrument, submits matching target inputs, collects the next result by study and writes a source/latency/judgment summary. Fresh checkouts use the requested commit's history from the existing mirror. Host requests authenticate enrolled ED25519 keys.

John integrated [bench-hashes PR #150](https://github.com/servil-software-factory/bench-hashes/pull/150), including #148/#149, into `next` at **`0b9ccc2f9cfc783700a62e8943237527f0c64e47`**. [The maintained runner lives there](https://github.com/servil-software-factory/bench-hashes/tree/0b9ccc2f9cfc783700a62e8943237527f0c64e47/tools/pinned-run); this branch holds evidence. Its files match reviewed source C4 byte for byte. **44 tests and sixteen fault controls** passed on Ice Lake and ARM with empty HOME and system-only PATH, and in both hosted Linux CI jobs. John and Devon also reproduced the checks independently on ARM and x86.

The reserved dual Ice Lake host costs **USD 0.74/hour / USD 124.32/week**. Representative native validation returned in **27.1 s**; startup A/A returned in **17.1 s**. A compiler/reference job's four paired checks fell from **16.98–17.26 s to 6.19–6.24 s**. Combined preflight→Ice Lake target finish took **14.1 s**. The reports identify the source and conditions for every result.

## Reports and raw records

| Read this for | Report | Raw records |
|---|---|---|
| Historical delay, failed probes and priorities | [Process audit](REPORT.md) | [Deduplicated run audit](run-audit.json) |
| Phase records and initial checks | [First slice](STARTED.md) | [ARM/Zen 3 phase checks](phase-runs/) |
| Hardware, lockdown and first native/timing runs | [First fast-lane runs](FAST-LANE-ICE.md) | [Fast-lane records](fast-lane-runs/) |
| Clock, counter, timer, load and energy validation | [New-host machine profile](MACHINE.md) | [Machine checks](machine-runs/) |
| Compile/reference gate and zero-target failure control | [Preflight](PREFLIGHT.md) | [Preflight records](preflight-runs/) |
| Study-scoped fetch and generated review summaries | [Collection](COLLECTION.md) | [Collection records](collect-runs/) |
| Four old/new preparation pairs and representative checks | [Exact-commit preparation](PREPARATION.md) | [Preparation records](prepare-runs/) |
| Reviewer fixes, clean environment and host-key rejection | [Host authentication](HOST-AUTH.md) | [Authenticated checks](host-auth-runs/) |
| Generator dependencies in the long-proof cache | [Proof-cache identity](PROOF-CACHE.md) | [Cache-key checks](proof-cache-runs/) |
| Fast controls before longer CI work | [CI handoff](CI.md) | [Hosted CI records](ci-runs/) |

The proof-cache correction is [BLAKE3 PR #290](https://github.com/servil-software-factory/BLAKE3/pull/290), ready for review. It changes cache selection and tests, leaving library code and proof definitions unchanged.

## Open follow-through

- Organization review/integration of the proof-cache correction #290.
- Devon’s local-backend lifecycle corrections and execution bounds; [independent review](LOCAL-REVIEW.md).
- Real-work queue tails, first-actionable-result time and reviewed decisions per week, weighed against the added hardware cost.
- Enrollment of remaining fleet hosts before their first request with the authenticated client.
- Later #146 work: dependency-complete evidence reuse, proof throughput and calibrated 80/20 screening.

Library optimization ports remain paused while the API settles. Frozen optimization candidates and their cost decisions stay separate from this pilot.

— Sam Shackleton
