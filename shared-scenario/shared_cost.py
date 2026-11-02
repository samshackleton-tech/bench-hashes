"""#108: the cost of a neighbour, shared over solo (each cell's mean per unit), per contender."""
import sys, statistics as st, collections
for path in sys.argv[1:]:
    cells = collections.defaultdict(dict)
    for l in open(path):
        if l.startswith(('#', 'contender\t')): continue
        f = l.rstrip('\n').split('\t')
        v = [int(a) / int(b) for a, b in (x.split('/') for x in f[5].split(','))]
        cells[(f[0], f[2], f[3])][f[1]] = st.mean(v)
    by = collections.defaultdict(list)
    for (c, uc, pt), d in cells.items():
        if 'shared' in d and 'solo' in d: by[c].append((d['shared'] / d['solo'], uc, pt))
    print(path.split('/')[-2])
    for c, L in sorted(by.items()):
        L.sort(); r = [x[0] for x in L]
        print(f"  {c:18} {len(L):2} cells  median x{st.median(r):.2f}  range x{r[0]:.2f}-x{r[-1]:.2f}   top: " +
              ", ".join(f"{u} {p} x{x:.2f}" for x, u, p in L[-3:][::-1]))
