# Released repair-branch costs and key-independent dispatch controls

User-approved follow-up, November 8, 23:16 UTC: measure the actual released-line repair candidate and add regression controls to ordinary library tests. No production optimization, merge, release, advisory, hardware change or worker tuning was performed.

## 1. Exact released-line candidate

**71154c1dc4661e7bfa30e89d8b434a9394f2feaa** (#318) directly against published main **6e0dffd37e04b01b80dc56eb833b00fc337b6873**. Benchmark/clocks **9994de190259648ede82f7c5e4dbac4f1534a41d**.

This is John's composition of constructor privacy, iterative public-mode held cohorts, checked capacity and corrected allocation tests. It does **not** include the independent-key held-stage optimization. Its costs cannot be inferred from next or the held-stage candidate.

### Method and retained driver failure

The original `mixed-stage-costs.sh` assumed the newer consuming/resetting `finalize_each`. Released main's `finalize_each` is an immutable read. Both first jobs built successfully, then failed the driver's reset expectation on the **old source**:
- `FAILED-main318-complete-costs-ice-20261108T231818-e7bd494a`
- `FAILED-main318-complete-costs-epyc-20261108T231819-f7a413ee`

These are retained instrument-contract failures, not library correctness failures. `main-complete-costs.sh` adapts only that API difference: a helper calls released finalize_each, then explicitly resets every selected hasher, **on both sources**. Digest production and that reset remain inside complete-cycle and finish counters; update resets remain timed, as before. Every prepared finish state is finalized once. Both driver versions are archived by SHA-256 with BLAKE3 beside it.

The successful jobs each use four fresh private build/layout pairs, adjacent alternating sides, existing clocks/summary, 3% practical margin / 5% FDR. Inputs, keys, caller capacities and Hasher construction are outside counters. Descriptor refill, library allocations, updates, digest and reset are included in complete cycles. Sixty-four shapes cover 16/32 KiB messages in 4 KiB arrivals, 2/8/16/17/24/128/512 active states, plus sparse 7/8/15/16 active among 1024. Finish consumes each prepared state once and has energy NA; RAPL includes background package energy. Locks cover preparation through verification; unrelated correctness work used a separate host.

Successful runs:
- `main318-explicit-reset-ice-20261108T232200-676446fe`
- `main318-explicit-reset-epyc-20261108T232202-66d81e40`

### Complete-cycle wall

| Workload | Ice | EPYC |
|---|---|---|
| Plain, 18 shapes | 18 Level; ratio 0.990–1.004 | 18 Level; 0.984–1.002 |
| One shared key, 14 | **13 Slower / 1 Level; +3.0% to +8.9%** | **14 Slower; +6.2% to +15.5%** |
| Distinct keys, 14 | 12 Faster / 2 Level; down to 0.780 | 10 Faster / 4 Level; down to 0.771 |
| Mixed modes, 18 | 2 Faster / 16 Level | 18 Level; highest mean ratio 1.033 |

Shared-key update-only wall: **14 Slower** each; Ice +3.4% to +9.0%, EPYC +6.7% to +17.0%. Finish has **256 Level judgments** on each host across metrics. See `main318-costs-summary.tsv` and complete per-metric judgments. Level is not equal cost.

**These are scoped four-pair cost comparisons, not a canonical broad regression gate.** Runner VERIFIED means instrument/provenance/output checks passed, not no regression or cost acceptance. The shared-key cost requires John's exact-source review; a prior next-source acceptance is not automatically this main-source acceptance. The user's independent-key performance target remains separate work, not a waiver of this cost.

Devon separately reports a canonical i7 plain-mode gate for this exact 71154c1d source against main (13 points, four pairs plus 64-pair suspects, no Slower). That is her evidence; it does not measure keyed grouping, is not a new Sam receipt, and was not independently fetched in this session. Release ring correction, native ARM acceptance and final shipping composition remain John's gates.

A local manifest-generation SyntaxError (unclosed list) occurred before any launch, was corrected, and produced no measurement. The later two remote driver failures are retained in full; the corrected driver succeeded on its single retry.

## 2. Security regression controls

[SECURITY-REVIEW.md](SECURITY-REVIEW.md) describes the actual tests, exact sources, rejecting controls, generated-code inspection and limitations. They live in the library's `src/each.rs` and `tests/allocations.rs`, not a new framework.

- Held-stage test branch: **5bb5e5bd92d9127f287970eeb2493669e763e5cd**, on cd2880f1. Ice **233 release / 21 docs**, ARM VM **205 / 21**, fmt/no-default/rustdoc, planted grouping/allocation faults and restored controls pass. A separate AVX-512 fault control proves the kernel-entry-set assertion rejects a change even when cohort membership and pass count stay equal.
- Main repair test branch: **4f9b6bb34fc0854f11c17ab218a11cba9eb1ca76**, on exact 71154c1d. Ice **187 release / 20 docs**, ARM VM **167 / 20**, fmt/no-default/rustdoc, planted grouping/allocation faults and restored controls pass. Runs `security-main-prefix-controls-ice-20261108T233815-7ee6cb19` and `security-main-prefix-controls-arm-20261108T233816-42f9454e`.

Production grouping remains unchanged in both test children. Main's safety repair can adopt the tests without waiting for independent-key optimization. They test observed work structure, not instruction-level constant time. Existing assembly proofs were not rerun for test-only changes. No production throughput benefit or whole-library security proof is claimed.
