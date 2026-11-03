# BLAKE3 #219 evidence

- `runs/b219-samecode-icelake-*`: every x86-64 row not already same code, built as the release build (mutants profile, incremental off), as written and line count kept, hashed (code_hash.py) against the unmutated build. `scan-fresh.tsv`.
- `runs/b219-catch-ampereone-*`: the AArch64 twins of #221 rows, each mutant applied and its test run.
- `runs/b219-fairness-ampereone-*`: pool_fairness on the 4-vCPU AmpereOne, servil and the counting branch.
- `runs/b219-catchpf-ampereone-*`: #222's prefetch tests against every mutant of the prefetch functions on the AmpereOne (85 caught, 26 missed, 1 unviable, 1 time-out), then the whole suite (passes).
- `runs/b219-catch2-ampereone-*`: #221 at cc9cce0b on the AmpereOne: all 28 mutants caught, every group exit 0.
