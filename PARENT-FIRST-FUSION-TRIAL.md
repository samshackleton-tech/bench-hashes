# Full-round first-parent fusion: bounded benchmark prototype

This follows the #118 stage and layout studies. The provisional kernel keeps 32 complete chunks’ CVs in registers, pairs adjacent children, and computes sixteen non-root parent CVs. It reuses the current leaf prefix and parent-round emission logic. Production BLAKE3-Servil remains unchanged at **8d6525c3a4a6e2c6ffd135b21c0c7c25f6097066**.

## What the prototype tests

The native leaf prefix retains the common key pointer. After its sixteenth block and feed-forward, the verified even/odd compaction prepares sixteen parent messages in registers. A full seven-round parent compression follows, at counter zero with PARENT and the common mode flags. The caller performs later levels and the final ROOT compression.

The benchmark compares **complete modeled trees** using either the original leaf/parent calls with copies or this fused first level with the same remaining parent/copy sequence. The actual public `throughput::hash` remains a separate measurement. Its wrapper/recursion/layout differences are part of that separate comparison.

Sizes: 16/32/64 chunks. The 16-chunk case deliberately uses the original pipeline as a control. Four independent builds reverse stage order on alternate layouts; each binary runs twice for A/A checks. Shared clocks: 3% margin / 5% FDR. Clocks/analysis source **415e7df398d42d6cc34b965a4c033a02798a9dd6**.

## Measured result against the controlled copying pipeline

Ratios are fused modeled tree / original modeled tree:

| Host / message size | Wall | Process CPU | Package energy | Verdict |
|---|---:|---:|---:|---|
| 9700X / 16 KiB control | 1.000 | 1.000 | 0.991 | Level |
| 9700X / 32 KiB | 0.989 | 0.989 | 0.984 | Level |
| 9700X / 64 KiB | 0.993 | 0.993 | 1.003 | Level |
| EPYC 9255 / 16 KiB control | 1.000 | 1.000 | 0.996 | Level |
| EPYC 9255 / 32 KiB | 0.991 | 0.991 | 0.990 | Level |
| EPYC 9255 / 64 KiB | 0.991 | 0.991 | 0.989 | Level |

Cycles and instructions are also Level. At 32 KiB, retired instructions decrease **36,808 → 36,298**. Each host’s fifteen A/A metric cells are Level.

Against the actual public call, the modeled fused pipeline is ~3.1–3.3% faster at 32 KiB. The earlier scratch-swap model also showed ~3.1–3.2% there. The controlled copy/fusion comparison above is therefore the useful estimate of the new fusion’s contribution: **about 0.7–1.1% wall time in this cohort**, with no practical-margin time/CPU/energy verdict established.

Package energy is whole-package RAPL, including background/idle costs. Raw per-layout figures and all neighboring/control rows are retained.

## Native correctness

- Every fused parent CV is independently checked in **plain, keyed and derived-key material modes**, at four initial chunk counters: 0, 32, 2^32 and 2^54−64.
- A 512-byte output canary checks the sixteen-CV extent.
- Both complete modeled trees match official BLAKE3 final digests at 16/32/64 KiB.
- Existing per-level reference checks and the corrupted-leaf positive control remain.
- All hashing stages perform every standard compression round. The earlier layout-only probe remains a separate control.

Native buffers/pointer strides and single-caller ownership are logged. The leaf’s 2368-byte frame is reused for the parent permutation scratch. This stays in the benchmark harness; production bindings, startup coverage and kernel proofs remain work for any integration proposal.

## Decision

This one bounded prototype confirmed that first-level formatting plus call/setup reuse gives a modest gain, consistent with the small layout bridge measured earlier. It has not earned a production compression entry, tree dispatch and verification cases from these results. I am retaining it as evidence and asking John whether a deeper fold has enough benefit to justify another bounded design.

A later integration experiment could also measure the existing tree wrapper work it replaces. That would be a new library comparison, with the current modeled results kept under their own identities.

## Reproduction

Raw: `parent-fused-runs/`.
- `parent-fused-model-9700x-20261106T162739-bfb031e9`
- `parent-fused-model-epyc9255-20261106T162739-b67ff306`

Both VERIFIED. Sources, generator and manifests: `scripts/parent-fold/gen_fused.py`, `fused_helpers.rs`, `fused-stages.rs`, `fused-stages.sh`, and `fused-stages-{9700x,epyc9255}.json`. Generated `fused.S` is preserved in each run. The generator reads the pinned production source and requires exact unique anchors for each change.

— Sam Shackleton
