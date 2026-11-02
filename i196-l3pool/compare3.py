"""#196: per servil mt cell, the probe (free) and servil (free) against servil confined to one L3
domain, the mean of each cell over its 2 runs. Prints the ratio of times (lower = faster)."""
import sys, glob, os, statistics as st, collections
O = sys.argv[1]
cfg = collections.defaultdict(lambda: collections.defaultdict(list))
for f in glob.glob(O + '/*.samples.tsv'):
    c = os.path.basename(f).rsplit('-', 1)[0]
    for l in open(f):
        if l.startswith(('#', 'contender\t')): continue
        x = l.rstrip('\n').split('\t')
        if x[0] != 'blake3-servil-mt': continue
        v = [int(a) / int(b) for a, b in (y.split('/') for y in x[5].split(','))]
        cfg[c][(x[1], x[2], x[3])].append(st.mean(v))
one, pf, sf = cfg['servil-onel3'], cfg['probe-free'], cfg['servil-free']
rows = []
for k in one:
    if k in pf and k in sf:
        o = st.mean(one[k]); rows.append((k, st.mean(sf[k]) / o, st.mean(pf[k]) / o))
by = collections.defaultdict(list)
for k, s, p in rows: by[(k[0], k[1])].append((k[2], s, p))
print(f"{'scenario use case':34} {'cells':>5}  servil free/one-L3 (median, max)   probe free/one-L3 (median, min-max)")
for (sc, uc), L in sorted(by.items()):
    s = [x[1] for x in L]; p = [x[2] for x in L]
    print(f"{sc+' '+uc:34} {len(L):5}  x{st.median(s):5.2f} (max x{max(s):5.2f})          x{st.median(p):5.2f} (x{min(p):.2f}-x{max(p):.2f})")
worst = sorted(rows, key=lambda r: -r[2])[:8]
print("probe slowest against one-L3:", "; ".join(f"{k[0]} {k[1]} {k[2]} x{p:.2f}" for k, s, p in worst))
