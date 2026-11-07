# BLAKE3-Servil: eight-lane AVX2 finishing, nearly fivefold ready-state gains

2026-11-07 — Sam Shackleton

## Result and review scope

The existing grouped incremental API now uses eight independent SIMD lanes on
AVX2 CPUs. On native Zen 3, at 1,024 messages:

- **Ready-state finalization, 1 B:** 105.23→21.55 ns/message, **4.88× faster**,
  about **80% less whole-package energy**.
- **Complete 1-KiB reset/update/finalize cycle, four 256-B arrivals:**
  1089.06→418.07 ns/message, **2.60× faster**, **57% less package energy**.
- **Complete 64-B cycle, 17-B arrivals:** 195.79→64.09 ns/message,
  **3.06× faster**, **66% less package energy**.

Mixed keys/modes give similar gains. All seven standard BLAKE3 rounds, flags,
digests, immutable finalization and state reuse remain. No public API changes.
These are direct comparisons against frozen #271, with all complete-cycle work
measured together; they are distinct from its earlier AVX-512 ratios.

The current 9700X AVX-512 control also improves: ready-state 64-B finishing is
10.34→7.26 ns/message, about 30% less wall time. Its current ready/grouped
comparisons have no Slower metric judgments. Initial wrapper versions regressed
this path; the raw losses and the measured correction remain in the record.

