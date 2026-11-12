John, sorry for the day's delay: I had not read my assigned items since yesterday afternoon. Your three questions in order.

**1. The properties, in order of value**

1. *The result.* For every input, key, mode and output length, the bytes returned are the specification's BLAKE3. Today the kernels are proved against the specification and `alg/Stack.lean` on my experiment branch proves the stack algorithm is the specification's tree; the Rust between them (the tree walk, `hasher.rs`, `incremental.rs`, `many.rs`, `each.rs`) is tested, not proved.
2. *Memory.* Every read and write falls inside what the caller passed or the function's own frame: each `unsafe` block, and the pointer and length arithmetic of the `ffi_*.rs` bindings.
3. *No trap.* Each panic site is unreachable, or is a refusal the API states. In the trial's x86-64 build I counted 556 panic sites in 185 functions.
4. *Secrets.* No branch and no address depends on a key, an input or a hash (#370 is the first instance).

**2. What stands in the way**

- **A proof about machine code is about one build, and a Rust library is built by its user.** Generic and `#[inline]` functions are compiled in the user's crate: in my test program `hash_serial` sat in the program's object and `Hash ==` was inlined into `main`. What would help: the logic in non-generic functions over pointers and lengths that are their own symbols, with the generic and inlined API as thin adapters over them.
- **Layouts are unspecified.** A statement about memory needs to say where things are. `#[repr(C)]` on the stack of chaining values, the chunk and hasher state and `Output` would fix that, at no cost I know of.
- **Preconditions live in prose.** Where a type can carry one (flags as a byte-sized type, a target that cannot be zero), a proof and a caller both lose a case.
- **The units.** `CvStack::merge` and `push`, `final_node`, the chunk state's update and the tree walk's loop are the units I would take; some are inlined today. Your offer to keep a boundary for the prover is exactly right.
- **`unsafe` gathered and listed**, each with its contract in a sentence: yes, please.

**3. What holds up 0.9: nothing.** None of this touches the public API as `docs/core-api.md` has it; all of it is internal structure or the hidden interface, which may change with any release. The one public point is #370's, which you have settled for 0.9.

**Where the experiments are heading** (my fork's `experiment/sam-machine-code-lean`, `tools/verify/machine/lang/`; not a proposal for the library yet): statements in Lean about the bytes that ship, written for a reader, and an implementation language whose compiler writes the proof with the assembly. As of today `merge` written that way is proved against the specification's `mergeTo` from its source in about 90 s. The first thing I mean to offer the library is the one you named on #370: the constant-time hex, after 0.9, with its source, compiler and proof in the tree and a check, on both architectures.

**Next move:** yours: which of the structural points you take, and when. I ask for none before 0.9.

— Sam Shackleton
