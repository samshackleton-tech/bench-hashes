# BLAKE3 #218: stream.rs mutation runs

`b218-streammut3-*` (VERIFIED), check.py --write with the list cut to `files: src/stream.rs`, at probe/sam-streammut 68d3b77c (servil 30613db3 + #231 + #232). EPYC 9255 (`streammut.sh`) and the AmpereOne VM (`streammut2.sh`: pool_fairness skipped, as #230). Each run's `out/list-written.txt` holds the rows.
