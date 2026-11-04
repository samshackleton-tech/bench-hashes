"""Lines instrumented and never run on both machines (cargo llvm-cov text reports), grouped in runs with
their code; tests and the self-test left out.   both.py X86.txt.gz ARM.txt.gz"""
import sys, gzip, re
def zeros(p):
    cur = None; z = {}; code = {}
    for l in gzip.open(p, 'rt', errors='replace'):
        m = re.match(r'^(/\S+\.rs):$', l.strip())
        if m: cur = m.group(1).split('fork/')[-1]; continue
        m = re.match(r'^\s*(\d+)\|\s*(\S*)\|(.*)$', l)
        if m and cur and m.group(2) == '0':
            z.setdefault(cur, set()).add(int(m.group(1))); code[(cur, int(m.group(1)))] = m.group(3).strip()
    return z, code
zx, cx = zeros(sys.argv[1]); za, ca = zeros(sys.argv[2])
for f in sorted(set(zx) & set(za)):
    if re.search(r'test\.rs|self_test|tools/', f): continue
    both = sorted(zx[f] & za[f])
    if not both: continue
    runs = []; s = p = None
    for n in both:
        if s is not None and n == p + 1: p = n
        else:
            if s is not None: runs.append((s, p))
            s = p = n
    runs.append((s, p))
    print(f"== {f}: {len(both)} lines")
    for a, b in runs: print(f"   {a}-{b}: {cx[(f, a)][:120]}")