There are review costs: two small-count Zen 3 complete-cycle cells are +3.3%,
first-initialize instructions rise 12.6%, and prefix work retained by updates
increases finishing latency. Sam owns follow-up, linked to the existing startup
and first-chunk cost work (#268/#270). John owns explicit acceptance/integration.
Intel AVX2 timing is requested from Devon, who owns the i7. The speed evidence
here is native AMD AVX2 plus native AMD AVX-512 controls.

## Exact identities

- Baseline, frozen #271: **7c4166fa922165c7db8250908f6442cb3b9a28a2**.
- Current candidate: **e3af185c5962076972129e83dfc2c8d9badb62b2**,
  `samshackleton-tech/BLAKE3:probe/sam-output8`.
- Initial kernel/wrapper trial: **7c2829e34763ce61042f5af9880df523d8228ef0**.
- Constant-width intermediate: **87db5487f781b402e7418155de3dd07eadcb8449**.
- Shared clocks: **415e7df398d42d6cc34b965a4c033a02798a9dd6**.

Every source cohort remains separate. The new output8 assembly and proof are
byte-identical across the three candidate heads. Existing output16 and partial
assembly regenerate byte-identically to the baseline. Identity hashes accompany
all source/proof/measurement logs.

## Mechanism and complexity inventory

`gen_output8.py` reuses the existing AVX2 partial-kernel `Kernel` emitter for the
single-compression prefix of its seven-round body. Constants come from read-only
tables, counters are zero, and an eight-by-eight transpose returns canonical
32-byte values. The new kernel body is **6,715 bytes**. Its local block-label
alias has a different symbol size; the reported number is the function itself.

Its compact read-only **384-byte Params8** contains eight block pointers, eight
word-major CV vectors, lengths and flags. Existing byte descriptors and Hasher
buffers remain. The shared Rust compression/finishing loop is parameterized by
width: eight for detected AVX2, sixteen for AVX-512. Other CPU/count/state paths
retain their existing operations. Inputs must be full readable padded blocks;
first-chunk counters are zero. Real groups contain eight messages, with partial
groups handled individually.

Added pieces are one ISA-specific kernel/generator/proof, the compact parameter
type, width selection and reuse of the shared const-width wrappers. There are no
new persistent Hasher fields, public types, tuning clocks, workers or APIs.
Linux/std and the existing CPU feature detection select the path. AVX-512 keeps
its sixteen-lane compression kernel.

## Production-API measurements

All direct current comparisons are **7c4166fa→e3af185c**, four independent fresh
builds/layouts, alternating source/method order, shared paired judge at **3%
practical margin / 5% FDR**. Each operation is its own comparison family.
`pinned-run` locks the host before checkout/build preparation through verification;
targets are private and job scripts do not nest that lock.

A CPU-2 caller owns states/descriptors/outputs. Native Hasher/output size,
alignment, stride and base addresses are logged. RAPL measures the whole package,
including idle/background activity; wall, process CPU, cycles, instructions and
package energy are separate metrics. No cache-line cause is inferred from timing.

### Ready-state finalization

These states are prepared with ordinary per-Hasher `update` calls in 17-byte
pieces. Finalization borrows already-computed prefix CVs. The separate complete
cycle resets states, performs all those ordinary updates and finalizes together.
Construction/key/context/data preparation is outside repeated timing. Independent
blake3 references and final byte counts check every timed operation.

Counts are 2/7/8/9/16/1024. Plain sizes are 0/1/63/64/65/255/1024/2048; mixed-mode
1-KiB and varied-length 1..1024 cases complete the 60-cell matrix.

| CPU | Ready finish wall Faster/Level/Slower | Ordinary-update complete cycle wall F/L/S |
|---|---:|---:|
| Zen 3 EPYC 7443, new AVX2 path | 36 / 24 / 0 | 36 / 24 / 0 |
| 9700X, AVX-512 control | 18 / 42 / 0 | 8 / 52 / 0 |

All five-metric Slower sets are empty in both ready-state instruments. On Zen 3,
ready-state 1-B finalization at 1,024 messages is:

| Metric/message | Old | New |
|---|---:|---:|
| Wall ns | 105.2266 | 21.5497 |
| Process CPU ns | 105.2289 | 21.5486 |
| Package nJ | 7111.28 | 1430.64 |

Ready 1-KiB finishing is 103.6666→21.9782 ns; mixed modes/varied lengths are
103.5423→21.9844 ns. Prefix preparation stays outside these finish-only rows.

### Grouped updates and complete cycles

The grouped instrument includes active-state reset, caller piece-vector refill,
`throughput::update_each` calls, library allocations and canonical output in its
complete-cycle rows. Update-only and finish-only rows expose the work split.
Initial Hasher/key/context/data creation is outside. Counts 2/8/16/1024,
17/256-B pieces, plain 64/1024 and mixed 1024/varied lengths give 32 cells/operation.

| CPU | Update wall F/L/S | Finish wall F/L/S | Complete-cycle wall F/L/S |
|---|---:|---:|---:|
| Zen 3 | 24 / 5 / 3 | 6 / 8 / 18 | 24 / 6 / 2 |
| 9700X AVX-512 control | 0 / 32 / 0 | 4 / 28 / 0 | 3 / 29 / 0 |

Zen 3 at 1,024 messages, complete cycles:

| Shape / arrivals | Wall old→new ns/message | Process CPU old→new | Package energy old→new nJ/message |
|---|---:|---:|---:|
| 1 KiB, four 256 B | 1089.0562→418.0703 | 1088.9605→418.0795 | 69938.43→30080.38 |
| Mixed modes 1 KiB, four 256 B | 1089.2559→415.5670 | 1089.1386→415.5758 | 75799.64→29977.57 |
| Mixed varied lengths, 256B pieces | 624.9266→361.2552 | 620.1551→361.1933 | 43524.62→25912.19 |
| 1 KiB, 17B pieces | 2225.3042→1131.9992 | 2225.3424→1131.9920 | 146652.39→80510.61 |
| 64 B, 17B pieces | 195.7933→64.0866 | 195.7574→64.0776 | 13206.96→4547.31 |

### Sparse active/ready counts

The current-source sparse study keeps 1,024 Hashers open with only
1/2/8/15/16/17 active/ready messages. Only active states reset. Plain/mixed modes,
64/1024-byte messages and 17/256-byte arrivals give 48 cells/operation.

| CPU | Sparse update wall F/L/S | Sparse finish wall F/L/S | Sparse complete-cycle wall F/L/S |
|---|---:|---:|---:|
| Zen 3 | 48 / 0 / 0 | 16 / 8 / 24 | 48 / 0 / 0 |
| 9700X | 0 / 48 / 0 | 8 / 40 / 0 | 8 / 40 / 0 |

Sparse complete cycles have no Slower metric judgment on either host (Zen 3
239F/1L, 9700X39F/201L). Finishing retains its pending-prefix cost. For example,
one ready 1-KiB message in the 256-byte-piece fixture finishes in
103.1473→999.5503 ns on Zen 3; eight ready messages finish 97.6138→310.0937 ns each.
Their complete cycles remain Faster.

### A/A calibration

Four current-head same-source runs use each complete instrument:

- Bulk, two hosts, three operations ×160 metrics: **960 Level**.
- Ready-state, two hosts, two operations ×300 metrics: **1,200 Level**.

All **2,160 current-head A/A judgments are Level**. These are independent
calibration runs, separate from the cross-source speed comparisons.

## Retained wrapper losses and correction

Initial `7c2829` and constant-width `87db` gain on AVX2 but regress small AVX-512
finishing about 30%; complete short grouped cycles grow 10–22%. The constant-width
loop alone leaves that cost. Their full raw measurements remain source-labeled.

A pinned code-inspection comparison shows an old 24-byte niche-encoded
`Option<Input>` transport and a new 32-byte nested `ControlFlow` transport in the
iterator helpers. Both inline the same input-field checks. The current bounded
ArrayVec construction avoids that nested iterator transport and its extra stores.
The current code-inspection and direct performance comparison accompany it.

On 9700X, ready 64-B finishing improves 10.3378→7.2649 ns/message;
instructions fall 129.6905→105.8819. The earlier intermediate was 13.17 ns and
141.59 instructions. These are distinct cohorts; the current baseline/current ratio is
directly measured. Current AVX-512 ready/grouped/sparse Slower metric sets are
empty. The observed code/retired-instruction change supports this correction;
no alias/cache mechanism is assigned from elapsed time alone.

## Measured costs and ownership

The complete-cycle two-message controls on Zen 3, 1KiB/17B arrivals, are
**+3.3% Slower** in both plain and mixed modes:
2618.4165→2705.3324 ns and 2620.6285→2705.9660 ns/message. CPU/cycles also rise;
package energy is Slower in the mixed case. The cause remains open. Three
update-only wall cells are Slower, including the matching two 1-KiB cells and
64-B/two-message +4.6%. All are retained, with no automatic false-positive label.

Deferred-prefix finishing at 1,024 ready 1-KiB states grows 105.2926→330.1821 ns
on Zen 3. It pays work previously done during updates; the complete 1089.06→418.07 ns
cycle includes it. Scalar sparse finishing can also grow as shown above. This
continues the first-chunk finishing trade-off owned in #270.

Current first/already-initialized startup measurements use 32 alternating fresh
process pairs/four layouts:

| CPU | First wall µs old→new | First CPU µs old→new | First instructions old→new |
|---|---:|---:|---:|
| Zen 3 | 33.3412→32.9770, Level | 34.6040→34.2359, Level | 117137→131900,+12.6%,Slower |
| 9700X | 24.3888→23.6367, Level | 24.6049→23.8505, Level | 123718→123717,Level |

Zen 3 first cycles are Level. Its already-initialized cycles are +3.4% Slower,
while wall/CPU/instructions are Level. All 9700X startup metrics are Level. Startup
package energy is outside this short-window probe. Earlier 87db startup measurements
remain separately labeled. The new AVX2 runtime case accounts for real additional
checked work; full selected-kernel coverage stays intact. #268 owns startup work.

Sam recommends acceptance of the remaining measured costs for the substantially
larger ready/bulk benefits. John owns explicit review/integration judgment. Sam
owns follow-up in the assigned startup/first-chunk issues, including reproduction,
raw evidence, prior attempted wrappers and bounded investigation. Intel timing
is a separate review task assigned to Devon by request, not inferred from Zen 3.

## Verification

Exact current source passes **189/189 nextest tests on all four x86 hosts and
162/162 on ARM VM**. No-default builds, 19 doctests and warnings-denied rustdoc pass
on all five. Tests select the actual 8/16-lane entry, cover 7/8/9 boundaries,
independent modes/keys/lengths, every ending position, reusable states, ordinary/
grouped mixtures, scalar finalization and continuation across 1-KiB/16-KiB boundaries. Native
read-only and guarded block/CV/descriptor/output buffers exercise the selected
kernel on AVX2 and AVX-512 CPUs.

The new assembled kernel's **1,230-step proof** covers eight arbitrary independent
CVs, blocks, lengths 0..64 and flag bytes at counter zero, all seven rounds. It
checks read-only Params384/input regions, exactly 256 output bytes, every legal
SysV entry-stack residue, ABI preservation and data-independent control/addresses.
Four faults reject wrong flags, a wrong CV word, a 16-byte block overread at 52,
and omitted final output. Native Zen 3 CPU/model comparison: **28 vector forms,
8 memory forms, 200 random states/form, 1 alignment control: all agree**.

The assembly and proof are byte-identical across all candidate heads; identity
hashes bind the initial proof/model run to the final source. Existing output16/
partial assembly regenerate byte-identically. The mixed CV/root startup checksum
**0x153e0dfbeac2bb44** retains the same sixteen fixture cases. It tests the
selected eight-lane kernel twice or the sixteen-lane kernel once. Native
independent-reference, corruption and reachability controls pass.

## Evidence and reproduction

[`output8-next/`](output8-next/) contains all 37 VERIFIED pinned runs, initial
losses and intermediate wrappers, current ready/bulk/sparse/AA/startup datasets,
native/proof/model records, code inspection, instruments and source manifests.
Executables are omitted and each file is below 20 MB. ARM VM is correctness/build
coverage; the i7 remains Devon's and no local heavy work was run by Sam.

Current source scripts/manifests are `direct-bulk-HOST.json`,
`direct-ready-HOST.json`, `sparse-HOST.json`, `aa-*.json`, and
`direct-startup-HOST.json`. Adapt authorized host/lock/local script paths while
retaining commits/instrument. Shared native/startup scripts are included beside
manifests that retain the author's absolute paths.

Sam owns implementation, evidence and follow-up; John owns independent design/
proof/cost review and integration. The Intel/i7 comparison is requested from Devon in
PR #271 comment 6700017436 with exact hashes and public instruments. Frozen #271/#269/
#259/#262 retain their source/review boundaries. No merge or release is implied.
