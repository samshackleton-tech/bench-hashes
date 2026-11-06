# Exact current #259 source: end-to-end paired matrix

Baseline#249 **1ea6183225b91f857770949c7120a06485be8d92** -> current draft#259
**1fb068fe77dc571ec47241753a0c35663b514c2f**. No multiplication of earlier
incremental ratios. All four hash-pinned runs are VERIFIED, four distinct build
layouts per side, alternating old/new processes. Each matrix has168shape/count
cells: counts2/4/8/16/32/64/128/1024,17equal lengths plus4mixed/skew distributions.
Clocks paired judgment:3% margin/5% FDR. Raw totals retain wall,processCPU,cycles,
instructions and whole-package RAPL energy separately.

|CPU|Faster wall cells vs#249|Level|Slower|
|---|---:|---:|---:|
|9700X|153|15|0|
|EPYC9255|156|12|0|
|IceLake/Xeon6330|116|52|0|
|Zen3/EPYC7443|136|32|0|

At1,024ready messages, versus **RustCrypto sha2 0.11.0 ordinary hardware-SHA call**:

|CPU/shape|SHA ns/item|B3 ns/item|B3/SHA paired time|B3/SHA package energy|
|---|---:|---:|---:|---:|
|9700X64B|55.25|12.93|0.234|0.259|
|9700X1KiB|414.15|82.42|0.199|0.216|
|9700Xmixed100–1,000B|230.83|63.33|0.274|0.295|
|EPYC9255 64B|69.09|15.88|0.230|0.243|
|EPYC9255 1KiB|519.83|101.69|0.196|0.205|
|EPYC9255 mixed|291.51|77.76|0.267|0.278|
|IceLake64B|190.25|47.71|0.251|0.253|
|IceLake1KiB|1452.79|284.78|0.196|0.197|
|IceLake mixed|805.18|208.46|0.259|0.262|
|Zen3 64B|70.52|29.75|0.422|0.441|
|Zen3 1KiB|577.56|206.26|0.357|0.380|
|Zen3 mixed|322.06|145.25|0.451|0.480|

All displayed comparisons are Faster. ProcessCPU ratios are in the raw judgments;
they closely follow wall in these single-thread calls, but are not inferred from
wall. Package energy includes idle/background package costs, not incremental
core-only energy. Both algorithms write all32-byte digests. Inputs/descriptors are
ready; source creation is outside, B3packing/padding/output stores are inside.
This measures performance::hash_each in its repeated-call pattern.

This is NOT a claim against every SHA implementation. The separate specialized
ISA-L Crypto sha256_mb comparison at **e448**, before bin-counting/compact-AVX2,
is retained in MULTIBUFFER-AND-SHARED-PATHS.md; its smaller advantages are not
silently attributed to this head or multiplied by later ratios. Caller conversion
and cached-keyHMAC studies likewise keep their own exact source/workload labels.

## Checks and costs that are not erased by this table

- Current assembly contract:32equal+32independently symbolic-ending proof cases,
  46helpertests,fourfaultcontrols; native392vector/110memory forms,200states each,
  28alignment controls. Native187/187on4x86hosts,158/158ARMVM; build/doc checks.
- Shared-path scopes were measured incrementally:1ea→e448 holds3machines but has
  the reported9700Xcold MTperformance1KiB+4.9%cell; e448→d270 and936→fc hold all4.
  Do not turn these incremental scopes into an unmeasured full-head macro verdict.
- Startup1ea→e448 adds~6.15us9700X (~26%); not removed to hide its cost. Not an
  exact startup measurement of this later head. No startupenergyclaim.
- Standard full-round BLAKE3 outputs/keyed semantics, no clock guesses or public
  API changes. The draft is available for independent review, not merged/released.
- Subsequent sparse-scratch/window experiments are separate and NOT included;
  they had losses and were not promoted. This freezes the measured candidate.

— Sam Shackleton
