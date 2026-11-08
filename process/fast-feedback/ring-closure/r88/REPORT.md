# Ring source 88e215ed on Ice and EPYC: no named cell slower; a flaky allocation test fixed

John's exact source **88e215ed79065823a9dadd48fb0a0f4150743989** (`probe/ring-return-chain`, the worker copy chain removed) against next **fbfb319f3414ac7fac4b3d4bce266488a1fdee3b**. Every run holds its host's bench lock from preparation through verification; the two timing hosts ran nothing else meanwhile.

## Speed: both machines pass the 15 stream points

bench 7ea20449 `check`, unchanged, on the same 15 points as ddb7199d: continuous 64 B to 1 MiB, batches of 64 and 1024, both pipelined collections, and receiving at saturated, 2 µs and 20 µs. It measures st, mt and pipeline, over four fresh layout pairs, then 64 fresh pairs on eight suspects.

| Machine | First stage | 64-pair confirmation | Exit |
|---|---|---|---|
| Ice (dual Xeon 6330) | no cell slower; no instruction movement beyond 0.5% | **no cell slower** | 0 |
| EPYC 9255 | no cell slower; no instruction movement beyond 0.5% | **no cell slower** | 0 |

Ice's suspects included mt shared-one-cache continuous 64 B and 1 KiB, the shared scenario where ddb7199d was +3.2–4.3% Slower. On 88e215ed the confirmation judged no cell slower. That is this source's verdict; ddb7199d's retained regression stands as its own. 257 points stay unmeasured. Physical-i7 and Mac results are Devon's and John's.

Runs: `r88-gate-ice-20261108T164309-b6276709` (57 min), `r88-gate-epyc-20261108T164304-e96fb8de`.

## Correctness and mutation

The exact source on Ice (`r88-quality-ice-20261108T164307-8962d124`, **FAILED, retained**) ran 228 release tests and 21 docs, all passing, plus fmt, no-default and rustdoc. The delayed-copy control fails on the old reuse boundary, and the restored source passes. The mutation gate (37 mutants) **stopped**: one shard's unmutated baseline failed `resource_admission_allocates_nothing_when_ready_or_waiting` with 900 B.

The cause is the test's counter, not the ring. The counter sums every thread's allocations, and the harness's own threads allocate during the call:

- the original test failed **7 of 400** runs on the ARM VM (892 B);
- a diagnostic counting other threads apart found every excess byte there; the admission code allocated none;
- with each thread counting its own bytes, it failed **0 of 400** (#313).

Child **10454b8a822e307aca8a471d112acfe5a0fc8f97** (personal `test/sam-r88-x86-quality`) holds that test-only fix (3d26a42e) and the six GPU-only `take_run` rows for x86-64 that ddb7199d needed. On Ice (`r88-child-quality-ice-20261108T165031-989f4cf0`, VERIFIED): the same tests and controls pass, and the mutation gate reports 37 mutants with no new survivor, in 60 s within the budget. Runtime code and proof inputs are 88e215ed's.

## Safety audit follow-up

- **ARM VM** (`r88-audit-arm-20261108T164358-70eac117`):
  - #310: a repeated index x16 gives 15 empty-message digests on NEON.
  - #311: the C reuse behaves as on x86.
  - XOF reads across 2^64 bytes match official BLAKE3 1.8.7 in release, and both panic alike in debug, so no finding there.
- **Fixes offered, not landed**, each one commit on next and validated on the ARM VM with a failing control:
  - **3b5e049f** (#307): `Packed::new` without overflow. EPYC `check` on the three Merkle-leaf points: no cell slower.
  - **fc250d0c** (#308): private `Stream::open`. EPYC `check`: same code.

No landing, release or tuning by Sam.

— Sam Shackleton

## #312 fix, at John's request: grouping by public mode

John asked for the minimal exact-source remedy (17:22 UTC), so this joined the plan.

**Fix 9d620e4444cd9c0a4f1f7ad4404cfa4935c8d836** (personal `fix/sam-update-each-public-grouping`, one commit on next fd048373) changes how `hash_held` groups a turn's held hashers. The old code compared secret keys; now the plain hashers' groups hash together, since every plain key is the IV, and each keyed or key-derivation hasher's group hashes alone, through the same per-hasher route. No key value decides the work. A test-only pass counter (`Counted::HeldPass`) asserts this: three plain hashers take one pass, and three keyed hashers take three whether their keys are equal or distinct.

**Backport 6057c458f012611e37c456d67afbc3e8a632f9d9** (`fix/sam-update-each-public-grouping-main`, on main 6e0dffd3, released 0.8.0) is the same change, with the counter in slot 4.

**Correctness:**
- Ice (`fix312-quality-ice-20261108T174728-fff8df5a`): 228 tests, 21 docs, fmt, no-default, rustdoc pass. With the old key-equality partition restored temporarily, the new test fails at "equal keys take the passes distinct keys take". The mutation gate reports 2 mutants, no new survivor, 33 s.
- ARM VM: 202 tests with the control on next (`fix312-native-arm-20261108T174743-73d9d7af`); 163 tests with the control for the backport (`fix312-main-arm-20261108T174835-9de2765c`).

**Cost, whole-workload instrument unchanged** (`mixed-stage-costs.sh`, bench/clocks 9994de19, four fresh layout pairs, 3% margin with 5% FDR). Wall time is shown below; cycles, instructions and package energy are in the judgments. Pieces are 4 KiB; there are 2 to 512 messages of 16 and 32 KiB, plus 1024 open with 7 to 16 active:

| Workload | Ice complete cycle | EPYC complete cycle |
|---|---|---|
| plain | 18 Level | 18 Level |
| keyed, **one shared key** | **14 Slower, +3.7% to +15.0%** | **14 Slower, +6.7% to +24.5%** |
| keyed, distinct keys | 7 Faster, 7 Level (down to 83.3% of old) | 10 Faster, 4 Level (down to 83.8%) |
| mixed modes | 2 Slower (up to +3.6%), 16 Level | 7 Slower (up to +4.7%), 11 Level |

Update-only follows the cycle closely. Consume-once finish is Level everywhere but one Ice shared-key cell (+8.9%). The distinct-key gain comes from the old code's repeated partitions: each pass partitioned what was left, and distinct keys left all but one. The shared-key loss comes from parent calls no longer batched across hashers that share a key; this is the cost of the fix. Using the independent-key lanes (#281/#304, not on next) is the route John named to recover it.

Runs: `fix312-costs-ice-20261108T174729-dd7b8205`, `fix312-costs-epyc-20261108T174727-e3cd618d`; summary `fix312-costs-summary.tsv`.
