#!/usr/bin/env python3
"""What one model for the whole crate needs: every instruction of the core crate's compiled Rust
(real/all.s), by shape (mnemonic and the kinds of its operands); which shapes the richest lifter
(one/lift_one.py) takes today; and how many functions lift whole as the missing shapes are added,
most needed first. Calls are left out of the shapes: a call needs its callee's contract, not a model."""
import collections, pathlib, re, subprocess, sys
lab = pathlib.Path.home() / "work/proof-lab"
text = (lab / "real/all.s").read_text()
R64 = "rax rcx rdx rbx rsp rbp rsi rdi r8 r9 r10 r11 r12 r13 r14 r15".split()
def kind(t):
    t = t.strip()
    if t in R64: return "r64"
    if re.fullmatch(r"e(ax|cx|dx|bx|sp|bp|si|di)|r\d+d", t): return "r32"
    if re.fullmatch(r"(ax|cx|dx|bx|sp|bp|si|di)|r\d+w", t): return "r16"
    if re.fullmatch(r"[abcd]l|[abcd]h|sil|dil|spl|bpl|r\d+b", t): return "r8"
    if re.fullmatch(r"[xyz]mm\d+", t): return t[0] + "mm"
    if re.fullmatch(r"-?0x[0-9a-f]+|-?\d+", t): return "imm"
    m = re.fullmatch(r"(?:(byte|word|dword|qword|xmmword|ymmword|zmmword) ptr )?(?:cs:)?\[(.*)\]", t)
    if m:
        inner = m.group(2)
        if inner.startswith("rip"): form = "rip"
        elif "*" in inner: form = "base+scaled index" if re.match(r"\w+ \+", inner) else "scaled index"
        elif re.fullmatch(r"\w+ \+ \w+( [+-] 0x[0-9a-f]+)?", inner) and inner.split(" + ")[1].split()[0] in R64: form = "base+index"
        else: form = "base+disp"
        return f"{m.group(1) or 'addr'}[{form}]"
    return "?" + t[:12]
funcs = []          # (name, [(shape, sample line)], instruction count)
for b in re.split(r"\n(?=[0-9a-f]{16} <)", text):
    m = re.match(r"^[0-9a-f]{16} <(.+)>:", b)
    if not m: continue
    shapes, n, lines = [], 0, b.splitlines()
    for i, line in enumerate(lines):
        mm = re.match(r"^\s+[0-9a-f]+:((?: [0-9a-f]{2})+)\s+(\S+)\s*([^#]*)", line)
        if not mm: continue
        n += 1
        op, args = mm.group(2), mm.group(3).strip()
        if op in ("call",) or op.startswith("nop") or op in ("ud2", "int3"): continue
        if op.startswith("j"): shapes.append((op, f"       0: 74 00                        \t{op}\t0x2 <f+0x2>")); continue
        ks = [kind(x) for x in args.split(",")] if args else []
        reloc = lines[i + 1] if i + 1 < len(lines) and "R_X86_64" in lines[i + 1] else ""
        shapes.append((op + " " + ", ".join(ks), line + ("\n" + reloc if reloc else "")))
    if n: funcs.append((m.group(1), shapes, n))
distinct = {}
for _, shapes, _ in funcs:
    for s, sample in shapes: distinct.setdefault(s, sample)
supported = {s for s in distinct if s.strip() == "ret"}      # the probe below ends each sample with a return of its own
for s, sample in distinct.items():
    listing = lab / "reach/one.listing"
    listing.write_text("0000000000000000 <f>:\n" + sample + "\n      ff: c3                           \tret\n")
    r = subprocess.run([sys.executable, str(lab / "merge/lift_one.py"), str(listing), "f", "0x40000", str(lab / "reach/One.lean"), "F"], capture_output=True, text=True)
    if r.returncode == 0 or s.strip() == "ret": supported.add(s)
total = sum(n for _, _, n in funcs)
need = [(name, {s for s, _ in shapes} - supported, n) for name, shapes, n in funcs]
print(f"{len(funcs)} functions, {total} instructions, {len(distinct)} distinct shapes (calls and NOPs aside); the lifter takes {len(supported)} of them today")
def lifted(have):
    fs = [(name, n) for name, miss, n in need if miss <= have]
    return len(fs), sum(n for _, n in fs)
print("with today's shapes:", "%d functions, %d instructions" % lifted(set()))
count = collections.Counter(s for _, miss, _ in need for s in miss)
order, have = [s for s, _ in count.most_common()], set()
marks = [10, 20, 40, 80, 120, 160, 240, len(order)]
for k, s in enumerate(order, 1):
    have.add(s)
    if k in marks:
        f, n = lifted(have); print(f"  + the {k} most needed shapes: {f} functions lift whole, {n} instructions ({n / total:.0%})")
print("the twenty most needed:", "; ".join(f"{s} ({c})" for s, c in count.most_common(20)))
mn = collections.Counter(s.split()[0] for s in order)
print(f"{len(order)} missing shapes over {len(mn)} mnemonics; most shapes per mnemonic:", ", ".join(f"{m} {c}" for m, c in mn.most_common(12)))
