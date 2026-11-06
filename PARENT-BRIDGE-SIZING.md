# CV layout bridge: 58–60 cycles through memory, 24–25 through registers

This benchmark-only data-layout control sizes the first-parent fusion idea from #118. Source emitters: **8d6525c3a4a6e2c6ffd135b21c0c7c25f6097066**. Clocks: **415e7df398d42d6cc34b965a4c033a02798a9dd6**. Production library code is unchanged.

## The two layouts

The input is 32 chaining values (CVs), held as the wide leaf kernel holds them: two groups of sixteen lanes, one word per vector. The desired output is sixteen parent-message vectors, pairing child 0/1, 2/3, …, 30/31.

- **Round trip:** reuse the current generator’s `output_group` and `transpose` emitters. Write 32 canonical CVs, reload them through sixteen parent pointers, and transpose them into parent-message vectors.
- **Direct:** compact even and odd lanes within each group, join the low eight words of each group, and retain the resulting parent-message vectors. This uses `vpermd` and `vshufi32x4` with the low-half concatenation immediate 0x44.

Both controls load the same sixteen input vectors and store the same sixteen output vectors. Those common boundary operations make the controls observable; a fused compression kernel would consume the vectors directly. The measured difference isolates this particular layout sequence, rather than a whole hashing implementation.

## Measured per 32-CV bridge

Four independent builds/layouts, alternating order, shared clocks 3% margin / 5% FDR. Both native requests VERIFIED.

| Host | Round trip | Direct | Direct/round-trip wall | Instructions |
|---|---|---|---:|---|
| 9700X | 10.952 ns, 57.684 cycles | 4.703 ns, 24.568 cycles | 0.430, Faster | 228 → 104 |
| EPYC 9255 | 13.760 ns, 59.520 cycles | 5.599 ns, 24.233 cycles | 0.407, Faster | 228 → 104 |

Process CPU follows wall in these calls. Whole-package energy ratios are 0.412 and 0.398. These are data-layout-control results. [The complete current 32 KiB public hash](PARENT-FOLD-SIZING.md) takes about **10,600 cycles**: the measured bridge savings are **33–35 cycles** per 32 chunks. That gives first-level-only fusion a small budget before considering call/setup savings and added code.

The self-comparison controls are all Level on both hosts. All per-layout wall/CPU/cycle/instruction/package figures are retained. The complete compression stages remain separately measured with every standard round.

## Native correctness and ownership

Sixteen arbitrary-word fixtures are checked against an independently indexed adjacent-child reference. A separate wrong-odd-child control must disagree with that reference. Both correct layouts pass and the planted control moves the result on both CPUs.

Native logs record 1024-byte, 64-byte-aligned input/output/scratch buffers, word stride 4 and pointer stride 8. A single caller owns the writable output and scratch; input and pointer table are immutable. The current emitters are reused through a strict AST extraction of exactly their three helper functions and WORD map from the pinned source.

## Reproduction

Raw records: `parent-bridge-runs/`.
- `parent-bridge-9700x-20261106T160710-fecad3e1`
- `parent-bridge-epyc9255-20261106T160711-83f50044`

Sources/scripts/manifests under `scripts/parent-fold/`: `gen_bridge.py`, `bridge.rs`, `bridge.sh`, and `bridge-{9700x,epyc9255}.json`. The generated `bridge.S` is preserved with each record. No production compression kernel or public API was added for this study.

Next decision: weigh a minimal first-parent fusion against this measured saving, or size a deeper fold with John before introducing a new kernel/proof contract.

— Sam Shackleton
