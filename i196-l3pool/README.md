# BLAKE3 #196: probe/l3-pool on the EPYC 9255 and the 2x Xeon Gold 6330

bench-hashes 0.19.6 (744eea5f); servil 09d3bbc6 (the probe's parent; its library is 0b9f40d7's);
probe/l3-pool 9c25ed9e. Every run through pinned-run (manifest.json: inputs by hash), VERIFIED.

- `i196-l3pool-*` (`l3pool.sh`): `check --fork PROBE --against 09d3bbc6 --cells all`, then servil mt
  full runs: servil free, servil confined to CPU 0's L3 domain, the probe free (`compare3.py`).
- `i196-everylen-*` (`everylen.sh`): EVERY_LEN at 8, 16, 32, 64 MiB and never, each a commit with
  fixed metadata (`mkvariants.sh` makes the same hashes), servil mt full runs, 3 rounds (`everylen.py`).
  A first attempt failed: the variants' origin was a local path, and bench-hashes' map step
  panicked after measuring (bench-hashes #111). The runs here set origin to the repository.

- `i196-tests*` (`tests.sh`, `tests2.sh`, `tests3.sh`): the probe's test suite on both machines; on the
  EPYC, against servil, and with the whole run on CPU 0 or CPU 12: a caller in a domain with no
  worker panics (forked_child) or hangs (stream_collect_one_worker).

The full runs' .err files (progress bars) and the build logs are left out.
