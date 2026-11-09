# Blaze build experiment — November9,2026

## Current result —16:30UTC

**Canary now builds/runs BLAKE3-Servil, detects a planted source edit, and restores the correct result after byte-exact restoration.** See [CANARY-WORKING.md](CANARY-WORKING.md) for the passing result, isolated prerequisites and all intervening failures. No Cargo-versus-Blaze speed comparison has been measured; existing acceptance gates remain Cargo/rustc-built.

## Initial decision —15:30UTC (historical)

Keep the existing Cargo/rustc workflow. This bounded pilot reached two host-prerequisite failures before a Blaze-built BLAKE3-Servil executable could be validated. **There is no build-speed comparison or measured speedup.** These outcomes establish problems with this isolated setup, not a general inability of Blaze to compile BLAKE3-Servil.

The user requested this experiment before resuming the independent runtime/test/formal follow-ups. Those follow-ups remained paused during the pilot.

## What was tested

EPYC9255, Linuxx86-64. Exact library source **1cbdf5d72d70d8ed511870b18c7f017cce83da15**. Each release had a fresh private library copy, probe project, target, HOME, Cargo settings and Blaze daemon state. The tool and build scripts ran as unprivileged uid65534, with an explicit clean environment and no root SSH, Git or API credentials. Global toolchains/configuration/security settings stayed unchanged.

The probe calls `initialize()` and the real public `convenience::hash(b"abc")`, prints the source identity and digest, and asserts the official known digest. It is a functional executable, not a substitute for the repository's nextest suites.

|Side|Actual outcome|
|---|---|
|Cargo/rustc1.99.1|Release build succeeds; executable produces6437b3ac38465133ffb63b75273a8db548c558465d79db03fd359c6cd5bd9d85 and exits0.|
|Blaze stable0.20261027.0|Version/help and own nightly bootstrap succeed. Build exits101: the BLAKE3-Servil build script's sandbox cannot write`/proc/self/setgroups` (permission denied).|
|Blaze canary0.20261105.4|Version/help and own nightly bootstrap succeed. Build exits101 before project compilation: daemon native driver reports`io_uring registered buffers: Cannot allocate memory` and exits.|

Both releases downloaded their own nightly2026-10-27 successfully. The current main-branch documentation differs from the actual release command surface; the observed release behavior is authoritative here. Stable's binary reports`0.20261027.0 (49ca152)`; its release tag currently resolves to5d4f78f7577cf7170993b74f735099dd03f5c6ca. The exact archive hash, not an assumption about that difference, identifies the executed artifact. Canary reports e930296, matching its tag e93029602544df9882fffb18bf272d048a1a7136.

## Host prerequisites and limits

Read-only inventory after the experiment:
- unprivileged user namespaces enabled, AppArmor restriction on unprivileged namespaces enabled;
- experiment uid's soft/hard locked-memory limits both8,388,608bytes;
- approximately395GB physical memory and383GB available at inventory time.

The stable error identifies its namespace/sandbox setup boundary. The canary error identifies registered I/O buffers, not a demonstrated shortage of ordinary heap memory. The8MiB locked-memory limit is a concrete lead, **not a cause established by an ablation**. Neither global policy nor resource limits were changed to obtain a successful build.

The planned incremental witness changes only the private copy's public hash implementation to hash the empty prefix, expects the digest assertion to fail after rebuilding, then restores exact bytes and expects the correct digest again. **Neither Blaze side reached this control.** We therefore make no cache-invalidation, test-completeness or output-correctness claim for Blaze.

## Failures, provenance and shutdown

First item`blaze-build-compatibility-20261109T150658-ed842204`FAILED during artifact download: the host received HTTP403 from the release CDN. Raw manifest/log are retained. One transport repair downloaded the archives locally, verified the published SHA-256 values, and provisioned hash-named read-only files under the host's exclusive bench lock. The repaired job rechecked the complete bytes, and computed BLAKE3 digests with official b3sum1.8.7.

`blaze-build-compatibility2-20261109T151801-8a3be8c4` is runnerVERIFIED **as an outcome-collection experiment**. That status does not turn the two failed Blaze builds into passing builds. `commands.json` records each exit separately. `daemon-diagnostics.json` contains the precise daemon/worker logs;`platform-prerequisites.json` contains the read-only resource/policy inventory.

Both per-release `stop` commands returned0. A later redundant root-shell cleanup emitted a permission error while looking for a workspace pin in its inaccessible current directory; that log is retained too. The current study has no queued/running job. Original library and existing development/evidence worktrees remain unchanged.

The release channels observed at the start were stable0.20261027.0 and canary0.20261105.4. Archives:
- Stable75,969,513bytes, SHA-256`df61ce6d8216087a40e986d4f84cf2a230638bde014e38519e08b50282e90e5d`.
- Canary179,512,564bytes, SHA-256`a8b8f3b36b7397671d3a5bcf739e5e1407e5941ee2345aaf5dc2b0868d44d8e6`.

Full binary archives stay out of public text evidence. Their BLAKE3 digests are in the repaired run's`out/release-BLAKE3SUMS`. Setup/download time and tools' self-reported times in raw logs are not compared or presented as benchmark evidence.

## What a subsequent trial must answer

A further trial should first establish a supported unprivileged sandbox configuration and an adequate per-experiment I/O-buffer locked-memory budget. It must then pass the changed-source/restoration witness before measuring.

The useful comparisons are separate: first build, warm no-change invocation, real library edit/rebuild, and the build portion of the actual mutation loop. Cargo and Blaze need explicit matching profiles, dependency/cache preparation and preserved functional checks. Persistent daemon CPU/memory belongs in the accounting; timing only the client would omit its work. The existing clocks child API on Linux has no process-tree core-cycle count, so a fair all-worker/daemon hardware-counter measurement needs that scope addressed rather than relabelling calling-thread counters.

Blaze is a separate compiler, linker and nightly toolchain, not a cache in front of rustc. Its own documentation retains Cargo/CI as the final correctness authority. Even a successful edit-loop trial would initially accelerate development; existing rustc-built safety, nextest, mutation and product-regression gates retain their identities until separately validated.

## Upstream references

Repository main inspected atd42956161394326e6329acca15180739cf278259:
- https://github.com/indexable-inc/blaze/blob/d42956161394326e6329acca15180739cf278259/README.md
- https://github.com/indexable-inc/blaze/blob/d42956161394326e6329acca15180739cf278259/docs/install.md
- https://github.com/indexable-inc/blaze/blob/d42956161394326e6329acca15180739cf278259/docs/toolchain.md
- https://github.com/indexable-inc/blaze/blob/d42956161394326e6329acca15180739cf278259/docs/usage.md

Release-specific documentation and API/channel/checksum responses are retained locally under`discovery/`; the executable bytes are pinned separately above.
