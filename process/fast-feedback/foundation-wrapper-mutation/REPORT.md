# Expanded #295 Rust-wrapper mutation gate

**Owner priority: the remaining foundation quality hold, before further optimization stages.** John’s single integration source is **`f16ee3829554fd66ef47c5b60e516c6be9d86a44`**, organization branch`integrate/output16-ready`, metadata-only child of the reviewed d4 integration. Sam’s checked test/registry child is **`18027259606908888318f196df644059e2c6268e`**, personal branch`test/sam-output16-wrapper-coverage`. No second port or mutation-tool redesign; no organization merge/release/tag/upload.

Sam missed the owner’s06:13request until the broader review refresh. The07:37priority reminder was acknowledged when seen; this gate then became the next work, with optimization experiments frozen/unpromoted. That delay is not measurement productivity or an external wait.

## Exact scope and tool identity

Both changed-line runs compare against **`7ee5c1f8cfad7937fb490e6510f8f36fe5ce912f`**. The x86 registry now includes `src/ffi_output.rs`; its dedicated list has **41 wrapper places**, and the complete change plans **49 mutants on the existing default6shards**. No whole-run substitution, empty plan, manual exclusion or test serialization/worker cap was used to get green.

Official cargo-mutants **27.1.0**, matching `tools/runner/setup-mac.sh`, is built from pinned release source **`8ab1dc786a1f61a4e370416cc6c68b81a704e917`**. Its binary SHA-256 is`a1eeecb626981d2c696722190efdf946928040e9ae856cb662b695b5833a5a7b`, BLAKE3`f6b623241e425b1c925b7e96887ac89e7a2985e517f867ddd28f3e4f67a7bc02`. Official b3sum1.8.7 is installed at the existing checker’s own expected location. Fresh pinned source/targets, privateTMPDIR, outer physical-Ice lock before preparation through verification; no local i7 compute.

## Original red gate retained

Exact f16 gate `foundation-expanded-mutation-ice-20261108T083217-f2cf9605` is **FAILED**, exit1. Its six unmutated baselines pass. The run confirms alone the survivor names whose counts differ:

- `src/each.rs`: **`&&`→`||` in finalize_each**, one live selector/work guard.
- `src/ffi_output.rs`: **`|`→`^` in input**, two equivalent places.
- `src/ffi_output.rs`: **`|`→`^` in self_test_shape**, one equivalent place.

No timeout is substituted for a catch. The checker took170s against its60s changed-line budget; confirmation/release-same work is retained. The assembly theorem does not cover these Rust conditions.

Two earlier setup records stay FAILED and supply no mutation verdict: Ice had no cargo-mutants command; then the tool was installed but PATH had no b3sum. The final driver source-pins the official tool and reuses check.py’s official-b3sum location. Neither setup failure is called a library fault or a successful gate.

## Focused live-survivor test

On AVX-512, replacing the selector’s AND with OR enters group dispatch even below16indices, while the fallback still preserves digests. Entry-only/digest tests therefore missed that work. On a CPU without AVX-512, the same mutant can incorrectly select the ISA for a large group.

The child uses the **existing test-only Counted mechanism** to count one output-group dispatch turn. The new test checks0/1/2/15/16/17/31/32/33indices, canonical digests and reset, independently expecting a turn only for a full group on the detected AVX-512 platform. The counter call is explicitly `cfg(test)`; TLS storage is already test-only. There is no new API, platform override, hint, runtime predicate or policy.

The planted AND→OR mutant now fails the new test at:

```
full output group dispatch n=0
```

The raw outcome is `CaughtMutant`, with `each::test::finalize_each_groups_only_full_output_lanes` named in its log. Other concurrently ended tests are not claimed as independent catches.

## Genuine equivalents, not waived live behavior

The registry explains the two input places: mode flags0/16/32/64, CHUNK_START1 and CHUNK_END2 occupy disjoint bits, so OR and XOR agree. The startup fixture’s structural flags3/2/4 likewise do not overlap its mode flags0/16/32/64. These are explicit bit-invariant equivalences, not generic “speed” or “otherISA” excuses. Tests cannot distinguish mathematically equal results.

Only `tools/mutants/known-x86_64.txt` gains those reasons; John’s ARM-only selector classifications remain intact. The runtime wrapper/assembly/proof implementation is unchanged; the source additions are the existing-mechanism test observation/test and registry explanations. No production behavior was changed to rescue a missing test.

## Green child gate and handoff

Exact child run **`foundation-wrapper-coverage-ice-20261108T084543-6ac057d4` VERIFIED**:

-49planned changed-line mutants on6default shards;
-225tests in each full unmutated baseline;
-live selector mutant caught by the new test;
-only the explained disjoint-bit survivors remain; unviable compiler mutants are not called catches;
-**no new survivor or timeout**;
-61s checker time, **over the60s budget by1s**, reported rather than rounded to a pass of the timing budget.

The mutation gate’s correctness verdict is green; its timing budget is a separate reported cost. The only final untracked output is the checker’s`tmp/`; tracked input diff is empty after the gate. Proof/generator inputs and production algorithm are unchanged, so no new speed or assembled-proof result is invented here; the owner’s reviewed d4/f16 runtime gates remain their own evidence.

John can review/fast-forward the exact18027259child on his one foundation integration line. `Counted::OutputGroupTurn` uses slot4 on this foundation; the downstream #281 held-partition counter also used4 in its frozen source, so that later integration must assign distinct slots/adjust the test-only array. The compiler will reject duplicate enum discriminants; no earlier source’s data is relabelled after that integration.

`foundation-mutation-runs/` retains the original red run, setup failures, complete wrapper plans, logs, outcome JSON/diffs, exact tools and both manifests. No compiled binaries/private operator data or files>=20MB are published. John still owns integration; this is a quality-gate handoff, not a release or performance acceptance.

— Sam Shackleton
