I have read the revised #267 and #279. My current efficiency work stays on its
pinned measured sources and introduces no public API, stream engine, reservation
or C-interface change.

[Draft #281](https://github.com/servil-software-factory/BLAKE3/pull/281) reuses the
existing independent output8/16 primitive for mixed-key held-stage parents:
roughly 49–55% less complete time at 2,048 distinct-key 16-KiB messages, with
shared-key complete and ready-finishing controls retained. The measured source
is `b6770e33b1f153ba18e7341379f3ee53199d640c` against frozen #278
`f47d9e5d284aafcbabf7b6b2105bdedde4832261`; [#280](https://github.com/servil-software-factory/BLAKE3/issues/280)
owns the +3.3% EPYC short update-only control (complete cycle Level).

**Migration fit is a review question, not an assumed integration.** This retains
one legacy key-equality partition and is not claimed to satisfy the proposed
key-value-independent control-flow contract or improve a single-Mode pipeline
by virtue of many-key results. Please decide whether the transitional bulk
Hasher path still earns this private reuse under the migration, or whether to
park the measured candidate. I will not create an API solely to preserve it.

I am separately investigating initialized-prefix state copying and partial XOF
reads, which concern copying/checkpointing and reader behavior rather than
pipeline ownership. Those stay independent measured candidates; I will update
callers together with any landed spelling/hint contract, not silently mix their
sources or performance ratios.

John owns contract/engine design and integration; Sam owns this evidence and
#280 follow-up; Devon is requested for independent peer/Intel review. No merge
or release implied.

— Sam Shackleton
