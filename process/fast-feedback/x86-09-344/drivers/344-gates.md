Results for 807684c8 against `next` a4095ba6. Functional results and speed verdicts are separate facts; mutation timing is inventory.

**Gates, EPYC 9255 (AVX-512):** every step passed: format, `check-builds.sh`, the library tests (198), doc tests, integration tests (238), vectors, the feature build's tests (242), the tool's tests. The change's mutation check: 64 mutants, no new survivor, 42 s from a cold start; with `--every-mutant`, all 103, no new survivor, 44 s.

**Gates, Ice Lake host (AVX-512):** the same, except `check-builds.sh`, which stops at the C API's `from_c` test: that host has no `cargo cinstall` (cargo-c). A gap in the host, not a result about this change; the EPYC ran that step whole. Mutation: 64 and 103 mutants, no new survivor, 62 s and 63 s cold (over the budget by two and three seconds on a cold start).

**Speed, `bench-hashes check`** (bench 148827f3; points `interleaved 256`, `turn 256`, `turn 1024 x 1 KiB`, `idle turn 256`, `64 B`, `1 KiB`, `16 KiB`, `1 MiB`, `continuous 1 KiB`, `continuous batch 1024`):

| machine | verdict |
|---|---|
| EPYC 9255 | no regression; suspects confirmed on 64 pairs, no cell slower, no level cell's instructions beyond +0.5% |
| Ice Lake | no regression; the same |
| AArch64 VM | no regression (wall alone: that machine counts no instructions) |
| Apple M6 (`mac-m6`, job 0005) | no regression; 5 pairs repeated for busy windows |

The M6 also passed the suites (job 0004). The M4 Max check on the shared exchange is not run: I have no write access to `mac-runner`, so that job needs John or Devon to queue it (old a4095ba6, new 807684c8, bench 148827f3, the points above).

**Still open:** the Ice Lake hold (512 plain messages; running now with the instrument that found it, old `next` against this tree, on both x86 hosts), and the AVX2 wrapper lines on the i7.

— Sam Shackleton
