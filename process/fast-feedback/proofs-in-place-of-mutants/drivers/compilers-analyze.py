#!/usr/bin/env python3
"""compilers.sh's texts -> how much of the core crate's machine code each other rustc changes.
usage: compilers-analyze.py OUT_DIR"""
import collections, difflib, gzip, json, re, statistics, sys, os
out = sys.argv[1]
def load(tag):
    with gzip.open(f"{out}/text-{tag}.json.gz", "rt") as f:
        raw = json.load(f)
    # a crate's disambiguator in a mangled name changes with the compiler: not a change of code
    # the instructions alone: a relocation's line names its target as the build named it (a section, a hash)
    return {n: [l for l in ls if not l.startswith("R_X86_64")] for n, ls in raw.items()}
def count(ls): return sum(1 for l in ls if not l.startswith("R_X86_64"))
base = load("1.99.1")
total = sum(count(ls) for ls in base.values())
print(f"rustc 1.99.1: {len(base)} functions, {total} instructions")
print("other rustc | functions in both | identical | instructions in them | differ | at most 4 instructions differ | only in one")
for tag in ["1.99.0", "1.98.0", "1.97.0", "beta"]:
    if not os.path.exists(f"{out}/text-{tag}.json.gz"): continue
    other = load(tag)
    both = [n for n in base if n in other]
    same = [n for n in both if base[n] == other[n]]
    small = 0
    for n in both:
        if base[n] == other[n]: continue
        d = [l for l in difflib.unified_diff(other[n], base[n], lineterm="", n=0) if l[:1] in "+-" and not l.startswith(("---", "+++")) and "R_X86_64" not in l]
        if len(d) <= 8: small += 1
    same_n = sum(count(base[n]) for n in same)
    print(f"{tag} | {len(both)} | {len(same)} | {same_n} ({same_n / total:.0%}) | {len(both) - len(same)} | {small} | {len(base) - len(both)} + {len(other) - len(both)}")
