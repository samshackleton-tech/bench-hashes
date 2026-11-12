John, the Mac's lists: two commits on your tip 43564b80, on my fork's [`lists/sam-arm64-43564b80`](https://github.com/samshackleton-tech/BLAKE3/commits/lists/sam-arm64-43564b80).

**The runs** (the Mac mini, Apple M6, 12 CPUs; by hand, in turn with the runner, started after 3082; `--write`, both exit 0):

| | mutants | caught / survive / unviable | time |
|---|---|---|---|
| core | 1,935 | 1,284 / 510 / 141 | 2,355 s |
| thread crate | 547 | 455 / 49 / 43 | 1,362 s |

**[549913fe](https://github.com/samshackleton-tech/BLAKE3/commit/549913fe7), the lists.** `known-arm64.txt` goes from 32 rows to 370, the thread crate's from 4 to 30, the time-outs from none to 3 and 13: nearly all with the reasons your AArch64 lists and the x86-64 ones give ("as on aarch64", "as on x86_64"), as the tool wrote them. Two things by hand:

- **Four time-outs no other list has**, all in the thread crate's `cut_with_prefix` (`+=` as `*=`, `+=` as `-=`, `/` as `%`, `<` as `==`): each makes the cut run without end. x86-64 and your VM catch them by a failing test; on the M6 the clock stops them first. The reasons are my reading of the function, not a run.
- **One survivor of the core had no reason, and should not get one:** `+` as `-` in `scratch_layout` (`src/ffi_sme2.rs`, the level above's place).

**[9bafee57](https://github.com/samshackleton-tech/BLAKE3/commit/9bafee57c), a test for that one.** With the mutant, from 256 chunks up the flat walk puts the level above *before* the scratch block's start: by the arithmetic it writes 1 KiB before it at 256 chunks and up to 21 KiB before it at 1,024 (the mutants' profile has no overflow checks, so the subtraction wraps). Every test on the Mac passed with it; your VM's lists have no row, so there something fails. No test looks at the places `scratch_layout` gives. The commit adds one: for every size the walk takes, the table, the values and the level above are in order, each with the room of a padded group, at 1 KiB and 3 KiB mod 4 KiB, inside `SCRATCH`. On an AArch64 machine it passes as the code is and fails with the mutant ("128 chunks: the values run into the level above"); formatted. It is your crate: take it, or write it your way and I add the row meanwhile.

Not run: the gates on these two commits; the M4 Max (these are the M6's lists).

**Next move:** yours.

— Sam Shackleton
