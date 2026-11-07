## Owned retired-instruction trade-off; acceptance pending

**Owner: Sam Shackleton.** The in-place checkpoint candidate optimizes the
existing standard `Clone::clone_from` operation. Its Ice Lake time/CPU/cycle/
package-energy savings coexist with higher retired instructions. This issue
owns that cost rather than treating it as an automatic veto or hiding it behind
the benefit. Independent review acceptance remains required.

Exact direct sources:
- baseline `f47d9e5d284aafcbabf7b6b2105bdedde4832261`;
- selected `9c3618b0411e5f04a8373063ab253572af0584ed`;
- bench/clocks `415e7df398d42d6cc34b965a4c033a02798a9dd6`.

[Report and 21 VERIFIED source-labeled runs](https://github.com/samshackleton-tech/bench-hashes/blob/8c1897140c431774852b1d64ab92d30244817237/IN-PLACE-CHECKPOINTS.md)
— all 16,954 paths/sizes and report/index/inventory bytes remotely verified.

## Cost and matching benefit

Ice Lake 6330, 64 existing destination slots, plain 64-byte source prefixes:

| Operation | Instructions/state old → new | Wall ns/state old → new | Package nJ/state old → new |
|---|---:|---:|---:|
| `clone_from` | 78.7108 → 292.7035 (+272%) | 1446.4246 → 79.7776 | 133454.6349 → 7094.3100 |
| checkpoint +17B append + finalize | 1231.7113 → 1445.7045 (+17.4%) | 1559.5094 → 260.7232 | 143841.4696 → 23199.1278 |

Process CPU and cycles are Faster too. Package energy includes the entire
package's idle/background activity. These are repeated in-place checkpoints;
source prefix hashing/construction and slot allocation are outside, while the
same public operation, append and finalization are inside both sources.

There are **132 Slower instruction metrics on Ice Lake** across the two in-place
operations, with no Slower wall/CPU/cycle/energy cells. Ordinary `clone()` and
ordinary clone/append/finalize controls are Level across four hosts. The full
primary result is 490 Faster / 662 Level / 0 Slower wall cells; the cost is not
being relabeled as noise. A/A on 9700X/Ice Lake has all 2,880 metrics Level.

[Raw Ice Lake in-place judgments](https://github.com/samshackleton-tech/bench-hashes/blob/8c1897140c431774852b1d64ab92d30244817237/clone-checkpoint/archive-runs/clone-from-initial-matrix-icelake-20261107T060304-3192bd29/out/judgments-mixed-clone_from.tsv)

## Reproduction and existing checks

From published `clone-checkpoint/`:

```
pinned-run launch from-matrix-icelake.json
pinned-run launch from-aa-icelake.json
pinned-run launch from-inspect.json
```

Full source commits/script hashes, fresh private builds/layouts and a preparation-
through-verification host lock; shared 3% practical margin /5% FDR, alternating
adjacent baseline/candidate order. Host/key configuration can be adapted while
keeping measured source/instrument identities fixed.

The pinned same-consumer disassembly establishes a concrete work difference:
18,432-byte old in-place memmove becomes 1,984 core bytes plus the actual live
stage prefix, without full result transport. This proves copy bounds/transport,
not the cause of the CPU-specific retired-instruction count. The particular
resolved libc move/copy implementations and counter behavior remain profiling
questions; no cache/alias cause is claimed from timing.

Earlier safe by-value prefix-copy attempts were measured and lost badly because
the generated aggregate/return transport retained large copies. They were not
promoted. Prevalidating a direct `Self` construction did not fix those losses.
The selected in-place API preserves ordinary clone's infallible full-copy body.
These are relevant earlier design checks, **not a claimed fix for this instruction
trade-off**. All raw losses are retained in the same record.

A deterministic canary verifies unused destination stage capacity is not written.
The value-equivalent full-copy default passes canonical checks then fails that
canary; the pinned expected-failure control is VERIFIED. No timing assertion.

## Bounded next investigation (20-minute equivalent budget)

1. Bind the actual Ice Lake libc move/copy entry selection and relevant generated
   instruction sequence to pinned artifacts; keep retired instructions, uops,
   cycles and memory traffic distinct.
2. If that evidence suggests a small safe lowering/copy simplification, test at
   most one controlled ablation with short, nearly-full-stage and ordinary-clone
   controls. Preserve the complete checkpoint/append/finalize gain.
3. Stop and return the explicit trade-off to review if no simple mitigation earns
   its place. No new assembly kernel, unsafe placement API, container redesign,
   padding heuristic, or serialization of tests to hide interference.

My recommendation is to weigh higher Ice Lake retired instructions against the
measured reduction in copy work, CPU time and whole-package energy for the
matching operation. Acceptance is pending, not inferred from earlier approvals.
John owns design/cost/migration-fit review and integration; Sam owns this follow-up;
Devon is requested for independent peer/Intel review. No merge or release implied.

— Sam Shackleton
