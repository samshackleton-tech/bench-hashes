# Mixed-key staged parents: reuse independent SIMD compression

**2026-11-07 — draft optimization; independent review/integration requested.**

BLAKE3-Servil's incremental bulk API can retain **one existing key/flags
partition**, preserve its fast shared-key parent batching, and hash a heterogeneous
turn's parents with the **existing** independent eight/sixteen-lane compressor.
It need not recursively partition the remaining messages by key.

For 2,048 distinct-key messages of 16 KiB, delivered in four 4 KiB arrivals,
the complete reset/update/finalize cycle takes **49–55% less wall time** on the
four measured x86 hosts, with **48–55% less whole-package energy**. At 512 messages,
complete-cycle time is **23–32% lower**. Plain/shared-key complete controls and
ready-state finishing remain Level in the selected matrix. This is a scoped
incremental many-key improvement, not a claim that every BLAKE3 call doubles.

One EPYC short **update-only** control is +3.3%; its complete cycle is Level.
The cost and a bounded follow-up are retained below; acceptance remains an
explicit reviewer decision, not inferred from the benefits.

## Exact sources and mechanism

- Baseline: [`f47d9e5d284aafcbabf7b6b2105bdedde4832261`](https://github.com/samshackleton-tech/BLAKE3/commit/f47d9e5d284aafcbabf7b6b2105bdedde4832261), frozen PR #278.
- Selected: [`b6770e33b1f153ba18e7341379f3ee53199d640c`](https://github.com/samshackleton-tech/BLAKE3/commit/b6770e33b1f153ba18e7341379f3ee53199d640c), `probe/sam-parent-loop-single`.
- Measurement/paired judgment: `clocks` from bench-hashes
  `415e7df398d42d6cc34b965a4c033a02798a9dd6`.
- Every selected result below is a **direct baseline → selected-head comparison**.
  No incremental ratios are multiplied. Earlier review candidates remain separate.

Previously, `each::hash_held` partitioned the held message indices into those
sharing the first message's key/flags and all others, hashed the first group, and
recursed on the others. With N distinct keys, the successive partitions examine
N, N−1, …, 1 indices: **N(N+1)/2 comparisons**, N nonempty partition passes,
recursive frames and successively allocated index vectors.

The selected path keeps the first partition. A homogeneous turn uses the old
shared-key kernels. On heterogeneous Linux/std AVX2/AVX-512 turns:

1. Each complete 16 KiB stage already fills a sixteen-chunk leaf call. Its own
   key, mode flags and chunk counter go to the existing chunk kernel.
2. Four parent levels run through existing independent compression descriptors.
   Each descriptor borrows its message's own key/CV and 64-byte parent block,
   with counter zero and `mode_flags | PARENT`, **without ROOT**.
3. Full real groups use eight/sixteen lanes. Underfilled tails use the existing
   scalar compression; there are no fabricated lanes.
4. The same `take_held` operation commits two half-CVs for the first group, or a
   subtree CV for a later group. Finalization and buffering schedules are unchanged.

This makes the supported heterogeneous turn's grouping work linear. It does not
sort secret keys, introduce a hash table, or claim that the whole library is now
constant-time. The existing first equality partition remains; other platform
fallbacks retain their existing grouping. ARM's sustained grouped SME2 run is
not replaced with an x86 strategy.

### Complexity inventory

**One new private Rust helper**, using the existing descriptor type and existing
kernel entries. No new public API, named state type, Hasher field, persistent
buffer capacity, assembly kernel, ABI, startup fixture, worker or clock heuristic.

The helper has three linear temporary buffers: leaf/current CVs, next-level CVs,
and the two-half snapshots already required by held-group commit semantics.
The existing first partition's index vectors remain. The 16 KiB per-Hasher stage
and roughly 18 KiB Hasher object are unchanged.

A first width-specialized version duplicated leaf/setup/commit work in generated
code. Sharing that traversal removed **3,476 bytes from the GNU `size` text
aggregate** in its direct same-consumer comparison; all 960 EPYC/Zen 3 scoped
comparison metrics were Level. The selected helper's symbol is **8,918 bytes**.
A direct baseline/selected consumer build reports GNU `size` text aggregate
573,524 → 583,424 bytes (**+9,900**), data +400 and bss −2,128. Those aggregate
consumer columns are not a bare-library `.text` section measurement. The footprint
is an explicit design-review cost, not hidden behind the runtime gain.

## Complete-cycle production API measurements

API: `throughput::update_each`, then `throughput::finalize_each`.
Each sample includes resetting every Hasher, refilling the caller's descriptor
vector, every update call, and canonical finalization. Constructor/key/context
preparation, independent reference computation and allocations are outside.

Messages are 16 KiB each; each receives **four 4 KiB arrivals**. A single complete
16 KiB update would bypass staging and would not ask the same question.

### Wall and process CPU, ns per message

| Host | Ready messages / distinct keys | Wall old → new | Process CPU old → new |
|---|---:|---:|---:|
| Ryzen 9700X | 512 | 2360.8687 → 1607.3650 | 2360.8002 → 1607.3250 |
| EPYC 9255 | 512 | 2913.2030 → 1998.0988 | 2913.2214 → 1998.0586 |
| Ice Lake 6330 | 512 | 8237.8272 → 6048.5658 | 8236.7180 → 6048.0403 |
| Zen 3 EPYC 7443 | 512 | 5421.1661 → 4163.4378 | 5420.5131 → 4162.8902 |
| Ryzen 9700X | 2048 | 5090.8022 → 2356.3005 | 5090.7545 → 2356.2832 |
| EPYC 9255 | 2048 | 5457.2620 → 2462.3581 | 5456.7614 → 2462.2409 |
| Ice Lake 6330 | 2048 | 14581.6616 → 6934.1531 | 14577.1170 → 6931.4408 |
| Zen 3 EPYC 7443 | 2048 | 10747.3755 → 5448.7371 | 10745.5550 → 5448.1416 |

### Whole-package energy and instructions, per message

| Host | Messages | Package nJ old → new | Instructions old → new |
|---|---:|---:|---:|
| Ryzen 9700X | 512 | 135098.7289 → 92132.9627 | 34391.8597 → 19198.1092 |
| EPYC 9255 | 512 | 216103.1323 → 147421.5835 | 34401.1751 → 19199.1436 |
| Ice Lake 6330 | 512 | 743352.3734 → 547115.5047 | 33556.5090 → 18411.0719 |
| Zen 3 EPYC 7443 | 512 | 361210.8529 → 277234.1669 | 58191.5993 → 43765.5567 |
| Ryzen 9700X | 2048 | 287952.4604 → 130072.4223 | 55919.0851 → 19181.6301 |
| EPYC 9255 | 2048 | 420475.3786 → 193414.3715 | 55918.3511 → 19182.5024 |
| Ice Lake 6330 | 2048 | 1344329.8638 → 632550.5674 | 55032.1230 → 18393.0937 |
| Zen 3 EPYC 7443 | 2048 | 843041.3902 → 435033.6269 | 79732.9233 → 43748.5650 |

RAPL is **whole-package energy**, including idle/background activity, not energy
attributed solely to the hashing core. Wall, process CPU, cycles, instructions
and package energy are separate measurements; cycle values remain in the raw TSVs.

At 2,048 messages, mixed plain/distinct-key/derived modes take roughly **12–16%
less complete-cycle time**, rather than the distinct-key-only factor. Plain and
single-shared-key complete controls are Level. The gain grows with key diversity;
there is no promise of a twofold gain for ordinary single-key hashing.

## Scope, controls and statistical protocol

All runs use `pinned-run`: full 40-hex source identities, script SHA-256, fresh
private checkouts/targets, and a host lock **before checkout/build preparation
through verification**. Builds finish before timing. Four fresh build/layouts
per comparison, adjacent baseline/candidate executions and alternating order;
shared `clocks::summary` judgments use a **3% practical margin / 5% FDR**.

The primary matrix has **72 shapes per operation per host**:

- 2/8/16/128/512/1024/2048 messages, 16/32 KiB each, 4 KiB arrivals;
- plain, one shared key, a distinct key per message, and mixed modes;
- short controls: 2/8/16/1024 × 1 KiB, four 256-byte arrivals, all four modes;
- separate update-only, ready finishing, and complete reset/update/finalize cycles.

Selected-head primary results, all four hosts:

| Operation | Wall Faster / Level / Slower | All five metrics F / L / S |
|---|---:|---:|
| update-only | 101 / 186 / 1 | 508 / 928 / 4 |
| ready finishing | 0 / 288 / 0 | 0 / 1440 / 0 |
| complete cycle | 99 / 189 / 0 | 504 / 936 / 0 |
| total | 200 / 663 / 1 | 1012 / 3304 / 4 |

The actual `update_each_multithreaded` API was measured separately: 16 shapes per
operation/host (2/16/512/2048 × 16 KiB × four modes, 4 KiB arrivals), warm pool.
Its complete-cycle wall results are **26 Faster / 38 Level / 0 Slower**; all
**960 metrics** across the three operations have no Slower cells. These held
stages execute on the caller; this is API coverage, **not a parallel scaling claim**.

Current-head A/A: **all 2,160 metrics Level** on 9700X/Zen 3 with the primary
instrument. A separate EPYC target/control A/A has all 30 metrics Level.
First and already-initialized startup: **all 24 metrics Level** across 9700X,
Ice Lake and Zen 3. No new registration or fixture work, and no startup energy
claim. A/A cohorts and earlier source versions are not pooled into direct gains.

The caller owns all Hashers, descriptors and output slots. Native object size,
alignment and stride are logged, rather than inferred from source field order.
No concurrent false-sharing or cache/alias cause is asserted from these timings.

## Retained short-update cost and follow-up

The primary EPYC matrix flags **plain 1 KiB × 8, four 256-byte arrivals,
update-only**:

- wall **23.4637 → 24.2384 ns/message**, +3.3%;
- process CPU **23.4638 → 24.2376**, +3.3%; cycles +3.3%;
- package **1774.2255 → 1833.1761 nJ/message**, +3.3%;
- instructions Level; **the complete reset/update/finalize cycle is Level**.

This is about six additional nanoseconds for the eight-message update operation
(which includes reset and all four arrivals), not a six-nanosecond penalty on
each individual callback. This short first-chunk control does **not execute the
new held-parent helper**. Its cause is not established.

The bounded isolated target/control check gives **24.0435 → 24.8243 ns**, +3.2%
mean, judged Level; the 16-message control is +2.8% mean, Level. The dedicated
same-head A/A is Level. These do **not erase or reclassify the original wide
Slower cell as a false positive**. Raw means, layouts and all metrics remain.

**Owner: Sam Shackleton.** Recommendation: review the small phase-only cost with
its complete-cycle context and the many-key benefit. Explicit acceptance is
pending. Before integration, the linked assigned follow-up will carry the exact
reproduction, original and isolated raw records, attempted alternatives, and a
bounded next investigation of this unchanged short path's generated code and
layout sensitivity. No padding/clock heuristic or automatic veto is proposed.

## Correctness and actual-work protection

Exact selected head:

- **191/191 tests on each of four x86 hosts**, **163/163 on ARM VM**;
- serde/zeroize, no-default-feature build, 19 doctests and warnings-denied rustdoc
  on all five; ARM is correctness/build coverage, not native ARM timing;
- deterministic mixed-key/mode stages at counts 2/7/8/9/15/16/17/31/32/33, zero
  and nonzero group counters, continuation after commit and XOF seeking against
  independent official BLAKE3 references; actual selected parent entry reached;
- one **actual nonempty held-partition entry** per supported mixed-key turn,
  counted on the calling thread with a release no-op hook.

The pinned negative control bypasses only the mixed-parent route, restoring the
old recursive grouping. Canonical digests, continuation and XOF checks pass,
then the work assertion fails on **AVX2, two distinct-key states: 2 partitions,
expected 1**. The control run is VERIFIED because that failure is required.
It tests a value-equivalent performance regression without timing assertions.

No assembly, generator, proof harness/model or build-script bytes change. The
inspection records their complete SHA-256 snapshot. The existing arbitrary-CV,
independent-flags output8/16 proofs cover the unchanged compression/ABI/memory
contracts, including parent CV output. New Rust indexing, dispatch and state
commit are exercised natively; this is not presented as a new formal Rust proof.
Standard BLAKE3's full rounds, keys, mode flags and digests/XOF are unchanged.

## Attempts retained, not promoted

| Source | Approach | Why not selected |
|---|---|---|
| `17af5cf788a3d19bcec3080ecd8ce88f99eae74c` / `93312276a98e80d4aa107288b77a4ecd12ebe5c9` | initial held-core/direct-turn prototypes | all old tests passed, but strict unused-method warning checks FAILED; all four records retained |
| `e533be7889093cc0f4f86535179b4c6a70f7a620` | absorb each held stage with its core | removes key recursion but loses shared-key parent batching; modern complete costs about 8–10%, changed finishing costs |
| `5690ab9106428bd09a4456230fb4f1e845110b83` | direct ordered x86 turn without waiting vectors | simpler, but the same parent-batching/finishing trade-off; retained outside selected source |
| `1b27184cd8c65a29d902e72f3e8a4e6e9e3315df` | independent parent lanes for all keys, including homogeneous turns | small shared-key/plain ×2 complete costs around 10% on Zen 5 and 5% on Ice; shared-key fast path retained next |
| `f80f666fee94d5a5e53e6595265963204d71ad36` | preserve common-key batching, const-width whole traversals | correct and useful; selected shared traversal removes duplicated generated setup/leaf/commit code |
| `b6770e33b1f153ba18e7341379f3ee53199d640c` | one shared traversal, existing width-specific compression batches | selected; direct baseline measurements above |

Raw evidence: [`stage-parent/`](stage-parent/), with **63 run folders: 59 VERIFIED,
4 FAILED warning-gate attempts**, all scripts, full manifests, source identities,
judgments, native/control/identity/startup logs, and source-labeled alternatives.
`stage-parent/inventory.json` lists every run and commit. Failed attempts contain
no accepted performance evidence; the expected negative controls are separate
VERIFIED runs. No executables are published.

John Servil: independent design/proof/cost review and integration. Sam Shackleton:
implementation, evidence and owned phase-cost follow-up. Devon Jonte: independent
peer/Intel review. Nothing merged, tagged, released or uploaded to crates.io.

— Sam Shackleton
