# The 0.9 release: runs made for its gates on the x86-64 machines

Version commit `bf2da8b957f5e0c80babb57952de3e53f95c921a` (0.9.0+73ee859e), BLAKE3 #348 step 4.

`whole-mutation-run/MACHINE/`: `python3 tools/mutants/check.py --whole` with the commit checked out, both
crates, nothing written. `mutants-bf2da8b957f5.log` is the tool's output as `tools/release-check.py` reads
it (`tmp/night/mutants-bf2da8b957f5.log` in a checkout); `release-check-reads.txt` is what that tool's own
`mutation_result` made of the log on the machine; `status.txt` the exit and the time (single executions:
inventory, no speed verdict); `identity.txt` the commits, the compiler and the CPU; the log's SHA-256 and
BLAKE3 beside it.

The script that made each run: `release-whole.sh` (below), under `pinned-run` with the commit pinned.
