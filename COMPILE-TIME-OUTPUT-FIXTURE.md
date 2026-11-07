# Compile-time output self-test fixture — bounded, unpromoted trial

2026-11-07 — follow-up evidence for [startup issue #268](https://github.com/servil-software-factory/BLAKE3/issues/268).

**Result:** the same output8/16 startup fixture prepared at compile time removes
about **7–10% of first-initialization retired instructions** on the three measured
hosts. First wall/process-CPU/cycle judgments are **Level**, as are all
already-initialized metrics. This is **not a demonstrated startup time/energy fix**
and is not promoted as a new library change. The earlier accepted/pending startup
trade-offs are not erased by these means.

- Direct baseline: `f47d9e5d284aafcbabf7b6b2105bdedde4832261` (#278).
- Trial: [`037165b0cdd5724614df872a7c16cb70ead55ef2`](https://github.com/samshackleton-tech/BLAKE3/commit/037165b0cdd5724614df872a7c16cb70ead55ef2), `probe/sam-output-fixture-const`.
- Measurement/paired rule: bench/clocks
  `415e7df398d42d6cc34b965a4c033a02798a9dd6`, four fresh layouts,
  alternating process executions, 3% practical margin /5% FDR.
- 32 fresh process executions per source over four layouts; each calls
  `initialize()` once, then again. Layouts are the paired units. Lock held before
  preparation through verification; source/script hashes and private targets.

## What changed, and what did not

Pinned baseline disassembly shows runtime loops building the fixture's lengths,
flags, arbitrary CVs and padded blocks. The trial stores the **same** four arrays
in read-only static data, prepared by constant evaluation. Descriptors still form
at runtime; actual compression, checksum folding, kernel entry/reachability,
corruption checks and registration counts remain runtime work.

The existing mixed CV/root/parent checksum remains **`0x153e0dfbeac2bb44`**. A new
unit test compares every byte, length, flag and CV against the original runtime
preparation. Native 9700X checks pass **191/191**, with serde/zeroize, no-default,
19 doctests and warnings-denied rustdoc. This is the scoped native/build coverage
of an experiment, not a claim of a new five-host release gate.

No new kernel, assembly, ABI, public API, Hasher field, worker or timing heuristic.
The private static fixture adds roughly 1.5 KiB of fixed data and replaces runtime
construction. It does not remove startup cryptographic work or test fewer cases.
Existing immutable-input compression contracts are unchanged.

## First initialization results

| Host | Wall ns old → new | Process CPU ns old → new | Instructions old → new | Judgment |
|---|---:|---:|---:|---|
| 9700X | 25765.3438 → 25295.8438 | 25981.9062 → 25515.8125 | 128499.7812 → 118939.2500 | time/CPU Level; instructions Faster |
| Ice Lake 6330 | 68189.5938 → 64555.8125 | 69078.3438 → 65443.0938 | 99909.3438 → 90299.0938 | time/CPU Level; instructions Faster |
| Zen 3 EPYC 7443 | 35347.5625 → 32091.9375 | 36643.7812 → 33341.8750 | 131525.8750 → 121911.2500 | time/CPU Level; instructions Faster |

Cycles are Level too. The Ice/Zen 3 lower mean times are retained, **not promoted
to a time gain despite their Level paired judgments**. Already-initialized wall,
CPU, cycles and instructions: all Level on all three hosts. No package energy was
measured for these process-start samples, and no energy gain is inferred from
instruction counts.

This is a bounded check of equivalent fixture preparation, not a broad startup
campaign or a reason to rerun until a favorable timing verdict. Recommendation:
retain as an option if instruction-work/initialization simplicity is valuable to
reviewers, otherwise park; no extra runtime mechanism needs to land without a
clearly accepted benefit/footprint trade-off.

Raw: [`startup-fixture-const/`](startup-fixture-const/), **four VERIFIED records**
(native + three startup comparisons), exact sources/manifests/logs and all means.
The previous shared-fixture study and its separate measured source remain in
[SHARED-STARTUP-TRIAL.md](SHARED-STARTUP-TRIAL.md), not pooled into this result.

Sam Shackleton owns #268 evidence/follow-up; John Servil owns independent review
and integration. No PR, merge, tag, release or crate upload for this trial.

— Sam Shackleton
