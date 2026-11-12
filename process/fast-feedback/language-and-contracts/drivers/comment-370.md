John, a candidate for the second of your two choices here (make it table-free), on x86-64, for you to take or leave: branch `candidate/sam-hex-constant-time` on my fork, [f9ed2918](https://github.com/samshackleton-tech/BLAKE3/commit/f9ed2918da66721a9cd0c421b3cab91def356d29), two commits on `next` 3313686b.

**What it is.** On x86-64 `Hash::to_hex` calls a kernel, `blake3_servil_hex` (`c/blake3_hex_x86-64_unix.S`): 45 SSE2 instructions, no table and no branch. Other targets keep the table, so the question stays open on AArch64.

**What is known about it.**
- *Proved, as assembled:* the 64 bytes it writes are the hexadecimal of the 32 it reads, it changes no other byte, it keeps the registers a callee keeps, and what an observer of time and cache sees is one list of addresses whatever the hash is (`hex_meets_its_contract`; Lean checks it in 1 s; 10 of 10 changed instructions are rejected after a control).
- *Tested:* a new test, every byte value in every one of the 32 places against the sixteen characters written out; and a million random hashes against the table version in a separate harness.
- *Speed* (single runs: inventory): 1.9 ns a call against 12.8 for the table on the EPYC 9255 host; 1.5 against 10.2 on the Ryzen 9700X.
- *Gates* on the Ryzen 9700X and a Xeon 6330 pair: format, the four suites, the features build, `check-builds.sh`, the tool's tests and the change's mutation check all pass. Three mutants of the table's loop become same-code rows on x86-64, where that loop is no longer compiled.

**What is new in kind, and why I am not landing it.** The assembly is not hand-written and not from a Python generator: it is printed from a source of about forty lines by a small compiler that also writes the proof (#361, the experiment branch's `tools/verify/machine/lang/`; `./prove.sh` redoes all of it). Neither that source nor the proof is in this tree yet, and whether `to_hex` should become a kernel at all is the library's design, which is yours. If you want it, what I owe before it can land: the source, the compiler and the proof in the tree with a check that the shipped file is what they print; `tools/size.py`'s line; and the same for AArch64 once the Arm model has the instructions.

**Next move:** yours (take it for 0.9, for 0.10, or not).

— Sam Shackleton
