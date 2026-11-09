# Canary functional result — November9,16:30UTC

**Blaze canary0.20261105.4 now builds and runs the real BLAKE3-Servil probe, observes a planted library edit, and restores the correct result after exact source restoration.** This is a functional/incremental-invalidation witness, not a speed comparison or full quality gate.

## Executed result

RunnerVERIFIED `blaze-canary-functional3-20261109T162842-74d4c11e`, EPYC9255. Library source1cbdf5d72d70d8ed511870b18c7f017cce83da15; canary binary reports e930296 and is the SHA256-pinned179,512,564byte archive from the initial report. Sandboxing remains enabled.

|Step|Observed outcome|
|---|---|
|8MiB child locked-memory limit|Daemon startup fails101 with registered-bufferENOMEM.|
|256MiB limit, otherwise same hello program|Build succeeds; executable prints7 and exits0.|
|BLAKE3-Servil release build|Build succeeds, native assembly/build script included.|
|Public hash of`abc`|6437b3ac38465133ffb63b75273a8db548c558465d79db03fd359c6cd5bd9d85, exit0.|
|Exact planted library edit: hash the empty prefix instead|Rebuild succeeds; executable prints af1349b9f5f9a1a6a0404dea36dcc9499bcb25c9adc112b7cc9a93cae41f3262 and takes explicit wrong-digest exit42.|
|Byte-exact library restoration and rebuild|Original correct digest, exit0.|

`out/outcome.json` records all stages, including `library_bytes_restored:true`. Timeouts/crashes are not accepted as the changed-digest witness. The public hash's production source remains unchanged outside private experiment copies.

## Trial-only prerequisites

1. **Locked memory:** each unprivileged trial child gets a256MiB soft/hard limit. The8MiB control still fails; the higher-limit process starts. No system-wide limit changes.
2. **Reflinks:** a sparse16GiB Btrfs image, mounted only in a private mount namespace. A `cp --reflink=always` plus independent-clone-write control succeeds. The real ext4 root is untouched. The drafted XFS wrapper was not run.
3. **A valid account home:** a namespace-local read-only bind of a private passwd copy gives uid65534 a home inside the image. This is needed because a sandbox helper clears its environment and otherwise finds nobody's `/nonexistent` home. An explicit XDG cache setting alone did not solve it. The global account database is untouched.
4. **Explicit build output:** `--target-dir` names the private output directory. Canary's default is its own external build directory, not Cargo's `./target`.

Everything continues to execute as uid65534 with an explicit environment, without root SSH/Git/API credentials. `host-after-canary.json` confirms the real nobody home remains`/nonexistent` and the root remains ext4 on`/dev/md0`. The driver stops and waits for its exact private daemon; the wrapper detaches the namespace-private mount and keeps the image for review. No current study job remains.

## Errors retained, and correction of course

- `blaze-canary-memlock-20261109T154516-f0c1d687`:8MiB fails;256MiB clears startup and reaches compilation, then ext4 refuses the required reflink. Outcome-collectionVERIFIED, not a passing build.
- `FAILED-blaze-canary-btrfs-20261109T155920-6627fe6f`: hello builds, but my harness looks in the wrong output directory; cleanup also reports busy mount. This was my error, not a Blaze compiler failure.
- `FAILED-blaze-canary-btrfs2-20261109T160714-e4448d70`: my embedded wrapper reuses its outer heredoc delimiter. Functional driver does not run. Again my error.
- I unnecessarily switched to stable. The user correctly pointed out that harness errors do not establish that canary is stuck. The stable trial161447-5e9caaf0 was alreadyFAILED on missing functional outputs when checked; `cancel` subsequently recordedCANCELLED on that same execution. Both facts are retained; it supplies no successful stable result. Work returned to canary.
- `validate-canary-harness.py` now parses the outer/embedded shells and Python separately, verifies their identity, and rejects the observed delimiter and output-directory faults. Three local tests pass before launch; no compiler/mount is invoked by this validation.
- `FAILED-blaze-canary-functional-20261109T161842-e8520ef7`: hello builds/runs; BLAKE3-Servil stops because the sandbox's interposer cache tries`/nonexistent`. Daemon exit is observed; busy unmount masks the primary failure with exit32, so both logs remain.
- `FAILED-blaze-canary-functional2-20261109T162414-c7715b75`: explicit XDG cache alone leaves the same sandbox-home error; namespace cleanup is corrected.
- Finalfunctional3 gives the trial uid a valid namespace-local home and passes every functional/rebuild/restoration expectation.

## Scope still open

At this16:30functional handoff there was **no measured Cargo-versus-Blaze speed verdict**. The later independent paired measurements are in [BUILD-SPEED.md](BUILD-SPEED.md). Tools' own times remain in raw logs and are not our benchmark. Full nextest, mutation equivalence, compile-fail safety checks and runtime performance preservation have not been established for Blaze. The successful release build emits an unreachable-code warning at`src/platform.rs:202`, retained rather than suppressed.

This functional gate established canary's usability for the subsequent bounded build-speed/coverage experiment. Its distinct compiler, linker and pinned nightly remain separate from the existing rustc acceptance gates. The stable diversion was unnecessary and has ended.
