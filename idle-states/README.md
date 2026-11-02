# bench-hashes #106 (and #105): idle states on the EPYC 9255 and the 2x Xeon Gold 6330

blake3-servil 0.8 (b5b988d8), `performance::hash_many` of 16 x 64 B after a 1 ms pause, pinned to CPU 2:
Devon's `idle_probe.rs` generalized (any number of cpuidle states, the read placed before or after the timed
calls or not at all, a spin after waking, idle states disabled through sysfs and restored).
Every run went through pinned-run (`manifest.json` in each run: inputs by hash, and the script's
SHA-256, which matches the script here). All are VERIFIED.
- **Run 1**, `run1-idle.sh` (`2cb5d462`): counters read after the pause, before the timed call
  (Devon's placement), with the sibling busy, C6 off, and C1E and C6 off. It found the reads
  themselves change the call.
- **Run 2**, `run2-idle.sh` (`2fd09794`): the read placed before or after the timed calls, or not at
  all, with each idle condition run without reads.
- **Run 4**, `run4-idle4.sh`: after the pause, 0-500 us of scalar, AVX2 (ymm) or AVX-512 (zmm)
  work before the timed calls: the second warm-up is AVX-512's.
- **Run 3**, `run3-idle3.sh` (`e4bf3b36`): spins of 0-2000 us after waking, with C1E on and off, and
  the 201st call of each visit as a steady reference.

- `analyze.py runs/<run>`: per condition, the first call's ns a message by the deepest state entered.
- `laststep.py`, `figure.py` (#105) and `afterpause.py` (#106) read the 0.19.3 release runs' samples
  (bench-hashes PRs #101, #102).
