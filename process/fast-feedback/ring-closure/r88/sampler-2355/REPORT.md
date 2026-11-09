# Shared mixed-stage sampler preparation

Requested by John on #312 comments 6728667307 and 6728948252. This is a bounded update to the existing sampler, not a new measurement workflow. Prior evidence at 4f4cef041be8af174aaa002862b68c6c1d3c369d and all later source-specific studies remains unchanged.

**Both API families pass x86 compile/preflight controls. ARM-wrapper setup failed and is stopped; no ARM/Mac compile or timing verdict is claimed. No new timing measurements requested or launched.**

Canonical local instrument: `/home/samshackleton/blake3-reports/optimization-resume-20261108/mixed-stage-costs.sh`. `mixed-stage-costs.sh` here is its byte-identical immutable distribution snapshot. Original and revised versions are archived under executing-instruments by SHA-256.

Changes:
- `API_FAMILY=main|next` selects `main-api` or `next-api` at compile time. Exactly one feature is required. The sampler records the selected contract on stderr. Main explicitly resets after the immutable finalize_each, inside cycle/finish work; next adds no reset. Update retains its existing timed pre-update reset.
- P/E-kind time_ns, cycles and instructions are emitted on stderr after counters close. Consume-once finish accumulates those same counter deltas across its 64 prepared samples. Missing counters are NA, not a false zero. TSV columns remain unchanged.
- The existing clocks::load quiet wait and final busy-window abstention now live in the shared Rust body. Preflight skips waits and timing; it still checks every canonical digest/reset invariant.
- The judge displays four-decimal per-item means using checked integer rounding. Existing cases, discovery inputs and discoveries(&cells,50,30) are unchanged.

The adapter should extract the existing PROBE_EOF/JUDGE_EOF bodies unchanged, supply both Cargo feature declarations, select exactly its API family's feature, and remove its old source-injection logic. The Linux shell wrapper retains its historical default API_FAMILY=next; the compile-time selection is recorded in identity.txt as well as sampler stderr.

## Exact source and validation

Shared instrument SHA-256: **3a0595df2a83d2c2c42b5decf50ebad56449f26d82721ac3c32ba89cdd3782cb**. Immutable source distribution is commit **c2308172c419a131a148a1fe49ea3afa2e611a6f** of personal bench-hashes, path `process/fast-feedback/ring-closure/r88/sampler-2355/mixed-stage-costs.sh`. SHA-256 and BLAKE3 are paired in executing-instruments/SUMS.tsv.

Pinned clocks/benchmark: **9994de190259648ede82f7c5e4dbac4f1534a41d**. Compile/preflight sources follow John's request:
- Main family: published **6e0dffd37e04b01b80dc56eb833b00fc337b6873** and released composition **7b1ba7b9da67e61dd53010de2054edfa32035170**.
- Next family: **a930b4c1a7ac94a77b6decd4a5bfd710391286b6** and **6eefdc657effe6002f9a001fccac9306699b3911**.

Successful runs:
- `shared-sampler-main-preflight-ice-tools-20261109T001113-480995be`
- `shared-sampler-next-preflight-ice-tools-20261109T001116-4dec3dc1`

Each compiles both library sides and executes all 64 cases/three phases in correctness-only preflight. Stdout contains the original header only, no speed rows. Stderr records the exact API contract and 192 P/E diagnostic rows with NA counters, including 64 finish rows. No waits or timing occur in preflight.

Controls:
- Missing API feature and both API features fail compilation at the explicit contract-selection error.
- One wrong oracle digest is rejected in forward order at `update canonical digest`, and reverse order at `consume-once finish canonical digest`. Source is restored byte-for-byte, rebuilt, and the full reverse preflight passes.
- The integer-display nextest test passes (thirds, half rounding, carry, u64 maximum).
- Original and revised judges consume the same frozen four-pair samples from the earlier independent-plain EPYC run. All cell identities, ratio_permille and verdict columns match across update/cycle/finish; only the two per-item display columns may change. Case loops and discovery-input/rule source statements are also byte-identical. This is an offline rule-control, not a new measurement.

P/E numerical accumulation and busy-window behavior compile but are not dynamically timed in this preparation. Native Mac execution and acceptance remain John's responsibility.

## Retained setup failures

The first four jobs stopped before sampler execution with **b3sum: command not found** (exit127). The preflight driver now installs official b3sum1.8.7 in its private run root; both driver versions are retained. The x86 retries above then passed.

Both ARM VM retries stopped during the historical Linux wrapper's identity header: it requires `/proc/cpuinfo`'s x86 `model name` field. The captured identity contains date/uname only; no Rust body compiled or executed. These are setup failures, not Rust correctness results. As agreed, a second setup failure stops this item: no third ARM attempt or quiet-window measurement was launched. The Mac adapter extracts the Rust bodies rather than invoking this x86 shell header; its compile/preflight remains open.

All failed records remain under runs/FAILED-*. No library source, public API, release or statistical discovery rule is changed.
