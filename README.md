# Short-message SIMD finishing experiments (#247)

BLAKE3-Servil `hash_each`, compared with #249 and sha2 0.11.0's SHA-256
using each CPU's SHA instructions. These are batches already in memory,
one thread pinned to CPU 2. Both algorithms store a 32-byte digest for
each message. Library packing and last-block padding are timed; allocating
and initially populating the input messages is not.

This compares the standard Rust sha2 call, not every possible specialized
multi-buffer SHA-256 implementation. The BLAKE3 computation retains all
seven rounds and standard flags/digests.

## Paired matrices

Four fresh builds per side (different Rust metadata/link layouts), run in
alternating order. All 168 shape/count combinations and their comparisons
are judged together with bench-hashes' `clocks::summary::discoveries`
(5% FDR, 3% margin). Wall, process CPU time, caller cycles/instructions and
RAPL CPU-package energy are recorded as integer totals. Package energy
includes the package's idle/background power, not just incremental energy
attributable to the hashing core. Busy-load runs are excluded by pinned-run.

The matrices' baseline is #249, commit
`1ea6183225b91f857770949c7120a06485be8d92`.

- `matrix-runs`: candidate `027c62fcd638cf91580292195c589a150fd610b9`,
  independently finishing AVX2/AVX-512 lanes, before sparse-group policy.
- `matrix2-runs`: candidate `24c55fd280ea98949355cb78e49645f99f82ff42`,
  with outlier separation and sparse-prefix selection. Startup checks and
  independent width tests included. This remains experimental: the small
  groups below still need work.

At 1024 messages, matrix 2's geometric-mean throughput over SHA-256:

| CPU | 64 B each | 1 KiB each | mixed 100–1000 B |
|---|---:|---:|---:|
| Ryzen 7 9700X | 4.35x | 5.03x | 3.40x |
| EPYC 9255 | 4.35x | 5.10x | 3.42x |
| Xeon Gold 6330 | 4.07x | 5.10x | 3.56x |
| 2x EPYC 7443 (one caller core) | 2.14x | 2.76x | 2.08x |

The corresponding ratios of BLAKE3-Servil package energy to SHA-256:

| CPU | 64 B each | 1 KiB each | mixed 100–1000 B |
|---|---:|---:|---:|
| Ryzen 7 9700X | 0.253 | 0.216 | 0.317 |
| EPYC 9255 | 0.241 | 0.206 | 0.306 |
| Xeon Gold 6330 | 0.247 | 0.196 | 0.282 |
| EPYC 7443 | 0.486 | 0.388 | 0.511 |

**Limits:** matrix 2 flags no slower wall-time cell against #249 on the
9700X or EPYC 9255. It flags 38 on the Xeon and 22 on the EPYC 7443, all
with fewer than 16 messages. None of the measured shapes at 16 messages
or more is flagged slower on those two CPUs. A subsequent candidate adds
an early original-path shortcut where no finishing group is eligible;
that candidate is not what these tables measure.

Raw per-run totals and all judgments are beside each run's manifest.
The embedded source in `matrix.sh` is the actual probe/judge used; standalone
source files are provided for reading. Executables are omitted here.

## Proof and fault controls

`proofs/last-mixed-proof-matrix-20261106T054418-b948ff7e` checks candidate
027c62fc against the existing Lean compression specification through the
x86 instruction model:

- 48 equal-ending cases (4/8/16 lanes, whole blocks before last 0..15).
  The later candidate removes the unused four-lane finishing kernel.
- 384 mixed-ending patterns: 8/16 lanes, 1..16 steps, cyclic ending
  patterns rotated through every lane position.
- Every case keeps bytes, keys, last-block lengths and mode flags symbolic;
  input/stack bounds and callee-saved registers are checked.
- 37 proof-helper tests.
- Three faults rejected, each with an unmodified positive control:
  ROOT removed; finished lanes overwritten; AVX2 snapshot choice reversed.

**The mixed matrix is finite pattern coverage, not a proof of all possible
combinations of lane-ending metadata.** Formal review/extension remains
required before a production proof claim. Native differential and guard-page
tests also cover the Rust wrappers.

— Sam Shackleton
