# Compact AVX2 finishing parameters

Measured source **fc6578594928499ec6f4299913d10d8fee81e710** versus936b8ec6.
The exact same tree was promoted to draft#259 at
**1fb068fe77dc571ec47241753a0c35663b514c2f** (empty git diff verified).
Not a release or merge.

## What becomes smaller

The last-only AVX2 ABI shrinks2,304→768bytes. H/SNAP lead the aligned block;
input/padded-last pointers, one common key/mode, one last length/ending per lane
follow. IV/rotation constants are immutable code-image data; the zero counter
and each step's length/flags are produced by the kernel rather than16caller-built
tables. Equal/mixed kernels share one Rust builder. Compared with936:

- Rust wrapper81added/180deleted, net99lines fewer.
- Generator74added/18deleted; proof initializer11added/26deleted.
- This linked probe's.text673,100→668,656bytes,4,444bytes smaller. Not a promise
  of identical byte savings for every consumer.
- The old partial-family assembly still regenerates byte-for-byte unchanged.

Parameters and last-block scratch are owned by the calling thread; H/SNAP rows
are naturally32-byte aligned. Static constants are read-only. No shared mutable
counter or cache-line ownership mechanism is introduced. Reduced footprint is
measured/layout-checked, but elapsed-time changes alone are not a cache-cause
proof.

The first compact trialad268bfb used mixed per-lane metadata work even for equal
prefix steps. Its Zen3 matrix had57slower wall cells and was NOT promoted. The
second uses the equal kernel's common ending to avoid those compares/blends on
prefix steps. Both trials' raw records remain.

## Results and scope

Zen3/EPYC7443, four fresh paired layouts,168shape/countcells, clocks3%margin/5%FDR:
**37faster,131level, zero slower wall cells**. At1,024×64B:

| metric/item |936baseline|compact|paired ratio/verdict|
|---|---:|---:|---|
|wall|32.939ns|29.949ns|0.909,Faster|
|processCPU|32.941ns|29.943ns|0.909,Faster|
|instructions|461.453|459.977|0.997,Level|
|whole-package energy|2,177.592nJ|1,965.598nJ|0.903,Faster|

Mixed100–1,000B is148.06→145.15ns (0.980,Level),1KiB208.99→207.42ns
(0.993,Level). Do not claim a large instruction-count or mixed-input win from
this change. The AVX512 path is unchanged; ordinary dispatch on those machines
is NOT an AVX2 timing result. Four-machine scoped shared-path936→fc checks,
including contention/unchanged-path cells, have no slower cell.

## Correctness and proof

- At the exact promoted1fb068fe tree, native187/187tests pass on9700X,
  EPYC9255,IceLake andZen3, and158/158on the ARMVM. All five also pass
  no-default-features builds, doctests and warnings-denied rustdoc.
  ARMVM is correctness/build evidence only, not timing.
- Corrected compact builds pass no-default-features, doctests, warnings-denied
  rustdoc. The first native attempts were FAILED due unused-import warnings;
  warnings were fixed rather than the runner's forbid rule weakened.
- Atfc657859, **32equal +32independently symbolic mixed-ending cases** pass,
  allK0..15 at8/16lanes, arbitrary keys/bytes/lastlengths/modeflags within the
  documented assembly contract. The compact ABI is initialized explicitly;
  padding is not invented as zero. This is not a formal proof of all Rust packing.
-46helpertests and all four planted-fault controls with positives pass.
-9700X model comparison: **392vector forms,110memory forms,200states each,
 28alignment fault controls; all agree**. No new instruction semantics were
 required for this compact format.
- Actual compact Rust blocks are inspected against their ABI rows before assembly
 changes H/SNAP; independent official-reference, mode/occupancy and guard tests
 remain. Standard full-round BLAKE3 digests/security semantics are unchanged.

The largest symbolic AVX2 case is slower to prove than before: the whole formal
matrix took about9minutes here. This is a recorded development cost, not a reason
to reduce the proof's coverage or call a timed-out run proved.

— Sam Shackleton
