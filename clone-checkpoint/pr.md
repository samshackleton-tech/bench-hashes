## Optimize existing in-place Hasher checkpoints

Override the standard `Clone::clone_from` default to copy the core and initialized
stage prefix directly into the destination. Preserve ordinary `clone()`'s old
infallible full-field copy. **No new API, type, storage, kernel, ABI, worker,
clock, buffering change or production unsafe code.**

Frozen head **`9c3618b0411e5f04a8373063ab253572af0584ed`**;
direct measured baseline **`f47d9e5d284aafcbabf7b6b2105bdedde4832261`** (#278).
Independent of #281 and the partial-XOF study; no composed performance ratios.

[Full report, raw records and slower by-value attempts](https://github.com/samshackleton-tech/bench-hashes/blob/8c1897140c431774852b1d64ab92d30244817237/IN-PLACE-CHECKPOINTS.md)
— **21 VERIFIED runs**, all16,954publicationpaths/sizes and exactreport/index/
inventorybytes remotelyverified. A VERIFIED run can include Slower verdicts;
those losses are retained, not relabeled FAILED.

### Work removed

```rust
let prefix = &source.stage[..source.staged];
self.core.clone_from(&source.core);
self.staged = source.staged;
self.stage[..prefix.len()].copy_from_slice(prefix);
```

The same-consumer pinned disassembly confirms old in-place18,432Bmemmove becomes
1,984 core bytes plus live staging bytes, without full result transport.
The roughly18KiBHasher/16KiBstage capacity remain unchanged. Actual native layout/
stride are logged; no cache/alias cause is inferred from timing.

Earlier by-value prefix-copy clones were slower: generated code copied the live
prefix,core,16,448Baggregate and18,432Bfinalresult through~35KiBstack. No
`from_core`call sites existed, so a helper-inlining hypothesis was wrong;
direct prevalidatedSelfconstruction did not fix it. This change avoids that
problem through the **existing in-place trait operation**, not unsafe placement
or a new public API.

### Measured checkpoint/append/finalize result

64 existing output slots, plain64Bprefix prepared once. Each operation uses the
same standard `clone_from` on both sources, appends17B and finalizes:

| Host | Copy alone ns/state old → new | Copy/append/finalize ns/state old → new |
|---|---:|---:|
|9700X|255.4462 →24.3591|364.7469 →142.9596|
|EPYC9255|317.5759 →30.2601|453.7496 →179.5964|
|Ice Lake6330|1446.4246 →79.7776|1559.5094 →260.7232|
|Zen3 EPYC7443|547.9347 →35.4631|683.0176 →160.6953|

**10.5–18.1× faster in-place copies;2.5–6.0× faster checkpoint/append/finalize**
in these cells. Prefix hashing/constructors/refs/slotallocation outside; actual
checkpoint/append/finalize inside. Not a claim that hashing the prefix from
scratch accelerates by this factor. Whole-package energy of the complete
operation falls22045→7486/34100→12656/143841→23199/47180→10478nJ/state.
RAPL includes package idle/background; wall/CPU/cycles/instructions separate.

72shapes/op/host:1/64states, prefix0/64/1024/2048/16383/16384, fresh or after64KiB
prime/reset,3modes. Four independent operations retain ordinaryclone and ordinary
clone/append/finalize controls. Four fresh private source/target builds/layouts,
alternating adjacent executions, lockbeforepreparationthroughverification,
clocks3%practicalmargin/5%FDR.

Allfourhosts: ordinarycloneandbranch **576wallcontrolsallLevel**. In-placecopy
wall251F37L0S;checkpoint/append/finalize239F49L0S. Total490F662L0S/1152wallcells.
CurrentheadA/Aall2,880metricsLevel on9700X/Ice.

### Retained Ice Lake instruction cost: acceptance pending

**[Sam-owned follow-up #282](https://github.com/servil-software-factory/BLAKE3/issues/282)**
contains reproduction/rawartifacts, attempteddesigns and a bounded next profiling
investigation. There are132Slowerinstructionmetrics onIce despite no Slower
wall/CPU/cycle/package cells. Showncase:

- in-placecopy78.7108→292.7035instructions/state,+272%;
- checkpoint/append/finalize1231.7113→1445.7045,+17.4%;
- completewall1559.5094→260.7232ns, package143841.4696→23199.1278nJ.

Less memory-copy work/time/energy does not imply fewer retired instructions.
The resolved libc sequences/counter behavior are a profiling question; not a
cache-cause claim or noise dismissal. My recommendation is to weigh this explicit
instruction trade-off against matching CPU/time/energy gains. **Acceptance is
still required**, not inferred from older approvals or the overnight task.

### Correctness and deterministic avoided-write control

Exacthead191/191tests each4x86,164/164ARMVM; serde/zeroize/no-default/19doctests/
warnings-deniedrustdoc all5. Modes/keys, zero/pending/nearfullstages, groups,
continuation and XOF checked independently. Source stays immutable; destination
starts pre-used with another key.

The new test initializes unusedsource/destinationstage to0xbb/0xaa, checks public
canonical values first, then requires unused destination bytes unchanged, then
checks append/XOF. Alltest-onlyassume_init reads coverexplicitlyinitialized
fixtures; nonewproductionunsafe. Reverting to `*self = source.clone()` preserves
public values but fails **“unused stage copied at len=0”**. The pinnedexpected-
failure control is VERIFIED, no timing assertion.

Assembly/proofmodel/harness/buildscript bytes unchanged. SafeRustcopy/indexing
is natively checked, not presented as a new formal Rust proof. Full standard
BLAKE3 rounds, modes, counters and digest/XOF semantics unchanged.

### Review and #267/#279 boundary

Targets`servil` with measured #278ancestry, but this private copying mechanism
has no dependency on the new SIMD additions and can be integrated independently
by John. No preceding review head is modified.

Copying/checkpointing belongs to the convenience contract in#267/#279. This draft
uses its pinned source's API spelling/representation and adds no new public
surface. John owns migration naming/hints/representation and should decide fit
as those evolve; callers/tests move together, not silently mixed benchmark
sources. No API is created solely to preserve this result.

John Servil: independent design/cost/migration-fit review and integration.
Sam Shackleton: implementation/evidence and#282follow-up. Devon Jonte: independent
peer/Intel review. No merge/tag/release/crateupload authorized or performed.

— Sam Shackleton
