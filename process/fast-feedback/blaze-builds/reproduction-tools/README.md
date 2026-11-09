# Replaying the BLAKE3-Servil build comparison

Use a **disposable, quiet root Linux x86-64 VM or machine**, with cgroup v2 CPU/memory accounting, loop mounts, Btrfs tools, Python3.12+, Git, a C compiler/linker and root's rustup installation. The observed machine was Ubuntu26.04.1/Linux7.0.0-38, EPYC9255(24cores/48threads), about395.6GB RAM, GCC15.2/glibc2.43. Allow ample memory (the observed daemon reached11.5GB RSS and the dev cgroup nearly15GB charge), disk space and network for untimed toolchain/dependency preparation. The harness makes a16GiB sparse Btrfs image per execution; retain it and the outputs.

`prepare-replay.py` is a convenience preparer, **not a new measurement implementation**. It copies the exact published executing wrapper for the chosen profile, verifies that wrapper's original SHA256 and uses the recorded source commits. Its sole replay-only wrapper change copies the published original Cargo.lock before`cargo fetch --locked`, preventing future dependency resolution from changing the inputs. `REPLAY-VALIDATION.json` records local hash/parse validation; these new convenience replays have not themselves been executed. The original measured executions and their statuses remain unchanged.

The preparer installs the two included Python helpers into`/usr/local/bin` only if absent; an existing different file stops preparation. These are the same helpers the original wrappers call: exact-text replacement and exact executable/process selection. Review them and the wrapper before running; they are setup dependencies, not clocks.

## Fetch only this evidence directory

Use the full immutable evidence commit linked from the upstream issue in place of`EVIDENCE_COMMIT`:

```sh
git clone --filter=blob:none --no-checkout https://github.com/samshackleton-tech/bench-hashes /root/blaze-evidence
git -C /root/blaze-evidence sparse-checkout set process/fast-feedback/blaze-builds
git -C /root/blaze-evidence checkout --detach EVIDENCE_COMMIT
P=/root/blaze-evidence/process/fast-feedback/blaze-builds
```

Install Cargo/rustc1.99.1 with rustup's minimal profile and select it explicitly for preparation and execution:

```sh
rustup toolchain install 1.99.1 --profile minimal
export RUSTUP_TOOLCHAIN=1.99.1
python3 "$P/reproduction-tools/prepare-replay.py" release /root/bz-r1
# Inspect /root/bz-r1/replay.sh, then run its printed command:
flock -n /root/bench-native-afk.lock bash /root/bz-r1/replay.sh /root/bz-r1

python3 "$P/reproduction-tools/prepare-replay.py" dev /root/bz-d1
flock -n /root/bench-native-afk.lock bash /root/bz-d1/replay.sh /root/bz-d1
```

Run the profiles one after another, not concurrently. Both wrappers retain the original540-second outer bound. If a different/slower machine hits it, retain the failed outputs; changing a bound creates a separately identified execution, not a successful original replay. Each wrapper already performs four alternating fresh pairs,104 builds, digest-change/restoration checks, measurement controls and cleanup. The preparer prints a command rather than executing it.

The expected Blaze input is the exact179,512,564-byte Linuxx86-64 archive:

- URL:`https://blaze-releases.ix.dev/v0.20261105.4/blaze-v0.20261105.4-x86_64-unknown-linux-gnu.tar.gz`
- SHA256:`a8b8f3b36b7397671d3a5bcf739e5e1407e5941ee2345aaf5dc2b0868d44d8e6`
- Expected location:`/var/tmp/blaze-input-SHA256.tar.gz`

The preparer downloads and verifies it only when that location is absent. If the release CDN is inaccessible from the VM, download on another machine and transfer those exact bytes there; an incomplete download is not accepted. Blaze bootstraps its own nightly2026-10-27 during untimed preparation.

## Scope and outputs

The wrapper runs compiler/build scripts as uid65534 with a clean explicit environment,256MiB child memlock, enabled Blaze sandbox, private HOME/state/targets and a namespace-only read-only passwd-home overlay. The real account database and global resource/security policy are unchanged. Disposable cgroup leaves account for the CLI, daemon and compiler children. Linux subreaping keeps the daemon in the measuring process's descendant tree. Core-cycle/instruction/energy scopes remain unavailable, rather than client-only substitutes.

Inspect`RUN/out/samples.json`, `commands.json`, `lifetimes.json`, `load.json`, `measurement-controls.json`, build stdout/stderr, source diffs and digest checks. `replay-provenance.json` distinguishes the replay-only lock pin from the original script. Do not treat build exit0 alone as a passing invalidation control; the planted edit must print the known empty digest and exit42, followed by byte-exact restoration and the original abc digest/exit0.

`cpu_ns` is nanoseconds. The original snapshot dictionaries keep kernel names ending`_usec` even though the driver stores scaled nanoseconds; their exact interpretation is documented in the report/audit. Cgroup memory charge includes file cache/kernel memory; the explicit daemon RSS snapshots are a separate observation.
