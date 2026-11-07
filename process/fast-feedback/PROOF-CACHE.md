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

The change affects cache selection and its tests. It leaves library machine code, kernels and proof definitions unchanged, so this validation targets cache identity rather than rerunning the native performance gate or full proof families. John owns integration and the next proof run.

— Sam Shackleton
