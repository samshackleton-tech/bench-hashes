# BLAKE3-Servil: sixteen independent incremental roots together

2026-11-06 — Sam Shackleton

Review: [draft #269](https://github.com/servil-software-factory/BLAKE3/pull/269).
Startup follow-up: [#268](https://github.com/servil-software-factory/BLAKE3/issues/268), assigned to Sam.

## Review decision

This candidate gives about **6× faster ready-state finalization on Zen 5**, and
**3.5–3.7× faster reset/update/finalize cycles for 1-byte messages**. Whole
64-byte cycles improve by 2.2–2.4× on those hosts. The exact current-head direct
matrix has **1,889 Faster / 1,511 Level / 0 Slower** metric judgments; its separate
A/A matrix has **3,400 Level** judgments.

There is a measured one-time startup cost: Ice Lake's first `initialize()` grows
**61.822 → 66.728 µs (+7.9%, Slower)**. I recommend reviewing and accepting that
cost for the repeated-bulk gains, with Sam owning a bounded startup follow-up.
The cost and suggested next experiment appear below. John owns independent
design/proof and integration review. This is a separate change from frozen #259
and the accepted fixed-length Batch adapter #262.

## Exact identities and scope

- Baseline, current upstream `servil`: **8d6525c3a4a6e2c6ffd135b21c0c7c25f6097066**.
- Current candidate: **f9fcef459d9999af05765a598c9fb72f704029ff**, branch
  `samshackleton-tech/BLAKE3:probe/sam-finalize-lanes`.
- Initial implementation/screening: **8b83b89e367ff0625263e0ee1414ffcd5ac9f016**.
- First proof/CPU-model head: **7ec7eec89fe9b02e5e6821613801817a6799a77f**.
- Shared `clocks` source: **415e7df398d42d6cc34b965a4c033a02798a9dd6**.

The final matrices, A/A, native/build/doc gates, proof and CPU-model comparison
all run at **f9fcef45**. Earlier screening/verification stays under its measured
identity. `incremental-root/code-identities.json` records the assembly and
production-wrapper hashes across the three candidate heads; generator output
reproduces the checked-in assembly byte for byte.

The existing `throughput::finalize_each` previously finalized selected Hashers
one by one. The candidate borrows each eligible Hasher's final padded block and
current chaining value into a 24-byte descriptor. One AVX-512 compression returns
sixteen canonical 32-byte root digests. Every lane has its own CV, length and
mode/structural flags, so different keys and derivation modes share a group.
The generated kernel uses all seven standard BLAKE3 rounds.

Dispatch is Linux/std/AVX-512F+VL, groups of sixteen selected states, each with
zero staged bytes, initial chunk counter zero, current chunk counter zero and
an empty CV stack. These are first-chunk states, up to 1 KiB. A group containing
another state, and a partial group, uses the existing finalization loop.
Finalization keeps the states reusable and preserves selected-index/output order.
The public API stays the same. The kernel body is **3,737 bytes** in both measured
startup probes; its generator reuses the existing transpose/compression emitters.

## Matching warm workloads: direct baseline → current head

Each host has 85 shape/count cells for each of two operations, each measured in
four independent builds/layouts. Source and method order alternate. The shared
paired judge uses a **3% practical margin and 5% FDR**, across the five available
metrics separately for each operation's family.

| CPU | Finalize wall Faster/Level/Slower | Full-cycle wall Faster/Level/Slower |
|---|---:|---:|
| Ryzen 9700X | 64 / 21 / 0 | 64 / 21 / 0 |
| EPYC 9255 | 64 / 21 / 0 | 64 / 21 / 0 |
| Xeon Ice Lake 6330 | 64 / 21 / 0 | 63 / 22 / 0 |
| EPYC 7443 Zen 3, AVX2 fallback | 0 / 85 / 0 | 0 / 85 / 0 |

Across 680 wall cells: **383 Faster / 297 Level / 0 Slower**.
Across wall/process CPU/cycles/instructions/package energy: **1,889F/1,511L/0S**.
Zen 3 has one Faster package-energy judgment while all of its time judgments
are Level; the unchanged fallback supplies the functional control.

Counts are 2, 16, 17, 64 and 1,024. Plain lengths are
0/1/31/63/64/65/128/255/512/1023/1024/2048 bytes, plus varied lengths in 1..1024.
Mixed plain/keyed/derived-mode sets cover 1/64/1024 and varied lengths. The
2-message and 2-KiB cases provide existing-path controls.

### Already-prepared immutable states, 1,024 one-byte messages

Nanoseconds and nJ **per message**:

| CPU | Wall old → new | Process CPU old → new | Package energy old → new |
|---|---:|---:|---:|
| 9700X | 80.6234 → 13.3109 | 80.6214 → 13.3106 | 4314.50 → 735.31 |
| EPYC 9255 | 102.1834 → 16.5384 | 102.1807 → 16.5381 | 7336.56 → 1198.33 |
| Ice Lake | 208.4738 → 41.9224 | 208.4433 → 41.9155 | 19241.96 → 3797.79 |

The corresponding wall speedups are **6.06× / 6.18× / 4.97×**.
Mixed-key/mode, varied-length ready states give similar finalization gains.

### Reused-state full reset/update/finalize cycles

These rows include resetting every Hasher, all ordinary updates in 17-byte
pieces, and `finalize_each`/canonical outputs. Initial Hasher construction,
key/context preparation, fixture allocation and reference answers are prepared
before repeated timing. The finalize-only rows above start from ready states.
Every result is checked against official blake3, and every Hasher's byte count is
checked after the timed operation.

At 1,024 messages, nanoseconds per message:

| CPU | 1 B wall old → new | 64 B wall old → new | 1 KiB wall old → new |
|---|---:|---:|---:|
| 9700X | 93.8690 → 26.8780 | 122.3247 → 55.0562 | 1527.1709 → 1457.4855 |
| EPYC 9255 | 118.2032 → 32.3346 | 149.2163 → 63.4326 | 1868.2141 → 1778.5517 |
| Ice Lake | 266.9823 → 99.5807 | 365.8603 → 198.1771 | 3440.9479 → 3291.2432 |

For the one-byte cycles:

| CPU | Process CPU old → new (ns) | Whole-package energy old → new (nJ) |
|---|---:|---:|
| 9700X | 93.8683 → 26.7156 | 5093.68 → 1514.89 |
| EPYC 9255 | 118.2020 → 32.3336 | 8540.69 → 2398.32 |
| Ice Lake | 266.9729 → 99.5824 | 24270.65 → 9010.95 |

That is about **70% / 72% / 63% less package energy** for these whole one-byte
cycles. At 1 KiB the complete cycles are about 4.4–4.8% faster; mixed-mode,
varied-length cycles are about 8.6–9.4% faster. Required prefix updates remain
part of the full-cycle work.

RAPL measures the **whole physical package**, including idle/background activity.
Wall, process CPU, cycles, instructions and package energy are retained as
separate metrics. One CPU-2 caller owns all states and output buffers; native
Hasher size/alignment/stride/base and output layout are logged. Four layouts and
native addresses accompany the results; this study claims no cache-line cause.

### A/A and retained screening

Fresh **f9fcef45 → f9fcef45** builds and executions use the identical instrument,
85 cells/operation and five metrics. All **425 judgments per operation/host are
Level**, totaling 3,400 Level judgments. Those are separate calibration runs.

The initial direct **8d6525c3 → 8b83b89** cohort is retained in `runs/`: 3,400
metric judgments, 1,889F/1,511L/0S. Its numbers stay distinct from the final
cohort above; no incremental ratios are multiplied.

## Startup cost and footprint review

The direct **8d6525c3 → f9fcef45** init-only probe uses 32 alternating fresh
process pairs across four builds/layouts, with the measurement machinery ready
before BLAKE3-Servil's first call. Times are µs per process's first initialization:

| CPU | Wall old → new | Process CPU old → new | Instructions old → new |
|---|---:|---:|---:|
| 9700X | 24.0827 → 25.1872, Level | 24.3115 → 25.4076, Level | 110910 → 123728, Slower |
| Ice Lake | 61.8224 → 66.7283, Slower | 62.7244 → 67.6112, Slower | 82323 → 95206, Slower |

Ice Lake first-init cycles rise 10.6% (Slower); 9700X cycles are Level. Already-
initialized wall/CPU/cycles/instructions are all Level on both hosts. Startup
package energy is outside this short-window instrument. Raw `nm` and section
sizes of all eight probes/host accompany it; the 3,737-byte figure above is the
new kernel body, while section sizes include its Rust fixture and other code.

I recommend accepting this one-time ~4.9-µs Ice Lake cost for the repeated-bulk
savings, subject to explicit integration review. Sam owns a bounded follow-up:
compare compile-time preparation of the same deterministic fixture bytes/CVs/
flags against the current runtime builder, preserving the checksum, all kernel
reachability and corruption controls. The first stage has measured the cost;
this proposed mitigation has no performance result yet.

## Verification at the current head

- **187/187 nextest tests on all four x86 hosts; 162/162 on the ARM VM.**
  No-default builds, all 19 doctests and warnings-denied rustdoc pass on all five.
- Official-reference tests span independent modes/keys, message lengths around
  every block/chunk boundary, counts around SIMD boundaries, reversed/repeated
  selected indices, reusable immutable states and staged/long fallbacks.
- Compile-time checks fix the actual descriptor size and offsets. Native guard
  tests put every block, CV, descriptor table and output flush against protected
  pages on both sides. Descriptor/CV/block pages are read-only during execution.
  These kernel safety cases execute on the three AVX-512 hosts; Zen 3 exercises
  its AVX2 fallback and ARM supplies build/correctness coverage.
- The assembled kernel's **1,210-step symbolic run** matches the Lean BLAKE3
  compression specification for sixteen independent arbitrary CVs, block bytes,
  lengths 0..64 and byte flags, with ROOT set and root output counter zero.
  It checks read-only input/bounds, exactly 512 output bytes, every legal SysV
  entry-stack residue and callee-saved registers. Secret CV/block bytes steer
  neither addresses nor control flow.
- Four independently supervised fault cases are rejected by `Unproved`: omitted
  ROOT, another lane's CV, a 32-byte CV overread and the final outputs omitted.
  Unsupported instructions/parser errors fail the run.
- Native CPU/model comparison: **353 vector forms, 93 memory forms, 200 random
  states/form, 27 alignment-fault controls: all agree**.
- Independent Python compression/reference checks derive startup checksum
  **0x54e3da46af4eb775**, and pass standard empty/`abc` BLAKE3 vectors. Startup
  runs the new entry and a corrupted-answer control rejects a changed checksum.

## Evidence and reproduction

Everything below is in [`incremental-root/`](incremental-root/):

| Path | Purpose |
|---|---|
| `final-runs/` | exact-head direct baseline → f9 matrices, all metrics |
| `aa-runs/` | separate same-source calibration matrices |
| `startup-runs/` | one-time/already-initialized measurements and symbol/section sizes |
| `final-native-runs/` | five-host exact-head tests/build/docs, including guarded buffers |
| `final-proof-runs/` | exact-head symbolic proof/fault controls and native model comparison |
| `runs/`, `screening-native-runs/`, `proof-runs/` | earlier source identities retained |
| `matrix.sh`, `probe.rs`, `startup.sh`, `proof.sh`, `model.sh`, `reference.py` | complete instruments/reference |
| `*.json`, `code-identities.json` | as-launched manifests and source/generator identity checks |

Each run uses `pinned-run`: immutable full commits/script SHA, fresh private
source/target directories and the host lock held **before preparation through
verification**. Scripts do not nest that lock. Every run in this experiment is
VERIFIED. Executables are omitted; each published file is below 20 MB.

To reproduce on an authorized host, adapt only host/lock/local script locations
in a manifest, retain the source commits and instrument, and launch with
`pinned-run launch final-matrix-HOST.json` or the corresponding A/A/startup
manifest. Native manifests retain the author's absolute shared-script path;
`native-tests.sh` is included with the same script contents for a local path.
The library's own `tools/verify/prove_output.py` and `cross_check_x86.py` are the
proof/model commands. This evidence branch records a review candidate;
John owns integration, and Sam owns x86 evidence and the startup follow-up.
