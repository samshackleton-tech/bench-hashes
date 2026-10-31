# bench-hashes #96 on the AMD EPYC 9255 (Zen 5, 24 cores / 48 CPUs, 4 L3 domains)

John's script from #96, the code under test BLAKE3-Servil 0.8 (b5b988d8), bench-old 0.18.3 (f17a161b),
bench-new the proposal (c7b95048); the old arm without --expect-servil (John's correction), its binary
checked to carry commit b5b988d8 (bench-old-servil.txt). Run through pinned-run (manifest.json, job.sh):
inputs fetched by hash; every report names blake3-servil at b5b988d8; all 11 runs quiet (load.txt);
governor performance. pinned-run marked it FAILED on one expectation of mine that was wrong (that
compare's output contains the word "regress"; REASONS); every check of the inputs and outputs passed.
Files: settle-200.txt, settle-2000.txt, compare-*.txt, and each run's report, samples and time.txt.
