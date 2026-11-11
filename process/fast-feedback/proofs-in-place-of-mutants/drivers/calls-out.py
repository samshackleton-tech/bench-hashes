#!/usr/bin/env python3
"""The core crate's compiled Rust (a whole-crate disassembly with relocations): what each function calls
or refers to through the PLT or the GOT, by kind. usage: calls-out.py ALL.s"""
import collections, re, sys
funcs, name, targets = [], None, collections.Counter()
for l in open(sys.argv[1]):
    m = re.match(r"^[0-9a-f]+ <(.+)>:$", l)
    if m:
        name = m.group(1); funcs.append([name, 0, collections.Counter()]); continue
    if name is None: continue
    if re.match(r"^\s+[0-9a-f]+:\s+(?:[0-9a-f]{2} )+", l): funcs[-1][1] += 1
    m = re.search(r"R_X86_64_(?:PLT32|GOTPCREL\w*)\s+(\S.*?)(?:[-+]0x[0-9a-f]+)?$", l.rstrip())
    if m: targets[m.group(1)] += 1; funcs[-1][2][m.group(1)] += 1
PANIC = re.compile(r"^core::panicking::|slice_\w*fail|len_mismatch_fail|^core::option::(unwrap|expect)_failed|^core::result::unwrap_failed|^alloc::raw_vec::(handle_error|capacity_overflow)|^alloc::alloc::handle_alloc_error|extend_panic|^std::panicking")
def kind(t):
    if PANIC.search(t): return "a panic function"
    if re.match(r"^(mem(cpy|set|move|cmp)|bcmp)$", t): return "memcpy, memset, memcmp"
    if t.startswith("blake3_servil_"): return "an assembly kernel"
    if "blake3_servil_core" in t: return "the crate's own function"
    if t == "_Unwind_Resume": return "the unwinder"
    return "something else of Rust's library"
total = sum(f[1] for f in funcs)
print(f"{len(funcs)} functions, {total} instructions")
sites = collections.Counter()
for t, c in targets.items(): sites[kind(t)] += c
for k, c in sites.most_common(): print(f"  {c:4d} call sites or references to {k}")
def share(pred, what):
    fs = [f for f in funcs if pred({kind(t) for t in f[2]})]
    n = sum(f[1] for f in fs); print(f"{what}: {len(fs)} functions, {n} instructions ({n / total:.0%})")
share(lambda ks: "a panic function" in ks, "contain a call to a panic function")
share(lambda ks: not ks, "call nothing")
share(lambda ks: ks and ks <= {"an assembly kernel", "the crate's own function", "memcpy, memset, memcmp"}, "call only kernels, the crate and memcpy's family")
share(lambda ks: "something else of Rust's library" in ks or "the unwinder" in ks, "call something else of Rust's library, or the unwinder")
print("panic functions, by sites:", "; ".join(f"{t[:48]} {c}" for t, c in targets.most_common() if PANIC.search(t))[:600])
