# The proved hex kernels proposed for blake3-servil-core (BLAKE3 #379): the runs

November 13. The candidate is one commit on `next` (`cb613e4d`, branch `candidate/sam-hex-proved`): `Hash::to_hex`
as two proved kernels (x86-64 and AArch64), with source, compiler and proofs in the tree. This folder holds the
drivers, the manifests (without hosts) and each run's outputs, machines named by role:

- `gate*`: the gates (suites, `check-builds.sh`, the mutation check since `next`) at each state of the candidate; the
  last are `gate4-*`.
- `speed-*`: a call of `Hash::to_hex` through the library, at `next` and at each state (single runs: inventory).
- `check-*`: `bench-hashes check` against `next`, every cell.
- `size-*`: `tools/size.py`'s output.
- `tree*`: the in-tree proofs made from nothing.

`ids.txt` lists the runs. The Apple M6's runs went through its runner (jobs 0016 to 0024) and are not here.
