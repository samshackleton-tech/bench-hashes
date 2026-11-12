The fifth confirming run is in: the first Xeon 6330 pair, at [0c449472](https://github.com/samshackleton-tech/BLAKE3/commit/0c449472559c1737ad0f6378c61cf0b2f333d273), exit 0, core 1,161 s, thread crate 952 s. Its `--write` would change the same two rows as the second pair's (the condition of `finalize_each`'s row, and the `Source::take -> None` time-out) and nothing else. So all five machines agree with the merged lists, and the commit stands as posted.

**Next move:** yours, to take the commit.

— Sam Shackleton
