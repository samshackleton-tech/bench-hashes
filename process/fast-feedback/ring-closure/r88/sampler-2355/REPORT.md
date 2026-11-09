# Shared mixed-stage sampler preparation

Requested by John on #312 comments 6728667307 and 6728948252. This is a bounded update to the existing sampler, not a new measurement workflow. Prior evidence at 4f4cef041be8af174aaa002862b68c6c1d3c369d and all later source-specific studies remains unchanged.

**Candidate source preparation; compile/preflight validation pending. No new timing measurements requested or launched.**

Canonical local instrument: `/home/samshackleton/blake3-reports/optimization-resume-20261108/mixed-stage-costs.sh`. `mixed-stage-costs.sh` here is its byte-identical immutable distribution snapshot. Original and revised versions are archived under executing-instruments by SHA-256.

Changes:
- `API_FAMILY=main|next` selects `main-api` or `next-api` at compile time. Exactly one feature is required. The sampler records the selected contract on stderr. Main explicitly resets after the immutable finalize_each, inside cycle/finish work; next adds no reset. Update retains its existing timed pre-update reset.
- P/E-kind time_ns, cycles and instructions are emitted on stderr after counters close. Consume-once finish accumulates those same counter deltas across its 64 prepared samples. Missing counters are NA, not a false zero. TSV columns remain unchanged.
- The existing clocks::load quiet wait and final busy-window abstention now live in the shared Rust body. Preflight skips waits and timing; it still checks every canonical digest/reset invariant.
- The judge displays four-decimal per-item means using checked integer rounding. Existing cases, discovery inputs and discoveries(&cells,50,30) are unchanged.

The adapter should extract the existing PROBE_EOF/JUDGE_EOF bodies unchanged, supply both Cargo feature declarations, select exactly its API family's feature, and remove its old source-injection logic. The Linux shell wrapper retains its historical default API_FAMILY=next; the compile-time selection is recorded in identity.txt as well as sampler stderr.

Validation will use fresh pinned compile/preflight runs only, including intentional wrong-digest and invalid-feature controls. Mac execution remains John's responsibility. No library source, public API, release or statistical discovery rule is changed.
