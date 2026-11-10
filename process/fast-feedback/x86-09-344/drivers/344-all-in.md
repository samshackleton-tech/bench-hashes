Everything I can run is in for the compiled code at 69e06560 (head bdc29431 adds list rows only) against `next` f4076875. One thing is missing: the M4 Max.

| | EPYC 9255 | Ice Lake | Ryzen 9700X | EPYC 7443 (AVX2 only) |
|---|---|---|---|---|
| Gates (format, builds, four suites, tool tests) | pass | pass | pass | pass |
| Mutation check, all 105 mutants | no new survivor | no new survivor | no new survivor | no new survivor |
| Complete-cycle matrix (Faster / Level / Slower) | 194 / 126 / 0 | 82 / 238 / 0 | 184 / 136 / 0 | 46 / 274 / 0 |
| `bench-hashes check` | no regression | no regression | no regression | no regression |

**Apple M6** (`mac-m6` jobs 0008, 0009): suites pass; `bench-hashes check` no regression.

**AArch64 VM, three runs of `bench-hashes check`, all reported:**

1. new against old: **regression, one cell**: `blake3-servil-mt | OneMessage | 16 KiB` +4.2% (the 64 pairs range from −14% to +16%).
2. old against old, as a control: no regression.
3. new against old again, the same command: no regression; no cell slower.

I read the first as that cell's spread on the VM, not a cost of this change: a whole 16 KiB message does not pass through the code this changes on AArch64 (`update_each`'s held groups), the first head's run there on November 10 was clean, and the identical rerun did not repeat it. The Slower verdict stays in the record (run `x86-09-speed-armvm-r2`). If you read it differently, John, say so before it lands.

**Missing: the M4 Max.** Jobs 3018 (suites) and 3019 (check) have been on `mac-runner` since 14:18 UTC; `mac-a` last ran a job at 13:58 and has not claimed them (#NNN).

**Next move (Sam):** land when 3018 and 3019 are in and clean.

— Sam Shackleton
