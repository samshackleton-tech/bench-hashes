# Retain the current partial XOF block across short reads

2026-11-07 — measured candidate; independent design/cost review requested.

BLAKE3-Servil can retain one partially read 64-byte output block rather than
recompressing that same block on every short `OutputReader::fill` call. For a
64-byte input and 4 KiB of output read **one byte at a time**, the complete
`convenience::hash_xof` call plus all reads is **7.8–13.3× faster** on the
four measured x86 hosts. Whole-block output controls remain Level; this is not
a claim of that factor for ordinary canonical hashing or long vectorized XOF
bandwidth.

The old repeated-compression behavior was already documented. This is a measured
change to that trade-off, not a claim that the behavior was newly discovered.
A native Reader grows **192 → 256 bytes**; a few batch-copy and package-energy
costs are retained explicitly for review below.

## Exact sources and mechanism

- Baseline: `f47d9e5d284aafcbabf7b6b2105bdedde4832261` (frozen #278).
- Selected: [`762b0227939e60a0f2d4f3da5cfc8742d8c01697`](https://github.com/samshackleton-tech/BLAKE3/commit/762b0227939e60a0f2d4f3da5cfc8742d8c01697), `probe/sam-xof-cache-head-return`.
- Bench/clocks: `415e7df398d42d6cc34b965a4c033a02798a9dd6`.
- Independent from #281's held parents and #283's in-place checkpoints. Every
  selected result is a direct baseline → selected comparison; no ratios composed.

Two private fields hold `[u8; 64]` and a validity bit. A partial-block read computes
that block only on a cache miss. Sequential reads use its remaining bytes;
finishing a block invalidates it as the output counter advances. Seeking always
invalidates it. Cloning copies the reader's position and cache, so each reader
then progresses independently.

Whole blocks still go to the existing vectorized `xof_many` path. After a partial
head consumes the requested buffer, a three-line early return avoids a zero-length
`xof_many` call. No future output is computed speculatively.

**No new public API, type, kernel, assembly, ABI, worker, clock or production
unsafe operation.** There are two new private Reader fields and one-block retained
storage. Native size/alignment/stride were measured: **192 → 256 bytes, align64**,
not inferred from field order. Hasher storage is unchanged. Explicit zeroization
wipes cache bytes **even when invalid**, plus its validity bit; Debug still exposes
only position. Standard full-round BLAKE3 keys, flags, counters and XOF bytes remain.

## Complete convenience API: input hashing and every read inside

Each timed operation calls `convenience::hash_xof(mode, bytes)` and extracts all
4 KiB in one-byte calls. Input allocation, independent references and output
allocation are outside, but **input hashing, reader construction and all output
calls are inside**. This table is one reader at a time, plain 64-byte input:

| Host | Wall ns old → new | Process CPU ns old → new | Package nJ old → new |
|---|---:|---:|---:|
| Ryzen 9700X | 192147.3500 → 15504.7638 | 192148.2886 → 15504.4412 | 9793196.5743 → 853557.0476 |
| EPYC 9255 | 241598.1381 → 18147.4145 | 241594.8173 → 18146.6232 | 16755540.0292 → 1334311.0518 |
| Ice Lake 6330 | 374602.7250 → 45574.7318 | 374317.7241 → 45570.8845 | 33304002.5481 → 4083062.9680 |
| Zen 3 EPYC 7443 | 218445.1082 → 27988.7129 | 218425.8440 → 27977.7041 | 14055824.2788 → 1897092.4627 |

Retired instructions in those complete operations fall:
2,008,033 → 359,649 on Zen5, 1,999,850 → 351,465 on Ice, and 2,442,219 → 358,379
on Zen3. Full cycles and all shapes remain in the raw records. Wall, CPU, cycles,
instructions and energy are separate. RAPL is **whole-package energy including
idle/background activity**, not energy attributed solely to the hashing core.

The 64-reader reuse cohort also holds: the same complete per-reader operation is
192112.6852 → 16426.1495 ns on9700X, 241576.4668 → 19495.0468 onEPYC,
377520.8828 → 45534.5334 onIce, and218986.8527 → 27999.1440 onZen3.

## Phase controls, whole-block controls and calibration

Primary instrument: **96 shapes per operation/host**:

- 1/64 readers; 64-byte/16-KiB inputs; 4-KiB output;
- read sizes1/7/16/32/63/64/65/1024; plain/keyed/derived modes;
- `ready_read`: reset an existing reader to offset0, then extract;
- `construct_read`: finalize a prepared Hasher into a reader, then extract
  (input hashing outside this phase);
- `convenience_read`: input hashing plus construction/extraction inside, as above.

For every host/operation, wall results are **72 Faster /24 Level /0 Slower**.
All 64-byte and1024-byte whole-block read controls are Level. Across four hosts,
primary wall totals are **864F/288L/0S**. Primary metrics total4320F/1439L/1S;
the one Slower is retained Ice package energy in a whole-block construct/read
control, not a whole-API time loss.

Separate constructor/copy/seek instrument: 24 shapes/op/host (1/64 readers,
input0/64/2048/16384,3modes), eight operations:
constructor alone, constructor/first32, convenience constructor alone,
convenience/first32, clone before output, clone after one byte, clone/read32,
and seek/read32. These include real convenience entry points rather than only
prepared-Hasher finalization. Constructors, first32 and convenience/first32 wall
controls are Level or Faster. Clone/read32 is Faster in every cell: copied cache
bytes avoid recomputing the current block.

Hash-pinned `pinned-run` sources/script SHA; private checkouts/targets; lock before
preparation through verification. Four fresh build/layouts, adjacent executions
with alternating order; shared `clocks::summary` **3% practical margin /5% FDR**.
Each caller owns its states and output slots. No false-sharing/cache/alias cause
is inferred from timing or source field order.

Current-head A/A on EPYC/Zen3: **all 4,800 metrics Level** across the primary
three-operation instrument and separate constructor/copy controls. A/A is separate
from direct gains and from earlier source versions.

## Occasional convenience calls after idle or other work

Existing clocks gap machinery, 24 calls after1ms Idle or Busy(128MiBarena), four
fresh layouts. The entire convenience hash/XOF extraction call is timed. No new
warmth API or clock heuristic; the caller chose the existing convenience API.
CPU/energy are **NA** in this gap cohort, not inferred from elapsed intervals.

First32 and full64 output controls: all wall/cycle/instruction judgments Level
on EPYC/Zen3. For 4KiB extracted one byte at a time, all24 wall cells/host Faster:

| Host/pattern,64B input | Complete call ns old → new |
|---|---:|
|EPYC after busy work|242153.9792 →17465.0208|
|EPYC after idle|241797.1042 →17096.1458|
|Zen3 after busy work|219622.6458 →25735.1979|
|Zen3 after idle|232397.0729 →25709.8542|

Level is not proof of identical cost. For example EPYC busy/full64 has a
453.4375 →576.6667ns mean, Level at the paired rule; Zen3 busy/first32 is
728.0312 →782.9375ns, Level. These means and the underlying layouts remain in the
record rather than being hidden behind the short-read gain.

## Retained costs and explicit review

The extra64bytes of native Reader storage and copied state must earn their place.
Selected-head costs retained:

- **Ice** four64-reader partial-clone wall cells +4.6–8.0%, roughly0.43–0.75ns
  per copied reader; 14 Slower metrics across wall/CPU/cycles/package.
- **Zen3** four empty-reader clone wall cells +3.2–7.9%, roughly0.19–0.45ns,
  and one partial-clone +5.3%,~0.30ns; 17 Slower clone metrics.
- **Zen3** one constructor-only package-energy cell, derived empty input/C1,
  1546.5593 →1604.7252nJ,+3.8%, wall Level.
- **Ice** one prepared-Hasher construct/read control, derived64Binput/C1,
  output4096in64Breadchunks: package505393.5607 →522949.3637nJ,+3.5%, wall/CPU Level.

These are real retained verdicts, not labeled false positives or automatically
vetoed. The matching clone/read32 operation is Faster in every cell, and ordinary
first32/whole-block wall controls remain Level. Smaller copy-only phases and
package measurements still deserve their own weight and ownership.

**Owner: Sam Shackleton. Acceptance pending.** An assigned follow-up will carry
these exact cells, artifacts, attempted head-return mitigation and bounded next
investigation before integration review. There is no proposal to hide them with
new padding, clocks or serialized tests.

The earlier cache-only source `911c40267a1224b246116b03de9c4cb2e8a52cc5` had
Zen3 seek/read32 costs of~3.4–3.6%. Returning when a partial head consumes the
request removes the unnecessary zero-length output call; selected-head seek
wall controls are Level or Faster. The earlier source and its clone/seek costs
remain separately labeled, not pooled into the selected gain.

## Correctness and actual compression-work control

Exact selected head: **191/191 tests on each of four x86 hosts,164/164 on ARM VM**;
serde/zeroize,no-default build,19doctests and warnings-denied rustdoc on all five.
ARM VM is correctness/build coverage, not native ARM timing.

The existing actual `RootBlock` work counter now verifies a cached head computes
no new block, while a new tail computes one. New targeted tests cover33one-byte
reads with empty fills, clone independence, repeated seeks across counters,
three modes, every native platform and independent official XOF bytes. Existing
byte golden/boundary/seek/whole-output tests remain. Invalid cache bytes are
explicitly tested for zeroization; no new unsafe production code.

The pinned negative control forces cache misses. Independent golden byte tests
still pass; the updated work assertion fails **“the rest of that block is
cached”**, because recomputing correct bytes costs an extra compression. This
expected failure is a VERIFIED control run, not a library failure. No timing
assertion or broad mutation campaign is involved.

No compression assembly, generator, proof/model/harness or build-script bytes
change. Existing compression/ABI/memory contracts remain; the new safe Rust
cache state machine is exercised natively, not claimed as a new formal Rust proof.

Raw record: [`partial-xof/`](partial-xof/), **30 retained run folders:28VERIFIED,
2FAILED probe-compilation attempts**. The failed gap probe tried to mutate the
prepared state's shared reference (`E0596`); corrected code captures its separate
owned output mutably. Those attempts contain no timing evidence. Every source,
manifest,instrument,mean,control and earlier cost remains; no executables published.

## Review boundary

Both convenience and Hasher-produced readers use the same private implementation.
The pending #267/#279 contract/name migration remains John's; this candidate adds
no new public surface and does not redesign the throughput engine. Integration
may be independent of preceding SIMD drafts despite the measured #278 baseline.

John Servil: independent design/cost/migration-fit review and integration. Sam
Shackleton: implementation,evidence and owned reader-copy/package follow-up.
Devon Jonte: independent peer/Intel review. No merge,tag,release or crate upload.

— Sam Shackleton
