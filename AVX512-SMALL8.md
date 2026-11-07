# BLAKE3-Servil: reuse eight-lane finishing on AVX-512 CPUs

2026-11-07 — Sam Shackleton

## Result and scope

AVX-512 CPUs already have a tested eight-lane kernel. Grouped incremental
finishing previously selected only sixteen lanes, leaving 8–15 ready messages,
and tails of that size, to finish individually.

Reusing the existing kernel gives these direct 9700X results:

- Eight ready one-byte messages: **78.54→14.57 ns/message, 5.39× faster**.
- Eight 1-KiB messages in four 256-byte arrivals, complete cycle:
  **993.03→258.38 ns/message, 3.84× faster**, **71% less package energy**.
- Eight 64-byte messages in 17-byte arrivals, complete cycle:
  **131.78→33.39 ns/message, 3.95× faster**, **74% less package energy**.

EPYC 9255 confirms ~5.42× ready finishing and ~3.88× complete 1-KiB cycles.
Ice Lake confirms ~3.85× ready finishing and ~2.39× complete 1-KiB cycles.
There is no new kernel, ABI, persistent field, worker, clock or public API.
Standard full-round BLAKE3 semantics stay unchanged.

Measured costs remain for explicit review: small Zen 3 controls slow 3–7%, a
sparse seven-ready callback costs 5%, and checking the newly eligible kernel adds
~2.34 µs to 9700X first initialization. Sam owns follow-up; John owns acceptance
and integration review.

## Identities and mechanism

Baseline, frozen #274: **e3af185c5962076972129e83dfc2c8d9badb62b2**.
Candidate: **6630e56573f4907e5f691347dba8778a2ffb2b05**,
`samshackleton-tech/BLAKE3:probe/sam-avx512-small8`.
Shared clocks: **415e7df398d42d6cc34b965a4c033a02798a9dd6**.

Finalization uses full real sixteen-message groups first, then a real eight-
message group when available, then individual messages. Both grouping loops keep
compile-time width. Eight-capable collections use the existing first-chunk
buffering and staged finishing mechanism. An explicit AVX2 capability check
protects the narrow path, including feature-masked AVX-512 configurations.

Startup uses the same sixteen mixed CV/root fixture cases and checksum
0x153e0dfbeac2bb44. AVX-512+AVX2 hosts check both kernels; AVX2-only hosts retain
their existing coverage. Tests check actual selected and unselected entries at
0/1/7/8/9/15/16/17/23/24/25/31/32/65 messages. Guards execute both eligible widths.

## Direct measurements

All comparisons are **e3af→6630**, four fresh builds/layouts, alternating order,
shared paired judgment at **3% practical margin / 5% FDR**, with each operation
its own family. `pinned-run` holds the host lock before checkout/build preparation
through verification; targets are private and job scripts do not nest the lock.

One CPU-2 caller owns all states/descriptors/outputs; native layouts are logged.
RAPL is whole-package energy, including idle/background activity. Wall, process
CPU, cycles, instructions and package energy remain separate. No cache-line cause
is inferred from elapsed time.

### Ready states

Ordinary per-Hasher 17-byte updates prepare prefix CVs before finish-only timing.
Counts are 2/7/8/9/15/16/17/23/24/25/31/32/1024; plain sizes 1/64/1024 and mixed-mode
varied lengths give 52 cells. The separate complete cycle includes resets,
ordinary updates and canonical output.

| CPU | Ready finish wall Faster/Level/Slower | Complete ordinary-update cycle F/L/S |
|---|---:|---:|
| 9700X | 24 / 28 / 0 | 17 / 35 / 0 |
| EPYC 9255 | 24 / 28 / 0 | 19 / 33 / 0 |
| Ice Lake 6330 | 24 / 28 / 0 | 15 / 37 / 0 |
| Zen 3 AVX2 control | 4 / 44 / 4 | 0 / 52 / 0 |

Eight ready one-byte messages, per message:

