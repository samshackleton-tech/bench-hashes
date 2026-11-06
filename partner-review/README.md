# Partner review: #253 and #237

All measurements are hash-pinned VERIFIED runs; this directory contains the
manifests, raw outputs, scripts and paired judgments. The earlier load-invalidated
copy run `ring237-copy-20261106T065100-66e63a8b` remains FAILED on the runner and is
not used here. Queued repository preparation had run before its lock; pinned-run
now holds that lock from preparation through verification, with regression tests.

## #253: x86 check of cold-by-API

Ice Lake, stable bench-hashes 0.20.4, 6973611d -> 5d2778b9. Scoped ST/MT points:
64 B, 1/3/4/8/16 KiB; idle1/4/16KiB; lent1/4KiB; turn256; the selected cells'
contention placements. No cell slower, regress exit0. Not the retired full check.
ARM results are correctness/build evidence only, never QEMU timing evidence.

## #237: ring displacement

EPYC9255, 5d2778b9 -> 372ce8ce, same stable bench. Scoped stream/continuous
collection/batch gate: no cell slower, exit0. It flags five cells faster,
including solo1MiB -10.0% and shared-two-caches1MiB -16.2% paired time.

The separate copy driver uses CPU0's L3 domain, 4 distinct layouts, 32 independent
process pairs per main1/4MiB case; 8 per source-offset/output-padding control.
Results are aggregated within the 4 layouts for clocks::summary's equal-count
simultaneous judgment (3% margin,5% FDR). Raw per-process totals remain available;
no noisy processes are discarded. This is a different, restricted-affinity
workload from the scoped gate, not its substitute.

### Time, CPU work and energy are different

At1MiB, with caller SMT sibling24 excluded from affinity:

| metric/message | old | new | paired judgment |
|---|---:|---:|---|
|wall time|29.383us|28.228us|Faster, ratio0.961|
|process CPU time|119.504us|128.702us|Slower, ratio1.077|
|package energy|2.640mJ|2.598mJ|Level, ratio0.984|

Padded outputs retain the same pattern (wall~4% less, CPU~7.4% more, package
energy level). With sibling24 available, occasional slow processes remain in
both versions; their inclusion makes the aggregate main wall cell level.
At4MiB all wall/CPU/energy cells read level at this margin. Thus this record
**does not establish an energy saving or lower CPU work at1MiB**. It reports
wall improvement separately from the CPU regression.

### Layout/ownership and causal limits

- Source buffers are initialized,64-byte-aligned and read-only during the stream.
  The caller copies source bytes; workers read the library's distinct ring slots.
  Producer/consumer handoff is genuine sharing, not fixed merely by padding.
- Native Hash size32, padded wrapper size64/alignment64, with output addresses
  recorded. Distinct worker outputs can false-share a line when packed; the
  padded-output ablation changes that ownership and its footprint. It does not
  remove the base time difference or CPU increase, so output false sharing alone
  cannot account for them.
- In all32 main1MiB processes, ring-minus-source mod4096 is0 for old and1984 for
  new. With the source shifted2048, it is2048/4032. The source-offset control
  removes the old/new base gap. These observations are consistent with an
  address-relation effect, but timing alone is not proof of a4K alias mechanism.
- The affinity masks make CPU24 available or unavailable; they do not pin a
  particular worker there. Last-CPU snapshots show workers on24 in both versions,
  not how much time each spent there. Removing24 also changes available CPU
  count and therefore the default pool size. This is not a fixed-worker-count
  experiment isolating SMT placement by itself.

— Sam Shackleton
