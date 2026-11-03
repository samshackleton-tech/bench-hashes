# BLAKE3 #231: the wake-count test on AVX-512

Pinned runs `wakes-wide2-*` (VERIFIED): servil 30613db3 fails `test_a_job_wakes_one_worker_a_piece_past_its_own` (`Some(1)` for `Some(2)`); fix/sam-wakes-wide d252770e passes it and the whole suite (157/157) on an EPYC 9255 and a 2x Xeon Gold 6330. Script `wakes2.sh`; each run's `out/`.
