# BLAKE3-Servil: whole incremental cycles, another sixfold gain

2026-11-07 — Sam Shackleton

## Result and review decision

For 1,024 independent 1-KiB messages arriving in **four 256-byte pieces each**,
the complete reused-state reset/update/finalize cycle on the 9700X goes
**935.76 → 154.55 ns/message: 6.05× faster**. Process CPU goes
935.74 → 154.55 ns; whole-package energy goes 46,717 → 9,020 nJ, **81% less**.
Different keys and plain/keyed/derived modes in the same collection give the
same gain. This measures all updates, caller-descriptor refill and final output.

The candidate reuses PR #269's sixteen-lane primitive for the first chunk's
prefix blocks, with the existing Hasher buffers. The public API stays the same.
The evidence is a direct comparison against #269's frozen head, rather than a
product of its earlier finalization speedup and this new ratio.

The important review trade-off is **finishing latency**: some prefix work moves
from updates into `finalize_each`. Whole cycles usually become much faster;
finishing by itself takes more time. Sparse-ready callbacks also expose four
whole-cycle losses of ~5–6% on the 9700X. I recommend reviewing the large grouped
benefit with these measured costs owned by Sam in a dedicated follow-up. John
owns independent design/proof and integration review; Devon reviews performance.

## Sources and mechanism

- Baseline: **f9fcef459d9999af05765a598c9fb72f704029ff**, frozen PR #269.
- Current candidate: **7c4166fa922165c7db8250908f6442cb3b9a28a2**,
  `samshackleton-tech/BLAKE3:probe/sam-first-chunk-front`.
- Initial measured prototype: **9d570da27402438e06a6982a0a8208278bdbf07e**.
- Intermediate tested/proved head: **eea5943d695c2e0a6b9500f21bf2deae06cd6b1f**.
- Shared clocks: **415e7df398d42d6cc34b965a4c033a02798a9dd6**.

A short first chunk has up to fifteen prefix compressions before its root
compression. Previously these prefixes ran serially in each Hasher. Bulk updates
now keep the first block in the existing chunk buffer and its suffix in the
existing stage. Grouped finalization compresses sixteen independent prefix
chains together, then returns each lane's root digest at its own ending.

Every lane has an independent CV (chaining value), key, mode flags and ending.
The compression primitive now takes its flags exactly as supplied. The root
caller supplies ROOT; prefix calls produce ordinary CVs. All seven BLAKE3 rounds
and counter-zero first-chunk semantics are preserved. The assembly change removes
sixteen forced-ROOT instructions; its vector instruction sequence stays identical.
The kernel body is **3,673 bytes**, down from #269's 3,737 bytes.

A forward scan gathers a callback's eligible pieces before the general held-
group turn allocates its queues. At the first other piece, the remaining pieces
run through the existing turn in their original order. Earlier collected short
pieces therefore avoid that allocation/queue work. The intermediate version
collected them inside the general turn; its controls and remaining losses stay
in the record. A controlled intermediate → current comparison has 7/8 Faster
whole-cycle cells on EPYC/9700X out of 16 each, the rest Level; finish-only cells
are all Level and all metric Slower sets are empty.

**Inventory:** two private helpers, direct gathering before the existing turn,
expanded flags semantics for the same private descriptor/kernel, finite local
CV/tail scratch, a mixed CV/root startup fixture, tests and docs. Hasher allocation
remains about 18 KiB. Up to 960 first-chunk suffix bytes use its existing stage;
there are no added persistent fields, public types, clocks, workers or kernels.

Dispatch is Linux/std/AVX-512F+VL, a collection of at least sixteen Hashers.
The gathering helper accepts first-chunk states before prefix compression,
with zero initial/current counters and empty CV stack, total at most 1 KiB.
Full selected groups of sixteen finish their staged prefixes together. Other
states and selected counts retain their existing finalization path. Ordinary
updates can mix with bulk updates; selected order, repeated indices, immutable
finalization/state reuse and later continuation retain their semantics.

## Direct exact-candidate whole-cycle measurements

