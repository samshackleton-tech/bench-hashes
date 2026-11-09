# Independent-key x86 checkpoints — November9,2026

Sam Shackleton. Overnight owner plan: [#325](https://github.com/servil-software-factory/BLAKE3/issues/325#issuecomment-6733102916),05:33–13:33UTC. John owns common allocation storage, native ARM/API/cost decisions; Sam the minimal independent-key x86 backend and validation; Devon source-ring/owned-batch work. These are personal review candidates; no organization merge or release.

## Sources

|Purpose|Exact source|Personal branch|
|---|---|---|
|Reviewed integration base|`0b5bf7b71cb5f850067fa4182d9a3c724d7e5710`|Owner confirmed; documentation child of6eef|
|Independent core|`62b75883dd752bad5b74195138e157349b830344`|candidate/sam-independent-reviewed-next|
|Shared startup fixture|`91d79d37d46e6116c12442673a6ba7c8f9f30a04`|candidate/sam-independent-startup; parent62|
|John's contiguous workspace|`bc235942421ab422b327035f7bece662c57f9840`|organization candidate/grouped-noalloc|
|First flat composition, **held for costs**|`67a90f08b976c60bfcaa8e0a368324f4fb1e0a1b`|Archived immutable source|
|John's final-place child|`0e6d1ae701e3c7f4dfd07609c68a956abaae5b82`|Sharednew()/buffers(n) interface|
|In-place composition, measured Ice512 costs held|`3f1c24d82766b068f40d41a5b314cd5836e3fdcb`|Archived immutable source|
|John's typed-parent-row child|`f13933376c8b8236adaeffe6aa9d25ad25f2af24`|Same private workspace interface|
|**Current typed composition, whole-gate budget hold**|**`1cbdf5d72d70d8ed511870b18c7f017cce83da15`**|**candidate/sam-independent-flat; no timing claimed**|

67's parents arebc235942 and91d79d37. Its independent backend replaces just its two Vec initializers with the existing `crate::each::HeldWorkspace::<TABLE>::new(n)` and `buffers()`. The contiguous leaf/parent schedule and per-lane key/flag descriptors are unchanged. No in-stage scatter, extra workspace representation, state field, kernel, public API or ring/protocol change. John's workspace, safe input writer and ordinary-library allocator tests are byte-identical tobc235942. All-plain turns keep the public shared-IV path; keyed/mixed x86 turns use independent parent lanes; lower platforms retain public-mode cohorts. Held slices are bounded by existingTABLE128.600-state work controls expectceil600/128=5, still rejecting600singleton passes.

The shared workspace has two Block-aligned CV payload capacities64KiB+32KiB atTABLE128, with16n/8n CV slice lengths. Compiler-native layout is98,432B/alignment64 forcapacity128 and896B/alignment64 forcapacity1; payload capacities are not the whole frame. No key values/equality select storage size. The existing distinct-message-row witness now exercises plain, shared-key, distinct-key and mixed modes at2…257states, including127/128/129.

## Exact-source quality

|Source/run|Release/docs|Rejecting controls|Mutation baseline/result|
|---|---|---|---|
|62 / reviewed-independent-quality-epyc-20261109T055005-51b8611d|234/22|4backend/security +7source-status controls|0b5→62:106mutants,no new survivor,57s/60s|
|91 / independent-startup-fixture-quality-epyc-20261109T074814-cbe2dd5e|234/22|6backend/security/startup +7source-status controls|0b5→91:106mutants,no new survivor,57s/60s|
|67 / flat-independent-quality-epyc-20261109T081138-28c1980e|236/22|9backend/security/workspace/startup +7source-status controls|bc235942→67:105mutants,no new survivor,56s/60s|
|**3f1 / inplace-independent-quality2-epyc-20261109T092051-af575634**|**236/22**|**9backend/security/workspace/startup +7source-status controls**|**0e6d1ae7→3f1:103mutants,no new survivor,53s/60s**|

The four rows above are runnerVERIFIED; formatting, no-default build and warnings-denied documentation pass. The subsequent **1cbdf whole-composition gate** `typed-independent-final-quality-epyc-20261109T101205-5050a1dd` has236release/22docs/builds and all nine rejecting/restored controls, then **163mutants/no new survivor/72s OVER60**, baselineconfirmed0b5bf7b71cb5f850067fa4182d9a3c724d7e5710. Its runner is explicitly **FAILED for the budget hold**; the driver requireswithin60 and does not publish a final green status. The final source-status predicate was not reached after that hold; raw final gitstatus and all diagnostics remain. No green-seeking repeat.3f1's103/53s result is only the delta since0e6d1ae7, not this full gate.67's nine planted faults are equality-dependent grouping, hot allocation, valid secret-dependent AVX2/AVX512 routing, singleton backend, restored heap backend, corrupt wide startup output, corrupt eight-lane output, valid wrong-message parent rows and missing parent-buffer swap. Each rejects with the intended assertion; byte-exact source restoration and positive reruns pass. The allocation controls use the ordinary library's calling-thread allocation/reallocation/free meter, across first-post-setup and repeated complete cycles and fragmented table-boundary shapes. They report zero processing requests/frees for67. Common/native all-thread acceptance stays with John's corresponding work.

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

## Completed67 performance — held for priority-workload regressions

All eight67 matrices areVERIFIED, with12,288diagnostic rows checked. Both A/A studies have320cycle+320update+256finish **allLevel**. The valid measurements find real costs:

|Direct comparison / complete-cycle wall|Ice plain/shared|EPYC plain/shared|
|---|---|---|
|a930→67 preservation|16Slower/2Level, up+53.0%;12Slower/2Level, up+37.9%|13Slower/5Level, up+35.8%;9Slower/5Level, up+30.9%|
|91→67 composition effect|16Slower/2Level, up+54.7%;12Slower/2Level, up+38.6%|13Slower/5Level, up+35.1%;9Slower/5Level, up+23.2%|
|bc235942→67 independent-backend recovery|2Faster/16Level;5Faster/7Level/2Slower, up+25.0%|2Faster/16Level;12Faster/2Slower, up+4.4%|

Every Slower metric/phase cell, including finish/CPU/energy, is retained in `flat-cost-summary.json` and all judgment TSVs; `counter-integrity-flat-all.json` checks all rows. Distinct/mixed gains do not accept plain/shared losses. No canonical gate or adoption of67 is queued. The original exact62 and91 results above remain separate.

### Measured-source frame finding and new3f1 child

Pinned diagnostic`flat-native-layout-epyc-20261109T084828-bf5a8b26` compiles67 withrustc1.98.1 and-Zprint-type-sizes/emit-asm (RUSTC_BOOTSTRAP=1 for diagnostics, no timing). The native large workspace is98,432B; generated`flush_held` probes196,608B plus1,024B fixed subtraction and copies98,432B. Independent parent code is inlined into that caller. Genericcommon128cohort separately has a large return-copy frame. Raw layout and extracted Rust frames are included.

John's0e6d1ae7 initializes the same buffers/tables through their final places and separates common cohort frames. **3f1c24d8** merges that exact source and additionally gates the existing independent backend by public nonempty/ISA selection before entering its non-inlined workspace body. Its redundant empty/unsupported returns and boolean result are deleted; outerhash_held signature and key/flag/kernel schedule remain unchanged. Shared workspace/cohort/writer/allocation-test/ring code remains byte-identical0e6d1ae7. John's completed-turn observation is retained across all four row-test modes.

Pinned`inplace-native-layout-epyc-20261109T091733-98f224c0` confirms the same workspace sizes,`flush_held`'s fixed subtraction1,064B, and separate large native/common bodies. The98,432B copy setup is absent; the remaining native384B memcpy is the existing16-descriptor transfer. These are codegen observations. **3f1's eight complete-work matrices are finished**, not relabelled67 executions. Both A/A studies have896Level cells;12,288diagnostic rows check. All metrics/phases and every Slower cell are in `inplace-cost-summary.json` and `counter-integrity-inplace-all.json`.

|Direct3f1 comparison / complete-cycle wall|EPYC plain/shared|Ice plain/shared|
|---|---|---|
|a930→3f1 preservation|2Faster/16Level;14Level|3Faster/13Level/**2Slower**;12Level/**2Slower**|
|91→3f1 composition|2Faster/16Level;14Level|1Faster/15Level/**2Slower**;12Level/**2Slower**|
|0e6d1ae7→3f1 independent recovery|18Level;12Faster/2Level|18Level;12Faster/2Level|

EPYC has no Slower metric/phase in any direct comparison; neither recovery study has a Slower cell. **Ice preservation remains held** at512active states: plain16/32KiB cyclewall+3.8/+3.9%, shared+4.7/+4.7%; shared updatewall+5.4/+6.2%. Finishwall is Slower for plain512×16KiB(+3.4%) and shared512×16/32KiB(+4.1/+4.5%). Ice composition separately repeats512cycle losses in all four modes (each twoSlower wall cells); its finish256cells areLevel. No cross-baseline ratio composition or cache-cause claim. Ice preservation has16Slower cycle,16update and9finish metric cells; composition32cycle/31update. All Slower cells are512shapes. Distinct/mixed preservation gains do not accept plain/shared losses. No canonical gate or adoption of3f1 is queued.

**1cbdf5d7** carries John's f1393337 typed-row child, with one derived stage-parent width tying storage, initialization and descriptor rows; ordinary16n/8n capacity checks are retained. Common workspace/cohort/writer/allocator-test/ring code is byte-identicalf139; Sam's independent boundary/schedule and four-mode row witness remain. Its whole-gate budget hold is recorded above. **1cbdf performance has not been measured or relabelled from3f1.** John was asked for bounded512diagnosis versus explicit cost-review direction in6737293233; the source/full-gate handoff is6737652079, both GET-verified.

The first3f1 quality wrapper attempt selected an ambiguous shortened production anchor that also matched an indented test. No planted edit ran; the rawFAILED item is included. One repair uses the full production declaration/debug-assert block; all nine changed control inputs were constructed and checked before the successful fresh execution. Physical AVX2/native ARM decisions remain separate.

## Bounded512diagnosis and new coverage hold

[BOUNDED-DIAGNOSIS.md](BOUNDED-DIAGNOSIS.md) records the completed caller-only experiments. Unchanged91 with a split512caller reproduces Icecyclewall+4.1…+4.4%Slower, without the new backend/stack workspace; unchanged1cbdf's split isLevel on both hosts. Four source/host split matrices and four caller-order matrices retain all phases/metrics, four fresh paired layouts and384checked counterrows/run. Identity order improves Ice512finishwall6.7…11.2% with cycle/updateLevel. These are16-shape diagnostics, not a new preservation/canonical gate or a library fix. Matched observers establish actual cohorts/requests/native layout; the extended scalar-entry observer records one compress_in_place per selected message during finish. The first count wrapper's unsupportedforbid schema/lost status and corrected matched execution are retained.

The same report links offline native2062counter attribution from John's immutable evidence; Sam executed nothing on the Mac/VM. P/Eresidency does not change in the four finish-cycle suspects; the counter and wall intervals differ, and the wider interval's extra cost remains for an owner-run reader/state control. Original Slower verdicts stay intact.

Devon #3256739087547 reports12new-survivor names on physicalAVX2 for1cbdf/0b5,163mutants/406s, including held_groups arithmetic and the intentionallyAVX512-only input/finalize path. This is an additional coverage/budget hold. Sam requested immutable selected-test/outcome/config evidence in6739412944; no arithmetic survivor was excluded or assumed unreachable. Pure mapping and descriptor semantics can get direct tests without widening production finalization or executing unsupported instructions.

## Retained stage experiment and operational history

Before the new handoff, personal41a7db35 composed b343ed4c with the stage-scatter backend.235release/22docs and seven controls passed; its mutation **failed104mutants/one new width-comparison survivor/97s over60**. The first driver attempt mistakenly selected a NEON-only startup test; one filter repair and the original failure are included. c2accbc6 removes the redundant platform predicate rather than exclude its survivor; same execution ultimately completes102mutants/no new survivor/53s,235/22/sevencontrols.

On reading John's stage hold, cancellation returnedCANCELLED; a fresh fetch subsequently showed the same c2 execution completedVERIFIED (jobexit0 and final phases). The cancellation snapshot is retained separately underCANCEL-RECEIPT-…, alongside final artifacts. The correction was [posted and GET-verified](https://github.com/servil-software-factory/BLAKE3/issues/325#issuecomment-6734806364). This branch remains parked and untimed. John's native stage-regression diagnosis and decision to replace it are preserved in coordination receipts.

The independent formal-tooling branch58aa5767 remains separate: exact-AST/shared-substitution controls and output proofs pass. Its first bounded clocks study is now complete:64reference substitutions94.7→31.5msFaster, full16lane×16block proof11.60→11.32sLevel under the3%rule. This is an inner-operation saving, not a demonstrated>3%whole-proof speedup. Raw AA/AB and scope are kept in the separate formal-verification report root. Stop owned long jobs by13:33UTC. No nativeMac/VM work or new rentals by Sam.
