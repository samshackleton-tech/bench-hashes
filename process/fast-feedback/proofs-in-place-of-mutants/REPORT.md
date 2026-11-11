# Proofs for blake3-servil-core: every technique tried, what each cost, how each stands

Sam Shackleton, 2026-11-11 (BLAKE3-Servil #361). Asked on Nov 11, 03:46 UTC: a list of every
formal verification tool or technique I tried, my own time on each (nearest half hour), and the
advantages and disadvantages of each, above all against the holy grail:

> a complete, meaningful property (computes the correct BLAKE3 hash of the input; touches memory
> only validly; branches on no secret) over every instruction that can run when
> blake3-servil-core is used, which a skeptical, paranoid genius can verify.

Times are my own attention by the clock (`TIMELOG.md` beside this file), not machine time.
Everything proved is on my fork, branch `experiment/sam-machine-code-lean`, directory
`tools/verify/machine/` (its README lists each experiment and its limits). Nothing here is a
gate or a pull request.

## 1. The list

"The code" below means the machine code: the bytes rustc and the assembler produce, read by a
disassembler. A "model" is a Lean definition of what each instruction does. A "trace" is what
someone timing the code or watching the cache can see: the addresses it touches and the way each
branch goes.

| # | Technique | What I did with it | My time | The proof is about | Checks in |
|---|---|---|---|---|---|
| 1 | Lean, the Rust copied by hand | detection rule proved (`bv_decide`) | 0.5 h | a hand copy | 0.3 s |
| 2 | Kani 0.68 (CBMC) | detection proved; a loop up to 64 words | 0.5 h | Rust source, bounded | 0.04 s; 159 s at 64 words; none at 256 |
| 3 | Verus 0.2026.11 | the loop, any length, my invariant | 10 min | Rust source | 0.5 s |
| 4 | Aeneas (Rust to Lean) | translates both crates' subjects; my proof of the detection rule did not close | 1.0 h | a tool's translation of the source | 11 s to walk 44 paths; unfinished |
| 5 | Jasmin 2026.09 | an AVX2 function compiled, its constant-time check run | 0.25 h | Jasmin source, its compiler proved in Coq | seconds |
| 6 | Binsec 0.11.3 | constant-time check of compiled code, also of the crate's own binary | 0.5 h | the binary, for one input length | under 1 s |
| 7 | Sail's x86 model, to Lean | 47,021 lines of Lean generated; they do not build | 1.0 h | (a machine model, not a proof) | – |
| 8 | s2n-bignum / HOL Light | installed; two of its proofs re-checked | 0.25 h | machine code, their model | 131 s and about 270 s |
| 9 | Lean, the machine code, on our own small model | twelve experiments in ten folders, below | 8.0 h | **the code** | 2 s to 170 s each; 7 to 30 min for all from nothing |
| 10 | Lean function first, Rust printed from it, proof generated | eight loop functions, no proof written by hand | 0.5 h | **the code** | 8 s for all eight |
| 11 | The algorithm in Lean, no code named | the hasher's stack algorithm is `Blake3.blake3` | 10 min | the algorithm | 0.5 s |
| 12 | The models against real processors | five of the models: every instruction form their proofs use, on random states, each with a wrong model as control | 1.0 h | (the model's fidelity) | 23 s |
| 13 | The same proofs on other compilers' and other settings' code | detection re-checked on two other compilers' and three other optimisation levels' bytes, `merge` on 1.98.0's; the crate's code compared across five compilers, a hundred commits, sixteen build settings; the theorem as the judge of source mutants | 1.5 h | (what a change costs; which build a theorem is about) | 4 s and 3 min |

Already in the repository and not re-done here: the Z3 proofs of the assembly kernels
(`tools/verify/*.py`, about 11,300 lines; machine code, our own Python models), and the
specification in Lean (`c2sp/BLAKE3/`).

### What #9 to #12 hold now (all checked by Lean; axioms: the three standard ones and `bv_decide`'s)

| Folder | Code (x86-64 unless said) | Instructions | Theorem | Wrong versions rejected |
|---|---|---|---|---|
| (top) | `read_x86_features` + two callees, rustc's | 84 | returns the specification's feature bits for every CPU | 23 of 25 (2 are equal code) |
| `loop/` | a loop over a caller's slice | 15 | any length: result, the slice's new contents, nothing else written, the trace a function of address and length only | 11 of 11 |
| `call/` | a function that calls and tail-calls it | 10 | by the callee's theorem as a contract; `Decode.lean` reads the bytes itself | 2 of 2 |
| `kernel/` | `compress_in_place_sse41` (assembly) | 94 (467 run) | = the specification's compression, all inputs | 16 of 16 |
| `kernel512/` | `compress_in_place_avx512` (assembly) | 76 (362 run) | the same | 14 of 14 |
| `wide/` | the seven rounds of `hash_many_avx512` | 784 | = the specification's rounds in each of 16 lanes (loads, transposes, loop not done) | – |
| `one/` | the crate's `parent_output`, `Output::chaining_value`, both kernels, in one model | 222 | the two Rust functions leave `Blake3.parentNode … .cv` (C2SP's own definition), on either kernel; **each kernel's trace is fixed by its three addresses and its return address** (`Leak.lean`) | – |
| `a64/` | the loop, compiled for AArch64 | 9 | the same theorem as `loop/`, decoder from the words | 8 of 8 |
| `hex/` | the crate's `Hash::to_hex` | 39 (324 run) | output = length and hexadecimal of the hash; nothing else written; the trace stated; and the trace **depends on the hash** | 36 of 36 |
| `eq/` | `Hash == Hash` (`constant_time_eq_32`, a dependency's code) | 14 | returns 1 exactly when the 32 bytes are equal; the trace is three addresses, **the same for all hashes** | 11 of 11 |
| `one/Merge*` | the crate's `CvStack::merge`: loop, two panic checks, an assertion, a call to either kernel | 100 | **returns with the stack merged as `Blake3.mergeTo` says**, registers restored, nothing else written, no panic reached; **and the trace of that same run is a function of addresses, platform, length and target** (`merge_whole`) | 10 of 11 (1 is a dead store) |
| `gen/` | eight functions written in Lean, Rust printed, compiled | 139 | each = its Lean function, any length, memory, trace; proofs written by a script | 102 of 103 (1 is equal code) |
| `alg/` | none | – | `push`/`merge`/`final_node` of `hasher.rs`, as Lean functions, give `Blake3.blake3` for any input | 8 of 8 wrong definitions |

About 1,400 instructions are under a theorem, of about 44,600 in the x86-64 crate (30,214
compiled Rust in 324 functions, 14,393 assembly): 3%. About 1,230 of them are the crate's own
code (the rest are test subjects and one dependency's function). My time on #9 to #13 together:
about 11 hours.

## 2. Against the holy grail

Five things it asks. C: the correct hash, for all inputs. M: memory touched only validly. T: no
secret in the trace. E: about every instruction that runs (so: the compiler's and assembler's
output, not the source). S: a skeptic can check it (little to trust, a common tool, minutes).

| # | Technique | C | M | T | E | S |
|---|---|---|---|---|---|---|
| 1 | Lean on a hand copy | of the copy | no | no | no | the copy cannot be checked |
| 2 | Kani | up to a bound | up to a bound | no | no: source | trusts CBMC, Kani, rustc, LLVM |
| 3 | Verus | yes | yes (safe Rust's sense) | no | no: source; no assembly | trusts Verus, Z3, rustc, LLVM |
| 4 | Aeneas | yes, if the proofs get written | panics modelled; `unsafe` and assembly outside | no | no: a translation of the source | Lean, plus the translator |
| 5 | Jasmin | with EasyCrypt (not tried) | yes | yes, built in | yes, for code written in Jasmin; **no AVX-512** | strong (compiler proved in Coq) |
| 6 | Binsec | no | no | yes, per input length | yes, where it can read the instructions (not AVX-512) | trusts the tool |
| 8 | HOL Light (s2n-bignum's way) | yes | yes | in part | yes | strongest kernel of all; proofs by hand; OCaml, not Lean |
| – | our Z3 kernel proofs | yes, kernels | partly | no | yes, kernels only | trusts 11,300 lines of Python and Z3 |
| 9 | Lean on the code, our model | **yes** | **yes** | **yes** | **yes**, for the build it was made on (3b), as far as it is extended | Lean; a 200 to 350 line model checked against CPUs; see 4 |
| 10 | Lean first, Rust printed | **yes** | **yes** | **yes** | **yes** | as 9; the printer is not trusted |
| 11 | the algorithm in Lean | the part between the kernels and the specification | – | – | names no code | Lean alone |

Each, in a few lines:

1. **Lean on a hand copy.** Fast and easy. Worth nothing as a guarantee: nobody can check the
   copy is the code. (Your verdict; I agree.)
2. **Kani.** No annotations, finds real bugs, checks panics and overflow. But it unrolls loops: 64
   words took 159 s, 256 did not finish in 15 minutes, no bound gave nothing. It can never say
   "for every input". Says nothing of timing or of what the compiler made.
3. **Verus.** The quickest proof I wrote all night (the loop, any length, 0.5 s). But it is
   about the Rust source, in Verus's own annotation language inside the source, checked by Z3;
   it cannot see the assembly kernels, the compiler, or timing. A good tool for a different goal.
4. **Aeneas.** Translates our subset to Lean in 0.3 s, and proofs would be in Lean. But the
   proofs are about generated Lean that changes with every edit of the Rust (October's proofs
   were removed for that), my proof of a 59-line function did not close in an hour, and it covers
   neither `unsafe`, nor assembly, nor the compiler, nor timing.
5. **Jasmin.** The only one with the compiler itself proved correct, and constant time built in.
   But it has no AVX-512 (`u512` does not parse), so our fastest kernels cannot be written in it;
   the Rust around the kernels would stay outside; functional proofs are in EasyCrypt.
6. **Binsec.** Cheap and useful as a second opinion on timing: it works on the binary. It showed
   that a branch on a secret in Rust source was compiled to a conditional move (so source-level
   reasoning about timing is unsound both ways). Bounded: one input length at a time. It cannot
   read AVX-512 instructions.
7. **Sail's x86.** Not a proof method but a candidate for the machine model. See section 5.
8. **HOL Light, as AWS's s2n-bignum does it.** In production, about machine code, with the most
   trusted proof checker there is. But every proof is a hand-written script (the person says what
   holds at each loop head and which lemma to use at each step), its x86 model is 6,400 lines and
   its decoder 3,583, re-checking one small function took 131 s, and it is not Lean.
9. **Lean on the code.** The only route here that gave all of C, M, T and E, in one theorem, in
   the tool you prefer, with a model small enough to read (and tested against two CPUs). Its
   costs are in section 4.
10. **Lean first, Rust printed.** The same theorems as 9, with no proof written per function.
    What it needs is in section 3.
11. **The algorithm in Lean.** Needed by any route that reaches C for whole inputs; it went
    fastest of all (270 lines, ten minutes), and no edit of the Rust can break it.

## 3. What the night's experiments say about growing to the whole crate

- **One theorem shape works for assembly kernels and for compiled Rust alike**: "these bytes, on
  this model, compute this Lean function, touch only this memory, and show only this." The same
  shape on a second machine (AArch64) cost a 130-line model and twelve minutes.
- **Straight-line code is automatic**: lift, run symbolically, `bv_decide`. One round of the
  compression is one such step; seven are composed. Speed: about 0.1 to 0.25 s an instruction for
  the kernels, far less for ordinary code (`to_hex`: 324 instructions run in 12 s).
- **Loops needed me, until two things**: a rule proved once per kind of loop (`gen/Rule.lean`,
  machine-independent), and memory kept by region (`hex/Regions.lean`). With the rule, eight
  functions needed no proof from me; with regions, `to_hex` was one symbolic run.
- **Calls compose**: a callee's theorem is used as a contract (`call/`, and the two Rust
  functions of `one/` over either kernel).
- **The compiler does not have to be trusted, and it does surprise**: it put one function's
  carried value in another register, kept a constant in a third, rewrote an expression, turned a
  secret branch into a conditional move. The proofs are about what it emitted.
- **Optimisation level**: at `opt-level=3` rustc unrolls a simple loop by four after a remainder
  loop, which the loop rule does not cover. With `-C llvm-args=-unroll-runtime=false` the shape
  stays and the same proofs check. That flag on the library's own Rust **changes no machine code
  that bench-hashes' ten check points run** (EPYC 9255); `opt-level=s` instead makes one of the
  ten 7% slower (Ice Lake).
- **The third property found something**: `Hash::to_hex` reads its table at an address made from
  the hash's nibbles. `the_trace_depends_on_the_hash` is a proved theorem; Binsec, run on a
  binary that links the crate, reports the same four instructions. Upstream's `to_hex` is the same
  code. It matters only where a hash is a secret (a keyed hash's tag before comparison, a derived
  key). I make no claim of a vulnerability; the point is that a proof which must state the trace
  cannot overlook it.
- **The algorithm layer is cheap and stable**: `hasher_is_blake3` says the stack algorithm of
  `hasher.rs` (lazy merging to the counter's one bits, pushes of whole power-of-two subtrees)
  yields the specification's bytes for any input. What remains for C over whole inputs is then
  only code-level: each compiled function computes its Lean function.
- **One real function now has everything the holy grail asks, of the same executions.**
  `CvStack::merge` as compiled (100 instructions:
  six saved registers, an aligned 384-byte frame, a bounds check on each index, an assertion, a
  call through the GOT to either kernel) is proved to return with the stack merged exactly as
  `Blake3.mergeTo` says, for any number of turns: `merge_is_mergeN`, `merge_runs_mergeTo`. Bytes,
  model, Lean function, algorithm, specification. And `merge_whole` proves, of the same recorded run with the kernels'
  instructions included, that what it shows is `mergeShows(platform, addresses, length,
  target)`: no value of the stack, no byte of the key or flags. Result, memory and timing took me
  about 50 minutes in all, on what the night had built (the kernels' contracts, memory by region,
  the loop pattern, the observer beside the model); the check is about 90 s beyond the kernels.
- **And positive results on timing to set beside `to_hex`**: `Hash == Hash`, which is a
  dependency's `constant_time_eq_32`, compiles to two byte compares, an AND and a mask (not the
  xor-or loop of its source); `hash_eq_is_equality` proves that code returns equality and shows
  only the three addresses. And both one-block kernels: `one/Leak.lean` puts an observer beside
  the model's own step (so the trace is of the same runs as the result) and proves that each
  kernel's trace is fixed by the addresses it is given and its return address, whatever the
  key, the block and the flags. My first statement of it left the return address out and did
  not check: the proof finds the trace by itself and may use only what the statement allows.
- **How far the model reaches**: by mnemonic, 88 of the crate's 323 compiled functions use only
  instructions the models have today; 25 more mnemonics bring it to 301. Each took minutes. But
  the models are several, each with its own subset: the richest single one (`Machine.lean`, under
  `merge`) lifts only 33 functions whole today (191 instructions); the first forms it lacks are
  `test`, RIP-relative operands, `jb`, `shr`, R10 and R11, `ja`, `imul`, all of which another of my
  models has. One model for everything is the first piece of work, before more functions, and
  its size is now known (`reach-survey.py`): the crate's compiled Rust uses 225 instruction
  shapes (a mnemonic with the kinds of its operands; calls aside); that lifter takes 87; the 40
  most needed of the other 138 bring a third of the crate's instructions into functions that
  lift whole, 80 bring 61%, 120 bring 85%, all 138 everything. A shape has cost me minutes, plus
  its line in the processor cross-check.

## 3b. Which bytes, and what a change costs (measured Nov 11, 10:00 to 10:55 UTC)

A proof about the machine code is about one build's bytes. Three questions follow, and I measured
each on the core crate (322 compiled functions, 30,192 instructions, x86-64).

**Which build?** A Rust library is compiled by its user. The same source and compiler, other
settings, compared function by function (instructions alone, addresses and the names in
relocations left out) with the plain release build the proofs were made on:

| Build | Functions identical | Instructions in them | The five proved Rust functions |
|---|---|---|---|
| release again, and on another machine | 322 of 322 | 100% | identical |
| a program that depends on the crate, plain release | (the crate's objects are linked as they are) | 100% | identical |
| `-C llvm-args=-unroll-runtime=false` | 302 | 87% | identical |
| `debug = true` (debug information) | 303 | 80% | identical |
| `panic = "abort"` | 276 | 60% | identical |
| `overflow-checks = true` | 191 | 37% | 4 of 5 |
| `opt-level = 2` | 228 | 32% | identical |
| `debug-assertions = true` | 171 | 27% | 1 of 5 |
| `-C target-cpu=x86-64-v3` | 181 | 21% | none |
| `-C target-cpu=native` | 164 on a Xeon 6330, 46 on the EPYC 9255 | 17%, 1% | none |
| `codegen-units = 1` | 71 (173 are inlined away) | 14% | 2 of 5 (`merge`, `to_hex`); 2 inlined away |
| `opt-level = 1` | 139 | 13% | none |
| `opt-level = "s"` | 66 | 2% | none |
| the program built with `lto = "fat"` | 0 (11 names survive, all changed) | 0% | none (inlined away) |

And even the plain build has a hole: a function marked `#[inline]` or `#[inline(always)]` (112
attributes in the core crate's sources) or
generic is compiled again inside the user's crate. In my test program `hash_serial` (79
instructions) sat in the program's own object, and `Hash == Hash` was inlined into `main`; only
`to_hex` was called in the library's object, as proved.

So today's theorems hold, for the functions that are not inlined, for a user who builds with
cargo's defaults, and say nothing to one who sets fat LTO, one codegen unit or the native CPU,
which performance-minded users do. **This is the
largest gap between what I proved and the holy grail's "every instruction that can run", and it
is not in the proofs: it is in how Rust libraries are delivered.** Two ways to close it:

1. *Ship the proved bytes.* The crate already does this for the kernels (assembly files). The
   Rust around them could be compiled once per release by a pinned rustc to assembly, proved, and
   shipped the same way; the user's compiler then only assembles. Cost: no inlining across the
   boundary, one file per target and ABI, a speed check (John's and Devon's to judge), and the
   shipped code may call nothing of Rust's own library, whose symbol names change with every
   compiler: today 185 of the crate's 324 compiled functions, with 91% of the instructions, contain
   a call to a panic function (556 call sites; `calls-out.py`), and 73 call something else of
   Rust's library or the unwinder (106 sites call `memcpy`'s family, whose names are stable). Only
   97 functions, with 6% of the instructions, call nothing but kernels, the crate's own
   functions and `memcpy`'s family, and could be shipped so as they are. A proved core would have to be panic-free or
   send its panics to a function of its own, which a proof of "no panic is reached", as
   `merge`'s is, makes possible function by function.
2. *Make the proof run on any build.* If lifting and proving need no hand, a user checks their own
   binary. That is what `gen/` aims at, and the next two measurements say how near it is.

**When the compiler changes.** The same source by other rustc versions:

| rustc | Functions identical to 1.99.1's | Instructions in them | Differ | In only one of the two |
|---|---|---|---|---|
| 1.99.0 (a patch release earlier) | 322 of 322 | 100% | 0 | 0 |
| 1.98.0 | 228 | 36% | 69 (8 by at most four instructions) | 25 + 27 |
| 1.97.0 | 241 | 37% | 70 | 11 + 15 |
| 1.101 beta (Nov 10) | 222 | 49% | 67 (34 by at most four) | 33 + 39 |

After a six-weekly release about two thirds of the instructions sit in functions whose code
changed (often by a few instructions). What that did to the proofs:

- **Detection** (84 instructions; 1.98.0 exchanges two registers and reorders three
  instructions): the theorem checks on 1.98.0's code **with no edit, in 4 s**. At first it did
  not: my proof named each instruction's lemma by its address. One change (an attribute in place
  of the names) fixed that for good.
- **`merge`** (1.98.0 swaps two stores and uses `movups` for `movaps`): `one/other_compiler.sh`
  lifts 1.98.0's listing and rebuilds all of `merge`'s theorems, the trace included, **with no
  proof text edited, in three minutes**; the trace differs in the order of two addresses, as the
  code does, and Lean finds the new one itself.
- **`to_hex`**: identical from 1.97.0 to 1.99.1. But the 1.101 beta no longer inlines the string's
  pushes: 49 instructions and two calls for each byte, where 1.99.1 has 39 and no call. That is a
  different function and needs a new proof (with the callee's contract), not a re-run.

And the same proof on other build settings' code, for detection (one compiler, eight settings):
four give the same 84 instructions (`panic=abort`, `debug-assertions`, `overflow-checks`,
`codegen-units=1`); `opt-level` 1 and 2 give other code and the theorem checks unedited in 7 s;
`opt-level=s` gives other code again and the theorem checked after I gave the symbolic run one
lemma it lacked (a pointer saved on the stack and restored is the same pointer); with
`-C target-cpu=native` the lifter stops at an instruction and a register the first model does not
have. Seven of eight, with a 200-line model, on the first function I proved. For `merge`, three
of five settings give the very bytes already proved (`codegen-units=1`, `opt-level=2`,
`panic=abort`); `debug-assertions` leaves a call where the release build inlines (a different
function), and the native build uses 256-bit moves this model does not have.

And the generated proofs of `gen/` (eight loop functions; the script prints the Rust, compiles,
lifts and writes each proof), on four compilers and six optimisation settings:

| Setting | rustc 1.97.0, 1.98.0, 1.99.1, 1.101 beta |
|---|---|
| `opt-level=s` | 8 of 8 check on each (139 or 141 instructions: the compilers differ) |
| `opt-level=3` with `-unroll-runtime=false` | 8 of 8 on each (162 or 164) |
| `opt-level=3`, 2, 1 | none: LLVM unrolls each loop by eight after a remainder loop; my rule knows one loop |
| `opt-level=z` | none: another loop shape |

So the generated route already costs nothing across compilers, and its limit is exactly one
thing: the loop rule knows one shape. A rule for "k words a turn, after a remainder loop" is the
next experiment I would run for way 2.

So: small differences (register choice, order, instruction selection, optimisation level) are
absorbed if the proof names nothing by address; each failure I met was a missing piece of the
tool (a lemma, an instruction, a naming habit), fixed once; a change of structure (inlining,
unrolling) is a new proof unless the proof is generated, as in `gen/`.

One design lesson sits under these results. Detection's theorem survives every other build
because its statement says nothing of the frame: its machine's stack is "whatever the code wrote
before it reads it". `merge`'s and `to_hex`'s statements name the frame (384 bytes, aligned; the
red zone below the stack pointer), so code with another frame is another theorem: five of
`to_hex`'s six source mutants compile to code that makes a frame, and stopped right there. The
next statements
should be written the first way: "the function may use this much stack below the pointer", and
nothing about where in it.

**When the source changes.** The last hundred commits on `next` that touch `src/` (the whole
library, about 600 functions and 50,000 instructions), each against its parent, same compiler
(98 compared; two did not build alone):

| Functions whose code changed (or were added) | Commits | Instructions in those functions |
|---|---|---|
| none | 52 | tests, comments, other targets' code, API surface |
| 1 to 4 | 14 | median 0.6% of the library's |
| 5 to 16 | 9 | median 3.9% |
| 17 to 64 | 18 | median 12.5% |
| 65 or more | 5 | median 29% |

Over the hundred, a commit moves 4.6% of the instructions on average, and half move none.

Most changes move the machine code of the functions they edit and little else; a feature moves
a tenth to a third of the library (inlining spreads it); rustc is
deterministic here (a rebuild and a second machine give the same bytes). So proofs per function,
re-run only where a function's bytes changed, fit the way the library changes; the cost is the
compiler upgrade, every six weeks, and the answer to it is either pinning (way 1) or automation
(way 2).

**Measured against the mutation run** (your ninth goal). Of the core crate's 1,902 mutants, 65
(3.4%; 117 s of 2,697 s of mutant time on the EPYC 9255) are in the functions proved so far:
`read_x86_features` 40, `merge` 9, `to_hex` 6, `parent_output` 6, `chaining_value` 2, `Hash ==` 2.
The tests of that commit miss 15 of those 65 (14 in detection, since closed by #366's exhaustive
test; one in `parent_output`); the proofs reject every changed instruction that changes behaviour
(a few are provably the same code). So proofs are
stronger where they exist and cover little yet: the saving in mutation time today would be 4%.

**The proof as the test** (#361's step 3, tried on detection). `source-mutants.sh` takes the 62
source mutants cargo-mutants plants in the six functions the detection theorem covers
(`features_of`, `os_saves_avx`, `family`, `wide_cpu`, `read_cpu_words`, `read_x86_features`) and,
for each, builds the library, lifts the function and builds the theorem on the mutant's bytes:

| Verdict | Mutants | The test suite's verdict on the same |
|---|---|---|
| the same bytes as the unmutated build | 3 | the same three are its "same code" rows |
| **refuted**: the theorem fails, and on a CPU, run on the model, the code returns something else than the rule (50 on a CPU the prover names; 5 more on one of four real CPUs) | 55 | caught |
| not proved: the theorem fails and no such CPU is found (the prover's counterexamples were spurious) | 2 | caught |
| the lifter stops (the sign flag, a ninth register: the first model lacks them) | 2 | caught |
| the theorem checks on changed bytes | 0 | – |

No mutant is accepted, and the three the compiler erases are the three the tests already list.
A refutation comes with its test case: for "replace `os_saves_avx` with true" the prover names a
CPU whose leaf 1 lacks OSXSAVE, and on the model the mutant's code faults there, at XGETBV. That
check matters: some of the prover's counterexamples were spurious (it says "potentially"), and
running them on the model sorts them (`witness.py`).
103 s for the 62 on six shards of the EPYC 9255 (the suite's check of the change that touched
these functions took 53 to 89 s for 35 to 44 mutants, on three other machines), so no time is
saved on this function; what is gained is that the judge is a theorem over every CPU, not
65,536 cases. (On the first run the lifter stopped at 16 mutants; a 32-bit `lea` and one more
condition in the model brought 14 of them to the theorem.)

The same on the crate's own functions with hand-led proofs (`source-mutants-real.sh`; the
unmutated listings, lifted and judged the same way, are proved, as a control): of `merge`'s 9
source mutants and `to_hex`'s 6, **none is accepted**; 4 fail in the proof and 11 stop the lifter
(forms these models lack, or the function inlined away). But slowly: a failing proof of `merge`
took 3 to 8 minutes, and one mutant of `to_hex` kept Lean busy for 17 minutes before it failed.
So there the theorem is a sound judge and not yet a quick or an informative one: every verdict
is "not proved", none "refuted". For detection, whose proof is one symbolic run and a decision
procedure, it is both.

## 4. What a paranoid reader must still trust, and what went wrong

1. **Lean's kernel, and `bv_decide`.** Each `bv_decide` step adds an axiom
   (`…_native.bv_decide.ax_…`): it trusts Lean's compiler to run its certificate checker. And
   **its SAT solver has a ten-second limit: on an older Xeon and an ARM VM the kernels' proofs
   first failed to check.** Fixed for now with a longer limit. The right fix is certificates
   (`bv_decide?` writes one, `bv_check` reads it, and no solver runs): I measured it on one
   round lemma: it checks in 21 s in place of 52, but its four certificates are 21 MB each (8 MB
   compressed). Splitting a round into half rounds would shrink them. Not done.
2. **The model.** 200 to 350 lines a machine; several copies exist where one should. Five of
   the copies are checked against processors (EPYC 9255, Xeon Gold 6330, Ryzen 9700X): the
   kernels' SIMD model, the general-register model of `gen/` and `hex/`, `Machine.lean` (under
   `merge_whole`: 225 forms, 9,000 states), `eq/`'s, and the first model, under detection (71
   forms, checked last, at noon, after I noticed I had written "every model" when it was not
   so); 531 instruction forms in all, 23,000 random states, registers, flags and memory
   compared, no difference; five deliberately wrong models were caught. **Not checked against
   a processor:** `loop/`'s and `call/`'s copies, `wide/`'s 512-bit one, the AArch64 one; and
   in every model CPUID, XGETBV, jumps, calls, returns, push and pop. Nothing is checked
   against Sail.
3. **The disassembler.** Most lifters trust llvm-objdump's listing. Two experiments read the
   bytes with a decoder written in Lean instead; that should become the rule.
4. **Which build** (section 3b): the theorems are about rustc 1.99.1's plain release build.
5. **The hypotheses of each theorem**: who owns which memory, that a call through the GOT reaches
   the kernel its relocation names, that a table holds what the source says, the calling
   convention, no interrupt or other thread changing the state. They are stated, not proved.
6. **Not attempted**: the functions around `merge` (`push`, `final_node`, the chunk's state),
   so the algorithm's theorem is joined to the code at one function only; calls into `memcpy`;
   the loops, loads and transposes of the wide kernels; the AArch64 kernels (146,471
   instructions); the trace in the parent functions' theorems.
7. **My slips**: I pushed a file holding my home path to the public fork (replaced a minute
   later); twice I killed processes by pattern and hit my own shell; I left eight Lean processes
   running for two hours; I miscounted a function's instructions and lost half an hour to it; I
   did not read my assigned issues for five and a half hours, so John's #367 waited; the ARM VM's
   disk filled with my runs' scratch files and one check failed for it (cleaned, 94% to 32%). And
   five wrong statements reached public comments on #361 before I caught them, each corrected
   there with a note: tables that counted a renamed relocation as changed code; "every model is
   checked against processors" when four of nine were, and earlier "every instruction form the
   proved programs use" when two models were; "139 inline functions" where 27 of the attributes
   are `inline(never)`; "360 panic calls" where a full count gives 556. The cause was
   the same each time: a count I had not looked inside. The rule I took from it: list the
   members before writing "every" or a total.

Checking everything from nothing on a rented machine with no Lean (elan, the toolchain, every
folder in turn), with `merge_whole`: 7.4 minutes on the Ryzen 9700X, 9.5 on the EPYC 9255, 23 on
each pair of Xeon Gold 6330, 14.8 on the EPYC 7443 pair, 30 on the four-CPU ARM VM; the kernels and `one/` are nine tenths of it; a second check is 2 s.

## 5. Your open questions

**"Hand-guided" proofs.** In s2n-bignum a person writes each proof as a script: the invariant at
each loop head, the lemma at each step; the checker only confirms. With `bv_decide` or Z3, for a
bounded piece (one round, the detection rule) one states the goal and the solver finds the proof.
Ours are a mix: straight-line code is automatic; my first loop took 220 lines by hand; after the
loop rule, eight loops took none.

**Why might "write it in Lean, print the Rust, prove the bytes" not work?** Where I tried it, it
worked: eight functions, no proof by hand, 102 of 103 wrong programs rejected. What could stop
it at the crate's scale: (1) each construct of the language needs its rule, proved once: there is
one, a fold over a slice; `hasher.rs` needs buffers, the stack, calls to kernels, 64-bit
counters, early returns; (2) the compiler reshapes loops (the flag above answers the case I
met; vectorising would need its own); (3) each new function met instruction forms the model
lacked; (4) nobody has measured printed Rust against the hand-written for speed. None is a wall;
(1) is the real work and the next experiment.

**Finish Sail's x86 and contribute it?** What I found: the public model (translated from ACL2's,
2024) has none of the SSE or AVX integer instructions we use (they are in its opcode catalogue
only), and its Lean export (47,021 lines) does not build: the hand-written prelude fails. So
"finishing" means writing the SIMD semantics in Sail ourselves and repairing the Lean path, and
then proofs would run on 47,000 lines where ours run on 350. My suggestion: proofs stay on the
small model; Sail, like the processors, is something to check the model against, instruction by
instruction, where it has the instruction; and an issue upstream asking what they plan for SSE
and AVX costs nothing. (For Arm, Sail's model is the official one and complete, and
`isla_check.py` already uses it.)

**Our own language, printed to Rust and to Lean.** Yes, the same idea as the previous one, and
`gen/` is its smallest instance, with one difference worth keeping: there the language lives
inside Lean, so "to Lean" is nothing and cannot be wrong. A separate language (Ode) adds a
second printer to check.

## 6. Where I would go next (your decision)

**What the whole crate would take: an estimate, not a measurement.** On the crate's own Rust I
proved about 290 instructions (detection, the two parent functions, `to_hex`, `merge`, `==`) in
about three hours net of mistakes: roughly 100 instructions an hour, on ground the earlier
experiments had prepared. The x86-64 Rust is 30,214 instructions, so three to four hundred
hours of my attention at today's rate: two to three months, for one build of one target. The
rate rose through the night (`merge` went twice as fast per instruction as `to_hex`) and should
rise further as contracts accumulate; it will fall on the largest functions (one has 2,341
instructions). The assembly kernels are another 14,393 instructions on x86-64, mostly rounds,
which are automatic. And section 3b says what that buys: a proof of one build, to be made again
for two thirds of the code at each compiler release unless the bytes are pinned or the proofs
need no hand. So I would not start the long march before deciding that.

**The two ways of section 3b, as first steps one could take.**

*Way 1, ship the proved bytes* (a design question for the core crate; John's to weigh):
1. One function to try it on: `CvStack::merge` behind an `extern "C"` boundary, compiled by the
   pinned rustc to assembly, assembled by the crate's build as the kernels are. Its theorem
   exists (to be re-run on the new bytes), and it proves no panic is reached, so the panic
   blocks can go.
2. Measure with Devon's bench what the boundary costs (no inlining into `push` and `finalize`).
3. If the cost is acceptable, the list of what must be so shipped is the 185 functions with a
   panic path and whatever is `#[inline]` into users; the rest follows function by function.
What it buys: one artefact to prove per release and target; a compiler upgrade becomes a
choice, not an event. What it costs: speed at the boundaries, per-target files, and the Rust
source stops being what runs (it becomes the specification the assembly is made from).

*Way 2, proofs that run on any build*:
1. One model with the crate's 225 instruction shapes, a decoder in Lean, the processor
   cross-check extended to all of them.
2. Theorems stated without the frame and without a step count, as detection's is.
3. The loop rule for unrolled loops; then `gen/`'s language grown until `hasher.rs` can be
   written in it, and its printed Rust measured on the bench against the hand-written.
4. A command a user runs on their own build's objects: lift, prove, report which functions
   are proved for that build.
What it buys: the holy grail's "every instruction that can run", for whoever runs the command.
What it costs: the most tool-building, and a proved build may still not exist for every setting.

The two meet: way 1 can begin with the proofs there are; way 2 makes them cheap to redo.

**Pieces of work, either way:**

1. The functions around `merge` the same way (`push`, `final_node`, the chunk's state, the
   output's bytes), until `hasher_is_blake3` is joined to the code from the API down. `merge`
   itself is done.
2. Certificates for `bv_decide`; one model for everything, with the trace everywhere; the Lean
   decoder for every form; the cross-check extended to jumps and the stack, and to the models it
   does not cover yet.
3. Grow the language of `gen/` until `hasher.rs` can be written in it; measure it on the bench.
4. The wide kernels whole, in Lean or left to the Z3 proofs meanwhile; then AArch64.
5. #361 step 3: a change's mutation check skips functions a machine-code theorem covers; the
   whole run still plants them as the audit. Today that would be 65 of the core crate's 1,902
   mutants (section 3b).
6. Decide between the two ways of section 3b (ship the proved bytes; or proofs that run on any
   build), or both: the first is the short road to "every instruction that can run", the second
   is what makes a compiler upgrade cost nothing.
