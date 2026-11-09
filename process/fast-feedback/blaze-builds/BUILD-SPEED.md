# Canary build-speed results

## Release builds: Cargo is faster in this trial

Blaze canary0.20261105.4 builds the real BLAKE3-Servil probe correctly, but takes longer than Cargo/rustc1.99.1 in all four release-build cases. All eight wall/CPU comparisons are **Slower** under the existing paired Rust judge (3% margin,5%FDR).

|Release case|Cargo mean|Canary mean|Canary/Cargo, judged ratio|
|---|---:|---:|---:|
|Fresh project|1.687s|18.893s|11.20× Slower|
|Warm, no change|9.848ms|431.394ms|43.81× Slower|
|Library edit|965.578ms|6.676s|6.91× Slower|
|Exact restoration|965.944ms|3.828s|3.96× Slower|

Means contain every sample. The judged ratio is the geometric mean of four paired run-mean ratios, not a quotient composed from other baselines. First-edit and first-no-change costs remain in the samples: they are work a caller meets, not discarded warmups.

Canary's daemon had **7.47–9.13GB resident memory** in the post-build snapshots. Its full side lifetimes used312.8–315.9CPU-seconds versus Cargo's29.2–29.3CPU-seconds, including checks and shutdown. These lifetimes are resource observations, not an additional judged speed cell. Build-bracket CPU includes the CLI, daemon, compiler and exited children; CPU outside those brackets is retained separately in `AUDIT.json`.

## What ran

RunnerVERIFIED `blaze-build-speed-paired-20261109T173513-23a257b1`, EPYC9255. Four fresh paired private layouts, adjacent alternating sides;104 timed builds,32 explicit changed-digest exits42 and72 correct-digest exits0. Every private library source was restored exactly.71 clocks load windows, none busy. All ten owned cgroup leaves ended empty and were removed; private daemons stopped. The full source remains1cbdf5d72d70d8ed511870b18c7f017cce83da15.

Both pipelines received the same probe, Cargo.lock and checksum-verified Cargo-vendored dependencies, with private workspace-local source configuration. Release requests opt-level3, debug=false, incremental=false, lto=false, panic=unwind and codegen-units16. Native assembly/build scripts remain enabled. Canary uses its pinned nightly2026-10-27 and LLVM release backend; Cargo uses its copied1.99.1 toolchain. These are distinct compiler pipelines, not a rustc cache comparison.

“Fresh” means fresh project outputs and no running daemon or v2 compilation store, with toolchains/source/dependencies already prepared. OS caches and sandbox-helper caches are warm. Cargo's installed standard library is prebuilt; canary's fresh build compiles standard-library functions. That is part of these pipelines' observed first-project cost, not a claim about frontend speed alone. Warm cases retain each tool's normal successful-build state.

Wall scope is command launch through blocking wait, including private uid/environment setup. Cgroup CPU snapshots bracket a wider interval. **Process-tree cycles, instructions and build energy are NA**: the pinned clocks Linux child API has no all-worker hardware scope. Calling-thread or client-only counters are not substituted.

Cgroup `memory.peak` is11.82–11.98GB for canary and225–226MB for Cargo, including file-cache/kernel charges: it is **not RSS**, and page-cache ownership depends on earlier preparation. The daemon's explicit `/proc` RSS snapshots above describe its resident process separately. One launch-only control is retained; no wrapper overhead is subtracted or treated as a universal latency floor.

## Development builds: Cargo is faster here too

The separate unoptimized profile also passes the functional/edit/restoration controls. Its four-pair comparison favors Cargo in all four cases; all eight wall/CPU cells are **Slower**, judged together within this profile using the same3% margin/5%FDR rule.

|Development case|Cargo mean|Canary mean|Canary/Cargo, judged ratio|
|---|---:|---:|---:|
|Fresh project|1.750s|19.887s|11.38× Slower|
|Warm, no change|12.580ms|457.553ms|36.42× Slower|
|Library edit|253.476ms|7.156s|28.27× Slower|
|Exact restoration|242.618ms|4.142s|17.07× Slower|

