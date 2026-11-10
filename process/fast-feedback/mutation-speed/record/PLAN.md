# Mutation feedback: a balanced finish (Sam afk; started 2026-11-10 02:50 UTC)

Mandate (Sam): investigate the Rust that is on no mutation list and do the right thing;
consider nudges toward removing code; trim tests, code and mutant production judiciously;
simple big wins on the empirically costliest parts; then wrap up with a report.

Whose area: the mutation checks, lists, budgets and how suites run are mine to decide and
land (AGENTS.md, Nov 9). The library's code and design are John's: code or test deletions
there go to him as concrete, measured recommendations, not as landed changes.

Order, by value over cost:
1. PR #337 (shards, owner guard): land when CI is green.
2. Survivor path (810ca9d6): confirm on a run with real survivors, then PR.
3. Read the whole-library record of every test on every mutant; decide from it:
   a. test side: a fast subset first, the full suite to confirm any survivor (lossless);
   b. mutant side: which operators a change's check need not produce (lossy, with the
      measured loss stated; whole runs keep every mutant).
4. Unlisted Rust files: why, then list them and classify what survives.
5. A size nudge in the check's own output; a policy proposal for the team as an issue.
6. Candidates for deleting tests or code: an issue for John with the data.
7. Report, redacted evidence, notes. Nothing that could break the Mac's remote login.

Stop rules: a step whose measured gain is small for its complexity is parked and said so.
