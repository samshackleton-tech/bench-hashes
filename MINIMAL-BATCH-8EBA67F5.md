# #262 minimal borrowed adapter: current source and gates

Current draft head: **8eba67f56b946f81fa0f1fb8d13fc306300e42d2**, `candidate/sam-batch-partials`, worktree `~/work/b3-batch-candidate`.

`git rev-parse HEAD^{tree}` equals `git rev-parse 8f3c06bd5135b34b0bf78912c39b8a43ac746743^{tree}`. The condition-reordering (`83cc613b`) and dispatch-isolation (`e2df3c4b`) experiments were reverted in normal commits, not force-pushed or erased. Neither fixed the intended-pattern problem; the extra wrapper did not earn its complexity.

The direct four-host timing records remain labeled **1fb068fe → 8f3c06bd**, not relabeled as measurements of the new commit identity. They include a Zen 3 **1024 B × 8 warm loss ~3.1%**. The retired isolated variant instead lost **512 B × 8 ~6.1%**, also CPU/cycles/package energy; instructions essentially level. Both are retained. No false-positive, cache, aliasing or code-placement cause is asserted from timing alone.

**Not ready for integration.** Large gains in ready partial-block batches do not average away an intended-pattern loss. Earlier shared-path scoped controls at the retained code tree hold on all four hosts; these are not full-library release checks.

## Fresh exact-commit correctness/build gates

All five VERIFIED under current 8eba identity:

| Host | Native tests | Other gates |
|---|---:|---|
| 9700X | 188/188 | no-default build; doctests; warnings-denied rustdoc |
| EPYC 9255 | 188/188 | same |
| Xeon 6330 / Ice Lake | 188/188 | same |
| EPYC 7443 / Zen 3 | 188/188 | same |
| ARM VM | 158/158 | same; correctness/build only |

Records in `batch-runs/`:
- `batch-minimal-native-9700x-20261106T124156-1fecb55a`
- `batch-minimal-native-epyc9255-20261106T124156-9330ea96`
- `batch-minimal-native-icelake-20261106T124157-9fc3b141`
- `batch-minimal-native-zen3-20261106T124158-e362efdd`
- `batch-minimal-native-arm-20261106T124159-889ff6bc`

Assembly is unchanged from frozen #259. Reusing its proof is a statement about those unchanged instructions and their contract, not a new formal proof of the Rust Batch adapter.

The separate `probe/sam-batch-width8` experiment is **not in this draft**; see `WIDTH8-PROBE.md` for exact sources, two-host scope and retained failed test expectations. No change to the safe Batch input contract or public API is proposed.

— Sam Shackleton
