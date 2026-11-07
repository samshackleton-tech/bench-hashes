# Development-cycle audit — November 7, 2026

## Objective and budget

Sam The User wants substantially shorter development cycles. First find changes that preserve the same quality while approaching a tenfold reduction in turnaround. Then consider processes using at most 20% of the time for at least 80% of the value. She is happy to spend four times as much per week for at least twice the productivity.

Optimization implementation is paused behind the API discussion. This audit changed no production tool, library source, review head or rented hardware.

## What the records say

`audit_runs.py` reads existing artifacts from nine recent studies, deduplicates run IDs, and writes `run-audit.json`. The sample contains **314 distinct runs: 296 VERIFIED and 18 FAILED**. Twelve locally fetched live-CV records are in it; four other live-CV native/control records were not locally present in these directories. This is a defined sample, not the entire registry.

Times come from the manifest launch timestamp and tar-preserved artifact modification times. `out/identity.txt` marks the beginning of script execution. The preceding interval combines queueing and preparation; the current fetched records do not separate those phases. STATUS's modification time marks completion. This arithmetic analyzes existing logs and launches no timing run.

| Jobs | Count | Median script execution | Median launch-to-result |
|---|---:|---:|---:|
| All sampled jobs | 314 | 54.4 s | 160.6 s |
| Names containing `native` | 94 | 18.2 s | 25.0 s |
| Names containing `startup` | 17 | 9.7 s | 362.5 s |

For 198 records containing build logs, the median interval from identity to the last build log was **9.2 s** (90th percentile 13.5 s). The median remaining interval was 130.2 s. Compilation is already short in these probe jobs.

Concrete queue/preparation tails:

- `parent-single-final-startup-9700x-20261107T053313-e2a57b68`: **531.2 s before script execution, 9.0 s execution**.
- `first-chunk-startup-icelake-20261106T233931-699c95bb`: **599.5 s before execution, 13.9 s execution**.
- `xof-cache-occasional-zen3-20261107T061926-881f51dd`: **607.4 s before execution, 5.8 s to a compiler failure**.

The 18 failures were 11 probe compilation failures, four warning-gate failures in alternative library implementations, and three unsupported-instruction/model-development failures. The same probe mistakes were fanned out across multiple hosts. The corrected scripts and old failures remain in the archives.

A representative XOF matrix (`xof-cache-final-stream-9700x-20261107T061447-cd32845b`) started at 06:15:23. The eight contender builds and judge finished by 06:15:32. The four paired runs finished at 06:20:12. This identifies where compiler caching would and would not help.

## 1. Buy a fast lane, and schedule for decision latency

**Largest demonstrated opportunity.** A ten-second check should not sit behind several minutes of unrelated work. The startup-job median shows roughly 37 times as much launch-to-result time as execution time.

Use separate resource pools:

- **Interactive lane:** immediate pinned preflight, native correctness and small focused checks. Keep capacity available for the next development step.
- **Quiet timing lanes:** benchmark jobs, with their preparation and verification still inside the host lock.
- **Compute lane:** builds, symbolic proofs, mutation work and bulk artifact processing. These jobs may saturate their dedicated machines.

Use spare physical hosts, not different cores on one timing host: cores share package power, memory bandwidth and other resources. Preserve the preparation-before-lock fix. Build and proof work leave the timing host; they do not move outside its lock on the same host.

Start with a compute worker and a second copy of the most congested timing CPU class. Keep a replica available for short timing checks. Extend to additional CPU classes when their queue tails demand it. Capability labels must distinguish native ISA checks, CPU-family timing, GPU/native Mac work and architecture-independent computation.

Give queued interactive jobs priority and reserve capacity for them. Do not interrupt a running timing pair. Queue age prevents long validation work starving. Keep the existing superseded-queued-run cancellation.

The native Mac gate has also waited for mains power. Make an always-powered, available native Mac fixture part of the team's infrastructure plan with John. Renting additional equipment follows the Cherry-only policy; any different provider needs its own decision.

**Target:** common correctness/mechanism feedback within 40 seconds, and routine Rust-only candidate validation within six minutes when the relevant resources are available. Measure the 90th/95th percentile queue delay, not just average machine utilization.

## 2. One experiment definition, with preflight before fan-out

The sampled runs use 49 script hashes. Scripts repeatedly embed contender construction, a Rust probe, the paired runner and a judge. For example, `held-stage-next/final-matrix.sh` and `xof-cache-next/full-matrix.sh` each carry a large copy of the judgment program.

