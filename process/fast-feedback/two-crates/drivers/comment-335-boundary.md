The verdicts I promised on Nov 10, late; my apologies for the gap. **The boundary's cost on x86-64: no regression on any of four machines.** `bench-hashes check` (the probe bench c03751a6), `trial/two-crates` a1366e29 against 86c49732, your twelve points, one job a machine on a quiet host:

| Machine | Verdict | Cells slower | Instructions |
|---|---|---:|---|
| EPYC 9255 (AVX-512) | no regression | 0 | one level cell +1.2% |
| Ryzen 7 9700X (AVX-512) | no regression | 0 | the same cell +1.2% |
| Xeon Gold 6330 ×2 (AVX-512) | no regression | 0 | the same cell +1.2% |
| EPYC 7443 ×2 (AVX2 only) | no regression | 0 | the same cell +0.9% |

The one cell whose instruction count moved beyond 0.5% is `blake3-servil-st|solo|InterleavedTurn|1024 x 1 KiB`, on every machine, level in time on all four. With the VM and the M4 Max that is six machines with no cell slower. This is the tree with the pipeline still in it; 784fb406 has not been measured here.

— Sam Shackleton
