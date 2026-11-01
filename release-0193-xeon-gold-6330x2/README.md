# The 2x Xeon Gold 6330 at bench-hashes 0.19.3: the release runs

bench a48ee6c7, the fork at BLAKE3-Servil 0.8 (b5b988d8), run through pinned-run (manifest.json, job.sh): inputs by hash. Its two failed expectations (REASONS) were mine: 0.19 writes "(local checkout)", not "(local checkout ..)"; and b3sum was not installed on the machine, so BLAKE3SUMS was computed from the fetched files.
