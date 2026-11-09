# Released repair bundle: exact-source Ice and EPYC gates

## Result

Exact candidate **7b1ba7b9da67e61dd53010de2054edfa32035170**, organization `integrate/released-ring`, directly against published main **6e0dffd37e04b01b80dc56eb833b00fc337b6873**. Both refs were GET verified before launch and after completion. The user explicitly approved the intact longer gate.

**Canonical plain-mode gates exit 0 on both hosts: no named cell judged Slower.** Both ran four fresh paired layouts and the full 64-pair confirmation for eight suspects. Ice's final output retains one ordinary single-threaded 64 B wall suspect; it is not a Slower verdict and was not erased or promoted to certainty.

**The shared-key cost remains:** complete-cycle wall +2.9–9.5% Ice (13 Slower, 1 Level), +6.6–16.0% EPYC (14 Slower). One Ice shared-key finish cell is +3.4% Slower. This repair bundle does not contain the independent-key held-stage optimization. These exact-source costs need explicit review; gains for rare distinct-key workloads do not accept costs in plain/shared-key priority workloads.

No release/integration/cost acceptance is claimed by Sam. Four runs are runner VERIFIED; that certifies pinned inputs/instruments/output expectations, not absence of regression.

## Sources and instruments

| Purpose | Identity |
|---|---|
| Candidate | 7b1ba7b9da67e61dd53010de2054edfa32035170 |
| Baseline | 6e0dffd37e04b01b80dc56eb833b00fc337b6873 |
| Canonical benchmark | 5c1a092f71126b95f035e104c25d38b0cacae63b |
| Keyed clocks/benchmark | 9994de190259648ede82f7c5e4dbac4f1534a41d |
| Shared sampler distribution | personal bench-hashes c2308172c419a131a148a1fe49ea3afa2e611a6f |
| Shared sampler SHA-256 | 3a0595df2a83d2c2c42b5decf50ebad56449f26d82721ac3c32ba89cdd3782cb |
| Shared sampler BLAKE3 | 835914929e9d8408c9db7bd316dfd0c8f0d65b44c73a2206579cddf8c6ee119b |
| Runner SHA-256 | f45d9b2e187b4074d7bd10bc8e2dce1ff7430d4f92ede54aab25bdd4172859cf |

Canonical bench predates the pipeline contender: released main has no pipeline API. Later pipeline/next evidence cannot substitute for this comparison. The keyed instrument is the one shared Rust sampler, compiled with `main-api`, with explicit reset after the released immutable finalize_each inside cycle/finish work. Cases, timed boundaries, columns and discovery rule are retained. No library or benchmark source was changed.

Each host held `/root/bench-native-afk.lock` from preparation through verification; its keyed job queued behind its canonical job. Quiet timing hosts ran no unrelated correctness work. Strict authenticated ED25519 SSH was retained. No setup failed and no job was retried in this study. A single non-measuring log read observed Ice confirmation progress; its interactive shell warning is not timing evidence. Final verdicts come from fetched pinned-run records only.

## Canonical plain-mode gate

Scope **25 of 269 points**, leaving **244 unmeasured**. Complete point names are in PLAN.md, `out/points.txt` and check logs:

- Continuous 64/128/256/512 B, 1/4/16/64/256 KiB, 1 MiB.
- Continuous batches 16/64/1024; interleaved256; turn256 after other work, idle and brief idle.
- Continuous git-object and Nix-file collections; saturated/2us/20us receiving.
- Merkle65536 and ordinary64B/1KiB controls.

Both single-threaded/multithreaded contenders and the canonical shared-cache scenarios remain intact. No controlled-idle point (EPYC lacks the required driver), worker cap, manual sample suppression, --probe, layout-count override or shortened confirmation. Same-code screening, busy-pair retirement and the 3% practical margin / 5% FDR rules are canonical, unchanged.

| Host | First stage | Confirmation | Final |
|---|---|---|---|
| Ice Xeon6330 | 4 fresh pairs; no Slower or Level instruction movement >0.5%; 8 suspects | 64 fresh pairs over the selected family | exit0; no Slower, no Level instruction movement >0.5%; residual wall suspect below |
| EPYC9255 | 4 fresh pairs; no Slower or Level instruction movement >0.5%; 8 suspects | 64 fresh pairs over the selected family | exit0; no Slower, no Level instruction movement >0.5%; no residual suspect printed |

The canonical confirmation uses16 new layouts per side, each run four times, for64pairs (SECOND_LAYOUTS=16, SECOND_RUNS=4). No assertion of64unique link layouts is intended.

Ice residual: `blake3-servil-st|solo|OneMessage|64 B`. The canonical implementation prints a Level wall cell as a suspect when its mean ratio exceeds the practical margin but the statistical test has not judged it Slower; it can also select consistent instruction movement. Here the log explicitly reports no Level instruction movement. Exit0 is the canonical gate's result; no third-stage rerun or claim of exact equality was added. The residual uncertainty remains available for John's judgment.

