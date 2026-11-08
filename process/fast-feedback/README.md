# Fast-feedback pilot — November 7, 2026

Program [#146](https://github.com/servil-software-factory/bench-hashes/issues/146) seeks faster development feedback at the same quality. Pilot [#147](https://github.com/servil-software-factory/bench-hashes/issues/147) supplies reserved physical capacity and an end-to-end pinned workflow.

## November 8: library optimization resumed

Sam The User redirected work to major BLAKE3-Servil optimizations before multithreading tuning. Further workflow experiments are parked; the deployed runner is unchanged. [Current output16 integration](output16-next/REPORT.md) and the [grouped first-chunk stage](first-chunk-next/REPORT.md) use that runner. Startup/sparse/crossover costs and historical alternatives stay separate; the first-chunk stage also retains an unresolved pipeline-doctest gate hold.

## Pilot delivery

The deployed runner preflights an instrument, submits matching target inputs, collects the next result by study and writes a source/latency/judgment summary. Fresh checkouts use the requested commit's history from the existing mirror. Host requests authenticate enrolled ED25519 keys.

John integrated [bench-hashes PR #150](https://github.com/servil-software-factory/bench-hashes/pull/150), including #148/#149, into `next` at **`0b9ccc2f9cfc783700a62e8943237527f0c64e47`**. [The maintained runner lives there](https://github.com/servil-software-factory/bench-hashes/tree/0b9ccc2f9cfc783700a62e8943237527f0c64e47/tools/pinned-run); this branch holds evidence. Its files match reviewed source C4 byte for byte. **44 tests and sixteen fault controls** passed on Ice Lake and ARM with empty HOME and system-only PATH, and in both hosted Linux CI jobs. John and Devon also reproduced the checks independently on ARM and x86.

The reserved dual Ice Lake host costs **USD 0.74/hour / USD 124.32/week**. Representative native validation returned in **27.1 s**; startup A/A returned in **17.1 s**. A compiler/reference job's four paired checks fell from **16.98–17.26 s to 6.19–6.24 s**. Combined preflight→Ice Lake target finish took **14.1 s**. The reports identify the source and conditions for every result.

## Reports and raw records

| Read this for | Report | Raw records |
|---|---|---|
| Mixed-key held stages: full cycles, consume-once finish and sparse costs | [Mixed-key stage](mixed-stage-next/REPORT.md) | [Exact-source phase records](mixed-stage-next/mixed-stage-runs/) |
| Independent CPU-native ring-slot ownership validation and deterministic red control | [Ring safety](ring-slot-native/REPORT.md) | [Exact-source native records](ring-slot-native/ring-runs/) |
| Real eight-message AVX-512 groups: exact incremental/aggregate gains and costs | [Real-eight stage](small8-next/REPORT.md) | [Raw native/proof/cycle records](small8-next/small8-runs/) |
| AVX2 output8 integration checks and AVX-512 control/performance holds | [Output8 stage](output8-next/REPORT.md) | [Native/proof/control records](output8-next/output8-runs/) |
| Grouped first-chunk whole-work gains, costs and correctness hold | [First-chunk stage](first-chunk-next/REPORT.md) | [All positive/failed records](first-chunk-next/first-chunk-runs/) |
| Current-API output16 kernel integration and costs | [Output16 integration](output16-next/REPORT.md) | [Current-source records](output16-next/integration-runs/), [retired parallel port](output16-next/EARLIER-PORT.md) |
| Historical delay, failed probes and priorities | [Process audit](REPORT.md) | [Deduplicated run audit](run-audit.json) |
| Real-change outcomes versus short-job feedback | [Initial feedback snapshot](FEEDBACK.md) | [Phase audit](pilot-audit.json), [review events](decision-audit.json) |
| Phase records and initial checks | [First slice](STARTED.md) | [ARM/Zen 3 phase checks](phase-runs/) |
| Hardware, lockdown and first native/timing runs | [First fast-lane runs](FAST-LANE-ICE.md) | [Fast-lane records](fast-lane-runs/) |
| Clock, counter, timer, load and energy validation | [New-host machine profile](MACHINE.md) | [Machine checks](machine-runs/) |
| Compile/reference gate and zero-target failure control | [Preflight](PREFLIGHT.md) | [Preflight records](preflight-runs/) |
| Study-scoped fetch, summaries and named-run wait follow-up | [Collection](COLLECTION.md) | [Collection records](collect-runs/), [wait checks](wait-runs/) |
| Four old/new preparation pairs and representative checks | [Exact-commit preparation](PREPARATION.md) | [Preparation records](prepare-runs/) |
| Reviewer fixes, clean environment and host-key rejection | [Host authentication](HOST-AUTH.md) | [Authenticated checks](host-auth-runs/) |
| Proof-cache dependencies, reuse scope and executed-driver identity | [Proof-cache identity](PROOF-CACHE.md) | [Initial checks](proof-cache-runs/), [driver follow-up](proof-driver-runs/), [input history](proof-key-history.json) |
| Fast controls before longer CI work; evidence-only trigger cleanup | [CI handoff](CI.md) | [Hosted CI records](ci-runs/) |
| Local backend’s lifecycle findings and clean-HOME regression | [Independent review](LOCAL-REVIEW.md) | [Reproductions and failed check](local-review-runs/) |

John integrated the [proof-cache correction #290](https://github.com/servil-software-factory/BLAKE3/pull/290) into `next` at **`31c11c254c3bce80ff2cd00543fd693f6969fb37`** and independently reproduced its three tests. It changes cache selection and tests, leaving library code and proof definitions unchanged.

## Deferred follow-through and external review

- Resolve the lifecycle/reviewer-fixture findings on Devon’s local backend [#152](https://github.com/servil-software-factory/bench-hashes/pull/152), then check its execution bounds; [review](LOCAL-REVIEW.md).
- Independent review/integration of the one-second named-run wait [#153](https://github.com/servil-software-factory/bench-hashes/pull/153) and executed-driver proof-cache identity [BLAKE3 #293](https://github.com/servil-software-factory/BLAKE3/pull/293).
- Extend the [initial real-work snapshot](FEEDBACK.md) with client invocation→display time, real queue contention and reviewed decisions per week, weighed against the added hardware cost.
- Enrollment of remaining fleet hosts before their first request with the authenticated client.
- Later #146 work: dependency-complete evidence reuse, proof throughput and calibrated 80/20 screening.

The API settled and the user resumed library optimization on November 8. Frozen optimization review heads and their cost decisions remain separate from this pilot; no multithreading tuning or release follows automatically.

— Sam Shackleton
