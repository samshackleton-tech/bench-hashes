# x86-64 for 0.9 (BLAKE3-Servil #344): the gates, proofs and measurements (November 10, 2026)

Keyed and mixed-mode held groups finish in independent SIMD lanes (sixteen on AVX-512,
eight on AVX2). Landed as `next` 86c49732. Machines by role: an EPYC 9255 and a Ryzen
9700X (Zen 5, AVX-512), an Ice Lake Xeon pair, an EPYC 7443 (Zen 3, AVX2 without
AVX-512), an AArch64 VM. `manifests/` names every commit of every run; a run's
`status.txt` is its own verdict, and a runner's VERIFIED says only that the run stated
the identities asked of it.

The tip moved as `next` did (r2 … r8 in the run names); the changed files were compared
before each rebase. What each kind of run is:

- `gate-*`: format, `check-builds.sh`, the four suites, the tool's tests, the change's
  mutation check with and without `--every-mutant` (`steps.tsv`).
- `preservation-*`, `cycle-v2-*`: the complete-cycle matrix, 320 cells, four fresh
  paired layouts, 3% margin (`judgments-*.tsv`). `cycle-v2` is the frozen instrument
  with the two calls that left the public API replaced (`drivers/cycle-matrix-v2.sh`).
- `speed-*`: `bench-hashes check` on ten points.
- `proofs*`: the x86-64 half of the proofs (`steps.tsv`).
- `same-code-*`, `arm-side-*`: the AArch64 build's machine code against `next`'s, object
  by object, and the suites and mutation check in the VM.

Things the record keeps that a summary would lose:

- 807684c8 on the Ice Lake host: a pair of keyed hashers Slower by 3.5% (cycle matrix),
  which `INDEPENDENT_MIN = 3` removed.
- `speed-armvm-r2`: one cell Slower (+4.2%); the old-against-old control and the
  identical rerun were clean.
- The Apple M6's check of bdc29431 read one cell Slower (+4.0%): the AArch64 build
  differed from `next`'s in one object. The x86-64 route then moved behind one
  x86-only function, and the AArch64 code is `next`'s byte for byte.
- Runs named `partial-fetched-while-running-*` and `cut-short-by-my-script-*` are mine
  to explain: fetched before they ended, or a driver that lost its last steps.
