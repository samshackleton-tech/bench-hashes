# The stream's ring for long messages on x86-64: 2, 4 and 8 MiB on five machines (November 10, 2026)

For BLAKE3-Servil #349. `bench-hashes check` (bench 148827f3), 16 pairs, points
`continuous 1 MiB, 4 MiB, 16 MiB`. Machines by role; `manifests/` names every
commit, `runs/*/check.log` holds each verdict and `runs/*/samples/` every sample.

- `long-ring-2mib-ice2`: c133807a (2 MiB) against its parent 23b09d56 (8 MiB) on an
  Ice Lake Xeon pair: 2 MiB slower on all six long-message cells (7 to 19%).
- `long-ring-{4,8}v2-*`: on `next` 86c49732 (2 MiB), the ring at 4 and at 8 MiB
  (probe commits 34d64d65 and 01625b9b), each against `next`.

Result (the table is in the issue): 8 MiB gains 10 to 20% on the Ice Lake pairs and a
Ryzen 9700X, and costs an AVX2-only EPYC 7443 18 to 36%; 4 MiB gains 4 to 8% and costs
that machine 10% on one cell; an EPYC 9255 is level at every size. 2 MiB, 0.8's size,
is the only one with no Slower cell on any machine.
