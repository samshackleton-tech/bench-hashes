# Preflight before fan-out

Pilot [#147](https://github.com/servil-software-factory/bench-hashes/issues/147) now has an exercised preflight gate in the existing runner. It catches a broken probe before spending a second host's queue and build time on it.

Source: [`1b3114d65af5a3d8148b58f804e14b0b24d8b837`](https://github.com/samshackleton-tech/bench-hashes/commit/1b3114d65af5a3d8148b58f804e14b0b24d8b837), built on the phase-recording slice in [#148](https://github.com/servil-software-factory/bench-hashes/pull/148).

## Command and contract

```sh
pinned-run fanout root@FAST_HOST manifest-a.json manifest-b.json
```

The manifests name the same script bytes, repository commits and paths, explicit environment and forbid rules. The runner captures all inputs before submission. It runs one preflight under the first manifest's lock with `PINNED_RUN_PREFLIGHT=1`. The instrument compiles its probe, runs its small reference/work assertions and writes its completion marker. Only a VERIFIED preflight permits target submission. The targets receive the captured inputs and retain their normal output expectations.

The fixture builds BLAKE3-Servil at `6e0dffd37e04b01b80dc56eb833b00fc337b6873` and checks the official `abc` digest through two incremental updates. It exercises the gate with a real compiler and reference assertion. Each target still builds on its own architecture.

## Checks

Both fresh-source suites passed **28 tests and six planted-fault controls**:

- Ice Lake: `preflight-gate-check-ice-20261107T182337-ab3bc11e`.
- ARM: `preflight-gate-check-arm-20261107T182924-6f34ab5c`.

The added controls bypass a failed preflight and accept mismatched source/environment inputs; each makes its named test fail. Existing phase/lock/terminal-result controls also pass.

### Live successful path

1. Ice Lake preflight `preflight-live-good-ice-preflight-20261107T182716-ab6f796f`: VERIFIED in **17.3 s** accepted→finished.
2. Then Ice Lake target `preflight-live-good-ice-20261107T182735-02973d75`: VERIFIED in **18.0 s**.
3. Then ARM target `preflight-live-good-arm-20261107T182736-7dd9e4c6`: VERIFIED in **19.1 s**.

Both targets contain the reference-pass output. Their phase records place acceptance after the preflight finished. These are workflow latencies from monotonic records, with separate lock/preparation/execution events retained in the raw data.

### Live failed path

The same fixture with `PREFLIGHT_PLANT=compile` inserts a compiler error. Run `preflight-live-bad-ice-preflight-20261107T182757-89afe402` failed in **18.0 s**, with `error: planted preflight compile error` and no completion marker. The client exited 1. The local registry delta contains **exactly one run: the failed preflight; zero target jobs launched**. `fanout-bad-receipt.json` and the client log preserve that check.

### Control-development failure retained

`preflight-gate-check-ice-20261107T181722-523d4dfb` used predecessor `348de1c5c0e4e967b7b04bc06bc06445257b3b10`. Its ordinary suite passed, but the input-mismatch fault test reached a mocked submission and then a real status call, yielding a TypeError rather than the intended assertion failure. The corrected test supplies a VERIFIED status to reach its named assertion. The original FAILED run remains beside the successful checks.

Raw outputs, manifests and phases are in `preflight-runs/`; compiler failures retain their FAILED names. Source and instrument identities are recorded in each manifest. No library source changed.

— Sam Shackleton
