# In-place Hasher checkpoints: copy live staging bytes, not capacity

2026-11-07 — [draft PR #283](https://github.com/servil-software-factory/BLAKE3/pull/283); independent review requested, no integration.

BLAKE3-Servil can optimize the **existing standard `Clone::clone_from` operation**
without changing the public API or Hasher representation. Copy its core, staged
length and initialized stage prefix directly into the destination. Do not copy
unused 16 KiB stage capacity through a temporary complete Hasher.

This is specifically an **in-place checkpointing** improvement. Ordinary
`clone()` retains its existing full-copy implementation and is a measured control.
Earlier attempts to shorten by-value `clone()` copies actually made generated
code worse; those losses and the assembly evidence are retained, not relabeled.

## Frozen sources and scope

- Baseline: `f47d9e5d284aafcbabf7b6b2105bdedde4832261` (frozen #278).
- Candidate: [`9c3618b0411e5f04a8373063ab253572af0584ed`](https://github.com/samshackleton-tech/BLAKE3/commit/9c3618b0411e5f04a8373063ab253572af0584ed), `probe/sam-clone-from`.
- Independent from mixed-key staged-parent #281 and the partial-XOF cache study.
  No incremental ratios are multiplied.
- Measurement/paired judgment: bench/clocks
  `415e7df398d42d6cc34b965a4c033a02798a9dd6`.

Production change: preserve the old infallible full-field `Clone::clone` body,
and override the trait's existing `clone_from` default:

```rust
let prefix = &source.stage[..source.staged];
self.core.clone_from(&source.core);
self.staged = source.staged;
self.stage[..prefix.len()].copy_from_slice(prefix);
```

No new public method/signature, type, kernel, ABI, worker, clock, persistent
storage, production unsafe code or buffering schedule. The same roughly 18 KiB
Hasher representation and 16 KiB stage capacity remain. Keys, modes, counters,
full BLAKE3 rounds and digest/XOF semantics are unchanged.

The pinned same-consumer disassembly confirms the work change: the old in-place
path moves **18,432 bytes**; the selected path copies **1,984 core bytes plus the
live staged prefix**, with no full-capacity result transport. The ordinary clone
control still uses its full-sized copy. Source field order was not used to infer
native size, alignment or stride; those are logged.

## Measured reuse-and-branch workload

Prefix state is prepared once. Each timed operation copies it into an existing
slot with the same API on both sources, appends 17 bytes, and finalizes a canonical
digest. Prefix hashing, optional priming/reset, source/key/context construction,
references and slot allocation are outside. This is an application checkpoint/
branch operation, **not a claim that hashing the entire prefix from scratch is
this much faster**.

For 64 source states with 64-byte prefixes, plain mode:

| Host | In-place copy ns/state old → new | Copy + append + finalize ns/state old → new |
|---|---:|---:|
| Ryzen 9700X | 255.4462 → 24.3591 | 364.7469 → 142.9596 |
| EPYC 9255 | 317.5759 → 30.2601 | 453.7496 → 179.5964 |
| Ice Lake 6330 | 1446.4246 → 79.7776 | 1559.5094 → 260.7232 |
| Zen 3 EPYC 7443 | 547.9347 → 35.4631 | 683.0176 → 160.6953 |

The in-place operation is about **10.5–18.1× faster** in these cells; the complete
checkpoint/append/finalize operation about **2.5–6.0× faster**.

### Process CPU and whole-package energy of the complete operation

| Host | Process CPU ns/state old → new | Package nJ/state old → new |
|---|---:|---:|
| Ryzen 9700X | 364.7377 → 142.9593 | 22045.4871 → 7486.3434 |
| EPYC 9255 | 453.7520 → 179.5919 | 34099.9950 → 12655.7534 |
| Ice Lake 6330 | 1559.0056 → 260.6584 | 143841.4696 → 23199.1278 |
| Zen 3 EPYC 7443 | 682.9573 → 160.6766 | 47180.2687 → 10477.5267 |

Wall, process CPU, cycles, instructions and package energy are separate metrics.
RAPL includes the **whole package's idle/background activity**, not energy
attributed solely to the caller. Full cycles/instructions and all other shapes
remain in the raw judgment tables.

## Controls and retained instruction cost

72 shapes per operation per host: 1/64 states; prefix lengths
0/64/1024/2048/16383/16384; fresh or after hashing 64 KiB then resetting;
plain/keyed/derived modes. Prefixes arrive in 17-byte pieces, exercising both
unstaged and pending-stage states, including nearly full stages.

Four separate measured operations:

1. ordinary `clone()` into a slot;
2. ordinary clone + append/finalize;
3. existing `clone_from` into a reusable slot;
4. in-place checkpoint + append/finalize.

All comparisons are direct baseline → selected head, four fresh private source/
target builds and layouts, adjacent executions with alternating order, host lock
**before preparation through verification**, and hash-pinned script/manifests.
Shared paired judgments: **3% practical margin / 5% FDR**.

| Operation, all four hosts | Wall Faster / Level / Slower | All five metrics F / L / S |
|---|---:|---:|
| ordinary clone | 0 / 288 / 0 | 0 / 1440 / 0 |
| ordinary clone + branch | 0 / 288 / 0 | 0 / 1440 / 0 |
| in-place copy | 251 / 37 / 0 | 1179 / 189 / 72 |
| in-place copy + branch | 239 / 49 / 0 | 1138 / 242 / 60 |
| total | 490 / 662 / 0 | 2317 / 3311 / 132 |

**The 132 Slower metrics are retained Ice Lake instruction costs**, not runtime
or energy losses. For the shown 64-state/64-byte-prefix case:

- in-place copy: **78.7108 → 292.7035 instructions/state**, +272%;
- checkpoint/append/finalize: **1231.7113 → 1445.7045**, +17.4%;
- wall/CPU/cycles/package energy are Faster in both cases, as shown above.

Less memory-copy work and lower time/energy do not imply fewer retired
instructions. Pinned assembly establishes copy lengths and transport, not a
cache/aliasing cause. The particular libc instruction sequence and why the
counter trade-off differs by CPU remain a scoped profiling question.

**[Follow-up #282, assigned to Sam Shackleton](https://github.com/servil-software-factory/BLAKE3/issues/282). Explicit acceptance pending.** The instruction cost
has exact reproduction, raw artifacts, attempted designs and a bounded next
investigation; it is not automatically vetoed or silently treated as noise.
The warm time/CPU/energy savings and unchanged ordinary-clone controls give the
context in which reviewers can judge it.

Current-head A/A: **all 2,880 metrics Level** on 9700X/Ice Lake with the four-operation
instrument. All arrays and outputs have one caller owner; no concurrent
false-sharing explanation is inferred from these timings.

## Correctness and deterministic avoided-write protection

Exact selected head: **191/191 tests each on four x86 hosts, 164/164 on ARM VM**;
serde/zeroize, no-default-feature build, 19 doctests and warnings-denied rustdoc
on all five. ARM VM is correctness/build coverage, not native timing.

The new targeted test builds real partial states from 17-byte arrivals, checks
lengths through two groups plus a tail, independent modes/keys and a pre-used
destination with a different key. It initializes only test fixtures' otherwise
unused source capacity to `0xbb` and destination capacity to `0xaa`:

1. call the public standard `clone_from`;
2. verify count, canonical destination digest, immutable source digest and live
   staged bytes against independent references;
3. require unused destination capacity to remain `0xaa`;
4. append another 129 bytes and check canonical/XOF output and source independence.

All test-only `assume_init` reads are over explicitly initialized canary bytes.
There is no new production unsafe operation. Reverting `clone_from` to its old
`*self = source.clone()` default preserves public values but overwrites unused
destination capacity. The pinned negative control passes the preceding canonical
checks and then fails **“unused stage copied at len=0”**. The expected-failure
control is VERIFIED; no timing assertion is used.

No assembly, proof model/harness or build-script bytes change. This is a safe
Rust state-copy optimization, not a new compression primitive or a claimed
formal proof of all Rust movement. Existing cryptographic contracts carry forward;
references, continuation, XOF, zeroize and feature/build coverage bind the new copy.

## Earlier by-value attempts: measured losses, not part of the candidate

- `ca749fe7490297fb86601cc7d586911e34385496`: initial live-prefix by-value clone.
- `ffe0a2a18b406f61a2b9f5fd8219ad1f6a5438ca`: retain cross-crate inlining.
- `527e9ba3c1eae0319290e51c72a2c1f3f65edf3e`: validate first and construct `Self`
  directly rather than through `from_core`.

These **lost badly** on the single-state and near-full-stage cases; Zen 3's
by-value clone/branch wall cells were all Slower. EPYC's few 64-state time gains
did not erase the other costs or the increased instruction counts.

Pinned code generation explains a concrete extra-work problem: old by-value
clone lowers to one 18,432-byte memmove directly between source/destination.
The prefix prototype uses about 35 KiB of stack and copies the live prefix,
1,984 core bytes, a **16,448-byte aggregate**, and a final **18,432-byte result**.
There are **no `from_core` call sites**, so an initial helper-noninlining hypothesis
was wrong. Prevalidating a direct `Self` construction did not recover the timings.
The selected in-place trait override avoids that result-transport problem instead
of adding unsafe placement machinery or a new API.

Raw record: [`clone-checkpoint/`](clone-checkpoint/), **21 VERIFIED runs**, including
all slower source alternatives, manifests, instruments, comparisons, A/A,
correctness, expected negative control and pinned code-generation inspection.
A VERIFIED run can contain Slower verdicts; those are not relabeled FAILED or
removed from the record. No executables are published.

## Integration boundary

This is independent of draft #281's heterogeneous held-parent work. The pending
#267/#279 convenience-Hasher migration owns naming, length hints, public contract
and eventual representation decisions. Copy/checkpoint behavior belongs to that
convenience contract; this candidate changes only an existing standard trait
operation on its measured representation. John should decide its fit as that
representation evolves. Nothing creates an API merely to preserve this result.

John Servil: independent design/cost/migration-fit review and integration. Sam
Shackleton: implementation, evidence and owned instruction-cost follow-up. Devon
Jonte: independent peer/Intel review. No merge, tag, release or crate upload.

— Sam Shackleton
