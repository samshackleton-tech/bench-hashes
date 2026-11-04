"""The full-run part of cores_analyze.py alone: full_analyze.py OUT base,v1,v2,..."""
import sys, glob, os, re, statistics as st, collections
O = sys.argv[1]; V = tuple(sys.argv[2].split(',')); W = V[1:]
full = {v: collections.defaultdict(list) for v in V}
for f in glob.glob(O + '/full-*.samples.tsv'):
    _, v, rnd = os.path.basename(f)[:-12].split('-')
    for l in open(f):
        if l.startswith(('#', 'contender\t')): continue
        x = l.rstrip('\n').split('\t')
        if x[0] != 'blake3-servil-mt': continue
        t = [int(a) / int(b) for a, b in (y.split('/') for y in x[5].split(','))]
        full[v][(x[1], x[2], x[3])].append(st.mean(t))
print("full runs, servil mt cells, time x servil (lower = faster), mean of 2 runs:")
for v in W:
    rat = {k: st.mean(full[v][k]) / st.mean(full['base'][k]) for k in full['base'] if k in full[v]}
    fast = sum(1 for x in rat.values() if x < 0.95); slow = sum(1 for x in rat.values() if x > 1.05)
    by = collections.defaultdict(list)
    for k, x in rat.items(): by[k[1]].append(x)
    print(f"  {v:5}: {len(rat)} cells, {fast} faster than x0.95, {slow} slower than x1.05; by use case (median): " + ", ".join(f"{u} x{st.median(xs):.2f}" for u, xs in sorted(by.items())))
    worst = sorted(rat.items(), key=lambda kv: -kv[1])[:5]
    print("     slowest: " + "; ".join(f"{k[0]} {k[1]} {k[2]} x{x:.2f}" for k, x in worst))
