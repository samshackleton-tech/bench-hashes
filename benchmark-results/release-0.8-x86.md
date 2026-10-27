# 0.8's release runs on six x86 machines (BLAKE3 #125)

Library 934dee89 (0.8.0+f7ce4e4e), bench 0.18 at 67bae864 (this branch's base), each machine bare metal,
governor performance, nothing else running. Per machine `release-0.8-<machine>/`:
- `full/`: the full `--all` run, built with `bench-hashes build-against ..` (the report names
  blake3-servil 0.8.0+f7ce4e4e, local checkout, commit 934dee89). The bench reads "dirty" because
  build-against's lock carries the release's version of blake3-servil; the tree is clean before and after.
- `b3sum/`: the b3sum run (official 1.8.7 and the fork's b3sum at 934dee89, each also on one thread).
- `checks/`: the suites at 934dee89, and two rounds each of John's release check (against bfbda192,
  old bench 5be5f236) and the same-library check (against 934dee89, old bench 3f9edd13), `--cells all`.

Machines: epyc9255 = AMD EPYC 9255 (Zen 5, AVX-512, wide kernels on); ryzen9700x = Ryzen 7 9700X (Zen 5
desktop, wide on); epyc9254 = EPYC 9254 (Zen 4, AVX-512, wide off); xeon-gold-6330x2 = 2x Xeon Gold 6330
(Ice Lake, AVX-512, wide off); epyc7443p = EPYC 7443P (Zen 3, AVX2); xeon-e5-1650v4 = Xeon E5-1650 v4
(Broadwell, AVX2). The five beside the EPYC 9255 rented hourly from Cherry Servers.

**Redo with bench 0.18.1 (2c9633ae: official's multi-threaded form in `--all`; Zooko, October 27):**
`release-0.8-<machine>/full-0.18.1/` replaces `full/` for the CHANGELOG's table and the overview. Each report names
`BLAKE3 official mt: blake3 1.8.7` and blake3-servil 0.8.0+f7ce4e4e (local checkout ..) at 934dee89; run by
pinned-run (`pinned-run-manifest.json`: inputs by hash, the report's identities verified). Where a machine was
re-rented for the redo, it is a different box of the same model and plan; its b3sum/ and checks/ are the first box's.