`direct-front-runs/` compares **f9fcef45 → 7c4166fa** through the production APIs.
Four independent builds/layouts, alternating source/method order, CPU-2 caller,
shared paired judge at **3% practical margin / 5% FDR**. Each operation is its own
five-metric comparison family. All sources/targets are fresh and private;
`pinned-run` holds the host lock before preparation through verification.

The instrument reports three operations: reset/bulk-update, finalize prepared
states, and the **complete reset/update/finalize cycle**. Initial Hasher/key/
context creation, data allocation and reference answers are outside repeated
measurements. The complete cycle includes descriptor-vector refill, library
allocations, every update and canonical digest output. Every result and byte
count is checked against official blake3.

### Seventeen-byte arrivals

85 cells/operation/host: counts 2/16/17/64/1024; plain lengths
0/1/31/63/64/65/128/255/512/1023/1024/2048; varied lengths 1..1024;
mixed plain/keyed/derived-mode sets at 1/64/1024 and varied lengths.

| CPU | Update wall Faster/Level/Slower | Finish wall F/L/S | Whole-cycle wall F/L/S |
|---|---:|---:|---:|
| 9700X | 64 / 21 / 0 | 28 / 17 / 40 | 68 / 17 / 0 |
| EPYC 9255 | 64 / 21 / 0 | 28 / 17 / 40 | 68 / 17 / 0 |
| Ice Lake 6330 | 64 / 21 / 0 | 28 / 17 / 40 | 68 / 17 / 0 |
| Zen 3 EPYC 7443, AVX2 path | 0 / 85 / 0 | 0 / 85 / 0 | 0 / 85 / 0 |

Whole-cycle wall: **204F/136L/0S** across 340 cells; all five whole-cycle metrics:
**1,020F/680L/0S** across 1,700 judgments. Update-only has one flagged package-
energy cost: Ice Lake, two varied-length messages, +3.1%; its wall is Level and
the complete cycle is Level. The finishing cost is detailed below.

At 1,024 messages, **complete cycles**, ns/message:

| CPU | 64 B | 1 KiB | Mixed keys/modes, varied lengths | 2 KiB control |
|---|---:|---:|---:|---:|
| 9700X | 60.6680 → 30.3580 | 1538.7323 → 417.0489 | 813.8171 → 302.2490 | 3048.6626 → 2755.4097 |
| EPYC 9255 | 71.9241 → 36.4237 | 1896.0764 → 478.6433 | 1007.9564 → 360.4493 | 3763.9125 → 3402.4078 |
| Ice Lake | 255.7409 → 144.3948 | 4412.8271 → 2009.4170 | 2421.3802 → 1433.4564 | 7903.8216 → 6493.2379 |

For the complete 1-KiB cycles:

| CPU | Process CPU old → new (ns/message) | Whole-package energy old → new (nJ/message) |
|---|---:|---:|
| 9700X | 1538.6771 → 417.0447 | 83859.11 → 24527.76 |
| EPYC 9255 | 1896.0029 → 478.6363 | 136487.81 → 36804.63 |
| Ice Lake | 4392.1056 → 2009.3551 | 394600.13 → 183573.96 |

The 1-KiB wall speedups are **3.69× / 3.96× / 2.20×**. Mixed varied-length cycles
improve **2.69× / 2.80× / 1.69×**. These are direct measured whole cycles.

### Larger arrivals: 64, 256 and 1,024-byte pieces

`front-pieces-runs/` is another direct **f9fcef45 → 7c4166fa** cohort: counts
16/64/1024, plain sizes 64/65/1024, mixed-mode 1024 and varied lengths, at each
of three piece widths. All **45 whole-cycle wall cells and 225 whole-cycle metric
judgments are Faster on each host**.

At 1,024 messages of 1 KiB, complete cycles:

| CPU / arrivals | Wall old → new (ns/message) | Process CPU old → new | Package energy old → new (nJ) |
|---|---:|---:|---:|
| 9700X, 4×256 B | 935.7638 → 154.5502 | 935.7352 → 154.5464 | 46717.14 → 9019.89 |
| 9700X, one 1024 B | 969.7448 → 141.0837 | 969.7348 → 141.0819 | 48505.05 → 8264.19 |
| Ice Lake, 4×256 B | 1757.5609 → 628.0451 | 1757.4842 → 627.8494 | 156567.99 → 56999.64 |
| Ice Lake, one 1024 B | 1499.8899 → 570.9308 | 1499.5499 → 570.6508 | 134114.71 → 52107.56 |

