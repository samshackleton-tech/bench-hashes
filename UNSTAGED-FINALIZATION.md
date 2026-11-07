# BLAKE3-Servil: skip the core clone when no staged bytes remain

2026-11-07 — Sam Shackleton

## Chosen change

A three-line production guard avoids cloning the Hasher core and updating that
clone with an empty slice when the staging buffer is empty. The current core
already represents all accepted bytes; final-node computation can borrow it.
Pending-stage calls retain their existing clone/update path, preserving immutable
finalization and state reuse. Buffer sizes, compression, API and buffering policy
stay the same. This removes work rather than deferring it.

At 64 ready states holding 64-byte messages, warm direct `Hasher::finalize()` is:

| CPU | Wall old→new, ns/message | Process CPU old→new | Whole-package energy old→new, nJ |
|---|---:|---:|---:|
| 9700X | **78.9622→48.6760** | 78.9617→48.6759 | 4132.08→2500.08 |
| EPYC 9255 | **98.5024→61.2020** | 98.4995→61.2002 | 6903.62→4268.69 |
| Ice Lake | **159.2091→94.9168** | 159.1344→94.8794 | 14202.14→8419.98 |
| Zen 3 | **100.2322→69.1941** | 100.2309→69.1898 | 6522.45→4398.18 |

That is about **31–40% less finishing time**, and **33–41% less package energy**
in these cells. A former guard with this behavior was removed in the Nov 6 #238
cleanup pending measurement; this study supplies the measured rationale and a
work-count test that protects it. The earlier deletion is commit c21488d0.

## Exact sources and scope

- Baseline, frozen #277: **6630e56573f4907e5f691347dba8778a2ffb2b05**.
- Candidate: **f47d9e5d284aafcbabf7b6b2105bdedde4832261**,
  `samshackleton-tech/BLAKE3:probe/sam-finalize-guard`.
- Initial guard-only implementation: **59c26971b704ff96048d07c2f147f108177bcde6**.
- Shared clocks: **415e7df398d42d6cc34b965a4c033a02798a9dd6**.

An empty staging buffer does not mean an empty message. The current block and
CV stack can already contain a whole processed message, including a long one.
`final_output()` previously cloned that core and called `update(empty)` before
reading its final node. With staged bytes present, the clone still receives them.
The guard affects canonical and XOF finalization, across existing platforms.

Only the guard changes production work. The added clone counter uses the existing
thread-local test-count infrastructure and compiles away outside tests. The test
checks actual CV-stack clones, including those inside HasherCore::clone, for both
canonical and XOF calls. No kernel, ABI, persistent field, worker, public API or
new buffering behavior is introduced. All compression assembly is byte-identical.

## Direct exact-head measurements

Four fresh builds/layouts, alternating source/method order, shared paired judge
at **3% practical margin / 5% FDR**, separate families per operation. `pinned-run`
holds host locks before preparation through verification; targets are fresh and
private, and scripts do not nest the lock.

The final instrument has 60 cells/operation/host: one or 64 Hashers, fresh state
or state primed with a 64-KiB tree then reset, lengths 0/64/1024/2048/16384, and all
plain/keyed/derived modes. Ordinary per-Hasher 17-byte updates prepare the states.
It measures canonical finishing, XOF construction+first 32 bytes, and the complete
reset/update/finalize cycle. Initial allocation/key/context/data/reference/priming
is outside repeated timing; all complete-cycle work is inside. Every output and
final byte count is independently checked against official blake3.

| CPU | Canonical wall Faster/Level/Slower | XOF-first32 wall F/L/S | Complete-cycle wall F/L/S |
|---|---:|---:|---:|
| 9700X | 48 / 12 / 0 | 48 / 12 / 0 | 24 / 36 / 0 |
| EPYC 9255 | 48 / 12 / 0 | 48 / 12 / 0 | 24 / 36 / 0 |
| Ice Lake | 48 / 12 / 0 | 48 / 12 / 0 | 24 / 36 / 0 |
| Zen 3 | 48 / 12 / 0 | 48 / 12 / 0 | 24 / 36 / 0 |

Across 720 wall cells: **480 Faster / 240 Level / 0 Slower**. Across wall,
process CPU, cycles, instructions and package energy: **2,400F/1,200L/0S**.
The pending-stage 2-KiB finish cells are Level. Already-processed 16-KiB finalization
also improves, even though it uses parent nodes rather than a first-chunk root.

Plain 64-B messages at 64 states, other operations per message:

| CPU | XOF first 32 wall old→new (ns) | Complete reset/update/finalize wall old→new (ns) |
|---|---:|---:|
| 9700X | 82.7377→77.5662 | 114.4172→101.4933 |
| EPYC 9255 | 103.5321→98.4291 | 138.6340→124.8157 |
| Ice Lake | 174.9618→129.7010 | 298.8306→237.6187 |
| Zen 3 | 104.4292→82.0574 | 173.0356→140.1497 |

These are actual complete-cycle timings rather than sums of phase figures.
XOF results describe construction and the first 32 bytes, not long-output bandwidth.
The two current-head A/A jobs repeat this entire instrument on 9700X/Zen 3:
**all 1,800 metric judgments Level**.