Canonical job wall durations (not performance results): approximately56.2 minutes Ice /28.9 minutes EPYC. Both sides' logs report clean matching benchmark/library provenance.

Runs:
- `released-bundle-canonical-ice-20261109T005130-a4852883`
- `released-bundle-canonical-epyc-20261109T005131-99fa832f`

## Complete-work keyed matrix

Unchanged 64 shapes: 16/32 KiB messages in4KiB arrivals, 2/8/16/17/24/128/512 active hashers, plus 7/8/15/16 active among1024 open states. Each host uses four fresh private build/layout pairs, adjacent alternating sides, clocks::summary at3% margin/5% FDR.

Inputs, key construction, Hasher constructors and caller descriptor/output capacities are outside counters. Complete cycles include descriptor refill, library allocation, updates, digests and reset. Update includes selected reset/refill/update work, with digest outside. Finish prepares outside counters, finalizes and resets once per prepared state over64 samples; finish energy is NA. RAPL package energy includes background/idle work. The sampler's quiet wait and final busy-window abstention are active; every accepted executable reports quiet load.

### Complete-cycle wall

| Workload | Ice | EPYC |
|---|---|---|
| Plain,18 shapes including sparse | 18 Level; -1.2% to+0.2% means | 18 Level; -1.0% to+0.2% |
| One shared key,14 shapes | **13 Slower /1 Level; +2.9% to+9.5%** | **14 Slower; +6.6% to+16.0%** |
| Distinct keys,14 | 12 Faster /2 Level; down to-21.9% | 10 Faster /4 Level; down to-22.9% |
| Mixed modes,18 | 1 Faster /17 Level | 18 Level |

The2.9% Ice shared-key cell is Level, not Slower. No Level result implies exact equal cost.

### Update and finish costs

Shared-key update wall: Ice13Slower/1Level, +3.0–9.5%; EPYC14Slower, +6.9–16.9%.

Finish: EPYC256Level. Ice255Level/**1Slower**: **16 shared-key hashers,32KiB messages,4KiB arrivals**, wall **176.6084→182.5947ns/message, +3.4%**. CPU **+2.0% Level**, cycles **+3.3% Level**, instructions **+0.1% Level**. Wall and cycles move in the same direction but receive different statistical verdicts. Retain the wall finding; no cause or waiver is inferred from instruction count, code layout, or the other clock's Level verdict.

All-metric judgment counts:

| Host | Cycle | Update | Finish |
|---|---|---|---|
| Ice | 66F/189L/65S | 61F/192L/67S | 255L/1S |
| EPYC | 55F/195L/70S | 58F/193L/69S | 256L |

`keyed-summary.tsv` records wall summaries; complete raw/judgment tables preserve every metric and case. `counter-integrity.tsv` verifies all3072 observed diagnostic/TSV rows: calls match, P+E cycles/instructions equal their aggregate TSV fields, finish has64 calls and energyNA, and all16 executable logs end quiet. These homogeneous x86 hosts report E counters zero; this does not validate Mac core-kind attribution. No new statistical decision was implemented by this integrity check.

Runs:
- `released-bundle-keyed-ice-20261109T005133-ba8aa557`
- `released-bundle-keyed-epyc-20261109T005134-7d186d1a`

Keyed job wall durations approximately4.2 minutes Ice /3.7 minutes EPYC, after their canonical jobs released the lock.

## Interpretation and remaining gates

- This is the direct **published main→combined released repair** comparison, not an isolated ring attribution or a ratio composed from71154c1d/b4989d6c/next studies.
- John now separately requests **71154c1d→7b1ba7b9** on27 owned/lent/collection points for isolated ring acceptance (#303 comment6729670588). That comparison is not run or cleared here. Native Mac timing waits for an approved quiet AC window; Devon's i7 request is separate.
- John reports his adapter301367ee passes ARM VM and Mac2039/2040 correctness-only preflights (#312 comment6729670417). Those are owner-reported preflights, not speed results. These x86 numeric diagnostic checks do not replace native P/E/busy-window validation.
- The independent-key held-stage candidate and its tests remain separate from the released repair branch. Its earlier x86 results do not erase this branch's shared-key costs.
- Exact-source shared-key/finish costs and the residual Ice wall suspect are handed to John for explicit review. No cost acceptance, merge, release, tag, upload, advisory or0.9 decision by Sam.
- Owner mutation budget109s>60s, native ARM keyed costs, isolated ring acceptance, GPU/release gates and other earlier source-specific costs remain open as applicable. Protected EPYC retained; no hardware change, new ring design, worker tuning or further optimization.

All raw data, failure-free executing drivers, source manifests and paired SHA-256/BLAKE3 artifact manifests accompany this report. Binaries/private checkpoint and files>=20MB are omitted by policy; omission records distinguish them from missing results. No jobs remain active after fetch.
