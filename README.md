# BLAKE3-Servil #247 / draft #259: follow-up evidence

November 6, 2026 — Sam Shackleton

Earlier matrices and finite-pattern proofs are in
[data/2026-11-06/last247-first-matrices](https://github.com/samshackleton-tech/bench-hashes/tree/data/2026-11-06/last247-first-matrices).
This record does not silently replace their earlier candidate hashes.

## Review map: frozen source versus separate experiments

The chronological sections below retain their original source identities. For current review, start here:

- **Frozen #259, `1fb068fe`:** [direct whole-head results and gates](FINAL-1FB068FE.md), [compact AVX2 ABI/proof update](COMPACT-AVX2.md), and the fresh [exact-head standard multi-buffer SHA comparison](FINAL-1FB-MULTIBUFFER.md). The latter includes small-batch cells where SHA is faster, not just the large ready-batch gains.
- **Separate draft #262, `8eba67f5`:** [minimal borrowed fixed-length adapter](MINIMAL-BATCH-8EBA67F5.md). Five-host correctness/build gates hold. The user accepted the localized Zen 3 warm cost; [issue #263](https://github.com/servil-software-factory/BLAKE3/issues/263) owns its follow-up while integration review proceeds. Partial-length MT performance remains a review scope.
- **Not promoted:** [eight-wide fallback probe](WIDTH8-PROBE.md) and [startup-fixture reuse trial](SHARED-STARTUP-TRIAL.md). The startup trial lowers instructions but establishes no time/CPU/energy win at its margin. Rejected attempts and FAILED controls remain in the raw directories.
- **Separate current-`servil` [draft #269](https://github.com/servil-software-factory/BLAKE3/pull/269), `f9fcef45`:** [sixteen independent incremental roots together](BATCHED-INCREMENTAL-ROOTS.md): ~6× ready finalization and 3.5–3.7× reused-state 1-byte cycles on Zen 5, five-host gates/proof, four-host direct and A/A matrices. One-time Ice Lake initialization +4.9 µs is an explicit integration-review cost with Sam owning [follow-up #268](https://github.com/servil-software-factory/BLAKE3/issues/268).
- **Separate first-chunk bulk [draft #271](https://github.com/servil-software-factory/BLAKE3/pull/271), `7c4166fa`, stacked on #269:** [another sixfold whole-cycle gain](FIRST-CHUNK-BULK-GATHER.md): 1-KiB messages in four 256-byte arrivals, 936→155 ns on 9700X, ~81% less package energy. Full phase timings, sparse-ready costs, five-host gates and [Sam-owned follow-up #270](https://github.com/servil-software-factory/BLAKE3/issues/270) accompany the result.
- **Separate AVX2 [draft #274](https://github.com/servil-software-factory/BLAKE3/pull/274), `e3af185c`, stacked on #271:** [eight-lane incremental compression](AVX2-OUTPUT8.md): ~4.9× ready finishing and ~2.6× complete 1-KiB cycles on Zen 3, improved AVX-512 controls, all 2,160 A/A metrics Level. Costs extend Sam-owned #268/#270; Intel/i7 timing is requested from Devon.
- **Separate AVX-512 small/tail-eight [draft #277](https://github.com/servil-software-factory/BLAKE3/pull/277), `6630e565`, stacked on #274:** [reuse the existing eight-lane kernel](AVX512-SMALL8.md): ~5.4× eight-message ready finishing and ~3.8× complete 1-KiB cycles on Zen 5, three-host matching gains, calibration and explicit sparse/startup/control costs. The [register-live equal-ending trial](FUSED-FIRST-CHUNK-TRIAL.md) remains an unpromoted, separate study.
- **Separate unstaged finalization [draft #278](https://github.com/servil-software-factory/BLAKE3/pull/278), `f47d9e5d`, on #277:** [skip the core clone when the stage is empty](UNSTAGED-FINALIZATION.md): a three-line production guard, 31–40% less scalar finishing time in the shown short-message cells, 2,400F/1,200L/0S metrics across modes/four CPUs, and a clone-count deletion control. Broader container/borrowed-root/shared-entry alternatives remain measured studies.
- **Separate mixed-key staged-parent [draft #281](https://github.com/servil-software-factory/BLAKE3/pull/281), `b6770e33`, on #278:** [reuse independent compression for parents](MIXED-KEY-STAGES.md): 49–55% less complete-cycle time for 2,048 distinct-key 16-KiB messages, 23–32% less at 512, with common-key and ready-finishing controls retained. One existing partition replaces recursive key regrouping on the supported heterogeneous x86 path, no new kernel; a short EPYC update-only +3.3% cost remains explicit in [Sam-owned #280](https://github.com/servil-software-factory/BLAKE3/issues/280). Migration fit with the separate #267/#279 API direction also requires John's review.
- **Separate in-place checkpoint candidate, `9c3618b0`, on #278:** [optimize the existing `Clone::clone_from`](IN-PLACE-CHECKPOINTS.md): 10.5–18.1× faster shown in-place copies and 2.5–6.0× faster checkpoint/append/finalize, with ordinary clone controls Level. Ice Lake retired-instruction increases are retained for explicit review; the failed by-value prefix-copy attempts remain in the evidence.
- **Partner review:** [three requested x86 checks of John's isolated ARM collection change](partner-review/ARM-COLLECTIONS-X86.md), subsequently landed through #261. This is not ARM timing evidence from our x86 machines.

No later experiment silently expands the frozen #259 source/review boundary.

## Identities and limits

Every run has a hash-pinned manifest, STATUS, identity/build logs, and raw output.
Executables are omitted. `FAILED-` directories are failed development/diagnostic
runs, not performance verdicts. All reported timing below uses VERIFIED runs on
dedicated Cherry bare metal, a CPU-2 caller, four distinct build layouts, and
`clocks::summary` paired judgments (3% margin, 5% FDR). Package energy is whole
physical-package RAPL energy, including background/idle costs, not incremental
core-only energy. ARM VM logs are correctness/build evidence only.

Main library: [draft #259](https://github.com/servil-software-factory/BLAKE3/pull/259).
No release or merge is implied. All kernels retain full standard BLAKE3 rounds,
digests, flags and keyed-mode semantics.

## Full ending-combination assembly proofs

Source **e448e3ca1806c1a57f58c04f5ee0a7f274e8a7d3**, run
`last-symbolic-full-20261106T083119-419b01ef`:

- 32 equal-ending cases, widths 8/16 × K=0..15.
- 32 symbolic mixed-ending cases: every lane's ending is an independent public
  value in 0..K. For each output lane, its own end is checked at each value while
  all other lanes' ends remain arbitrary. This covers every combination within
  this assembly contract, not just the earlier rotated patterns.
- Keys and input bytes remain arbitrary; last lengths are arbitrary bytes, a
  superset of the Rust builder's valid 0..64; mode flags have CHUNK_START clear.
  Counter is zero and key/mode are common to the group.
- Prefix regions end at each symbolic ending. Conditional pointer loads prove
  bounds separately for both feasible alternatives. Arbitrary prior output
  ensures an omitted masked store cannot pass by leaving invented zeros.
- 46 proof-helper tests and four planted assembly faults with positive controls:
  omitted ROOT, overwritten completed lanes, reversed AVX2 snapshot, and unsafe
  prefix selection at/after an end. Unsupported/parser failures do not count.

This is **not a formal proof of all Rust packing/dispatch operations**. Tests
inspect actual ABI blocks before assembly changes them, against the initialized
proof rows: pointers, keys/constants, length/flag tables, ending offsets, zero
padding and scratch. Native tests span every K/ending phase and partial occupancy,
with independent official-reference answers and guard pages. FFI entry points
assert that caller flags leave CHUNK_START clear.

Native 9700X instruction-model comparison at e448: 386 vector forms, 107 memory
forms, 200 states each and 28 alignment fault controls, all agree. Separate native
CMOV controls establish that false 32-bit CMOV clears upper bits and false
memory-source CMOV still reads/faults; both are modeled. Rust: 187/187 9700X at
3ce63d58 (same Rust as e448), 158/158 ARM VM at e448. No-default-features builds,
doctests and warnings-denied rustdoc pass.

## Removing the small-batch helper-call cost

`inline-runs/` compares #249 **1ea6183225b91f857770949c7120a06485be8d92** with
**566fe8f3aa2b8ba7884e1fa3d794e498e2194102**, not with e448. The unchanged sparse
prefix helper was inlined after the prior matrix showed about 75 extra instructions
per small batch from its outlined call. Wall-time judgments across 168 shape/count
cells each:

| CPU | Faster | Level | Slower |
|---|---:|---:|---:|
| Ryzen 9700X | 152 | 16 | 0 |
| Xeon Gold 6330 / Ice Lake | 115 | 53 | 0 |
| EPYC 7443 / Zen 3 | 136 | 32 | 0 |

Inputs are already in memory; packing, tail padding and output stores are timed.
The comparison SHA is RustCrypto sha2 0.11.0 with hardware SHA instructions, **not
an assertion against every specialized multi-buffer SHA implementation**.

## Authentication: keyed BLAKE3 and cached-key HMAC-SHA256

`mac-runs/` compares #249 with 566fe8f3. sha2 0.11.0 and hmac 0.13.0; both reset
and cloned pre-keyed HMAC states are recorded. Key-pad precomputation is outside
the interval. BLAKE3 includes its normal per-batch key handling. Tag output stores
are timed for every contender. Official BLAKE3 keyed answers, a published HMAC
vector, and clone/reset equality are checked before measurement. Algorithm order
reverses between layouts.

At 1,024 messages, new keyed BLAKE3 time / HMAC-reset time:

| CPU | 64 bytes | 1 KiB | Mixed 100–1,000 bytes |
|---|---:|---:|---:|
| 9700X | 0.146 | 0.185 | 0.258 |
| Zen 3 | 0.292 | 0.340 | 0.437 |

9700X package-energy ratios are 0.162 / 0.199 / 0.278, respectively.
These are **different standard MAC constructions with different tags**. They
cannot be silently substituted in an existing protocol; this is tag-generation
cost evidence for applications free to choose their authentication construction,
not a comparison of tag-verification code or a new security claim.

## Caller conversion costs: diagnostic byte-slice inputs

`input-runs/` uses diagnostic source **1f13bf25e97d6f6c041cc93d536bd287f3ced264**.
The existing internal engine already reads byte slices. The experimental generic
public signature merely exposes that path alongside existing Block tuples for
measurement; **the private-bound trait is not a proposed production API design**.
No extra public function is proposed here.

Both aligned and deliberately +1-byte-shifted views have identical payloads in
initialized storage. This isolates alignment; it is not a claim that ordinary
malloc always returns alignment-one addresses. All BLAKE3 alternatives include
constructing descriptor lists; SHA reads the original byte views. `copy_reused`
reuses aligned payload allocations; `copy_allocated` includes aligned allocation,
initialization, copying and freeing. Source creation itself is outside every
interval. All final answers are checked against independent references.

9700X, 1,024 items, ns/item:

| Shape | Direct shifted bytes | Copy into reused Blocks | Allocate+copy Blocks | SHA-256 |
|---|---:|---:|---:|---:|
| 64 bytes | 13.50 | 14.99 | 47.35 | 55.30 |
| 1 KiB | 84.74 | 99.44 | 229.54 | 413.98 |
| Mixed 100–1,000 | 73.75 | 78.54 | 116.65 | 230.84 |

Direct shifted mixed input is about 7% slower than already-aligned Blocks on the
9700X, but cheaper than converting it. Zen 3 mixed: 158.27 / 181.40 / 251.51 /
322.56 ns/item for the same columns. This motivates an API discussion, not a
silent change to #259's Block-based public signature.

— Sam Shackleton