RunnerVERIFIED `blaze-build-speed-dev-paired-20261109T174723-5ee366f7`. Another104 builds/32 changed-digest exits42/72 correct-digest exits0,53 quiet load windows, exact restoration and ten removed empty cgroups. Development explicitly requests opt-level0, debug=2, incremental=true, debug assertions/overflow checks and256 codegen units. Canary's documented backend there is stencils. The profile's complete sources/commands and raw warnings remain available; equal requested settings are not output-equivalence evidence.

Canary's sampled daemon RSS is8.27–11.51GB. Its cgroup peak charge is14.68–14.92GB including file-cache/kernel charges; Cargo's is197–198MB with the same accounting caveat as above. Full side lifetime CPU is302.0–311.5CPU-seconds versus Cargo's5.91–6.15CPU-seconds, unjudged resource observations including checks/shutdown.

The first development pilot174203 failed on an overlong nested AF_UNIX socket path, after the untimed seed build passed. The repaired short-root pilot174454 passes all functional/measurement controls and remains unjudged. These are harness repair and validation, not evidence of compiler incompatibility. Both executions are preserved separately.

## Controls and preserved setup failures

- Pilot171939 failed because the actual release has no `blaze fetch` command, despite its documentation's command table.
- Pilot172334 passed Cargo's full edit/restoration cycle, then canary refused offline downloads in a fresh store even though the unpacked sources were present. Source copies alone do not populate its content-addressed fetch cache.
- Pilot172803 demonstrated that a directory source outside the workspace's mounted view is refused. Both sides now use identical workspace-local vendor directories.
- While inspecting the pilot, I removed Python's `wait(timeout=...)` polling/backoff from the wall bracket. Blocking wait is bounded by a child deadline alarm instead.172334's polling-based raw times receive no speed verdict.
- Pilot173122 passes the complete measurement/digest/restoration controls; it remains an unjudged one-pair pilot, separate from the four-pair result.
- Each paired run also rejects a planted exit17 and a planted deadline, reaps the deadline child and verifies cgroup attribution with sleeping versus CPU-using children. Four local harness tests reject delimiter collisions, missing explicit output directories and polling waits. Four independent reader-corruption controls reject a busy window, missing build, CPU-counter mismatch and accepted wrong digest.
- Final host inventory found an empty cgroup leaf left by failed pilot172803's asynchronous kill cleanup. Its raw cleanup had correctly recorded the still-exiting PID. The final check confirmed zero processes/populated0 and removed only that exact empty owned leaf. `host-after-build-speed.json` confirms no study cgroups remain, real nobody home`/nonexistent`, root ext4`/dev/md0` and ordinary8MiB memlock.

Raw CPU snapshot dictionaries retain kernel keys ending`_usec`, but the executed driver scales those stored values to **nanoseconds**. The correctly named`cpu_ns` field and reader/audit use nanoseconds throughout; original raw files remain unchanged.

## Decision and remaining scope

**Keep Cargo/rustc for this workflow.** Neither tested profile provides a build-speed benefit, and canary's resident-memory cost is substantial. Existing Cargo/rustc acceptance gates remain unchanged. These208 builds/64 explicit changed-digest rejections/144 correct-digest checks measure a real library dependency's edit/rebuild cycle, **not** the complete cargo-mutants/nextest loop, all tests, compile-fail safety coverage or runtime-performance equivalence. No actual mutation-loop speedup is claimed, and no adoption is justified by this trial.

Protocol: `BUILD-SPEED-PROTOCOL.md`. Exact raw runs: `runs/blaze-build-speed-paired-20261109T173513-23a257b1/` and `runs/blaze-build-speed-dev-paired-20261109T174723-5ee366f7/`. Frozen-judge inputs/results and integrity checks: the corresponding`analysis-blaze-build-speed-{paired|dev-paired}-.../` directories (`judgments.tsv`, `AUDIT.json`). Exact executing wrappers are retained by SHA256 under`executing-drivers/`; mutable current filenames are not substituted for earlier executions.