Improve the existing pinned-run/bench-hashes path so a study declares:

- pinned baseline/candidate/tool sources;
- probe source and exact dependency lock;
- workload shapes and timed operation;
- required host capabilities;
- reference/work checks and expected evidence;
- the comparison family and reporting destination.

The shared runner supplies fresh builds/layouts, adjacent alternating pairs, clocks, load checks, the current 3%/5% judgment rule and artifact collection. A manifest should name the whole instrument bundle by content. Maintain one implementation of the measurement and judgment rule.

Before multi-host fan-out, compile the exact probe against every named source on the compute lane and execute a tiny reference/work-control case. Check warning gates too. Then publish the eligible jobs automatically. Compiler and borrow-checker mistakes should fail once, in seconds, before occupying four queues.

For proof changes, first assemble the changed entry, check that every emitted instruction has a model, and run the small positive/negative control. Existing fault plants provide the controls for this stage.

A study-scoped completion command should return the next result for the current study. `pinned-run next` currently walks the historical registry and can return old unreported results; its poll interval is 20 seconds. Add scope to the existing command and expose phase events. Let completion drive fetch/judge/report rather than repeated manually composed polling and publication steps.

**Quality:** all final checks, cases and evidence remain. This changes their ordering and removes duplicated setup and avoidable failed fan-out.

## 3. Reuse deterministic evidence by its actual inputs

The code already has useful mechanisms:

- `long-proofs.sh` reuses a successful result when selected proof inputs are unchanged.
- Mutation checking defaults to changed lines, keeps per-shard build directories, narrows tests using reachability, and detects equal machine code.
- Each proof case has a fresh process and failure supervision.

Build on these rather than introducing another gate system.

Make the validation plan identify which evidence nodes actually changed: generator/output agreement, a kernel proof family, instruction-model/native comparison, Rust callers, public API examples, and platform builds. A reusable result names its complete input/tool/environment closure and its original evidence. Changed Rust dispatch still receives caller tests even when its assembly proof carries forward.

**Concrete cache-key gap found:** `long-proofs.sh` keys `c`, `c2sp`, `tools/verify`, and `tools/gen_neon_hybrid.py`. Its `generated` command also runs `tools/gen_sme2_hybrid.py` and `tools/gen_x86.py`, which that key omits. A generator-only change can therefore take the reuse branch without rerunning the generator/output agreement check. Include those dependencies or separate generation agreement into its own keyed node. Toolchain and solver identity belong in the closure too.

Start with conservative per-family dependencies. Preserve all required cases. Cache deterministic results and compilation artifacts; performance observations still come from fresh paired executions on the designated hosts.

Fresh private build directories can consume immutable content-addressed artifacts. This preserves source identity without repeating identical work. Nextest already supports build archives and source/target path remapping; it can separate native test execution from compilation. Package the matching source and fixtures with the identity checks. CPU/OS/features remain part of artifact selection.

Generic compiler caching is secondary here: the observed probe build phase is about nine seconds. sccache's Rust support excludes linker-invoking crates and requires incremental compilation to be disabled (or left uncached). Measure its fit before adding it to every job.

## 4. Parallelize the complete proof workload on compute hardware

The full proof driver runs families sequentially. `prove_x86.py` limits wide cases to three workers, with a documented peak near 22 GB per case. That is a memory-safety choice made for a particular capacity, not a useful universal machine limit.

Use a memory-budgeted case scheduler on compute hosts, retaining fresh processes and exact case coverage. Large-RAM machines can run more independent cases; multiple hosts can divide a case list. Join results against the declared list so a missing case fails the job.

The Arm symbolic proof scripts currently invoke a host-default assembler (`cc`, or Clang without an explicit target); x86 proofs already pass `--target=x86_64-linux-gnu`. Giving the Arm assembler an explicit target would let the symbolic computation run on an appropriate general compute host after validating the emitted instructions against the intended artifact. Native instruction-model checks remain on real ISA-capable machines.

For large uncached proof suites, this offers another substantial same-coverage speedup. A machine purchase should follow the measured per-case memory and CPU profile. More cores alone do not help if only three memory-heavy cases are allowed to run.

## 5. Make publication and review a short, automatic handoff

Our evidence repository had 18,525 files and about 208 MB of published payload at the last snapshot. Every source boundary, failure and cost deserves preservation. The reviewer needs a much smaller entry point.

