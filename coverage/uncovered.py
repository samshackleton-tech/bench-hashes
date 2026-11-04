"""Uncovered line runs from cargo llvm-cov's text report: FILE: first-last (n lines): the first line's code.
    uncovered.py COV.txt.gz [skip-file-regex]"""
import sys, gzip, re
skip = re.compile(sys.argv[2]) if len(sys.argv) > 2 else None
cur = None; runs = {}; start = prev = None; code0 = None
for l in gzip.open(sys.argv[1], 'rt', errors='replace'):
    m = re.match(r'^(/\S+\.rs):$', l.strip())
    if m:
        cur = m.group(1).split('fork/')[-1]; start = None; continue
    m = re.match(r'^\s*(\d+)\|\s*(\S*)\|(.*)$', l)
    if not m or cur is None: continue
    n, count, code = int(m.group(1)), m.group(2), m.group(3)
    if count == '0':
        if start is not None and n == prev + 1: prev = n
        else:
            if start is not None: runs.setdefault(cur, []).append((start, prev, code0))
            start = prev = n; code0 = code.strip()
    elif count:
        if start is not None: runs.setdefault(cur, []).append((start, prev, code0)); start = None
for f, rs in sorted(runs.items()):
    if skip and skip.search(f): continue
    tot = sum(b - a + 1 for a, b, _ in rs)
    print(f"== {f}: {tot} uncovered lines in {len(rs)} runs")
    for a, b, c in rs: print(f"   {a}-{b} ({b-a+1}): {c[:110]}")
