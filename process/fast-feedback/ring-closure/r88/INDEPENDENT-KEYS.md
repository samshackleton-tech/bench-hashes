# Independent-key parent lanes: preserve plain and shared-key performance

## Decision and scope

On November 8 the user selected independent-key lanes (#312 option 3): retain key-independent grouping and dispatch, with plain mode the first performance priority and same-key/many-message workloads second. Distinct-key gains do not offset regressions in those priorities. The user accepts the implementation complexity needed for those benefits, not an unmeasured performance cost or a weaker security contract.

For x86, the held-stage stack already supplies the required parent kernels. This experiment reuses them: no new assembly, generator, ABI, Hasher field, allocation representation or public API. Whole chunks already fill their lanes with one message's key; only the parent batches need independent keys.

**Personal candidate:** `cd2880f1d2f1a3d1d155877ce105b487ac6966b0`, branch `candidate/sam-held-independent-keys`, worktree `~/work/b3-held-independent`.

**Direct baseline:** `b817ac85c985582ed600208e02a380ece730c4a2` (the held-stage stack with parent-eight and scratch-vector deletion). This is not current organization next, main, or the iterative #312 safety fix. Its measurements must not be composed with the previous #312 ratios. Integration and release remain John's decisions.

## Implementation

- A wholly plain turn uses the existing shared-IV kernel body: public mode fixes the key to the IV.
- All other AVX2/AVX-512 held turns use `ffi_output::held_groups`: each message supplies its own key and flags to the existing output8/output16 parent-compression descriptors.
- SSE4.1, NEON and SME2 retain the reviewed public-mode remedy: one plain cohort, then one cohort per keyed/derive-key hasher, iteratively. Their independent-key optimization remains open; ARM VM tests are correctness coverage, not native speed evidence.
- No key comparison selects a cohort, allocation, loop count or kernel. This removes the identified secret-key-dependent dispatch, not a claim that a test suite proves every library operation constant-time.

## Correctness and rejecting controls

For `cd2880f1`, pinned native jobs:

- Ice `independent-plain-quality-ice-20261108T225838-0ba7d656`: **230 release tests, 21 docs**, fmt, no-default build and warnings-denied rustdoc pass. Changed-line mutation gate: **6 mutants, no new survivor, 38 s within 60 s**.
- ARM VM `independent-plain-quality-arm-20261108T225839-23553bc7`: **202 release tests, 21 docs**, the same build checks and rejecting control pass.

Tests cover plain/shared/distinct/mixed modes, widths 2/7/8/9/15/16/17/31/32/33, counter-zero and later stages, canonical digests, continued updates and XOF. Kernel-entry checks are captured before finalization. Large 600-hasher turns check that same-key and distinct-key values take identical pass counts; plain takes one pass. Every enumerated platform runs those controls.

The driver restores only the baseline held-stage runtime while keeping the new tests. The old route fails the independent-parent-entry check for a shared-key x86 turn and the key-independent-pass check on SSE4.1/NEON. The source is restored byte-for-byte, then the focused positive controls pass. No invalid memory or corrupted tasks are exercised.

Assembly/generator/proof inputs are unchanged from the existing held-stage line. Assembly proofs were not rerun: they would prove identical kernels, not the changed Rust selection. The Rust controls and full suites test selection separately.

## Complete-work measurements

Exact `cd2880f1` versus `b817ac85`, bench/clocks `9994de190259648ede82f7c5e4dbac4f1534a41d`, unchanged `mixed-stage-costs.sh`. Each host has four fresh private build/layout pairs with adjacent alternating sides, 3% practical margin / 5% FDR. Hosts were locked and separate from correctness work.

The 64 shapes cover 16/32 KiB messages, four/eight 4 KiB arrivals, 2/8/16/17/24/128/512 active hashers, and sparse 7/8/15/16 active among 1024 open hashers. Inputs, keys and caller capacity construction are outside counters. Complete cycles include descriptor refill, library allocations, updates, digest production and reset. Finish consumes each prepared state once; finish energy is NA. RAPL includes package background energy.

| Complete-cycle wall | Ice | EPYC |
|---|---|---|
| Plain (18 shapes, including sparse) | 18 Level, ratios 0.990–1.003 | 18 Level, 0.990–1.010 |
| One shared key (14) | 14 Level, 0.997–1.011 | 14 Level, 0.991–1.024 |
| Distinct keys (14) | 14 Level, 0.992–1.001 | 14 Level, 0.987–1.001 |
| Mixed modes (18) | 18 Level, 0.989–1.003 | 18 Level, 0.988–1.003 |

Across all metrics: **320 cycle, 320 update and 256 finish judgments are Level on each host**. These are scoped four-pair comparisons, not exact cost equality, a canonical 272-point gate, A/A evidence, native AVX2 speed, or acceptance of historical costs. See `independent-plain-costs-summary.tsv` and raw judgments.

Runs:
- `independent-plain-costs-ice-20261108T225841-cc56bb72`
- `independent-plain-costs-epyc-20261108T225842-e5565d65`

## Retained first attempt and failure

- `9a42bcde61feff3371a5a54bb3f8327550989cd8`: test-only commit.
- `a6aa7b4ed605168a191e8da2cea4619f92c28c50`: all modes, including wholly plain turns, use independent-key parent lanes.
- `FAILED-independent-quality-ice-20261108T225144-c2d73e47`: E0425, stale test message variable `mixed` after conversion to `flavor`. This is a real compile failure, not a passing quality gate.
- `2f92a4bfff421e5f69446664ea1e7da07701a964`: test-message correction only. Ice 230 tests/21 docs and 5 mutants/no new survivor/45 s pass. Original a6 ARM 202 tests/21 docs pass; the bad message was x86-cfg-only.
- Original a6 complete-cycle measurements against b817: Ice all 896 judgments Level. EPYC one sparse plain wall cell **+4.3% Slower** (7 active among 1024); update **+4.4%**, four Slower judgments per phase across metrics. Shared-key wall 14 Level on each. The original failure and cost remain source-specific; the revised candidate's green comparison does not erase them.
- `cd2880f1`: retains the existing plain-mode/shared-IV route using public mode. Its direct comparison above has no Slower judgment. This controlled revision changes the route; timing alone does not establish a cache, layout or instruction-level cause for the first attempt's cost.

## Remaining gates and ownership

John has the decision and candidate in #312. Devon is asked for physical i7/AVX2 complete-cycle coverage, especially plain and shared-key controls. John owns the NEON/SME2 independent-key design and integration with #298. Native ARM throughput, current-next/main composition, broader startup/small-message controls and integration gates are not claimed complete here. No merge, release, advisory, hardware change or multithreading tuning was performed.
