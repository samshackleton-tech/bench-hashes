# Study-scoped results, fetched with a review summary

The fast-feedback pilot [#147](https://github.com/servil-software-factory/bench-hashes/issues/147) now exercises the whole path: preflight, target submission, next result, fetched evidence and a generated review summary.

Source: [`b66cd509f00a89a2c1458f2a6f63a54ecba84f2d`](https://github.com/samshackleton-tech/bench-hashes/commit/b66cd509f00a89a2c1458f2a6f63a54ecba84f2d), built on the phase and preflight slices in #148/#149. This is also the installed local runner source.

## One collection command

A manifest's optional `study` names the work it belongs to:

```sh
pinned-run next --study my-change --fetch results
```

The runner contacts only that study's hosts and returns its next finished, unreported run. It fetches the run and creates `REVIEW.md` and `review.json`, then marks it reported. An interrupted fetch or summary remains retryable. Failed results retain the `FAILED-` prefix and their reasons. The CLI's `--help` describes the scope, fetch and wait options.

The summary carries the input identities, workflow intervals and the instrument's judgment counts and attention rows. It copies Slower and unjudged rows beside the runner's VERIFIED status. It links the original judgments and logs; statistical decisions remain with the instrument.

## Validation

Fresh pinned suites passed **37 tests and nine fault controls** on both architectures:

- `scoped-collect-check-ice-20261107T183908-5eafc3e7`.
- `scoped-collect-check-arm-20261107T183910-454f35b6`.

The added controls remove study filtering, omit summary generation and hide Slower rows. Each fails its named test. Tests also cover interrupted collection, malformed judgments, phase version/boot/order, once-only reporting and a VERIFIED run with both Slower and unjudged instrument cells.

### Live end-to-end path

Study `end-to-end-147` produced four collected results:

1. `collect-e2e-good-ice-preflight-20261107T184103-c565fd35`: VERIFIED preflight.
2. `collect-e2e-good-ice-20261107T184123-2306223b`: VERIFIED Ice Lake target.
3. `collect-e2e-good-arm-20261107T184123-383ff170`: VERIFIED ARM target.
4. `collect-e2e-bad-ice-preflight-20261107T184222-b043874d`: deliberate compiler failure. The registry delta again contained exactly one preflight and **zero target jobs**. The collector fetched the FAILED result and generated its failure summary.

All four have fetched manifests, logs, phases and review summaries in `collect-runs/`. A fifth `next` returned exit 3: every result had been reported exactly once. The first three include the official abc digest check described in `PREFLIGHT.md`.

### Short timing check during collection

`startup-scoped-collect-ice-20261107T184246-57568cfa` ran the existing startup A/A instrument while the new collector polled its status once a second. It returned VERIFIED in **18.8 s** accepted→finished, with **eight Level judgments** and no load-warning output. Its summary preserves all eight judgments and their source file. Preparation was 4.7 s; script execution was 14.0 s.

This uses the identical BLAKE3-Servil commit on both sides, four fresh build/layout pairs and the existing clocks/summary judgment. Its full identities are in the manifest. No library code or statistical rule changed.

## Next bottleneck

For the small compiler/reference jobs, preparation took about 13 s beside 3.5–5.2 s of script execution. The current preparation updates a mirror and imports every cached ref into every fresh checkout. Next is a controlled test of fetching only the named commit and its history, while keeping fresh checkouts/targets, exact HEAD checks and the preparation-through-verification lock.

## Named-run wait follow-up

[PR #153](https://github.com/servil-software-factory/bench-hashes/pull/153), source **`6c8d73e7352091e0eb4706059401953911939915`**, aligns the existing `wait HOST RUN` polling interval with scoped `next`: one second rather than twenty. It adds no command, setting, format or state.

The new test checks queued/running transitions and already-terminal VERIFIED, FAILED with reason, CANCELLED and lost results. It checks the exact host/run, requested sleeps and preserved output without sleeping. Restoring the twenty-second interval fails its focused control.

All **45 tests and seventeen fault controls** passed under empty HOME/system-only PATH in the exact-source preflight and both fresh target jobs:

| Pinned run | Accepted→finished |
|---|---:|
| `wait-check-ice-preflight-20261107T221207-80cb4601` | 6.583 s |
| `wait-check-ice-20261107T221216-7199fdcb` | 6.215 s |
| `wait-check-arm-20261107T221216-183ca920` | 6.704 s |

These are workflow phase intervals, not benchmark speed comparisons. `wait-runs/` retains the source/script/tool identities, all tests and planted faults, phases and generated review cards. The stable deployed runner remains the landed #150 version while this follow-up is reviewed.

— Sam Shackleton
