# Key-independent dispatch regression controls (#312)

## What is checked, and where

These are ordinary BLAKE3-Servil tests, not a new security benchmark or framework.

- `src/each.rs::held_dispatch_ignores_key_equality_and_prefixes`: hold lengths, modes, input bytes, input order and platform fixed; vary only keyed-mode key bytes. Compare actual cohort membership/order, existing assembly-entry sets, and held pass counts. Test-only cohort tracing is compiled out of normal library builds.
- `tests/allocations.rs::held_allocations_ignore_key_equality_and_prefixes`: compare calling-thread allocation requests and requested bytes in the actual non-test library. Caller constructors, key construction and descriptor capacity are prepared outside the counter. The reviewed caller-thread meter avoids harness allocations; a 4096-byte positive control checks both counters.

Each case uses identical keys or distinct keys matching exactly zero through seven leading 32-bit words. Counts 3/8/16/17/33 cover lane boundaries, in all-keyed and fixed mixed plain/keyed/derive modes. Two 16 KiB stages cover zero and nonzero chunk counters. Digests are checked against official BLAKE3 1.8.7. Unit tests force every locally supported platform; the allocation integration test runs the normally detected platform. Existing 600-hasher pass controls remain.

No locks, serial test groups, worker caps, timing thresholds or retries were added to the tests.

## Sources

- Held-stage candidate `cd2880f1d2f1a3d1d155877ce105b487ac6966b0` → test child **5bb5e5bd92d9127f287970eeb2493669e763e5cd**, personal `test/sam-key-independent-controls`, worktree `~/work/b3-key-independent-controls`. Intermediate `afda20d9` reuses the reviewed thread-local allocation meter.
- Main repair candidate `71154c1dc4661e7bfa30e89d8b434a9394f2feaa` → test child **4f9b6bb34fc0854f11c17ab218a11cba9eb1ca76**, personal `test/sam-key-independent-controls-main`, worktree `~/work/b3-key-independent-main`.

Both changes add tests and cfg(test) cohort observations only; they change no production grouping or cryptographic algorithm. No throughput improvement or exact release-binary identity is claimed for either test child. The pre-existing runtime mutation result belongs to its original source; no new production mutation verdict is claimed for these test-only additions.

## Rejecting controls

Each fault is planted with an exact replacement, rejected by nextest exit 100 at the intended assertion, then restored byte-for-byte. Restored focused tests must pass. These are correctness probes, not timing attacks or unsafe-memory witnesses.

1. **Secret-key grouping again:** equal keys share a cohort; otherwise use the original safe paths. All digests remain valid. SSE4.1 and NEON report different cohort memberships and pass counts when equal keys become last-word-different keys.
2. **Key-dependent allocation:** allocate an additional 32-byte vector when the first key's last word differs from the fixture's common word. The two-stage integration test reports exactly **64 extra requested bytes and two requests**, while the original grouping and digest remain unchanged.
3. **Wide-kernel selection, held-stage source:** the same grouping fault with the complete platform order reversed reaches AVX-512 first. Membership and pass count are identical on both key sets, but the kernel-entry sets differ; the new unit test rejects it. This is a targeted fault control, not removal of a platform from the suite.

Held-stage runs:
- `security-prefix-controls-ice-20261108T232700-e7a688f2`: **233 release tests / 21 docs**, fmt/no-default/warnings-denied rustdoc, both red controls and restored positives pass.
- `security-prefix-controls-arm-20261108T232701-71e45778`: **205 release tests / 21 docs**, same checks pass. ARM VM is correctness, not native speed.
- `security-wide-entry-control-ice-20261108T233220-21aecf1b`: positive / AVX-512 rejecting control / restored positive pass.

Main repair child runs:
- `security-main-prefix-controls-ice-20261108T233815-7ee6cb19`: **187 release tests / 20 docs**.
- `security-main-prefix-controls-arm-20261108T233816-42f9454e`: **167 release tests / 20 docs**.

Both pass fmt/no-default/warnings-denied rustdoc, the grouping and allocation rejecting controls, and restored focused positives. The allocated-byte/control deltas match the held-stage runs.

## Source and generated-code review

`security-release-inspect-epyc-20261108T232932-81a60b9f` captures rustc 1.99.1 release assembly and LLVM IR for exact 5bb5e5bd. Complete artifacts are `release.s`, `release.ll`; `held-functions.ll` contains hash_cohort and update_turn with hash_held/held_groups inlined.

The reviewed selector uses only public mode flags, detected platform, held indices/counts and stage/counter shape. Source copies each key into the compression inputs; it does not compare keys or derive cohort decisions from them. The generated IR agrees at the reviewed selection sites:
- `held-functions.ll` lines 1411–1416 load the public flags byte and compare it to zero for the wholly plain route.
- Lines 1431–1444 select the independent parent width by detected platform, not key bytes.
- `hash_cohort` lines 11–18 copy the 32-byte key and separately load flags/platform. Its allocation dimensions derive from cohort length.
- Lines 2690–2700 pass each message's key address to the existing full-chunk kernel; lines 2897–2910 select fallback cohorts by flags.
- No memcmp/bcmp or key-PartialEq call occurs in the extracted held/update functions. That absence alone is not a proof: a comparison could be inlined.

Native offsets in this artifact are compiler-specific; they are not a portable layout contract or a cache-causation claim. This is a bounded selector/dataflow review, not a formal taint proof, instruction-level constant-time proof, microarchitectural side-channel audit, or review of every GPU/SME2 path.

## Limits

A short-circuiting comparison with an unused result could escape every work-structure assertion. Equal entry sets do not prove identical instruction traces or identical entry invocation counts. Source/generated-code review remains necessary. Timing measurements do not certify this security property; bench-hashes checks the performance consequences separately. Adoption and integration remain with John; no merge or release was performed.
