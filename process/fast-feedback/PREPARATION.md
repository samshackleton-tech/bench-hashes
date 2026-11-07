# Exact-commit preparation removes about eleven seconds of waiting

The fast-feedback pilot [#147](https://github.com/servil-software-factory/bench-hashes/issues/147) traced its next bottleneck to repository preparation. For a 3.5–5.2 s compiler/reference check, preparation took about 13 s.

The existing runner refreshed each mirror from its remote and imported every cached ref into each new checkout. The mirror also held unrelated branches and their results. The requested commit was already available.

Source [`6146907b4a2f26501ada57bf7d635aab993ff108`](https://github.com/samshackleton-tech/bench-hashes/commit/6146907b4a2f26501ada57bf7d635aab993ff108) removes the unconditional refresh and fetches only the named commit and its full history into the private checkout. An absent commit is fetched by full hash. Every run still gets a fresh checkout and target, checks HEAD, and holds its physical host's lock through preparation, execution and verification. This removes work from the existing mechanism.

## Four adjacent pairs on the same host

Both versions ran the identical compiler/reference script against the same pinned library and tools sources. Order alternated old/new, new/old, old/new, new/old. Each run made fresh checkouts and targets and passed the official abc digest assertion. All eight runs were VERIFIED. Each fetched manifest's runner hash was checked against the version selected for that run.

Old runner: `b66cd509f00a89a2c1458f2a6f63a54ecba84f2d`. New runner: `6146907b4a2f26501ada57bf7d635aab993ff108`. Host: Cherry 1057251, dual Ice Lake. Values below are workflow seconds from the run's monotonic phase records, rounded for reading.

| Pair | Old preparation | New preparation | Old accepted→finished | New accepted→finished |
|---|---:|---:|---:|---:|
| 1 | 13.563 | 2.567 | 17.258 | 6.207 |
| 2 | 13.369 | 2.564 | 17.091 | 6.194 |
| 3 | 13.321 | 2.583 | 16.976 | 6.242 |
| 4 | 13.366 | 2.583 | 17.030 | 6.235 |

Script execution stayed at 3.54–3.64 s. Raw manifests, phases, logs and generated review summaries are in `prepare-runs/`; `prepare-ab-records.json` maps every pair to its selected runner source and exact integer durations.

## Correctness and work controls

Fresh pinned suites passed **41 tests and twelve fault controls** on Ice Lake and ARM:

- `exact-prepare-check-ice-20261107T185123-a360bcf8`.
- `exact-prepare-check-arm-20261107T185125-f24142d6`.

Real temporary Git repositories exercise full ancestry, an uncached commit arriving later, a known cached commit with its remote offline, fresh working-tree storage and a missing commit stopping before the job. The HEAD-mismatch test makes every Git command succeed but return the wrong commit; the job still cannot run. Three added plants import unrelated refs, force an unnecessary remote refresh or bypass the HEAD check; each fails its named test. All earlier preflight, collection, phase and lock controls still pass.

## Representative checks and the combined path

With the new runner installed:

- `optimized-native-ice-20261107T185655-59306efb`: VERIFIED in **27.1 s**, including 182 native tests, 19 docs, no-default build and rustdoc. Preparation: 0.60 s.
- `optimized-startup-aa-ice-20261107T185725-5a3cae7d`: VERIFIED in **17.1 s**, four fresh build/layout pairs, all eight judgments Level and no load-warning output during one-second collection polling. Preparation: 3.14 s.
- Study `optimized-end-to-end-147`: VERIFIED preflight, then VERIFIED Ice Lake and ARM targets, each fetched with its review summary. Preflight and Ice Lake target each took **6.2 s**; ARM target **7.5 s**. The Ice Lake target finished about 14 s after its preflight was accepted. The source identities and completion ordering are retained in their manifests and phases.

The study's result collection is the command in `COLLECTION.md`. Its preflight mechanism and the live zero-target compiler-failure control are in `PREFLIGHT.md`.

The local installed runner now matches source 6146907. Organization integration remains under review; the physical fast lane stays available at USD 0.74/hour. The next program decisions concern real-work queue tails, proof-cache identity and review turnaround.

— Sam Shackleton
