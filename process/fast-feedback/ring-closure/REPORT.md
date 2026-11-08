# Ring copy-elision candidate ddb7199d on Ice, and a cursory-reader safety audit

## Ring candidate: correctness passes, three short shared-stream cells still slower

John's candidate **ddb7199d7f0b0f04390e923474b630ffc7ff2811** against current next **fbfb319f3414ac7fac4b3d4bce266488a1fdee3b**, on the dual Xeon 6330 (Ice Lake) under pinned-run, each run holding the bench lock from preparation through verification.

**Correctness.** 227 release tests and 21 doc examples pass, with fmt, no-default and warnings-denied rustdoc. The delayed-copy control restores the old reuse boundary in the owner's schedule test: it fails at `publication waits until the old task is copied`, and the restored source passes.

**Mutation gate.** The first run planned 34 changed-line mutants and **failed**: six names new to the x86-64 list, every one in `take_run`, which is `cfg(blake3_gpu)` and absent on x86-64. The checker confirmed each as identical code. That run took 189 s against the 60 s budget. Registry-only child **05fd8b92fcf93f182b5bd0206abd166461b60ce7** adds exactly those six rows with their observed counts. Its fresh gate passed: 34 mutants, no new survivor, **57 s within the budget**. The second driver adds a registry-only check; both executing drivers are kept by hash.

**Speed.** bench 7ea20449 `check`, unchanged: 15 named stream points, st, mt and pipeline, four fresh layout pairs, then 64 fresh pairs on the eight suspects. Points: continuous 64 B to 1 MiB, continuous batches of 64 and 1024, both pipelined collections, and receiving at saturated, 2 µs and 20 µs. The first stage found no cell slower and no Level cell's instructions moved beyond 0.5%. The confirmation judged:

| Cell (servil mt, shared one cache) | Change | Verdict |
|---|---:|---|
| continuous 64 B | +3.2% | **Slower** |
| continuous 128 B | +4.3% | **Slower** |
| continuous 256 B | +4.1% | **Slower** |

The other five suspects (mt 1 KiB, the git-objects collection and three pipeline receiving cells) were not judged Slower on 64 pairs. **Exit 1, REGRESSION, three cells.** The remaining 257 points are unmeasured here. This Ice result agrees in kind with Devon's i7 short-stream costs on the earlier ring sources. It doesn't establish a cause, and John's later probe 7b602d92 (a whole-worker copy chain) is not measured here.

Runs: `FAILED-ring-closure-quality-ice-20261108T143801-2d9cc8c9`, `ring-closure-registry-ice-20261108T145715-ae527628`, `ring-closure-gate-ice-20261108T151041-c28e46b7` (57 minutes).

## Safety audit

Six findings, each in an assigned issue: [SAFETY-AUDIT.md](SAFETY-AUDIT.md). Three are memory unsafety reachable from safe code (#307, #308, #309), two silently wrong digests (#310, #311), and one secret-key-dependent timing (#312). #308 and #312 are in published 0.8.0.

No landing, release, advisory, worker tuning or hardware change by Sam. John owns the integration, cost and release decisions.

— Sam Shackleton
