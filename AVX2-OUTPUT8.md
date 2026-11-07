# BLAKE3-Servil: eight independent AVX2 incremental compressions

2026-11-07 — Sam Shackleton. Measurement/review experiment; integration owned by John.

Baseline: frozen #271 **7c4166fa922165c7db8250908f6442cb3b9a28a2**.
Current candidate: **e3af185c5962076972129e83dfc2c8d9badb62b2**,
`samshackleton-tech/BLAKE3:probe/sam-output8`.

## Current measured results

The new path brings grouped incremental root/prefix compression to AVX2 CPUs.
It reuses the existing partial-kernel seven-round emitters, with a compact
read-only 384-byte parameter block and eight canonical CV/digest outputs.
The Hasher buffers, shared byte descriptors and public API stay the same.
AVX-512 keeps its sixteen-lane kernel. Whole cycles use production
`throughput::update_each` and `finalize_each`; ready-state controls prepare
states with ordinary per-Hasher updates.

Exact-current Zen 3, 1,024 messages:

| Operation | Wall old → new, ns/message | Process CPU old → new | Whole-package energy old → new, nJ |
|---|---:|---:|---:|
| Ready-state finalization, 1 B | 105.2266 → 21.5497 | 105.2289 → 21.5486 | 7111.28 → 1430.64 |
| Ready-state finalization, 1 KiB | 103.6666 → 21.9782 | 103.6557 → 21.9761 | 7532.75 → 1567.85 |
| Complete 1-KiB cycle, four 256-B arrivals | 1089.0562 → 418.0703 | see raw `direct-bulk-runs/` | 69938.43 → 30080.38 |
| Complete 64-B cycle, 17-B arrivals | 195.7933 → 64.0866 | see raw `direct-bulk-runs/` | 13206.96 → 4547.31 |

That is about **4.9× ready-state finalization**, **2.6× complete 1-KiB cycles**,
and **3.1× complete 64-B cycles**. Complete cycles include resets, caller piece-
descriptor refill, all updates and canonical output. Initial Hasher/key/context/
fixture construction is outside repeated timing. Package RAPL includes idle/
background activity, with CPU/cycles/instructions retained separately.

The ready matrix has 36 Faster / 24 Level / 0 Slower wall cells for each operation
on Zen 3. The grouped complete-cycle matrix has 24 Faster / 6 Level / 2 Slower
wall cells: two-message 1-KiB/17-B-arrival controls, plain and mixed modes,
+3.3% (~86 ns/message). Those measured costs remain for review. Deferred finishing
also retains its own phase timings, as in #270; whole cycles account for all work.

The current 9700X AVX-512 control has ready finalization 18F/42L/0S, complete
ordinary-update cycles 8F/52L/0S, and grouped complete cycles 3F/29L/0S. All metric
Slower sets in those current controls are empty. Ready-state 64-B finalization
improves 10.3378→7.2649 ns/message; instructions fall 129.6905→105.8819/message.

## Controlled wrapper revisions

Initial **7c2829e34763ce61042f5af9880df523d8228ef0** and constant-width
**87db5487f781b402e7418155de3dd07eadcb8449** establish the AVX2 gain but regress
small AVX-512 finishing by about 30%, with complete short cycles 10–22% slower.
The constant-width loop alone leaves that cost. Both source cohorts stay raw.

A pinned code-inspection comparison shows the old iterator returning a 24-byte
niche-encoded Option<Input>, while the new generic iterator transports a 32-byte
nested ControlFlow record with an explicit tag. The current version builds its
fixed-width descriptors directly in ArrayVec, ending that nested transport.
Current assembly inspection and timings accompany the controlled change. It
preserves one shared const-width mechanism. No cache-line cause is inferred.

## Verification and pending calibration

Current source passes **189 nextest tests on all four x86 hosts; 162 on ARM VM**,
with no-default builds, 19 doctests and warnings-denied rustdoc on all five.
Tests select the actual 8/16-lane entry, cover 7/8/9 boundaries, independent modes/
keys/lengths, every ending position, state reuse and continuation, and guard
individual blocks/CVs/descriptors/output with read-only input pages.

The new assembled kernel's proof covers eight arbitrary independent CVs, blocks,
lengths 0..64 and flag bytes at counter zero, all seven rounds. It checks read-only
Params384/input buffers, exactly 256 output bytes, all legal stack residues and
ABI preservation. Four faults reject wrong flags, a wrong CV word, block overread
and omitted final output. Native Zen 3 CPU/model comparison: **28 vector forms,
8 memory forms, 200 random states/form, 1 alignment control: all agree**.
Assembly/proof are byte-identical across the three candidate heads; `output8-next/code-identities.json`
binds them. Existing output16/partial assembly regenerates byte-identically.

Startup at 87db is recorded separately: Zen 3 first 34.508→36.695 µs wall Level,
instructions +12.6% Slower. All 9700X startup metrics are Level. The new AVX2
kernel body is **6,715 bytes**. The existing mixed CV/root checksum
0x153e0dfbeac2bb44 tests the selected eight-lane kernel twice or sixteen-lane
kernel once, preserving the same fixture.

Same-head A/A and sparse-active callback studies are running at current e3af.
Intel AVX2 timing is requested from Devon, who owns the i7; this record currently
provides native AMD AVX2 timing and AMD AVX-512 controls.

## Reproduction and review ownership

[`output8-next/`](output8-next/) has complete `bulk.sh`/`ready.sh`, source-pinned
manifests, all earlier losses, current results, proof/native-model logs and code
inspection. Every measured pair uses four fresh builds/layouts, alternating
order, shared clocks **415e7df398d42d6cc34b965a4c033a02798a9dd6**, 3% margin / 5% FDR,
private targets and a host lock held before preparation through verification.

Use `direct-bulk-zen3.json` / `direct-ready-zen3.json` for the current exact
comparison, adapting authorized host/lock paths. The baseline/candidate are the
full hashes above. Native scripts are included alongside as-launched manifests.
Sam owns the x86 implementation/evidence; John owns design/proof/integration and
explicit cost acceptance. Devon owns Intel/i7 performance. Frozen #271/#269/#259/
#262 stay at their source/review boundaries. No merge/release is implied.
