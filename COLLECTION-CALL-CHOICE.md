# Diagnostic: a loop of existing single-message calls versus hash_each

This study compares two existing public call patterns, with the library unchanged. It asks whether a count below the SIMD width justifies routing a small collection through serial calls. Longer uniform inputs rule out that count-only shortcut.

Source is current `servil` after the isolated ARM collection merge: **d458cf21a3794cba2c3ca20e7ad8f8e5880ca7f6**, using its **`throughput` API**. This is neither frozen #259 (`1fb068fe`) nor an integration measurement of its x86 finishing kernels. #252’s newer GPR policy remained open when these samples were taken.

## Comparison

- `throughput::hash_each(Mode::Plain, items, out)`.
- A caller loop of `throughput::hash(Mode::Plain, blocks, len)`, copying each canonical digest to the same output array.
- Ordinary `sha2` 0.11.0 alongside them as context, not the experiment’s main comparison.

Both B3 choices use the same ready, aligned, byte-identical inputs and retained output storage. Input allocation, descriptor construction and initialization are outside the interval. All per-call wrapper, dispatch and output work is inside. B3 outputs are checked against official `blake3` 1.8.7. The timings compare whole public API paths. Attribution to an internal metadata operation, cache or alias effect would need another control.

Warm, repeated throughput calls cover 48 cells. Eight counts (1/2/4/7/8/16/64/1024) pair with six shapes: 0/1/64/256/1024 B and mixed 100–1000 B. Four independent builds/layouts, alternating algorithm order, repeated process controls, shared clocks at 3% margin / 5% FDR. Wall, process CPU, cycles/instructions and whole-package RAPL are recorded separately. This single-threaded study has no worker-sharing or per-thread-counter attribution claim.

## Count alone cannot choose the better path

**Caller-loop / hash_each wall time**, across all 48 cells:

| CPU | Loop faster | Level | Loop slower |
|---|---:|---:|---:|
| 9700X | 23 | 5 | 20 |
| EPYC 9255 | 23 | 5 | 20 |
| Ice Lake | 27 | 2 | 19 |
| Zen 3 | 27 | 2 | 19 |

At **two messages**, the loop helps one-block inputs but loses longer uniform inputs on all four hosts:

| CPU | 64 B loop/each | 256 B loop/each | 1 KiB loop/each |
|---|---:|---:|---:|
| 9700X | 0.484 | 1.179 | 1.714 |
| EPYC 9255 | 0.488 | 1.187 | 1.720 |
| Ice Lake | 0.502 | 1.060 | 1.645 |
| Zen 3 | 0.460 | 1.033 | 1.636 |

At four 1 KiB messages, the loop costs **2.66–3.06× hash_each time**. At 1,024 messages it costs **3.82–7.00×** on that shape. For mixed inputs, two serial calls are faster on every host. At four, the loop is slower on the Zen 5 hosts and Level on Ice Lake and Zen 3. At seven it is slower on all four. The raw judgments record CPU, instructions and energy separately from this wall table.

A proposed “all short collections below eight items go serial” shortcut would therefore sacrifice intended-pattern cells. **It was not added.** One-block cases remain opportunities, but the frozen x86 finishing candidate must be considered separately before choosing another special case. This does not reopen the retired proposal to remove `hash_each`.

## Provenance and scope

All four native requests VERIFIED. The caller-loop A/A controls are **240 metric cells, all Level on every host**. Clocks/analysis commit: **235ee5eb701ce64845b705d2b7cb0240d68eb9e7**. The existing judge source comes from immutable evidence snapshot **ef08b6c5a6fdc508dc309ca6de2bc3c6b4cb9561**.

Raw records: `collection-choice-runs/`. Script/source/manifests: `scripts/collection-choice-*`. Cold, byte-conversion, keyed-mode and multithreaded performance remain outside this study’s scope. #259 and #262 remain unchanged.

— Sam Shackleton
