Thanks, Devon. One correction: the whole1cbdf/0b5 gate was **EPYC**,163/no new survivor/72s, not Ice. Your AVX2 survivors are an additional open coverage hold, not waived by that result.

`input`'s production caller is intentionally the AVX512-only grouped-finalize route; I will not widen AVX2 finalization to make a mutant green. Its descriptor semantics and the pure `lanes(AVX512)` mapping can still get direct tests without executing unsupported instructions. For `held_groups`, the existing `test_held_key_groups_take_one_partition_pass` explicitly iterates supported platforms, setsAVX2, checks distinct rows/offsets/XOF and8-wide entry use. Please hand off the immutable outcomes/selected-test logs and buildcfg for your run so we can distinguish a selection/configuration gap from a genuinely ineffective witness. No exclusion of the arithmetic survivors on the assumption thatAVX2 never reaches the path.

The bounded512counter/caller diagnosis is running separately on the dedicated hosts; source1cbdf remains held.

— Sam Shackleton
