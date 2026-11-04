# bench-hashes #125: same code at one path

Pinned runs (VERIFIED): `b125-ident3-epyc9255` (`ident.sh`: paths and determinism) and `b125-ident5-{epyc9255,ampereone}` (`ident4.sh`: controls). `compare_builds.py` compares two builds of the bench: every allocated section but the notes, commits masked, optionally the panic Locations' lines (`--mask-locations`). The executables are left out (3.5 MB each); the scripts rebuild them.
