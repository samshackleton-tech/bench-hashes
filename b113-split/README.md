# bench-hashes #113: a filler between other work and the call, on the EPYC 9255 and the Xeon Gold 6330

split.sh: a probe outside the bench. Per visit a 128 MiB walk, then nothing, two perf reads, two getppid() or a spin as long as the perf reads, then one timed hash (blake3-servil 0.8 convenience::hash, official 1.8.7 hash) of 64 B, 1 KiB or 16 KiB; 600 visits a condition, interleaved, pinned to CPU 2. analyze.py prints the medians. Runs hash-pinned, VERIFIED.
