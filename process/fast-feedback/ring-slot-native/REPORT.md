# Independent native validation of John's ring-slot ownership fix

**[PR303](https://github.com/servil-software-factory/BLAKE3/pull/303), owner John Servil; [safety issue302](https://github.com/servil-software-factory/BLAKE3/issues/302).** One implementation, independently checked. Sam has added no competing ring design, queue policy or test hook.

## Exact identities

| Role | Full commit |
|---|---|
| John's checked candidate | **`cef8741e846669ef793fba0b4123c3531d89a233`** |
| Its reviewed foundation parent | `d4f675f4967317b41546e8c8309d35eb384cbbaf` |
| Frozen #277 integration before ring fix | `6e74ed36d683a634f193cb101cf26eaca72e0e3c` |
| Separate #277 integration plus identical owner fix | **`60a42e1e644aed262123ff5b285ac6812ea7e8a6`** |

The combined tree is personal ref`evidence/sam-small8-ringfix`, created by applying only John's commit to6e74. `src/lanes.rs` is byte-identical tocef8741e. No organization merge occurred; #295/#296/#299/#301 review heads remain frozen. Results for cef and60a are separate, not relabelled.

## Failure and fix

The original#296Ice run failed at `stream/receiver.rs:671`, **"a task claims one queued job"**, followed by PoisonError. [Original failed record and negative repetitions](https://github.com/samshackleton-tech/bench-hashes/blob/5b2e7261fd9c547333f2eff6de185044df55c0d2/process/fast-feedback/first-chunk-next/REPORT.md) remain unchanged. Devon traced the claim/copy interval and reproduced the crash by widening it; John confirmed the unsafe schedule and owns the fix.

A worker had advanced `claimed` before copying the ring Task. The producer used that advance to permit overwriting the slot. John's per-slot sequence now releases reuse after the CPU copy; GPU borrowed slots release after their callback. This is an ownership/safety correction, not a worker-count tuning experiment.

## Native results

Fresh outer-locked pinned checkouts/targets, full40hex input and instrument identities. Ice is the physical two-socket host that produced the original failure. ARM is a VM, supplying correctness/build coverage only. Both exact sources receive independent native targets; each also has an Ice captured preflight.

| Exact source | Ice release tests | ARM release tests | Doctests per host |
|---|---:|---:|---:|
|cef8741e |226passed/0skipped |201passed/0skipped |21passed |
|60a42e1e |228passed/0skipped |201passed/0skipped |21passed |

Nextest uses ordinary parallel settings; the complete doctest suite runs normally. Each target also runs the filtered `throughput::pipeline` doctest16extra times with unchanged pools. These are supplemental repetitions, not a serialized replacement for the full suite. Formatting/no-default/warnings-denied rustdoc also pass.

All native preflights/targets are VERIFIED. The deterministic positive schedule test pauses a real successful claimant before its Task copy, wraps the producer, checks that publication waits, then verifies exact task identities. Separate repeated1/2/3-slot wrap coverage passes in the full test suite.

## Deterministic red control

The script temporarily changes only the producer's sequence-wait condition tofalse, restoring the original unsafe reuse allowance in the owner's **unregistered-source schedule fixture**. It executes no task payloads and does not widen a production pipeline race. Channels order the producer write before the released claimant reads, so this control tests identity/ownership rather than relying on an unsynchronized stress crash.

On both architectures and both exact sources the control fails nextest100 at the intended assertion:

```
publication waits until the old task is copied
```

The script restores the exact text and verifies a clean input tree. The expected red result stays in `out/reuse-control.log`; whole jobs are VERIFIED because that failure is the specified control outcome. This is a focused fault control, not a mutation-tool campaign. John's separately running committed-source mutation study remains his evidence; his earlier zero-mutant uncommitted invocation is excluded.

## Scope and remaining gates

This validates CPU-native correctness for the named sources and confirms that the schedule test detects the old reuse rule. It is not a whole-engine formal proof, ThreadSanitizer result, GPU/Mac result or performance acceptance. The fix adds a per-slot atomic and producer/consumer synchronization; layout/footprint/performance costs need the owner's native gates. The sequence is intentionally shared by producer and consumer; no cache-line or scheduling cause is inferred from these test timings.

John retains the Mac GPU-borrow and performance gates/integration decision. Existing #268/#270/#300 resource/startup cost review and #299 physical AVX2 performance wait remain separate. Earlier#277 performance belongs to6e74, not60a; a safety patch can change native code/layout, so it is not retroactively assigned those measurements. No merge/release/tag/upload or multithreading tuning by Sam.

`ring-runs/` contains every preflight/native/expected-red record. `ring-owner-native.sh` and exact manifests provide reproduction, hashes and runner identities. No compiled binaries/private operator data are included.

— Sam Shackleton
