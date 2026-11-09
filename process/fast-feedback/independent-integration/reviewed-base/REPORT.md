# Independent-key x86 checkpoints — November9,2026

Sam Shackleton. Overnight owner plan: [#325](https://github.com/servil-software-factory/BLAKE3/issues/325#issuecomment-6733102916),05:33–13:33UTC. John owns common allocation storage, native ARM/API/cost decisions; Sam the minimal independent-key x86 backend and validation; Devon source-ring/owned-batch work. These are personal review candidates; no organization merge or release.

## Sources

|Purpose|Exact source|Personal branch|
|---|---|---|
|Reviewed integration base|`0b5bf7b71cb5f850067fa4182d9a3c724d7e5710`|Owner confirmed; documentation child of6eef|
|Independent core|`62b75883dd752bad5b74195138e157349b830344`|candidate/sam-independent-reviewed-next|
|Shared startup fixture|`91d79d37d46e6116c12442673a6ba7c8f9f30a04`|candidate/sam-independent-startup; parent62|
|John's contiguous workspace|`bc235942421ab422b327035f7bece662c57f9840`|organization candidate/grouped-noalloc|
|**Composed flat-workspace candidate**|**`67a90f08b976c60bfcaa8e0a368324f4fb1e0a1b`**|**candidate/sam-independent-flat**|

67's parents arebc235942 and91d79d37. Its independent backend replaces just its two Vec initializers with the existing `crate::each::HeldWorkspace::<TABLE>::new(n)` and `buffers()`. The contiguous leaf/parent schedule and per-lane key/flag descriptors are unchanged. No in-stage scatter, extra workspace representation, state field, kernel, public API or ring/protocol change. John's workspace, safe input writer and ordinary-library allocator tests are byte-identical tobc235942. All-plain turns keep the public shared-IV path; keyed/mixed x86 turns use independent parent lanes; lower platforms retain public-mode cohorts. Held slices are bounded by existingTABLE128.600-state work controls expectceil600/128=5, still rejecting600singleton passes.

The shared workspace has two Block-aligned CV payload capacities64KiB+32KiB atTABLE128, with16n/8n CV slice lengths. Stack-frame/metadata overhead is additional. No key values/equality select storage size. The existing distinct-message-row witness now exercises plain, shared-key, distinct-key and mixed modes at2…257states, including127/128/129.

## Exact-source quality

|Source/run|Release/docs|Rejecting controls|Mutation baseline/result|
|---|---|---|---|
|62 / reviewed-independent-quality-epyc-20261109T055005-51b8611d|234/22|4backend/security +7source-status controls|0b5→62:106mutants,no new survivor,57s/60s|
|91 / independent-startup-fixture-quality-epyc-20261109T074814-cbe2dd5e|234/22|6backend/security/startup +7source-status controls|0b5→91:106mutants,no new survivor,57s/60s|
|**67 / flat-independent-quality-epyc-20261109T081138-28c1980e**|**236/22**|**9backend/security/workspace/startup +7source-status controls**|**bc235942→67:105mutants,no new survivor,56s/60s**|

All three runnerVERIFIED; formatting, no-default build and warnings-denied documentation pass.67's nine planted faults are equality-dependent grouping, hot allocation, valid secret-dependent AVX2/AVX512 routing, singleton backend, restored heap backend, corrupt wide startup output, corrupt eight-lane output, valid wrong-message parent rows and missing parent-buffer swap. Each rejects with the intended assertion; byte-exact source restoration and positive reruns pass. The allocation controls use the ordinary library's calling-thread allocation/reallocation/free meter, across first-post-setup and repeated complete cycles and fragmented table-boundary shapes. They report zero processing requests/frees for67. Common/native all-thread acceptance stays with John's corresponding work.

The source-status predicate checks tracked working/index changes and admits only actual mutator diagnostics under tmp/mutants-last and tmp/mutants-diff-XXXXXXXX/change.diff. Seven dirty-source/index/unexpected-file controls reject. Raw gitstatus remains recorded. The original artifact-wrapper failures are retained, not replaced by these fresh authorized validation items.

`proof-carry.json` and `proof-input-tree.tsv` establish complete protected proof inputs/driver identical to executed9bdfe0e9 proof run`independent-next-proofs-epyc-20261109T030828-19b408c7`: assembly/model proofs, output8/output16 and eight rejecting controls/native instruction-model cross-check. TreeSHA256`328038cb0cc3a4c88afe997045ce91c3927756d438a9bf0965a1c1cba95928b0`;BLAKE3`876a9fef60014bb98db18e1429de14c6db534e323bac0852ad10480541ffbfe8`. This carries identical proof inputs, not a new execution or a Rust ownership/dispatch/workspace proof.

## Startup fixture experiment —91, not a ratio composition

The existing fixture is constructed once. Wide output is checked before its storage is reused by the eight-lane kernel; that output is checked independently. Both corrupt-output controls and actual per-platform entry/count coverage pass. No cached/global fixture or skipped kernel. All timings below are direct comparisons,4private layouts/side,32adjacent alternating process pairs (8/layout), existing clocks wall/CPU/core cycles/instructions, unchanged Rust judgment rule. Both91 A/A studies have8Level cells. Already-initialized91 comparison cells are allLevel.

|First initialization|EPYC wall|Ice wall|EPYC instructions|Ice instructions|
|---|---|---|---|---|
|0b5→62, original added coverage|41.6206→45.9701µs,+10.4%**Slower**|79.0817→82.8819µs,+4.8%Level|+10.9%Slower|+14.5%Slower|
|62→91, isolated fixture reuse|44.0334→43.2594µs,−1.8%Level|82.6486→80.7617µs,−2.3%Level|−7.0%**Faster**|−8.9%**Faster**|
|0b5→91, remaining total cost|42.9778→45.5003µs,+5.9%Level|79.8532→81.2445µs,+1.7%Level|+3.2%**Slower**|+4.2%**Slower**|

The remaining instruction costs and EPYC wall mean remain recorded for review. Level is not exact equality. Original and executing sampler copies, source identities, raw process rows, core/load diagnostics, rounding test and all judgments are included. `startup-executing.sh` SHA256`8e0b7795c98e60c4401af9096b6cae1e0b73995fd0eb976db4bd19f7cc6aad49`.

## Core62 complete-cycle evidence

Frozen sampler3a0595df, clocks9994de190259648ede82f7c5e4dbac4f1534a41d, next API contract;64shapes,4fresh alternating build/layout pairs on each dedicated host.16/32KiB messages in4KiB arrivals;2/8/16/17/24/128/512active and7/8/15/16among1024open. Constructor/key/data/caller-capacity preparation outside counters. Cycle includes refill, allocations, updates, output and reset; update excludes digest work; finish consumes64prepared cohorts once, energyNA. All original costs/abstentions are retained.

|Direct source comparison / complete-cycle wall|Ice plain/shared|EPYC plain/shared|
|---|---|---|
|a930b4c1→62 preservation|18Level /14Level|18Level /14Level|
|0b5bf7b7→62 recovery|18Level /12Faster+2Level|18Level /13Faster+1Level|

Preservation shared-cycle means99.8–100.9%Ice/99.0–102.6%EPYC of old; recovery−8.2…−2.0%Ice/−13.9…−3.3%EPYC. No Slower metric/phase. Each A/A320cycle+320update+256finish allLevel. These are62 results, not67 results.

`verify-counters.py` checked9,216diagnostic/TSVrows across these six runs: calls/items and P/E cycle/instruction sums match, finish64/energyNA, completed quiet logs. Cell identity includes shape **and active-item count**; sparse shapes intentionally share their open-count label. Observed nativeHasher size/stride18,432B, alignment64B; digest stride32B. One caller owns states/descriptors/outputs; these harness buffers have no concurrent sharing.

Ice's fresh62/a930 canonical run`reviewed-independent-canonical-ice-20261109T060136-b48aa4d6` isVERIFIED, actualcheck exit0, no named cellSlower/noLevel instruction movement>0.5%.25/272points,247unmeasured. Eight suspects receive64pairs=16fresh layouts/side×4runs. The log's64newbuilds wording counts repeated executable arguments; check.rs constants/each_run establish the layout count. The earlier cancelled69d Ice execution remains a separate retained partial.

## Current67 performance status

New67 A/A on Ice and EPYC isVERIFIED: each320cycle+320update+256finish **allLevel**,3,072diagnostic rows checked. Directa930→67 preservation,91→67 composition effect andbc235942→67 independent-backend recovery matrices are running. Their judgments are pending; none are inferred from62. Physical AVX2 and native ARM decisions remain separate.

## Retained stage experiment and operational history

Before the new handoff, personal41a7db35 composed b343ed4c with the stage-scatter backend.235release/22docs and seven controls passed; its mutation **failed104mutants/one new width-comparison survivor/97s over60**. The first driver attempt mistakenly selected a NEON-only startup test; one filter repair and the original failure are included. c2accbc6 removes the redundant platform predicate rather than exclude its survivor; same execution ultimately completes102mutants/no new survivor/53s,235/22/sevencontrols.

On reading John's stage hold, cancellation returnedCANCELLED; a fresh fetch subsequently showed the same c2 execution completedVERIFIED (jobexit0 and final phases). The cancellation snapshot is retained separately underCANCEL-RECEIPT-…, alongside final artifacts. The correction was [posted and GET-verified](https://github.com/servil-software-factory/BLAKE3/issues/325#issuecomment-6734806364). This branch remains parked and untimed. John's native stage-regression diagnosis and decision to replace it are preserved in coordination receipts.

The independent formal-tooling branch58aa5767 remains separate: exact-AST/shared-substitution controls and output proofs pass; no proof-speed result is claimed here. Stop owned long jobs by13:33UTC. No nativeMac/VM work or new rentals by Sam.