Generate one review card from the experiment definition and result index:

- change and mechanism;
- exact patch boundary and source identities;
- complete-work result and affected controls;
- residual costs and the explicit decision needed;
- evidence/tests/proofs carried forward versus newly run;
- links to the raw artifacts.

Use the same indexed records to generate report tables, inventories and publication checks. Verify immutable uploads once and verify each new delta, with periodic complete audits. Preserve complete remote-tree/size/content verification. The collectors currently duplicate prefix lists; one missed prefix is why the live-CV follow-up needs special collection work.

Attach design/review ownership when an experiment starts. John owns contract/integration decisions; Sam owns experiment evidence and assigned costs; Devon supplies independent review and Intel coverage. Review the intended contract and mechanism before the expensive matrix, then review the final evidence. A second independent agent can prepare a small review in parallel from the same frozen source.

Limit active integration candidates to what the reviewers can absorb. Extra agents should shorten diagnosis, independent checking and handoff, rather than just produce a larger queue of frozen drafts. Track idea-to-decision and decision-to-integration time as well as job duration.

## 6. Use deterministic mechanism checks as the first feedback

We already have good examples: count actual partitions/compressions/clones, canary unused copied capacity, and hold a worker while checking that admission returns. Make these the early loop, with their fault plants, before full performance matrices.

For a copying optimization, inspect generated copies before scheduling the full matrix. The failed by-value checkpoint alternatives visibly retained large aggregate/result transport. For an asynchronous optimization, check progress and ownership with deterministic handshakes before timing it.

These checks answer whether the intended work was removed in seconds. The final speed/energy/layout and occasional-use comparisons still answer whether the whole change pays.

## The separate 80/20 track

After the same-quality improvements above, introduce a declared screening mode:

- a small representative set of matching complete workloads;
- one likely target CPU first;
- one small/sparse control and an occasional-use control where relevant;
- the same measurements and explicit source identities;
- a full validation gate before promotion.

Shorter screening reduces exploratory cost; it has less coverage. Calibrate it by replaying decisions from retained good and bad trials, then test the chosen screen on held-out trials. Measure its agreement and missed problems. This provides an empirical answer to the user's 80%-value target rather than choosing a percentage of tests arbitrarily.

Do not shorten every measurement tenfold or relax the regression margin as the first move. Retain the final four-layout paired protocol and judgment family. If samples can become shorter at the same sensitivity, demonstrate that on A/A controls and known regressions as a separate methodology change.

Broad mutation campaigns stay at their existing release/stable-checkpoint role. John's changed-line fast path already does much of the useful 80/20 work and remains his design responsibility.

## Spending and rollout

The first spending priority is queue elimination: an interactive replica, separate compute capacity, and reliable native Mac availability. The next is enough matching timing replicas to run independent validation concurrently. Proof memory and additional independent review capacity follow the measured bottleneck.

Use the user's four-times-spend/two-times-productivity criterion at the level of **completed, reviewed decisions per week**, together with lead-time percentiles. Low utilization on a reserved interactive machine can be valuable: its purpose is to be ready when the next decision needs it.

Recommended first pilot:

1. Record queued, lock acquired, prepared, built, measured, verified, fetched and reviewed timestamps in the existing runner.
2. Reserve one fast lane and run the same checks there.
3. Add exact-instrument preflight before fan-out and one generated review card.
4. Compare launch-to-first-actionable-result and whole candidate decision time with this audit's baseline. Preserve all final acceptance evidence.

If this reaches the 40-second interactive target and halves candidate decision time, expand the fleet and automation. Then tackle complete proof-suite throughput and the calibrated 80/20 screen.

## References

- Existing artifacts and summary: `run-audit.json`; analyzer: `audit_runs.py`.
- `/home/samshackleton/bin/pinned-run` — host lock, fresh checkout, verification, registry and completion polling.
- `tools/verify/long-proofs.sh`, `tools/verify/workers.py`, `tools/verify/prove_x86.py`, `tools/verify/README.md` at `db3cab99`.
- `tools/mutants/check.py` at `db3cab99` — current scope/build/test reuse and its documented limits.
- [Nextest build archives](https://nexte.st/docs/ci-features/archiving/) — build/run split, requirements and remapping.
- [sccache Rust support](https://github.com/mozilla/sccache/blob/main/docs/Rust.md) — supported compilation and cache-key constraints.
