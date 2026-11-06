# Specialized multi-buffer SHA-256 and shared-path checks

## Standard multi-buffer SHA-256 comparison

These are VERIFIED pinned runs, not a claim against every possible SHA
implementation. ISA-L Crypto source is **f22c49aef162d7632bde4f22dc7491b22f0a7fc2**,
using its public runtime-dispatched **standard SHA-256 multi-buffer context API**.
This does NOT use its different `mh_sha256` construction. BLAKE3-Servil source is
**e448e3ca1806c1a57f58c04f5ee0a7f274e8a7d3**, not the later bin-counting trial.

The ISA-L manager/context allocations and initial setup are outside the interval,
reused across calls, and flushed completely each batch. The timed adapter includes
submission, library padding/compression, completion handling and canonical32-byte
big-endian digest stores. B3 includes packing/padding and its32-byte stores.
Pointers/descriptors are ready outside the interval; input buffers are initialized
and64-byte-aligned for all contenders. Native ISA-L manager is848bytes/alignment16;
per-message context320bytes/alignment64. That footprint is part of this API, not
an assumed Rust layout. C assertions remain enabled; state-changing calls are not
hidden in assertions. All outputs are checked against independent references.

Four distinct code layouts, two process runs each (old/new are an A/A control
here, same source), algorithm order reversed between layouts. Clocks paired
judgments use3% margin/5% FDR. Raw ordinary RustCrypto sha2 0.11.0 is also retained.
Whole-package RAPL energy is not incremental core-only energy.

At1,024 ready messages:

| CPU / shape | ISA-L SHA ns/item | B3 ns/item | B3/SHA time | B3/SHA package energy |
|---|---:|---:|---:|---:|
|9700X64B|59.48|12.99|0.218|0.226|
|9700X1KiB|180.81|82.45|0.456|0.456|
|9700X mixed100–1,000B|122.04|68.25|0.559|0.557|
|Zen3 64B|72.43|32.93|0.455|0.448|
|Zen3 1KiB|330.34|208.89|0.632|0.657|
|Zen3 mixed100–1,000B|200.37|155.35|0.775|0.789|

All displayed cells are Faster. This materially narrows the large-message and
mixed-input advantage compared with the ordinary single-message SHA call; both
comparisons are kept. It is evidence of time and energy savings against this
specialized implementation, not a universal fastest-SHA claim.

## #259 shared paths: exact e448 source

Stable bench-hashes0.20.4, #2491ea61832 -> e448e3ca. Four independently built
layouts per side, eight paired runs, ST/MT at collection git/Nix, continuous
collection git/Nix, continuous64/256/512B/1KiB/64KiB, continuous batches16/1024,
batches16/1024 and unchanged hash/idle/lent controls; selected contention cells
included. This is scoped regress, not the retired broad check.

- EPYC9255: no cell slower.
- Ice Lake: no cell slower.
- Zen3: no cell slower.
- 9700X: one slower cell: **MT solo OneMessage1KiB +4.9%** (pairs+5.8,+6.6,+3.9,
  +4.5,+4.0,+0.7,+9.4,+4.7%). ST collection Nix is3.1% faster.

The slower cell calls the performance multithreaded API after other work: its
inappropriate cold pattern. Under #253 it is reported, not averaged away or used
to veto an intended warm-pattern benefit. The convenience API's intended cold
cells and the performance API's intended warm cells show no flagged loss in this
scope. This does not assert a causal explanation for an unrelated-path/layout
change from timing alone.

The first scoped attempts were marked FAILED because I left two stale provenance
expectations from the #237 manifest. Those were not promoted by weakening the
runner's status: expectations were corrected and all four machines rerun. The
published scoped records above are the corrected VERIFIED runs.

— Sam Shackleton
