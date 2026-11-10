# Mutation-check speed: what was measured, changed and left (November 9–10, 2026)

For BLAKE3-Servil #257. Machines are named by role. Addresses, logins and
paths are removed from every file here (`FILES.json` lists what was
published and each file's SHA-256 after redaction).

Unless a line says "judged", a time is one execution: inventory, no speed
verdict. Functional correctness, a runner's VERIFIED, mutation outcomes,
the budget and speed are separate facts.

## The question

A change's mutation check has a 60 s budget. The composition 0b5bf7b7 →
1cbdf5d7 (163 mutants) failed it at 72 s on the EPYC 9255 host and took
383 s on the physical i7 (AVX2, no AVX-512; Devon's record, #330).

## Where the time goes

EPYC, 163 mutants, six shards, kept worktrees, 59 s: each shard builds
and runs the unmutated tree (about 4 s), then for each of its mutants
rebuilds (about 1.5 s) and runs tests to the first failure (about 0.4 s).
Four fifths of a mutant's time is its rebuild; the library's own test
binary is that rebuild's critical path (`runs/*build-anatomy*`). A cold
start (fresh worktrees and targets) adds about 14 s: the historical 72 s
was mostly that (`runs/*grouped-reuse-pilot2*`: 72.7 s fresh, 58.6 s kept,
same 163 outcomes as the historical run, `historical-obligations.json`).

## What changed

| | landed as | effect |
|---|---|---|
| More shards on large machines, for changes of 56 mutants or more | #337 | judged: wall 59.0 → 47.3 s **Faster** (802‰); CPU 1,481 → 1,779 s **Slower** (1201‰), accepted: the budget is wall time (`analysis-shards-ab/`) |
| A kept shard is never reset or cleaned by another clone; an orphaned one is replaced (Devon's fix), one Git cannot answer for is refused | #337 | a correctness fix found on the way |
| The tool's Git fixtures carry their own identity | #337 | its tests pass on a machine with no Git identity |
| A change's check leaves to the whole run the mutants a row already explains and thirteen kinds a sibling stands for | #340 | 163 → 102 mutants on this composition; 829 of the library's 2,851 |
| Survivors are named when the shards end; each surviving place is built for release once | #340 | four new names on the Ice Lake host: names at 61 s instead of the end, verdict at 127 s instead of 156 s |
| The check prints the lines of code a change adds and removes | #340 | a nudge, no time |

## The composition, on the EPYC 9255 host

| tool | shards | mutants | kept worktrees | fresh |
|---|---:|---:|---:|---:|
| before | 6 | 163 | 58.6 s | 72.7 s |
| #337 | 12 | 163 | 47.3 s (judged, above) | 71.2–72.2 s |
| #340 | 12 | 102 | 34.7 s, 34.9 s | 60.0 s, 59.9 s |

The 102 have the outcomes they had among the 163; no new survivor. The
Ice Lake host (112 threads) at 20–24 shards: 163 mutants in 59–62 s where
six shards took 102 s (`runs/*shard-sweep*-ice*`; most windows there were
busy, so unjudged). The i7 was not measured after these changes.

## The record of every test on every mutant

`check.py --whole --map --whole-suite`, x86-64, sixteen shards, EPYC. The
run reached its 45-minute limit with 13 shards complete, so the record is
2,266 of 2,489 mutants (`matrix.json`, rebuilt from the shards' own
cargo-mutants output by `build-matrix.py`; the raw output, 2.8 GB, is kept
privately). 1,552 caught, 382 the same code, 171 do not build, 129
survive, 32 time out only.

Tests (237, 8.9 s summed when unmutated): 94 tests taking 2.8 s catch
every caught mutant; 108 more (5.3 s) catch only what cheaper tests also
catch; 36 (0.8 s) never fail on a mutant (aborts, allocation counters,
contracts: things mutants do not model). 349 mutants have exactly one
catching test, spread over 76 tests. 91% of caught mutants fall to a
library unit test (`tests-analysis.json`). Nothing was changed on this
evidence: the tests are a fifth of a mutant's time and stop at the first
failure, so a cheaper order would shorten only the unmutated run and the
survivors' (an estimate: 3–5% of a check).

Mutants: siblings at one place (the two or three replacements of one
operator) had the same outcome at 91–100% of their places, `|` apart
(`| with ^` was caught nowhere). `dropped-operators.json` is the thirteen
kinds a change's check now leaves out; with them out, no place in the
record loses its only survivor except those of `| with ^`.

## Tried and not adopted

| idea | result |
|---|---|
| The target directory and worktrees on a RAM disk (tmpfs) | no change: 72.1 s fresh, 47.5 s kept, against 71.2–72.2 s and 47.2–47.4 s on disk (`runs/*tmpfs-target*`). The files are already in the page cache; the time is compiling. |
| One verdict for mutants that build to the unmutated image | correct, removed no work on this composition |
| Building model-only test targets once | about 2% |
| Dropping the first run's release builds of survivors | measured wrong (it kept the slower, serial builds); replaced by building once and reusing |
| A test order from the record | not built; see above |

## Code no check had planted mutants in

About 1,460 lines of Rust are on no list. The pipeline's three files
(917 lines, public as `throughput::pipeline`): 107 mutants, 16 surviving
places and 9 time-outs on x86-64, 17 and 6 on an Apple M6
(`unlisted/`; BLAKE3-Servil #339).

## How large changes are

The last 400 first-parent commits of `next`: 321 touch no mutated line;
of the 79 that do, the median is 8 mutants, the 90th percentile 66, the
largest 201 (`history-sizes.jsonl`).

## Limits

- The i7 and the Macs were not timed after the changes.
- A whole run (every mutant, once per stable release) is as it was.
- The check's opening estimate ("about N s") is a fixed formula and reads
  about twice the time taken on these hosts.
- A survivor that only a left-out kind would show waits for the whole run.
