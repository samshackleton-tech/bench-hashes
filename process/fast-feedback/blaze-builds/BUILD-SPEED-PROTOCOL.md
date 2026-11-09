# Cargo versus canary: build-speed protocol

## Question and scope

Compare the developer's wait for a real BLAKE3-Servil probe on EPYC9255, exact library1cbdf5d72d70d8ed511870b18c7f017cce83da15. Measure release and development profiles separately, each with its own passing pilot and four fresh paired layouts. Cargo/rustc1.99.1 and Blaze canary0.20261105.4/e930296 are different compiler pipelines. Equal requested profiles do not establish equal generated code, runtime speed, safety or test coverage. Existing rustc acceptance gates remain authoritative.

First run a one-layout harness/measurement pilot. It receives no comparative speed verdict. Pilot1 failed during preparation because this release rejects `blaze fetch`, despite the release documentation's command table. Its complete failure remains; preparation now uses seed builds, retaining only toolchains and fetched sources for fresh layouts. After its controls pass, collect four fresh private paired layouts with adjacent alternating sides. Judge the run means together with the frozen Rust rule (3% practical margin,5%FDR). Preserve all raw samples and unsuccessful attempts.

## Cases

- **Fresh project:** installed toolchains and checksum-verified vendored dependencies; fresh project outputs, fresh Blaze state containing only the installed toolchain and standard-library source (no v2 compilation store), and no running Blaze daemon. Prepare both systems with one untimed seed build. Seed artifacts are not cloned into measured layouts. Each workspace contains its own reflinked vendor directory and private source-replacement configuration. OS and sandbox-helper caches are not flushed. This is not a cold machine or first installation.
- **Warm no change:** four repeated invocations against that successful build, with Blaze's daemon alive.
- **Library edit:** replace the public hash implementation with the already validated empty-prefix fault. Each changed build must succeed and the executable must print the exact empty digest and exit42.
- **Restoration:** byte-exact source restoration, rebuild and original digest/exit0. Four edit/restoration cycles per side. Builds are timed separately; source replacement and executable checks remain outside build wall time.

The mutation-like edit measures rebuilding a real library dependency, not cargo-mutants/nextest integration. Actual mutation/test-loop coverage and timings are a subsequent gate; these probe results cannot stand in for them.

Both sides use private source copies, the same generated probe and dependency lock, the same Cargo-vendored source bytes and explicit target directories. Release requests opt-level3, debug=false, incremental=false, lto=false, panic=unwind and codegen-units16. The separate development profile requests opt-level0, debug=2, incremental=true, lto=false, panic=unwind, codegen-units256, debug assertions and overflow checks. Canary's documented default backends are LLVM for release and stencils for development. Native assembly and the library build script remain enabled. Record the requested manifest and both tools' complete output; unsupported or differing profile semantics remain a limitation rather than assumed equivalence. No worker caps.

## Measurement and isolation

Use clocks9994de190259648ede82f7c5e4dbac4f1534a41d for raw wall timing and load windows, through a small Rust callback bridge. Wall scope includes command launch, private uid/environment setup and blocking child wait. A launch-only control records one wrapper launch; it does not establish a universal latency floor, and no overhead is subtracted. Use a blocking wait bounded by an alarm: Python's wait(timeout=...) polls with backoff and is unsuitable inside these wall samples. Pilot2's raw times used that polling path and receive no speed verdict. A Linux subreaper keeps Blaze's daemon in the measuring process's descendant tree so clocks does not classify it as unrelated load.

Each side's child processes enter their own disposable cgroup-v2 leaf immediately before dropping to uid65534. Read cumulative cpu.stat before/after each invocation: this includes the CLI, persistent daemon, compiler and exited children, including work between invocations. Record the full side lifetime as well; per-build CPU brackets are wider than wall brackets. No CPU or memory limits or controller-policy changes. Record memory.current and memory.peak as cgroup charges (including file cache, not RSS), plus the daemon's VmRSS/VmHWM snapshots. Do not sum client-only rusage and call it all-worker cost.

Process-tree core cycles/instructions and build energy are **NA**: the pinned clocks Linux child API has no such hardware scope. Calling-thread hardware counters are deliberately not substituted. This limitation accompanies any result.

Exclusive /root/bench-native-afk.lock from setup through verification. Complete downloads and measurement-helper compilation before quiet samples. No global cache flush, account/configuration change, AppArmor change, filesystem conversion or global resource-limit change. Reuse the proven private Btrfs image, namespace-only passwd home, uid65534,256MiB child memlock and enabled Blaze sandbox.

## Required controls

Before interpreting timing: parse the wrapper and every embedded body; reject a delimiter collision and a missing explicit target path; check cgroup attribution with a CPU-using child and no-work control; propagate a planted command failure; observe the changed digest/explicit42 and restored exact bytes/digest. Stop and wait for the private daemon, verify empty cgroups and remove only those owned leaves. Keep the image and complete logs. Use a short unique private root so the development runtime's nested AF_UNIX path fits sun_path's108-byte limit; retain the first development pilot's long-path failure.
