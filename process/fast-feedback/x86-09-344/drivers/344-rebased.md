Rebased onto today's `next` (f4076875) with no conflict; the AVX2 hold is settled. Head **bdc29431**: the two commits as before (now 761aa7df and 69e06560) and one more that changes no compiled code.

**The AVX2 hold.** I read Devon's i7 record (his data branch) instead of asking for another run. All eighteen missed places of the twelve names are in lines only an AVX-512 CPU runs: `held_groups`' sixteen-lane arm and its eight-lane remainder after the full groups, `lanes`' AVX512 arm, and `input`, which only the sixteen-lane finish calls. On the i7 the test that covers them ran and passed; at width eight it never enters those lines. So they are rows, conditional on the CPU (`[cpu lacks avx512f avx512vl]`), each with that reason (bdc29431).

Confirmed on an AVX2-only machine of mine (a dual EPYC 7443, Zen 3, no AVX-512): every gate step passes, and the change's mutation check with `--every-mutant` runs all 105 mutants with no new survivor. On the EPYC 9255 the rows do not apply and all 105 are still caught or explained.

**At 69e06560 (the compiled code) against `next` f4076875:**

| | result |
|---|---|
| Gates, EPYC 9255 (AVX-512) | every step passes; 66 and 105 mutants, no new survivor |
| Gates, EPYC 7443 (AVX2) | every step passes at bdc29431; 58 and 105 mutants, no new survivor |
| Complete-cycle matrix, EPYC 9255 | 194 Faster, 126 Level, 0 Slower (update the same; finish 256 Level) |
| Complete-cycle matrix, Ice Lake | 82 Faster, 238 Level, 0 Slower (update 81 / 239 / 0; finish 10 / 246 / 0) |
| `bench-hashes check`, EPYC 9255 | no regression |
| `bench-hashes check`, Apple M6 (job 0009) | no regression |
| Suites, Apple M6 (job 0008) | passed |

**Running or waiting:** `bench-hashes check` on the Ice Lake host and the AArch64 VM (both in their 64-pair second stage); the Ice Lake gates (cargo-c is being installed there first); the matrix and the check on the AVX2 machine; and the M4 Max: jobs 3018 (suites) and 3019 (check) are on `mac-runner` since 14:18 UTC and `mac-a` has not claimed them yet.

**Next move (Sam):** land when those are in and clean.

— Sam Shackleton
