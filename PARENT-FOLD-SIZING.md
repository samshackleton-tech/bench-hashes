# Parent-folding cost study: current Zen 5 tree stages

Source: current `servil` **8d6525c3a4a6e2c6ffd135b21c0c7c25f6097066**. Clocks/analysis: bench-hashes **415e7df398d42d6cc34b965a4c033a02798a9dd6**. This is component sizing for #118, separate from frozen #259 and batch #262. Production library code is unchanged.

## What is measured

A single caller on CPU 2 hashes complete messages of **16/32/64 chunks** (16/32/64 KiB), repeatedly with code and data warmed. Four independent builds/layouts reverse stage order on alternate layouts. Each binary runs twice as an A/A control. All native requests VERIFIED.

The harness calls the current full-round assembly entries through their existing internal ABI:
- Leaf CVs: ordinary 16-input AVX-512 for 16 chunks, interleaved k32 for groups of 32.
- First parent levels with 16 or more parents: current p16 entries.
- Smaller parent levels: current ordinary AVX-512 hash-many entry.
- Final root: current AVX-512 compress-XOF, with PARENT|ROOT.

Component pointer tables are ready outside timing. Two **modeled complete pipelines** build parent pointer tables and either copy parent outputs back between levels or swap the scratch-buffer roles. The **actual public `throughput::hash`** is measured separately. Comparisons of the model and public call include their wrapper/layout differences; the model's advantage is not a production speedup claim.

`copy_cvs_only` and `barrier` are explicit data-motion/harness controls. Every hashing stage performs all standard compression rounds. The represented message size is the TSV `bytes` column; a parent component reads only its corresponding CV layer.

## First result: swapping scratch buffers has little leverage

Paired modeled swap/copy wall ratios:

| Message | 9700X | EPYC 9255 |
|---|---:|---:|
| 16 KiB | 0.992, Level | 0.991, Level |
| 32 KiB | 0.993, Level | 0.984, Level |
| 64 KiB | 0.995, Level | 0.993, Level |

All wall comparisons are Level at the shared clocks 3% margin / 5% FDR. The instruction reduction is small as well (106 instructions per 32-chunk modeled tree). Copy removal alone has not earned a production change from these measurements.

The modeled swap pipeline is about 3.1–3.2% faster than the public call at 32 KiB, with similar CPU/cycle results. That comparison includes more than copying: it is a diagnostic of the harness/model and wrapper work, not a measured library patch.

## Measured cycles per 32-chunk group

Ranges are the four independent process means, rounded here for readability. These components were timed independently; their sum is an estimate, not a directly measured fused result.

| Component | 9700X cycles/group | EPYC 9255 cycles/group |
|---|---:|---:|
| Leaves: 32 × 1 KiB → 32 CVs | 8312–8337 | 8299–8413 |
| Parents: 32 CVs → 16 | 413–417 | 412–413 |
| Parents: 16 → 8 | 398–425 | 398–399 |
| Parents: 8 → 4 | 301–304 | 301 |
| Parents: 4 → 2 | 285 | 285 |
| Final root | 259 | 259 |
| Copy 32 CVs only | 42–43 | 31–46 |
| Harness barrier | 9 | 9 |
| Modeled complete pipeline, copying | 10345–10437 | 10342–10423 |
| Actual public `throughput::hash` | 10615–10702 | 10622–10655 |

Parent compression remains required. A fusion targets the output/input formatting, transfers and setup surrounding it. The first parent stage is only about 4% of the whole call, so treating its whole cost as removable would overstate the opportunity. Leaf output formatting is another part to investigate.

Wall, process CPU, cycles, instructions and package energy are retained separately for every stage. RAPL measures whole-package energy, including background/idle costs. Both hosts' fifteen modeled-pipeline A/A metric cells are Level.

## Correctness and native layout

Each leaf CV is checked against official blake3 1.8.7's `hazmat::HasherExt::finalize_non_root` at the correct input offset. Every parent CV is checked against `merge_subtrees_non_root`; final roots match both `merge_subtrees_root` and official `blake3::hash`. Both complete pipeline variants are reference-checked. A corrupted-leaf positive control must move the final result.

The source uses disjoint Block-backed input/output storage. Native logs record addresses, sizes and alignments: Block is 64 bytes/alignment 64, logical CV stride 32 bytes/type alignment 1. Each run records parent snapshots and pointer-table addresses/stride. One calling thread owns all writable buffers; worker-output/counter sharing is outside this study.

## Artifacts and next decision

Raw records: `parent-fold-runs/`.
- `parent-stages-9700x-20261106T154909-68190fba`
- `parent-stages-epyc9255-20261106T154911-326e652e`

Sources/scripts/manifests: `scripts/parent-fold/`.

Next: agree a tree-only fusion contract with John. A promising reuse point is `tree::Kernels::subtree`: replacing an eligible 64-chunk subtree's existing two k32 calls plus first parent level with two fused 32-chunk→16-parent calls would return the same 32-CV cut at the same height. This keeps independent-message batching and ROOT handling at their existing callers. The register rearrangement and proof obligations should be sized before adding that kernel.

— Sam Shackleton