| CPU | Wall old→new (ns) | Process CPU old→new (ns) | Package energy old→new (nJ) |
|---|---:|---:|---:|
| 9700X | 78.5367→14.5666 | 78.5359→14.5665 | 4023.06→781.60 |
| EPYC 9255 | 98.9756→18.2698 | 98.9721→18.2693 | 6904.74→1313.76 |
| Ice Lake | 148.2925→38.5211 | 148.1590→38.5201 | 13194.78→3424.14 |

At 24 ready messages, the 9700X mean goes 30.4505→9.2109 ns: the final eight
follow a sixteen-lane call. The 1024-message multiple-of-sixteen control is Level.

### Complete grouped cycles

Counts 2/7/8/9/15/16/24/1024, 17/256-byte arrivals, plain sizes 64/1024 and mixed
varied lengths give 48 cells per operation. Complete cycles include active-state
reset, caller descriptor refill, every grouped update, library allocations and
canonical output. Initial Hasher/key/context/data preparation is outside repeated
timing. Independent references and byte counts check every operation.

| CPU | Update wall F/L/S | Finish wall F/L/S | Complete-cycle wall F/L/S |
|---|---:|---:|---:|
| 9700X | 18 / 30 / 0 | 14 / 22 / 12 | 24 / 24 / 0 |
| EPYC 9255 | 18 / 30 / 0 | 12 / 22 / 14 | 24 / 24 / 0 |
| Ice Lake | 18 / 30 / 0 | 12 / 22 / 14 | 24 / 24 / 0 |
| Zen 3 control | 0 / 40 / 8 | 8 / 40 / 0 | 1 / 42 / 5 |

The three AVX-512 complete-cycle wall families total **72F/72L/0S**. There is an
isolated +4.9% Slower package-energy judgment at 9700X 1024×64B/256B arrivals;
its wall is Level.

Eight 1-KiB messages in four 256-byte arrivals, complete cycles per message:

| CPU | Wall old→new (ns) | Process CPU old→new (ns) | Package energy old→new (nJ) |
|---|---:|---:|---:|
| 9700X | 993.0322→258.3794 | 992.9359→258.3519 | 49381.29→14141.59 |
| EPYC 9255 | 1252.5706→322.5702 | 1252.5525→322.5671 | 86298.74→23322.15 |
| Ice Lake | 1636.6230→683.7363 | 1636.3442→683.7346 | 144018.74→60944.67 |

Eight 64-byte messages in 17-byte arrivals have complete wall means
131.7785→33.3857 / 162.3584→39.7894 / 329.0216→109.1589 ns respectively.
Package energy is 7097.32→1859.57 / 11670.45→2922.80 / 29273.63→9671.02 nJ.

At 24 1-KiB messages in four 256-byte arrivals, complete wall means are
444.7932→180.8293 / 556.1701→222.2648 / 866.1599→572.0235 ns. All 1024-message
complete 1-KiB controls are Level. Ratios are direct, not composed with earlier gains.

### Calibration and sparse-ready calls

Same-head A/A of both complete instruments on 9700X, Ice Lake and Zen 3 has
**all 3,720 metric judgments Level**.

Sparse calls distinguish 8/16/1024 open Hashers from 1/7/8 active/ready messages,
using 1-KiB messages in 17/256-byte pieces: 18 cells per operation. Only active
states reset, with descriptors/updates/output inside complete cycles.

| CPU | Sparse update wall F/L/S | Sparse finish wall F/L/S | Sparse complete-cycle wall F/L/S |
|---|---:|---:|---:|
| 9700X | 6 / 12 / 0 | 4 / 8 / 6 | 8 / 9 / 1 |
| Ice Lake | 10 / 8 / 0 | 4 / 8 / 6 | 12 / 6 / 0 |
| Zen 3 | 0 / 18 / 0 | 0 / 18 / 0 | 0 / 18 / 0 |

## Explicit review costs

