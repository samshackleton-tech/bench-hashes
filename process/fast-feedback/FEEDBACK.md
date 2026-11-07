# Initial real-work feedback snapshot

This [#147 pilot](https://github.com/servil-software-factory/bench-hashes/issues/147) snapshot separates short-job feedback from the decisions those jobs support. It covers work through November 7, 22:40 UTC. Library optimization ports remain paused.

## Useful outcomes

| Work | Observed outcome |
|---|---|
| Runner workflow, authentication and CI controls, #150 | John integrated the reviewed implementation into `next`; John and Devon independently reproduced the checks. |
| Proof-cache dependency gap, BLAKE3 #290 | John integrated the correction and reproduced its three tests. |
| Local backend, #152 | Changes requested. The review exposed terminal/stale-group handling, empty-HOME and cleanup defects, then a separate spawn/cancel ownership window. |
| Named-run polling, #153 | Implemented and validated on both pilot architectures; awaiting independent review. |

These are two owner integrations, one candidate needing corrections and one submitted follow-up. Host, preflight and control runs supply evidence for each outcome.

## Phase-recorded jobs

There are **51 unique retained runs**: **49 with phase records**, plus two initial controls run before phase deployment. The phase-recorded subset has 45 VERIFIED and four FAILED runner results. A successful bug reproduction is VERIFIED while demonstrating a candidate defect.

| Purpose | Jobs | Accepted→finished range |
|---|---:|---:|
| Tool-change validation | 19 | 2.683–28.211 s |
| Real candidate gate failure | 1 | 3.959 s |
| Owned-process bug reproductions | 2 | 2.641–21.078 s |
| Host/instrument validation | 7 | 17.139–39.082 s |
| Controlled preparation comparison | 8 | 6.194–17.258 s |
| Workflow fixtures | 9 | 6.224–19.098 s |
| Deliberate compiler-failure preflights | 2 | 16.916–17.995 s |
| Retained control-harness development failure | 1 | 15.035 s |

The nineteen tool-validation jobs cover ten repository-source identities, with repeated coverage of some changes. This is a coverage inventory of different checks and preparation versions. The four matched old/new preparation pairs remain the controlled comparison in [PREPARATION.md](PREPARATION.md).

The observed lock-acquisition interval across these jobs was at most **0.556 ms**. These jobs encountered an available reserved lane. Sustained contention remains to be observed. Each interval is calculated from monotonic timestamps within one host boot. The two pre-phase checks receive no invented latency values.

## Server completion and review turnaround

The polling follow-up’s real source change used an exact-source preflight followed by fresh targets. All passed 45 tests and seventeen fault controls: **6.583 s** for the preflight, **6.215 s** for Ice Lake and **6.704 s** for ARM. The existing runner collected and summarized the results automatically.

GitHub’s timestamps show these whole collaboration intervals:

| PR | Opened→John’s integration note |
|---|---:|
| bench-hashes #150 | 2 h 24 min |
| BLAKE3 #290 | 1 h 54 min 31 s |

These whole collaboration intervals include author revisions and review. [decision-audit.json](decision-audit.json) retains the event timestamps and owner’s integration evidence. Review turnaround is a separate workflow measure from six-second test feedback. Weekly productivity requires longer observation.

Next observations should record **client invocation→displayed result** alongside the server phases and continue through the reviewed decision. Current phase intervals begin at server acceptance, so client dispatch and collection overhead are not included in the table.

## Reproduction and next measurement

The existing audit script gained a phase-recorded pilot mode. It reuses the maintained runner’s `review_card()` for format/boot/order checks, durations and copied judgments. The reader used here has SHA-256 `f45d9b2e187b4074d7bd10bc8e2dce1ff7430d4f92ede54aab25bdd4172859cf` (landed source `0b9ccc2f9cfc783700a62e8943237527f0c64e47`).

To reproduce this frozen snapshot, check out evidence commit **`1332a176fed74f86e72c41072abf2469906fe7ff`**, then run from its report directory with a checkout of that runner source:

```sh
python3 audit_runs.py --pilot . --runner /path/to/bench-hashes/tools/pinned-run/pinned-run
```

This regenerates the derived review cards and [pilot-audit.json](pilot-audit.json). Categories are explicit. New job kinds require classification. Original phase/manifest/log contents stay unchanged. The historical audit mode remains separate because its older artifacts use different timing evidence.

Keep the lane available at **$0.74/hour** while actual work arrives. Follow the next several real changes through accepted decisions, preserving rejected candidates and useful failures. Judge the added capacity by accepted decisions, their value and the weekly rate.

— Sam Shackleton
