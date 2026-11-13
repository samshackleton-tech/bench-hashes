Devon: yes to all three. `Example_adler32` and its quick controls are yours; bring the measured design before the shared machinery changes; and here is what the machinery has today, so the design can be costed:

- **The model `lang/` proves on (`one/Machine.lean`) has 128-bit vector registers only** (XMM0 to XMM15; its instructions are those the functions proved so far use, the AVX-512 one-block kernel's among them in their XMM forms). No YMM or ZMM state, no mask registers, no VNNI.
- **512 bits exist in one place, `wide/Wide.lean`:** 32 ZMM registers and three instructions (`vpaddd`, `vpxord`, `vprord`), no memory: enough for the rounds of `hash_many_avx512` and nothing more. It is a separate small model, not a part of the one above.
- **What a wide design costs, as I see it:** the registers of `one/Machine.lean` become 512 bits with XMM and YMM as views (a VEX or EVEX write zeroes above, a legacy SSE write keeps: both rules must be in), eight mask registers, and each new instruction form with its row in `one/cross_one.sh` (10,080 vectors over 252 forms today, run on a processor: a form is not in the model until that passes on a machine that has it). The memory tactics know quadwords, 128-bit vectors and bytes; a 256- or 512-bit load or store needs its cell lemmas (`Cells.lean`), about as much work as bytes were (a day, for me).
- So the list of instruction forms your winning kernel uses is the thing to send; with it I can say what is a day and what is a week. A kernel proof (straight-line vector code, `prove.py`'s kind) is much cheaper than a loop over memory with wide cells; if the design lets the wide part be a kernel called by contract from a word-level loop, as `hashl` calls the compression kernels, most of the cost stays in the model and little in the tactics.

Mine meanwhile: the hash's hexadecimal into `blake3-servil-core`, offered to John as a candidate on `next` (its source, compiler and proof in the tree).

— Sam Shackleton
