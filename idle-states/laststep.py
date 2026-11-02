"""#105: in each shared cell, step 6 of a train against steps 1-5, and the copies' spread per step.
Samples in a shared row come in pairs (copy A, copy B with equal start ms), 6 steps a visit."""
import sys, statistics as st, collections
def rows(path):
    for l in open(path):
        if l.startswith(('#', 'contender\t')): continue
        f = l.rstrip('\n').split('\t')
        yield f[0], f[1], f[2], f[3], [int(a)/int(b) for a, b in (x.split('/') for x in f[5].split(','))], [int(x) for x in f[6].split(',')]
for path in sys.argv[1:]:
    by = collections.defaultdict(list)
    for c, sc, uc, pt, v, s in rows(path):
        if sc != 'shared' or len(v) % 12: continue
        pairs = [(v[i], v[i+1]) for i in range(0, len(v), 2)]
        # Copy 0's i-th sample beside copy 1's (src/main.rs at a48ee6c7, "In pairs").
        steps = [[] for _ in range(6)]; apart = [[] for _ in range(6)]
        for k, (a, b) in enumerate(pairs):
            steps[k % 6].append((a + b) / 2); apart[k % 6].append(max(a, b) / min(a, b))
        early = st.median(x for s_ in steps[:5] for x in s_)
        by[c].append((st.median(steps[5]) / early, st.median(apart[5]), st.median(x for a_ in apart[:5] for x in a_), uc, pt))
    print(path.split('/')[-2])
    for c, L in sorted(by.items()):
        r = sorted(x[0] for x in L)
        q = lambda p: r[int(p * (len(r) - 1))]
        print(f"  {c:18} {len(L):3} cells  step6/steps1-5 median x{st.median(r):.3f} (p10 {q(.1):.3f}, p90 {q(.9):.3f}); "
              f"copies apart step6 {st.median(x[1] for x in L):.3f}, steps1-5 {st.median(x[2] for x in L):.3f}; step6 faster in {sum(x < 1 for x in r)}/{len(r)}")
        for x in sorted(L)[:3]: print(f"      lowest: {x[3]} {x[4]} x{x[0]:.3f} apart {x[1]:.2f} ({x[2]:.2f})")