The 9700X's four-piece speedup is **6.05×**, one-piece **6.87×**. Mixed keys/modes
with four pieces go 935.3838 → 154.6394 ns, again ~6.05×. With varied lengths,
four-piece mixed-mode cycles go 480.0068 → 139.2466 ns (~3.45×). Ice Lake's
four-piece full-size gain is ~2.80×; varied mixed lengths improve ~2.01×.

## Finishing latency and sparse-ready review costs

The full-cycle measurements account for all deferred work. Phase timings show
where that work is paid, which matters for callers prioritizing completion
latency or repeatedly finalizing an unchanged state.

For 1,024 1-KiB messages prepared by seventeen-byte bulk arrivals, finish-only
ns/message grows:

| CPU | Finish old → new | Extra finish time/message |
|---|---:|---:|
| 9700X | 13.1963 → 119.7923 | ~107 ns |
| EPYC 9255 | 16.7937 → 151.3096 | ~135 ns |
| Ice Lake | 41.7685 → 414.0114 | ~372 ns |

These calls now compute the pending prefixes as well as roots. The complete
cycles above include that time and remain substantially faster. Each AVX-512
host has 40 Slower finishing cells (200 metric judgments), all retained.

`sparse-runs/` directly compares f9 → current with **1,024 open Hashers**, only
1/2/8/15/16/17 active messages, 64/1024-byte messages, plain/mixed modes and
17/256-byte arrivals. Only active states reset; descriptor refill, active updates
and finishing are all inside complete cycles. Thus the open-state count differs
from the active/ready count and can select gathering for fewer than sixteen
ready outputs.

| CPU | Sparse whole-cycle wall Faster/Level/Slower |
|---|---:|
| 9700X | 40 / 4 / 4 |
| Ice Lake | 47 / 1 / 0 |

The four 9700X whole-cycle losses are 1-KiB messages in four 256-byte pieces,
8 or 15 active/ready messages, plain or mixed modes:
**992.90→1045.25 / 988.43→1049.01 / 993.62→1045.47 / 989.04→1049.70 ns/message**,
about +5.2–6.1%. The phase shift also makes a single ready 1-KiB message's finish
81.30→1028.52 ns on 9700X, and 154.21→1497.39 ns on Ice Lake. Their corresponding
complete single-ready cycles are Level (9700X) or Faster (Ice Lake).

These are real API costs for review. Sam recommends accepting them for the
larger grouped benefits, with a bounded follow-up comparing a ready-piece-aware
gathering condition or eager SIMD prefix processing during bulk updates. The
current general turn remains simpler than adding a new persistent ready queue.
The intermediate → current revision already removes inner per-piece gather
checks and avoids queue work for the direct prefix; it restores all Zen 3 time
controls to Level. It leaves the finishing trade-off explicit.

The isolated Ice Lake update-only package-energy +3.1% cell also stays recorded:
232273.62 → 239391.10 nJ/message, two varied-length messages; complete-cycle
wall/CPU/energy are Level. Timing or changed layout alone establishes neither
its cause nor a false-positive classification.

## Calibration, startup and retained source cohorts

- Current-head **7c → 7c** A/A, 16 selected size/count/piece cells on each AMD host,
  three operations/five metrics: **all 480 judgments Level**.
- The full 85-cell instrument at **eea → eea**, all four hosts/three operations:
  **all 5,100 judgments Level**. Its source identity stays distinct.
- Intermediate **f9 → eea** matrices, wider-piece tests and initial **f9 → 9d**
  screening remain in separate raw directories. The intermediate small-control
  losses remain visible beside the structural revision that improved them.
- Ordinary per-Hasher `update` / prepared-state finalization control on EPYC,
  **f9 → eea**, original PR269 instrument: all 850 metric judgments Faster or
  Level (320F/105L finalize, 117F/308L complete cycle).
