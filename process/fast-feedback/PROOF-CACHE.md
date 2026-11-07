# Long-proof cache identity includes every checked generator

The same-quality reuse work in [#146](https://github.com/servil-software-factory/bench-hashes/issues/146) found a source-dependency gap in BLAKE3-Servil's long-proof cache.

At base `2843a43d2e4b603f7722e5d974337ce97690859f`, `tools/verify/long-proofs.sh` checks generated assembly against three generators, but its cache key names only the NEON generator. A generator-only change to `tools/gen_sme2_hybrid.py` or `tools/gen_x86.py` leaves that key unchanged. A matching prior record returns success before the generation-agreement command runs.

Candidate [`349bc152064388de20fd5ff6bcaea1e668d952d6`](https://github.com/samshackleton-tech/BLAKE3/commit/349bc152064388de20fd5ff6bcaea1e668d952d6) adds those two paths to the existing key and updates its description. The cache mechanism stays the same.

## Deterministic checks

`test_long_proof_inputs.py` executes the production script's actual key expression against real temporary committed Git trees. It derives the checked generator names from the generation-agreement command, then checks:

1. Each checked generator change invalidates the key.
2. Kernel, specification and proof-tool changes invalidate the key.
3. Identical source inputs and unrelated top-level documentation retain the key.

Pinned Ice Lake and ARM jobs both passed all three tests:

- `proof-cache-inputs-ice-20261107T193104-30ba129b`.
- `proof-cache-inputs-arm-20261107T193105-537311e4`.

The control restores the original key's missing dependencies in a temporary script. The generator test then fails specifically for **gen_sme2_hybrid.py and gen_x86.py**, on both hosts. The other two tests remain green. This demonstrates both the original gap and the test's ability to catch it.

Raw source/script identities, tests, control diff, phases and review summaries are in `proof-cache-runs/`. `proof-cache-check.sh` is the pinned instrument. It reads no credentials and posts no GitHub proof status.

The change affects cache selection and its tests. It leaves library machine code, kernels and proof definitions unchanged, so this validation targets cache identity rather than rerunning the native performance gate or full proof families.

John independently reproduced the three tests and integrated [#290](https://github.com/servil-software-factory/BLAKE3/pull/290) into `next` at **`31c11c254c3bce80ff2cd00543fd693f6969fb37`**. He owns the next proof run.

## Scope check: retain the existing mechanism

The existing production-key helper was applied to the last **50 first-parent transitions** ending at landed `31c11c254c3bce80ff2cd00543fd693f6969fb37`. **46 preserve the key**; the fifty target commits fall into five input classes. The four changed-input transitions touch proof tools, a NEON kernel/model, or the proof-driver/cache tests. [proof-key-history.json](proof-key-history.json) retains every commit, key and changed path.

These are compatibility opportunities under one fixed driver, not measured cache hits. A compatible verified record is still required. The result favors keeping the existing cache over building a per-case cache. Reproduce the metadata-only scope check with `python3 proof-key-history.py /path/to/BLAKE3-clone`.

## Executed-driver identity follow-up

The scope check also exposed a remaining input gap: the key includes the target commit’s copy of `long-proofs.sh`, while the executing caller can come from another commit. Changing that caller’s verification command with a fixed target commit leaves the old key unchanged.

Test-first source **`e922ef7c2d9674c12404ef7cc5c5e4a7585c57d2`** demonstrates the gap. Pinned `proof-driver-gap-ice-20261107T230531-b02fbfe1` **FAILED only the new caller-identity assertion**, while the three existing tests passed. The test changes a caller’s helper-verification command, leaves the committed target unchanged, and also checks relocation of identical caller contents.

Initial correction **`79c1389a5ca67798b4e4378c67b62b02f9da18da`**, in [BLAKE3 PR #293](https://github.com/servil-software-factory/BLAKE3/pull/293), adds the executing driver’s content digest to the existing key. Reading through stdin excludes its filename, preserving relocation reuse. The same cache record mechanism remains.

Its initial unit screen passed **four tests and two focused controls**, through exact-source preflight and fresh Ice Lake/ARM targets:

| Pinned run | Accepted→finished |
|---|---:|
| `proof-driver-check-ice-preflight-20261107T231138-e67ad464` | 2.057 s |
| `proof-driver-check-ice-20261107T231143-a6840a1d` | 1.810 s |
| `proof-driver-check-arm-20261107T231143-0a75fd56` | 3.423 s |

The controls omit generator dependencies or restore the caller-blind expression. Each fails its intended assertion. `proof-driver-runs/` retains the original failed case, passing targets, phases, identities and control diffs; `proof-driver-check.sh` is the instrument.

### Preserve the evidence associated with each input key

The broader check added a regression for two callers checking one target commit. Test-first source **`0c8d03a0e98e90997a8397d0ec3c79ae9da75a68`** ran seven tests: six passed and only the new log-preservation assertion failed. The old destination was keyed solely by target commit, so different input records would share and overwrite their logs. Retained FAILED record: `proof-log-gap-ice-20261107T233331-d8258679`.

Final review source **`53ddd2b33fa2801e3be34b577db881f7b60de432`** retains logs by **COMMIT-INPUTS** and updates cache-hit lookup to the matching prior directory. It keeps the existing three-line input-record format. The existing full-command cache-hit fixture now derives its fingerprint from the production expression instead of duplicating the old hash formula. Local HTTP/status sinks prevent real publication in these fixtures.

Final validation passed **seven tests and four fault controls**:

| Pinned run | Accepted→finished |
|---|---:|
| `proof-driver-logs-ice-preflight-20261107T234436-37d41817` | 3.556 s |
| `proof-driver-logs-ice-20261107T234441-93ffcef9` | 3.305 s |
| `proof-driver-logs-arm-20261107T234442-2e232ebf` | 5.514 s |

The extra controls restore the shared log destination or the wrong cache-hit lookup. The tests exercise the production destination assignment and cache-hit block, including carry-over to a newer target commit. Both failed regression cases and both validation stages stay in `proof-driver-runs/`. The final instrument is `proof-driver-logs-check.sh`; the earlier `proof-driver-check.sh` is retained unchanged.

The change leaves library code, assembly, proof definitions and verification commands unchanged. This is a cache-identity correction, not a new proof campaign. No long-proof status was posted. John owns integration and subsequent proof execution. The separate memory-aware scheduling experiment remains later work, after the local-runner lifecycle is correct and changed-proof work needs it.

— Sam Shackleton
