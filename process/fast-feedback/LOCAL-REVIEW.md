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

The source has been read independently. The process lifecycle reproductions are the completed validation at this point; merging and broader end-to-end validation follow the lifecycle corrections.

— Sam Shackleton
