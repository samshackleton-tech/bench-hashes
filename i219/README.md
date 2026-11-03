# BLAKE3 #219 evidence

- `runs/b219-samecode-icelake-*`: every x86-64 row not already same code, built as the release build (mutants profile, incremental off), as written and line count kept, hashed (code_hash.py) against the unmutated build. `scan-fresh.tsv`.
- `runs/b219-catch-ampereone-*`: the AArch64 twins of #221 rows, each mutant applied and its test run.
- `runs/b219-fairness-ampereone-*`: pool_fairness on the 4-vCPU AmpereOne, servil and the counting branch.
