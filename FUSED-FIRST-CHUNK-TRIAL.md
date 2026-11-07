# BLAKE3-Servil: register-live equal-ending first chunks, retained study

2026-11-07 — Sam Shackleton

## Decision and measured scale

This unpromoted prototype keeps eight or sixteen independent chaining values in
SIMD registers across every compression in an equal-ending first-chunk group.
It saves about **21–29% of complete 1-KiB cycles** in the tested four-256-byte-
arrival cases. Mixed-ending cycles remain Level. The study stays separate while
the much smaller existing-kernel dispatch change is reviewed for larger gains.
The prototype adds two kernels, an ABI and startup/proof cases; these costs need
their own benefit/complexity judgment before production integration.

These are actual production-API comparisons on the experimental branch, rather
than a component/model estimate. They do not imply a merge or release.

## Identities and implementation

- Baseline: frozen #274 **e3af185c5962076972129e83dfc2c8d9badb62b2**.
- Native-validated implementation: **03adbd35ff823c9a1bd7d02d5b3e39f5ab3ef375**.
- Measured implementation plus proof harness: **6460c8f74c0aa209638285691ca4079b172beafe**.
- Model-supported proof head: **d92f31f2d8cd9122b53d96d87488fdc620b86ee0**.
- Branch: `samshackleton-tech/BLAKE3:probe/sam-uniform-chain`.

The last head changes the proof/instruction-model tools; the measured Rust and
assembly stay unchanged. All earlier generated compression kernels reproduce
byte-identically after extracting their shared canonical eight-output emitter.

`Uniform<W>` is a read-only parameter block, 576 bytes at width 8 and 1,088 at 16.
Each lane has separate FIRST, REST and LAST pointers, arbitrary initial CV and
mode flags, and an independent final byte length. The block count 1..16 is common.
FIRST has 64 readable bytes when count>1; REST has 64×(count−2); LAST has 64 padded
bytes. At count 1 only LAST is read. There is no whole-message copy.

The kernels reuse the existing seven-round emitters, retaining CVs in registers
between blocks and transposing/storing only their final outputs. Counter is zero;
CHUNK_START belongs to the first block, CHUNK_END|ROOT to the last. The staged
finisher selects this path only when all public ending-block counts agree.
Mixed endings keep the prior loop. All keys/modes and last lengths can differ.

## Results

Direct **e3af→6460**, four fresh builds/layouts, alternating order, shared clocks
415e7df398d42d6cc34b965a4c033a02798a9dd6, 3% margin / 5% FDR. Pinned host locks cover
preparation through verification. All complete cycles include active-state reset,
caller descriptor refill, all grouped updates and canonical outputs; initial
construction/key/context/data preparation is outside repeated timing.

At 1,024 1-KiB messages in four 256-B arrivals, ns/message:

| CPU | Complete wall | Process CPU | Whole-package nJ |
|---|---:|---:|---:|
| Zen 3 | 424.3553→303.4567, Faster | 424.2348→303.3652 | 28516.66→23137.86, Level |
| 9700X | 157.5221→123.7792, Faster | 157.5182→123.7772 | 9180.60→7020.62, Faster |

Mixed-mode 1-KiB cycles give 419.5406→303.6246 ns on Zen 3 and
158.5366→123.1454 ns on 9700X. Mixed varied-length cycles are Level on both. With 17-B fragments the
9700X complete 1-KiB cycle is 402.5264→393.5746 ns, Level; Zen 3 is
1148.2954→961.0258, Faster. These ratios stay separate from previous improvements.

Whole-cycle wall summary: Zen 3 **11F/21L/0S**, 9700X **6F/25L/1S**, 32 cells each.
The flagged 9700X whole cell is 1024×64B/17B arrivals, +5.1%. Ordinary per-Hasher-
update controls have Zen 3 finish-only 10 Slower/50 Level cells (~7–8% at some
small groups), complete cycles all 60 Level; 9700X both operations all 60 Level.
These costs remain in the raw record. RAPL is whole-package energy, including
idle/background activity. No cache-line cause is inferred from timing.

## Verification, model gaps and retained failures

Initial native tests/build/docs pass on Zen 3 and 9700X. Tests exercise every block
count, varied modes/keys/final lengths, reuse, and read-only guarded FIRST/REST/
LAST/parameter regions plus guarded output. Counts 1/2/3/16 have exact region
sizes; unused FIRST/REST regions can be zero bytes. A scalar oracle independently
derives the three-block startup checksum **0x69a05ec2649bc819**.

The first three proof/model jobs FAILED because the checker lacked numeric LEA
and VPORD forms. Their tracebacks remain in `failures/`; they are development
failures, not passed proofs or timing evidence. The model-supported head:

- Treats numeric LEA as arithmetic without memory/flags effects. Ordinary memory
  still requires a region pointer and public offset. Numeric values cannot become
  silently accepted memory addresses.
- Adds VPORD using the existing lane-wise OR semantics.
- Cross-checks the emitted vector and numeric-LEA forms against the CPU:
  **56 forms, 16 memory forms, 200 random states/form, 3 alignment controls, all agree**.
- Passes nine scoped memory/LEA/OR model unit tests, including flag preservation
  and numeric-memory rejection.

Supported symbolic proofs cover **both widths at block counts 1/2/16**, arbitrary
independent keys/CVs, all block bytes, final lengths 0..64 and byte flags; ABI,
all legal stack residues, read-only/bounds, complete output and data-independent
trace are checked. Four planted faults per width reject missing ROOT, wrong REST
stride, lost CV carry and omitted final output. The long 16-block cases prove
19,022 instructions at width 8 and 15,905 at 16. Other block counts have native
reference coverage; their separate symbolic cases remain work if this experiment
is proposed for integration.

## Artifacts and ownership

[`multiblock-next/`](multiblock-next/) contains 13 run directories: ten VERIFIED
native/timing/supported-proof/model/unit jobs and three retained FAILED checker-
development attempts. Scripts/manifests keep exact source identities. Individual
files are below 20 MB and executables are omitted. The independent reference uses
its included `reference-base.py`.

Sam owns this sizing/prototype evidence. John owns any future design/proof/cost
and integration review. Frozen #274/#271/#269/#259/#262 remain untouched. This
record retains a measured option; the simpler existing-eight-lane dispatch work
is a different source and review boundary.