One pinned CPU-2 caller owns states/output. Native Hasher size/alignment/stride/
base and output layout are logged. RAPL is whole-package energy including idle/
background activity, reported separately from process CPU. No cache-line cause is
inferred from timing. This is a warm Hasher API study, not a claim about network
latency, startup, cold one-shot calls or parallel throughput.

## Test coverage and genuine fault control

Exact head passes **190/190 nextest tests on each of four x86 hosts; 163/163 on
ARM VM**, with serde/zeroize coverage, no-default builds, 19 doctests and warnings-
denied rustdoc all five. Existing mode/key/reference/reuse/continuation tests hold.
All math/assembly and their proof contracts remain unchanged.

The new deterministic work test prepares lengths 0/64/1024/2048/16384/32768,
then asserts zero core-stack clones when `staged==0`, exactly one with pending
staged data, for canonical and XOF finishing. The clone-count hook sits
on the actual CV-stack Clone method. The test also verifies independent digests.

A pinned fault-control job runs the positive test, deletes only the three-line
guard using asserted replacement in its fresh checkout, then requires the test
to fail. It fails at canonical len 0 with **one clone instead of zero**, while the
digest comparison has passed. The source diff and failed-test output are retained.
Thus deletion of this value-equivalent performance guard is test-detectable
without timing or cross-test load. The negative control is an expected test failure
inside a VERIFIED control job, distinct from failed experiment setup below.

## Separate alternatives retained, not promoted

The earlier four-host joint instrument compared three independent changes against
the same baseline, with four fresh layouts each and back-to-back paired executions:

1. **The chosen guard**, initial 59c26971: canonical 16F/4L, XOF 16F/4L and complete
   cycle 8F/12L wall cells on each host. All metric Slower sets empty.
2. **Borrow final block directly**, 4f7c2d3040d3485376753b63e2d8db06973a8b02:
   canonical 12F/8L, XOF 20 Level; modern 64-B ~79→46.8 ns versus ~48.7 with
   the guard. It provides a larger incremental gain on Zen 3, but adds a distinct
   canonical-only path. It stays a measured option rather than part of this patch.
3. **Live-length ArrayVec stack**, e38783f6053f21636d0e1a9f9bcbabbe7fb26783:
   initial derived Clone loses 16/20 canonical cells on three CPUs (~8% on Zen 5)
   and adds instruction work. A bounded bulk-copy Clone revision
   **143acbd6f71421a36ccf1206c84273eb9b62ee3e** recovers a 27% scalar gain on EPYC,
   with staged 2-KiB cells Level. It still gives less than the guard while changing
   stack representation/zeroization helpers. Both source versions remain separate.

A broader experimental branch **probe/sam-root-output**, implementation
**ef2c994b91119059019a262e79fb13ff015da80e**, proof head
**183616e9459c07e6102fad4a20da28b7a9b0d62d**, adds two small arbitrary-CV root entry
wrappers sharing the existing stack-free chunk-root compression body. It combines
the guard/borrow changes, but buys little beyond them and has 3–5% flagged complete
16-KiB cycle costs on some CPUs. Its warm throughput/convenience controls are Level.
It remains unpromoted; its trait method, entry points and tests are outside this
three-line production patch.

That branch is independently verified: SSE root-block 483 steps / AVX-512 391 steps,
arbitrary CV/block/len/flags, counter 0, ROOT-only structural addition (parent roots
keep CHUNK_END clear), unused first ABI pointer zero-sized, read-only input,
ABI/stack/trace/exact 32-byte output. Eight faults reject omitted ROOT, forced END,
wrong length or wrong CV. Original chunk-root 32 cases are proved unchanged. Native
CPU/model 62 vector forms / 4 memory forms / 200 states all agree, with native readonly guards.
Those proofs establish correctness, not a reason to include the extra mechanism.

Nine FAILED probe-development jobs are retained: the expanded control instrument
first used the wrong throughput::hash signature, then the wrong Block export path.
Both failed during compilation, before timing. The corrected control uses
`throughput::hash(Mode::Plain, &[throughput::Block], len)` with aligned/padded fixture
conversion outside timing. Every raw source and script identity remains distinct.

## Artifacts and ownership

[`scalar-finalize/`](scalar-finalize/) retains 44 run directories: 35 VERIFIED and
nine FAILED setup attempts. It includes chosen exact-head mode/AA/native/control
runs, independent variants, unpromoted root wrappers/proofs, all losses, raw code
and instruments. No executable ELF files; each artifact is below 20 MB.

Chosen reproduction: `guard-matrix-HOST.json`, `guard-aa-HOST.json`,
`guard-native-HOST.json`, and `guard-control.json`. Adapt authorized host/lock/local
script paths while retaining source hashes and instruments. Shared native scripts
are included beside as-launched manifests with author absolute paths.

John owns independent design/performance/integration review. Sam owns this source,
evidence and any follow-up; Devon owns peer/i7 work. Frozen #277/#274/#271/#269/
#259/#262 retain their review boundaries. No merge/release is implied. Ratios are
direct to the measured baseline and are not multiplied with earlier improvements.
