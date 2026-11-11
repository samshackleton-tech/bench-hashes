#!/usr/bin/env python3
"""builds.sh's texts -> how much of the core crate's machine code each build setting changes.
usage: builds-analyze.py OUT_DIR"""
import gzip, json, re, sys
out = sys.argv[1]
def load(tag):
    with gzip.open(f"{out}/text-{tag}.json.gz", "rt") as f:
        raw = json.load(f)
    # the instructions alone: a relocation's line names its target as the build named it (a section, a hash)
    return {n: [l for l in ls if not l.startswith("R_X86_64")] for n, ls in raw.items()}
def count(ls): return sum(1 for l in ls if not l.startswith("R_X86_64"))
base = load("release")
total = sum(count(ls) for ls in base.values())
proved = re.compile(r"CvStack>::merge|Hash>::to_hex$|hasher::parent_output|Output<.*>>::chaining_value|read_x86_features")
print(f"release: {len(base)} functions, {total} instructions")
print("build | the release build's functions present by name | identical | instructions in them | differ | absent | of the proved five: identical")
for tag in ["release-again", "codegen-units-1", "opt-level-2", "panic-abort", "target-cpu-native", "debug-assertions", "program-plain", "program-fat-lto", "program-fat-lto-cgu1"]:
    try: other = load(tag)
    except FileNotFoundError: continue
    both = [n for n in base if n in other]
    same = [n for n in both if base[n] == other[n]]
    same_n = sum(count(base[n]) for n in same)
    pv = [n for n in base if proved.search(n)]
    pv_same = [n for n in pv if n in other and base[n] == other[n]]
    pv_absent = [n for n in pv if n not in other]
    print(f"{tag} | {len(both)} | {len(same)} | {same_n} ({same_n / total:.0%}) | {len(both) - len(same)} | {len(base) - len(both)} | {len(pv_same)} of {len(pv)} ({len(pv_absent)} absent)")
