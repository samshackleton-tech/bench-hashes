# Shared reference substitution: measured result

Sam Shackleton, November9,2026. BLAKE3-Servil's existing Lean specification, serialized reference, symbolic assembly models and proof contracts remain the architecture. This tooling change shares one traversal while instantiating the reference compression's16outputs. It introduces no kernel, instruction-model or theorem-statement change.

## Result

The reference-operation workload becomes substantially cheaper; the useful complete proof cases remain **Level under the3% practical margin/5%FDR rule**. A larger whole-proof generation speedup is still open.

|Measured proof-thread work|Old mean|New mean|Wall verdict|Cycles/instructions verdict|
|---|---:|---:|---|---|
|64complete compression-reference calls|94.674ms|31.469ms|Faster,−66.8%|Faster/Faster|
|AVX512compress proof|60.813ms|59.795ms|Level,−1.7%|Level/Level|
|AVX512hash_many,16inputs×16blocks|11.5963s|11.3212s|Level,−2.4%|Level/Level|

The full chunk case proves all legal entry-stack alignments and reports15,236modeled instructions. This is one useful case, not the whole kernel-proof suite. Exact raw judgments carry the CPU-time figures as well: all four reference-operation metrics areFaster; all four metrics in each complete proof case areLevel. Level is not equality. No cross-baseline ratio composition.

## Sources and semantic checks

Baseline69d9256b2ef3e0f14d0477bc0221c9498ae6cd6e. Candidate58aa5767ff6184bf430ef3e020b4846eb148a5dc, personal`verify/sam-compression-substitution`.

- Test-first0c8360524fdd45f31a66e162472e419e34d5cac5 requires exactly16equal output ASTs under simultaneous cross-bindings and one substitution traversal. The old16-traversal implementation fails that intended control.
- d188e700c41c9c6a32811a97e0cfcb2a23398e92 substitutes a16-child carrier once, then returns its children. The carrier never enters a proof comparison.
-58aa5767 repairs a separate mocked-curlGET fixture that consumed the outer shell's stdin. The original failed quality item is retained; the repaired fixture has a GET-input sentinel.
- Candidate quality:43helper/exact-AST tests, rejecting reversed-output/lost-counter controls with restores, output8/output16proofs and eight kernel-fault controls pass. Kernel/model/contracts/comparison code is unchanged. These checks establish the declared substitution boundary; they do not establish Rust dispatch/ownership or whole-library constant time.

`COUNTER-RESOURCE-AUDIT.json` includes both SHA256 and BLAKE3 of each executed reference-source file, independently checked against the pinned Git objects. Each measured process verifies that it loaded the intended private source. All microbenchmark final-answer fingerprints agree across paired sides; the exact-AST unit tests supply the broader semantic witness.

## Executing protocol and controls

`substitution-costs.sh` calls the existing bench-hashes`clocks` crate from a thin RustCDLL callback on the Python proof thread: wall/CPU time and P/Ecore cycles/instructions. The direct`clocks::child`launcher records complete driver-process wall/CPU/RSS/load. Four fresh private source/bytecode/native-adapter pairs, adjacent alternating sides, unchanged frozen Rust judge. A planted failed callback must propagate through the child; it does.

- AA`formal-substitution-costs-aa-20261109T100320-9b1929c0`:VERIFIED,12Level judgments.
- AB`formal-substitution-costs-ab-20261109T101948-5a7354f6`:VERIFIED,4Faster reference-operation judgments and8Level complete-proof judgments.
-48rawJSON/TSV/counter/load/resource records independently checked; consumed P/Ecounts match TSVtotals, source identities match, direct child succeeds and quiet logs complete. No Ecore counts on this EPYC run.

Imports, assembly/disassembly preparation and input-source copies occur outside the proof callback counters. The64-reference workload includes construction of concrete input terms, reference instantiation and retained results; its final answer is simplified/fingerprinted after counters. PeakRSS includes preparation and teardown. Finish/energy is not measured here.

The separate driver-process resource means are diagnostic totals, **not separately judged**: the chunk process is30.8893→30.5432s, with peakRSS988.80–988.84MBold/988.56–988.91MBnew. The proof region is the11.60→11.32s interval above; do not call it the whole process. Direct-Python teardown and the production multiprocessing worker lifecycle differ, so those process totals are not production pool-throughput evidence. No memory-saving claim follows from these small peak variations.

## Retired-instruction attribution

A subsequent bounded diagnostic, `formal-proof-instruction-profile2-epyc-20261109T130317-985d333d`, isVERIFIED on the same58aa5767source/full chunk proof. It reuses the clocks callback/child and enables `perf` sampling only around that proof, one sample per100million retired user instructions.1,485samples, zero lost. Leaf attribution:1,036samples in CPython3.14,157inlibz3,165in_ctypes/libffi and117inlibc. `_PyEval_EvalFrameDefault` alone has346samples. These are **instruction-sample counts, not elapsed-time percentages**, from one diagnostic execution; its recorded clocks figures are not another speed comparison.

The first profile attempt failed at its controller's disable ACK. Linuxperf writes `sizeof("ack\\n")`, including a terminating NUL; the text reader left that NUL for the next response. V1/raw remain. One repair validates the exact five bytes, with positive/reject-short preflight controls; both actual ACKs are recorded. Binary profile data stays local; complete text stacks/report are included.

This narrows the next bounded speed investigation toward repeated Python/ctypes API and wrapper work, before another solver, cache or worker policy. Preserve API/error checks and existing fault controls while eliminating redundant boundary work. The profile does not yet identify which Python function earns a change.

## Remaining work

The next speed question is which repeated Python-side operation can be removed while preserving the reference/model boundary. Independent theorem/definition binding and a second kernel remain a separate bounded pilot: compatible tool sources were inspected, but no checker was installed or executed in this window. The library's Lean4.34.1 pin remains unchanged. No new proof framework or incidental toolchain upgrade was adopted.

The overnight runtime-integration diagnosis took priority under John's plan. Exact failures, controls, executing drivers and raw costs are retained so a reviewer can reproduce the result and choose the next bottleneck study.
