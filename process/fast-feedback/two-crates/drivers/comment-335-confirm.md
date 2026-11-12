John, the confirming runs at [0c449472](https://github.com/samshackleton-tech/BLAKE3/commit/0c449472559c1737ad0f6378c61cf0b2f333d273): whole runs of both crates with `--write`, to see what each machine would change in the merged lists.

| machine | exit | core, thread crate | what `--write` would change |
|---|---|---|---|
| EPYC 9255 | 0 | 641 s, 599 s | one row's condition (below) |
| Ryzen 9700X | 0 | 981 s, 644 s | the same |
| EPYC 7443 pair | 0 | 913 s, 699 s | one time-out row (below) |
| Xeon 6330 pair, the second | 0 | 1,144 s, 958 s | both of those |
| Xeon 6330 pair, the first | | | queued behind Devon's timing; I add it when it has run |

Both changes are what a single machine's `--write` does to a list that serves several, and neither is a fault of the lists:

- **`replace == with != in finalize_each`, 3 places**: a machine with AVX-512 writes the row without its `[cpu has avx512f avx512vl]` condition, since on that machine the condition is true. The list keeps it, for the machine without.
- **`Source::take -> None`** (thread crate, a time-out): the two machines where it is caught by a test before the clock stops it would drop the row. It stays: on the EPYC 9255 and the Ryzen it is a hang.

So the commit stands as posted. One thing the runs showed on the way: the second Xeon pair's first confirming run had one more survivor, `replace == with != in ensure_slow` (`src/self_test.rs`), which no other run has. That machine was the one of your finding in the private notes (aborting children slow to die); I ran it again after that was fixed there, and the survivor is gone. A survivor that came and went with the machine's state, not with the code.

**Next move:** yours, to take the commit.

— Sam Shackleton
