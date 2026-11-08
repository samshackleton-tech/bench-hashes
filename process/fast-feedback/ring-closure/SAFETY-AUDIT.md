# Cursory-reader safety audit — BLAKE3-Servil next, 2026-11-08

**Question:** what could harm users when a competent programmer reads the quick start, skims the API docs and makes ordinary assumptions?

**Source:** owner ring candidate **ddb7199d7f0b0f04390e923474b630ffc7ff2811**, whose public API matches next **fbfb319f3414ac7fac4b3d4bce266488a1fdee3b**. Exposure was checked against published 0.8.0 on main **6e0dffd37e04b01b80dc56eb833b00fc337b6873**. Every probe ran on the EPYC under pinned-run, separate from Ice's timing gate. Each probe states what it executes.

## Findings

| # | Finding | Harm | Released 0.8.0? | Evidence | Remedy (owner's choice) |
|---|---|---|---|---|---|
| [#307](https://github.com/servil-software-factory/BLAKE3/issues/307) | `Packed::new(count)` computes `count * N`, which can wrap; a huge count then allocates nothing | **Memory unsafety from safe code:** the safe `Deref`/`as_blocks` accessors build slices from that count | No (added Nov 7) | Release probe red; never dereferenced | `count.div_ceil(128 / N)`: Vec's own capacity check then rejects it (control green) |
| [#308](https://github.com/servil-software-factory/BLAKE3/issues/308) | Public safe `Stream::open` (doc-hidden) lets safe code `mem::forget` a stream, then free buffers its published tasks borrow | **Use-after-free from safe code** | **Yes** | Compile-only witness, never run | Make `open` private; its C-API reason is obsolete (control: E0624) |
| [#309](https://github.com/servil-software-factory/BLAKE3/issues/309) | `pipeline::Stream` holds borrowed `Batch<'a>`/`&'a mut` places; forgetting it ends the borrow while workers use them | **Use-after-free and writes into reused memory, from safe code** | No | Compile-only witness; the borrow checker rejects the control that finishes first | Scoped pattern as `throughput::stream`, or owned batch/places |
| [#310](https://github.com/servil-software-factory/BLAKE3/issues/310) | A repeated `finalize_each` index (a documented precondition, checked only in debug builds) | **Silently wrong digest** (the empty message's), but only off the AVX-512 group path, so tests can pass | Precondition is next's | Release: x2 gives 1 right and 1 empty digest; x16 on AVX-512 gives 16 right | Doc what a repeat produces, or a measured release check |
| [#311](https://github.com/servil-software-factory/BLAKE3/issues/311) | C `b3_hasher_finalize` doc says the hasher "holds no message", but it keeps its state | **Silently wrong digest:** update without `b3_hasher_new` continues the old message | No (0.8.0's finalize was `const` and repeatable) | Release: hash("abcxyz") where the doc suggests hash("xyz") | Write a fresh state after the read, or reword b3.h |
| [#312](https://github.com/servil-software-factory/BLAKE3/issues/312) | `update_each` groups held hashers with `==` on their secret keys | **Key-dependent timing:** an equality oracle, plus prefix leakage through the comparison; contrary to #267's contract | **Yes** | Source finding; no timing measured | `constant_time_eq`, document the timing, or group by public data |

The three memory-safety findings share a root: **memory safety depending on a destructor or a forgettable guard.** Safe Rust may leak anything, so a sound API cannot rely on `Drop`. The scoped `throughput::stream` already solves this, and its scope ends only after the work is done. That suggests a quick check for every public type holding borrowed work: can safe code forget it?

## Checked and found adequate

- **Uninitialized use:** every call before `initialize` fails stop (`Platform::detect`); multithreaded calls before `initialize_multithreaded` panic; after `fork`, pool calls panic with the reason.
- **Rust `Hasher::finalize(self)`** consumes, so finalize-twice and update-after-finalize cannot compile. `finalize_each` resets each hasher, as documented.
- **Length and range arguments** (`hash`, `submit`, `hash_each`'s `len`, a `fill` returning 0 or too much, `update_each` indices) fail stop via slicing or explicit assertions.
- **Secret handling:** `Hash` comparisons are constant time; `Hasher`, `OutputReader` and `Mode` print no secrets in `Debug`; `Zeroize` on `Hasher` clears its 16 KiB stage too. Only `Hash` derives serde.
- **C API** checks alignment, ranges and simple overlaps, and states the remaining caller obligations.

## Accepted sharp edges, recorded as they stand

- **Recycled stream rooms** may hold bytes from an earlier stream on the same thread; a `fill` that reads before writing sees them. Reproduced again here. Zooko decided to document this, and the docs say so (#161).
- **A panic inside a stream aborts the process**, including one from the program's own `fill`, reader or handler; `catch_unwind` recovers nothing. The docs say so in bold. A server whose input parser panics inside `fill` loses the whole process, so parse errors belong in `submit_reader`'s `io::Error` path.
- **A borrowed `Batch`'s `message_mut` copies its blocks** first; writes then miss the caller's mapped data. This is documented.
- Residue after `finalize`/`reset` (stale stage bytes, a C hasher's key) matches official BLAKE3's model; `Zeroize` is the documented remedy.

## Method and limits

The probe crates use only public APIs. The memory-safety witnesses are **type-checked and never executed**: no dangling task, invalid slice or freed-buffer access ran. Each remedy control applied one temporary edit, restored the source byte for byte, and checked the tree clean. Wrong-result probes executed ordinary calls in release builds. The audit has no fuzzing or Miri run, no timing attack, and no review of the AArch64/SME2/GPU-only paths beyond source reading. Assembly proofs remain separate from these API properties.

Pinned runs (all VERIFIED as specified; the capacity probe's expected assertion failure is retained):
`safety-cursory-probes-epyc-20261108T144442-53674417`, `safety-remedy-controls-epyc-20261108T151055-39c3ef8e`, `safety-pipeline-forget-epyc-20261108T151306-ef36c9f7`, `safety-duplicate-index-epyc-20261108T151426-3663d140`, `safety-capi-reuse-epyc-20261108T151551-cecf68fe`.

No library change, landing or release by Sam. John owns API and release decisions, including any advisory for 0.8.0 (#308, #312).

— Sam Shackleton