With eight open Hashers, prefixes can now wait for SIMD finishing. Selecting only
one or seven ready messages still uses individual finalization, increasing finish
latency. For open8/256-byte arrivals, one ready 1-KiB finish on 9700X is
80.8764→1028.0386 ns; seven ready is 78.5542→1025.1050 ns each. Ice Lake equivalents
are 153.3630→1494.4793 and 150.0274→1490.3380 ns. Complete cycles include this work.

The sparse 9700X complete cycle at open 8 / ready 7 / four 256-B arrivals is
**996.6083→1046.9087 ns/message, +5.0% Slower**, with CPU/cycles similarly higher.
Other sparse complete-cycle wall cells are Faster or Level.

Five Zen 3 complete-cycle wall cells are 3.6–6.9% Slower, with two or seven
messages, 17-byte arrivals and plain 64/1024 or mixed varied lengths. Four ready-
finish wall cells at count 8 are 3.1–3.8% Slower (~0.6 ns/message); their complete
ordinary-update cycles are Level. Modern ready 16/17 instruction rows rise
3.1–3.8% with wall Level. These and the energy row above remain owned costs;
cause is open, with no timing-only false-positive/layout classification.

Startup checks both kernels before use. Thirty-two alternating process pairs
across four layouts give:

| CPU | First wall old→new (µs) | First CPU old→new (µs) | First instructions old→new |
|---|---:|---:|---:|
| 9700X | 25.2670→27.6096, Slower | 25.4870→27.8275, Slower | 123719→128800, +4.1%, Slower |
| Ice Lake | 67.1885→68.3523, Level | 67.8161→69.2393, Level | 95197→100302, +5.4%, Slower |
| Zen 3 | 37.9400→34.3017, Level | 39.1715→35.5610, Level | 131898→131912, Level |

9700X first wall/CPU grow 9.2%, cycles 10.0%. All already-initialized 9700X/Ice
metrics are Level. Zen 3 already-initialized CPU is +4.3% Slower with wall/cycles/
instructions Level. Startup energy is outside this short-window instrument;
lower means labeled Level establish no time win.

Sam recommends accepting the costs for the larger matching-group benefits,
with assigned follow-up in the existing startup/first-chunk issues. John owns
explicit acceptance and integration. No runtime check is removed to lower cost.

## Verification, artifacts and ownership

Exact head passes **189/189 nextest tests on each of four x86 hosts; 162/162 on
ARM VM**. No-default builds, 19 doctests and warnings-denied rustdoc pass all five.
Tests cover actual selected/unselected widths and tails, independent modes/keys,
reversed/repeated indices, endings, state reuse, mixed update methods, long
fallback and continuation. Read-only guarded inputs and guarded output exercise
both eligible kernels on AVX-512 hosts.

Assembly, compression-proof harnesses and instruction-model bytes are identical
to frozen #274, bound in `small8-next/code-identities.json`. Existing arbitrary-
input 8/16-lane proofs and CPU/model checks retain their scope. Exact-head native
reference/membership tests cover the new dispatch and registration. ARM VM is
build/correctness coverage rather than native timing.

[`small8-next/`](small8-next/) contains all 25 VERIFIED runs, all metrics, AA,
native/startup/sparse records and instruments. Executables are omitted; each file
is below 20 MB. Adapt authorized host/lock/script paths in bulk/ready/AA/startup/
sparse manifests while retaining hashes and instruments. Copies of shared native
and startup scripts accompany manifests retaining author absolute paths.

The separate [register-live equal-ending study](FUSED-FIRST-CHUNK-TRIAL.md) stays
unpromoted, with its more modest gains, proof subset and failed checker attempts.
Its new kernels/model changes are outside this three-Rust-file dispatch candidate.

Sam owns x86 source/evidence and cost follow-up. John owns independent design/
proof/cost review and integration; Devon owns peer performance. Frozen #274/#271/
#269/#259/#262 keep their review boundaries. No merge/release is implied.
