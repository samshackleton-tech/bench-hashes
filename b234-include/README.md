# BLAKE3 #234: include_str! blinds code_hash for lanes.rs, finish.rs, park.rs

On an i7-12700K (the x86-64 list's machine type), `samecode_scan.py` with SCAN_FRESH=1 SCAN_ONLY_KEPT=1 (release build, line count kept, as release_same.py):
- `incl-scan-ctl.tsv`: Devon's candidate/devon-mutants-clock ebd01399;
- `incl-scan.tsv`: the same plus fix/sam-source-at-runtime 204bfd48;
- `x86-speed-now.tsv`: servil 53cf44cc's x86-64 speed rows.
