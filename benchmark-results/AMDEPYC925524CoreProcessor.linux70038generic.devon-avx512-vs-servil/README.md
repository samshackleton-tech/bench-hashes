# AMD EPYC 9255: Devon's AVX-512 branch beside servil (not a standard run)

A side-by-side comparison measured on October 22, 2026, published on Sam Shackleton's fork only. It is not part
of the standard results. Those are in `../AMDEPYC925524CoreProcessor.linux70038generic/`.

- [`bench-hashes.beside.map.html`](bench-hashes.beside.map.html): devonjonte `candidate/devon-avx512-generated`
  (`35db939`) drawn solid, over johnservil `servil` (`27353cb`) dashed. Contenders: BLAKE3 servil (single- and
  multi-threaded), SHA-256, SHA-1DC and SHA3-256. In the b3sum section: `b3sum`, `b3sum --num-threads 1`, official
  b3sum 1.8.2, and the system's `sha256sum`, `sha1sum` and `md5sum` (uutils coreutils 0.10.0 on Ubuntu 26.04, not
  GNU's).
- Instrument: bench-hashes `candidate/devon-mean-trim` (`101efd1a`), Devon's fix for the mean's slowest-hundredth
  rule (not yet reviewed), so its means are not comparable to a standard run's.
- Each side was one full run (`--contenders …`, 96 rounds) and one b3sum run, one after another on an idle machine
  with the governor set to `performance`.

The judged comparison (`bench-hashes check --cells all --pairs 8`) and its follow-up: 2 of 408 cells slower,
single-threaded `ContinuousCollection` "Nix files", +3.4%. The cause is messages of 1,152 to 1,984 bytes, which
hash 34.6% slower on the branch because `pair.rs`'s whole-plus-partial-chunk path is gone. See
https://github.com/devonjonte/BLAKE3/commit/05c8d0ad9141d309fe12943f426e9c6b278da742#commitcomment-206216066.
