# bench-hashes #108: the shared scenario on the EPYC 9255 and the 2x Xeon Gold 6330

Every run through pinned-run (`manifest.json`: inputs by hash), all VERIFIED.

- `b108-place-epyc9255-*` (`place.sh`): official st and servil st, continuous 64 B and 4 KiB, the
  whole process confined to one core's SMT pair (0,24), two cores of one L3 domain (0,1), two
  domains (0,6), or free, with the duo-copy threads' CPUs sampled every 20 ms (`free-*.cpus`).
- `b108-pr77-*` (`pr77.sh`): #77 (the pool's longest piece 1 MiB) re-applied to 0.8 (b5b988d8),
  judged by bench 0.19.3's `check` against the tag, on each machine.
- `shared_cost.py`: shared over solo (each cell's mean) per contender, from a samples file (the
  0.19.3 release runs, bench-hashes #101 and #102).
