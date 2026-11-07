# First fast-lane runs: Cherry dual Ice Lake

Pilot [#147](https://github.com/servil-software-factory/bench-hashes/issues/147), under [#146](https://github.com/servil-software-factory/bench-hashes/issues/146). Cherry **1057251**, dual Xeon Gold 6330/256 GiB, `185.8.106.126`; **USD 0.74/hour** (USD 124.32 for seven days). Physical host separate from existing timing machines.

## Bootstrap and lockdown

A bounded, role-specific bootstrap installed Rust 1.99.1, LLVM/Clang, build packages and an existing verified nextest 0.9.149 binary. The binary's SHA-256 on the source and new host was `37e995af7bb62c3e2fcd4b8149e44c30997c745a28aee65d7f26ad4069d18ff4`. `bench-lockdown` passed all three controls: the everyday key rejects shell commands, answers pinned-run requests, and the interactive key gets a warning shell without the benchmark lock. The bootstrap source is in [#148](https://github.com/servil-software-factory/bench-hashes/pull/148).

Cloud-init finished with a networkd-wait-online/rename warning; SSH, apt, git, Rust and pinned-run operations all completed. The bootstrap did not run workload timing.

## First checks

Every result below is VERIFIED and fetched in `fast-lane-runs/`. Each job's manifest names its full source hashes and its script hash. The runner holds its host lock from before preparation through verification. These durations use the fetched monotonic phase records from the same boot.

| Job | Accepted→finished | Lock→prepared | Prepared→job finished | Result |
|---|---:|---:|---:|---|
| `fast-lane-native-ice-20261107T180656-fc6ef8bf` | 29.8 s | 2.115 s | 27.621 s | 182/182 nextest tests, 19 docs, no-default build and rustdoc |
| `fast-lane-startup-aa-ice-20261107T180802-02aa6e85` | 21.2 s | 7.091 s | 13.990 s | Four fresh layout/build pairs, 32 alternating process launches; all eight wall/CPU/cycles/instruction judgments Level; no load warning |
| `fast-lane-runner-check-ice-20261107T180923-5385051b` | See `phases.jsonl` | See record | See record | 21 runner tests and all four fault controls passed |

The native and startup checks use BLAKE3-Servil main `6e0dffd37e04b01b80dc56eb833b00fc337b6873`. The startup A/A uses bench-hashes/clocks `415e7df398d42d6cc34b965a4c033a02798a9dd6`; both sides use the identical library commit. `out/judgments.tsv` contains every cell and the original process samples are in `out/processes.tsv`. This is the pilot's first short timing check and an A/A validation of its instrument on the new host.

The 314-job historical sample in `REPORT.md` found a 362.5 s median launch-to-result among 17 startup jobs and 9.7 s median script execution. These pilot events separate lock waiting, preparation and execution for subsequent comparisons.

## Next decision

Keep this host available for the interactive lane. Run the next real short jobs through it, preserving quiet physical exclusivity for timing. Record a useful sample of queue tails alongside the existing host before judging the weekly spend against the 2× productivity criterion. Instrument preflight-before-fan-out and study-scoped collection are separate pilot steps.

— Sam Shackleton
