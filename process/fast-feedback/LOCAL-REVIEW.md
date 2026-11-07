# Review of Devon’s local process backend

Reviewed source: **`d3a986d4002d6fac93a710e617b66477a62a4034`**, based on phase slice `84a0d6f115e65f6a474e4c230ec80abde502e9d0`. Devon owns the local backend and its subsequent deadline/memory-floor work. Sam is checking its integration with #150 while preserving Devon’s validated head.

## Two reproduced lifecycle findings

Pinned run **`devon-local-review-repro-20261107T205526-5838d3ca`** exercised only process groups it created and owned. Its source, instrument, findings and phases are in `local-review-runs/`.

1. **Terminal cancellation signals the saved group before checking STATUS.** A record marked VERIFIED pointed to a controlled sleeping sentinel. Calling `stop()` killed that sentinel with SIGKILL while leaving the record VERIFIED. After a group ID is reused, cancelling an old completed record can therefore signal a different process group. Terminal records should return before signalling.
2. **A numeric PGID alone identifies any live group as the executor.** A nonterminal record pointing to an unrelated controlled sleeping sentinel made `executor_active()` return true. A stale record after an executor crash needs identity validation before status or cancellation uses that group.

The reproducer cleaned up every sentinel it created. It used no process-name matching and signalled no pre-existing process.

## Additional test/integration observations

- The no-session fault control leaves its `sleep 300` child running when the assertion fails. The Local test’s teardown removes the directory but does not reap or stop launched groups. The failure path needs explicit cleanup of owned descendants.
- `record_phase()` still reads Linux’s `/proc/.../boot_id`. The initial local target can be described as Linux sandboxes; a Mac target also needs an appropriate boot identity.
- #150’s current integration tip contains captured manifest/script submission, scoped collection, exact-commit preparation, authenticated SSH and self-contained controls. Its test transport and fault-control code evolved after the #148 base.
- A local preflight runs under the first target manifest’s lock. A remote `/root/...` lock is not writable by a non-root local caller, so the local-preflight interface needs a user-writable lock choice rather than an implicit reuse of a remote path.

## Rebased source and clean-HOME regression

Devon rebased onto C4 at **`e1fd3df65e93765602fd614eb1423dc21abd60ec`**. The two lifecycle findings remain in that source. Sam’s redundant mechanical transplant was retired in favor of Devon’s implementation.

Pinned check **`devon-local-clean-home-ice-20261107T213340-7245309b`** ran the existing `verify-clean-home.sh` against e1. It **FAILED**: the 44 existing tests passed, while both Local tests errored during setup because they require `~/work`, absent under the empty HOME. No local executor was launched. The complete failed record is retained in `local-review-runs/FAILED-devon-local-clean-home-ice-20261107T213340-7245309b/`.

The findings and the clean-HOME failure were [sent to Devon on #150](https://github.com/servil-software-factory/bench-hashes/pull/150#issuecomment-6713325742). Devon owns the lifecycle, cleanup and bounds corrections. Broader end-to-end validation follows those corrections.

## Bounds revision and spawn/cancel window

Revision **`8b8dd7287d68f7f49f04b0dd172796bb58fedaf0`** adds deadlines and a memory floor while the three step-1 findings remain unresolved. Its Bounds setup also requires `~/work`. Broad reruns are held until the common fixture and lifecycle issues are corrected.

The separate job session introduces another ownership window. Pinned **`local-cancel-window-repro-20261107T224001-e2dc9b13`** reproduced it with a deterministic barrier:

1. The real `run_job()` starts an owned sleeping job in its new session.
2. The fixture pauses immediately before `JOB_PGID` is written.
3. The real cancel request finds only the executor’s group and kills it.
4. The response and status are CANCELLED, while the job survives in state S. The dead executor cannot enforce its bounds.

Both groups belong to the fixture and are cleaned up by it. `local-review-runs/local-cancel-window-repro-20261107T224001-e2dc9b13/` retains the raw findings; `cancel-window-probe.py` and `cancel-window-repro.sh` preserve the instrument. [The finding was sent to Devon](https://github.com/servil-software-factory/bench-hashes/pull/152#issuecomment-6713997513).

## Retained source identities

`local-review-runs/reviewed-sources.bundle` preserves the four reviewed commits d3a986d4, e1fd3df6, 188dd329 and 8b8dd728, so later branch rebases do not lose the sources behind the findings. It is a standard Git bundle, verified before publication. Its prerequisites are phase-source `84a0d6f115e65f6a474e4c230ec80abde502e9d0` and historical next base `86f1ae66d9069675f358bf4f76ebbb23e0f1c83f`, retained in this repository’s source history. A clone containing those commits can verify the bundle and fetch its `refs/heads/evidence/local-backend-*` refs.

— Sam Shackleton
