# Exact frozen #259 head versus standard multi-buffer SHA-256

This is a **fresh direct study of frozen `1fb068fe`**, not the earlier `e448e3ca` study and not a product of incremental ratios. No source changes to #259.

Identities:
- BLAKE3-Servil: **1fb068fe77dc571ec47241753a0c35663b514c2f**.
- ISA-L Crypto: **f22c49aef162d7632bde4f22dc7491b22f0a7fc2**, standard public runtime-dispatched `sha256_mb` interface (`isal_sha256_ctx_mgr_*`), **not `mh_sha256`**.
- RustCrypto ordinary SHA-256: `sha2` **0.11.0**, measured alongside both.
- Shared clocks/analysis source: bench-hashes **96ea60d8648ead2940699d2723173be8555b4097**.

## Workload and interval

Ready, aligned byte-identical message views, fixed lengths 0/1/64/256/1024 B and mixed 100–1000 B, at 2/4/8/16/64/1024 messages: **36 cells per host**. Four independent builds/layouts; algorithm order alternates by layout, with repeated old/new-labelled executions serving as A/A controls rather than different library sources.

Reusable ISA-L manager/context allocation and initialization are outside the interval. Submission, library padding, compression, completion/flush and canonical 32-byte digest stores are inside. BLAKE3 descriptors and source blocks are likewise ready outside the interval; this is not an ordinary-byte caller conversion study. BLAKE3-Servil answers are checked against official `blake3` 1.8.7; ISA-L answers are checked against ordinary `sha2` SHA-256, which is also the reference comparator. Canonical output stores are checked after each timed algorithm. Native context/manager sizes and alignments are in the raw stderr logs (context 320 B/alignment 64, manager 848 B/alignment 16).

## At 1,024 ready messages

Ratios are **BLAKE3-Servil / ISA-L standard SHA-256**, paired clocks judgments, 3% margin / 5% FDR. Lower is better.

| CPU | Wall: 64 B / 1 KiB / mixed | Process CPU: 64 B / 1 KiB / mixed | Package energy: 64 B / 1 KiB / mixed |
|---|---|---|---|
| 9700X | 0.217 / 0.457 / 0.527 | 0.217 / 0.457 / 0.527 | 0.226 / 0.454 / 0.521 |
| EPYC 9255 | 0.213 / 0.454 / 0.521 | 0.213 / 0.454 / 0.521 | 0.218 / 0.452 / 0.519 |
| Xeon 6330 / Ice Lake | 0.267 / 0.467 / 0.536 | 0.267 / 0.464 / 0.539 | 0.266 / 0.465 / 0.537 |
| EPYC 7443 / Zen 3 | 0.423 / 0.631 / 0.727 | 0.423 / 0.631 / 0.727 | 0.429 / 0.655 / 0.748 |

All listed cells are Faster in these measurements. **Package RAPL includes physical-package idle/background costs, not incremental core-only energy.** CPU, wall, hardware counts and energy remain separate in the raw data.

## Small supplied batches are not a universal BLAKE3 win

Wall comparisons across all 36 cells:

| CPU | B3 vs ISA-L: faster / level / slower | B3 vs ordinary sha2: faster / level / slower |
|---|---|---|
| 9700X | 32 / 0 / 4 | 27 / 3 / 6 |
| EPYC 9255 | 32 / 0 / 4 | 27 / 4 / 5 |
| Ice Lake | 36 / 0 / 0 | 28 / 7 / 1 |
| Zen 3 | 20 / 3 / 13 | 26 / 2 / 8 |

For example, mixed two/four-item batches on 9700X are about **1.62/1.42× ISA-L time** and **2.42/2.11× ordinary sha2 time**. Zen 3 also loses several small uniform cells. The full per-cell wall/CPU/instruction/energy judgments remain available; these losses are not averaged into the 1,024-item result or dismissed as cold misuse. These are comparisons between algorithms/APIs, not new baseline-to-candidate regressions.

ISA-L is a materially tougher comparator for the larger/mixed ready batches, but is not uniformly faster than ordinary SHA-256 in every cell. This is **not universal fastest-SHA evidence**, a hardware-independent ranking, or an instruction to substitute protocol digests/MACs.

## A/A controls and provenance

All four native requests VERIFIED, with complete identity/output checks. A separate immutable-data pinned analysis checks **each algorithm’s A/A family separately**: 36 cells × 5 metrics = 180 judgments per algorithm/host, **12 families total; all 180 are Level in every family**. The analysis compiles fresh shared-clocks code against a full commit, reading raw samples from immutable data snapshot **6732bee49b4d951ac1ff04da0486465c6dba7b50**. It is statistics over native samples, not a new timing run.

Raw records: `frozen-multibuffer-runs/`; A/A analysis record: `frozen-multibuffer-analysis/`. Scripts/manifests: `scripts/frozen-multibuffer-*`, `mb-matrix.sh`, `mb-final-aa.sh`, `aa-judge.rs`. Raw ISA-L build-log trailing spaces are deliberately retained, not rewritten to appease whitespace checks.

Native requests:
- `frozen-multibuffer-9700x-20261106T130222-59492985`
- `frozen-multibuffer-epyc9255-20261106T130223-44936c37`
- `frozen-multibuffer-icelake-20261106T130224-9954f36c`
- `frozen-multibuffer-zen3-20261106T130225-f1ede6cc`

Analysis: `frozen-multibuffer-aa-20261106T130902-1a096e3e`, VERIFIED. No failed or load-invalid native request was relabeled to produce this table.

— Sam Shackleton
