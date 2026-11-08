# Retired parallel port — source 1d74d686

**Historical, not the integration candidate.** This independently prepared port was retired after locating John's existing integration branch. Current work is authoritative in [REPORT.md](REPORT.md), on a child of his branch. All numbers below remain attached only to `1d74d68667dce503e89c2399acdb20f630810871`.

**Not landed.** This ports the independently reviewed [#269](https://github.com/servil-software-factory/BLAKE3/pull/269) foundation onto the settled API. The original measured head stays frozen. No multithreading threshold, worker policy or pool size changes.

## Complete-work result

A cycle feeds each message in 17-byte pieces, finishes the selected states through `throughput::finalize_each`, and resets them for the next message. Updates, canonical digests and resets are timed. State construction and key/context preparation are outside the repeated cycles.

At **1,024 states**, nanoseconds per message:

| Message | Ice Lake before → after | EPYC 9255 before → after |
|---|---:|---:|
| Plain 1 B | 181.9320 → **91.3025** | 74.7988 → **28.3213** |
| Plain 64 B | 290.0794 → **184.1003** | 106.5614 → **55.0533** |
| Plain 1 KiB | 3379.1497 → **3030.0434** | 1819.0626 → **1680.1557** |
| Mixed-mode varied lengths | 1755.8927 → **1552.2076** | 938.9855 → **843.6708** |

CPU time, cycles, instructions and whole-package energy also improve in these cells. For 1-byte messages, package energy per message changes from 19230.2493 to 9797.1499 nJ on Ice Lake, and 5451.7811 to 2143.7310 nJ on EPYC. RAPL includes the package's idle/background energy; these are complete-cycle package costs, not isolated compression energy.

These compare **current API code directly**, not a product of older incremental ratios. The 85 shape/count combinations include counts 2/16/17/64/1024, lengths 0–2048 B, varied lengths and independent plain/keyed/derived modes. Four fresh build/layout pairs alternate adjacent old/new order. Shared `clocks::summary` judges all metrics at a 3% practical margin and 5% FDR:

- Ice Lake: **425 Faster**, no Slower judgments.
- EPYC: **409 Faster / 16 Level**, no Slower judgments.
- Ice Lake same-head A/A: **425 Level**.

These are this complete-cycle study's results, not a claim that every library workload improves. Sub-width cases improve too. Static inspection shows different fallback inlining: the original `finalize_each` contains the final-node path, while the port calls an out-of-line `HasherCore::final_output`. Gains outside the SIMD selection are whole-port/codegen observations; they are not attributed to SIMD or cache effects alone.

## Costs retained

The change is **not a global Pareto improvement**: startup work increases. On Ice Lake, the first initialization changes from **75.034 to 79.287 µs**, +4.253 µs/+5.7% Slower; CPU +5.6%, cycles +7.3%, instructions +15.6%. John accepted the original approximately 5 µs one-time cost in [#268](https://github.com/servil-software-factory/BLAKE3/issues/268); that assigned issue remains open.

Already-initialized wall time is Faster (90.09→81.41 ns), CPU/instructions Level, but its measured cycle interval is **+3.2% Slower** (1256→1296 cycles). The interval includes the measurement bookkeeping; its exact cause is not established. This observation remains for explicit owner review, rather than claiming all initialized controls equal. A separate same-head startup A/A has all eight metric judgments Level and does not erase the observed difference. Startup uses four build/layout pairs and 32 process launches per side total, with first/already measurements per process.

## Implementation and contract

The existing full-round kernel compresses sixteen independent roots from borrowed 24-byte descriptors. CVs, lengths and flags can differ by lane. The fast selection remains first-chunk states with no staged suffix or stacked subtree, on Linux/std/AVX-512F+VL. Other states use existing finalization.

The port preserves the new consuming/reset contract. A completed group resets its selected states after descriptor borrows end. Repeated indices observe preceding resets and therefore use sequential finalization within that group. No Hasher field, public API or persistent state is added. Native Hasher size/stride is 18,432 B, alignment 64; one caller owns all states and outputs. The kernel, generator and proof are byte-identical to the frozen reviewed source.

## Exact identities and validation

| Role | Full commit |
|---|---|
| Current baseline | `597581e963b3b6a2eb3df96234339a99aec274cd` |
| Port candidate | `1d74d68667dce503e89c2399acdb20f630810871` |
| Frozen reviewed #269 | `f9fcef459d9999af05765a598c9fb72f704029ff` |
| Benchmark / clocks | `9994de190259648ede82f7c5e4dbac4f1534a41d` |

- Fresh preflight and Ice Lake target: **222 nextest tests, 21 doc examples**, no-default build and warnings-denied rustdoc pass. ARM: **197 tests / 21 examples**, same build/doc checks pass.
- Canonical AArch64 check reports **the same compiled benchmark code**. No ARM VM native-performance claim is made; under John's review terms this requires no redundant Mac timing gate.
- The positive reset/index test passes. Removing the fast reset or bypassing duplicate detection each fails its intended native assertion, not compilation.
- Current symbolic harness: positive **1210 steps**, four fault controls rejected. This proves the assembled root compressions/ABI/bounds, not the new Rust selector.
- Build/proof registration includes the new generator, its cache dependency and the dedicated proof command.

The wider x86 canonical gate **passed on this retired source**: `output16-supported-scoped-epyc-20261108T015220-6d75650e`, both stages (including all64 suspect pairs), no cell slower and no Level cell's instructions beyond+0.5%. This is not a gate for the current integration source. The first bounded Ice check timed out during fresh build/layout preparation. The first EPYC attempt stopped at calibration because `controlled idle turn 256` requires cpuidle controls that this host lacks (driver `none`, zero state-disable files). Both failures are retained. That completed standard check covers the eight applicable points, keeping its four-pair stage and automatic 64-pair suspect stage unchanged. The unavailable controlled-idle point is explicitly recorded, not silently treated as a pass.

## Records and reproduction

All jobs use pinned-run with full sources, instrument hashes, fresh private checkouts/targets and the host lock held before preparation through verification. `native-runs/`, `cycle-runs/`, `code-runs/`, `control-runs/`, `proof-runs/`, `startup-runs/` and `gate-runs/` retain identities, phases, logs and canonical review cards, including failed setup attempts. The matching shell instruments are alongside this report. Static-inspection text is in `inspection/`; compiled binaries are intentionally omitted.

Follow-up source for the first-chunk stack gets its own identity after this foundation's gates and owner review. Frozen candidates are not rewritten. John owns integration decisions; no merge, release, tag or crate upload was performed.

— Sam Shackleton
