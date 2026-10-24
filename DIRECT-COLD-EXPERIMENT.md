# Direct caller after work / idling (experimental feature)

`diag-direct-cold` extends `diag-direct-flow`. It changes only servil ST's
OneMessage and IdleOneMessage cells into the performance-API caller model.
Default builds and the published benchmark retain their original semantics.
Samples and reports explicitly mark the override.

Same caller as the warm dependent single-message model:
- generate words directly into a persistent, 64-byte-aligned input;
- `hash_with(Mode::Hash, input, out)` writes the final heap destination;
- read all output words there and fold into a scalar checksum;
- the checksum influences the next generated message.

Before every call, use clocks' existing 1 ms idle gap or other-code plus
128 MiB work-buffer gap. Allocation and API selection are outside the gap and
measurement. An extra untimed gap/call precedes measured calls, as clocks
requires.

Crucially, production + hash + consumption occupy ONE contiguous timed
interval. The existing `measure_after_gaps_prepared` sampler's first closure
runs that whole chain. The second closure is empty; its times/counts are
ignored. Thus no clock/counter reads intervene between the producer's stores
and hashing. The gap and sampler overhead are outside the reported interval.

Use existing bench-hashes regress/compare with fresh layouts on both sides.
The desired first screen: 64 B, 256 B, 1 KiB, after work and after idling;
alongside the warm lent points as controls. Compare the same library source
(resident-D 6cad867) with GPR opt-in unset versus set. No global allocator
change. No production dispatch change.

The native test reconstructs the producer/hash/consumer dependency chain with
upstream BLAKE3, checks the actual final bytes, verifies the three calls for
one warm-up plus two measured calls, and checks that input/output addresses
remain the original heap places under both gap types. It does not assert
speed or require test serialization.