- Incremental first/already-initialized startup probe **f9 → eea**, 32 alternating
  process pairs/four layouts on 9700X and Ice Lake: **all sixteen metric judgments
  Level**. Current 7c changes only the bulk-update scheduler; that function runs
  outside startup. The existing #268 startup cost remains owned there.

RAPL is **whole-package energy**, including background/idle activity, with wall,
process CPU, cycles and instructions reported separately. One pinned caller owns
all states, descriptors and outputs; native Hasher/output size, alignment, stride
and addresses are logged. No cache-line or alias mechanism is inferred from these
timings. ARM VM evidence supplies correctness/build coverage.

## Verification and code identity

- Exact **7c**: **189/189 nextest tests on each of four x86 hosts; 162/162 ARM VM**.
  No-default builds, all 19 doctests and warnings-denied rustdoc pass on all five.
- Official-reference tests cover plain/keyed/derived modes, ordinary+grouped
  update mixtures, every ending block at every lane position, boundary lengths,
  reverse/repeated selected indices, state reuse, scalar finalization and
  continuation across 1-KiB/16-KiB staging boundaries.
- Native guard tests put independent CVs, blocks, descriptor tables and output
  against inaccessible pages at both ends, with input mappings read-only.
  The current mixed CV/root fixture executes on all three AVX-512 hosts.
- Assembly/proof are byte-identical between eea and 7c. The **1,193-step assembled-
  kernel proof at eea** matches the Lean compression definition for sixteen
  independent arbitrary CVs, block bytes, lengths 0..64 and byte flags, counter
  zero. It checks all legal SysV stack residues, ABI preservation, read-only
  input/bounds, all 512 output bytes and data-independent addresses/control.
- Four fault controls reject another lane's flags, another lane's CV, CV overread
  and omitted final outputs. Unsupported/parser failures stop the proof.
- Every vector-instruction line is identical to #269's native-model-tested kernel
  (353 vector forms, 93 memory forms, 200 states/form, 27 alignment controls).
  The change removes scalar OR instructions; it adds no vector form requiring
  a second copy of that native comparison.
- Independent Python compression derives mixed CV/root startup checksum
  **0x153e0dfbeac2bb44**, and standard empty/`abc` vectors pass. Runtime kernel
  reachability and corrupted-answer rejection remain. Generator regeneration
  reproduces checked-in assembly exactly.

## Evidence, reproduction and ownership

[`first-chunk/`](first-chunk/) contains all 41 VERIFIED pinned runs, source
manifests, raw logs, layouts, metrics, scripts and reference code. Executables
are omitted and every file is below 20 MB.

| Path | Scope |
|---|---|
| `direct-front-runs/` | exact candidate f9→7c, all three phases, four hosts |
| `front-pieces-runs/` | exact candidate wider arrivals, two hosts |
| `sparse-runs/` | exact candidate open/active/ready-count controls |
| `front-aa-runs/`, `front-native-runs/` | current-head calibration and five-host gates |
| `proof-runs/`, `code-identities.json` | general-flags proof and byte/form identity binding |
| `runs/`, `initial-native-runs/`, `initial-proof-runs/` | initial measured prototype |
| `final-runs/`, `aa-runs/`, `final-native-runs/`, `pieces-runs/`, `startup-runs/`, `prefixed-runs/` | intermediate source/controls retained |
| `front-runs/` | controlled scheduler simplification, eea→7c |
| `*.sh`, `*-probe.rs`, `probe.rs`, `reference.py`, `*.json` | instruments and as-launched manifests |

Use `pinned-run launch direct-front-HOST.json`, `front-pieces-HOST.json`, or
`sparse-HOST.json` after adapting authorized host/lock/local script paths, retaining
source hashes and the instrument. Native/proof/startup manifests retain author
absolute paths; local copies are included. Build preparation is under the shared
host lock; targets are private, and job scripts do not nest the lock.

This is stacked on frozen #269. The incremental review is **f9→7c**; John owns
independent design/proof, cost judgment and integration. Devon reviews performance;
Sam owns this x86 candidate, evidence and measured-cost follow-up. Frozen #259,
#262 and #269 retain their source/review boundaries. This record proposes review,
with standard full-round BLAKE3 semantics and no merge/release implied.
