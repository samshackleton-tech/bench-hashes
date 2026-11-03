"""#69 option (a): per cell, the median, the spread within a run (IQR/median of its samples, mean
over runs), the spread between runs (range/mean of the 4 runs' medians), by configuration."""
import sys, glob, os, statistics as st, collections
O = sys.argv[1]
cells = collections.defaultdict(lambda: collections.defaultdict(list))  # cell -> config -> [(median, iqr_rel, cpus)]
for f in sorted(glob.glob(O + '/*.samples.tsv')):
    conf = os.path.basename(f).split('-')[0]
    rows = [l.rstrip('\n').split('\t') for l in open(f) if not l.startswith('#')]
    head, rows = rows[0], rows[1:]; ix = {k: i for i, k in enumerate(head)}
    for r in rows:
        if r[ix['scenario']] != 'solo': continue
        t = sorted(int(a) / int(b) for a, b in (x.split('/') for x in r[ix['ns/units']].split(',')))
        cpus = set(r[ix['cpu']].split(','))
        q = st.quantiles(t, n=4)
        cells[(r[ix['contender']], r[ix['use_case']], r[ix['point']])][conf].append((st.median(t), (q[2] - q[0]) / st.median(t), cpus))
print(f"{'cell':44} | {'median ns/unit: U   P0   P1':28} | P1/P0 | within-run IQR/med U P0 P1 | between runs range/mean U P0 P1")
for k in sorted(cells, key=lambda k: (k[1], k[0], k[2])):
    v = cells[k]
    if not all(c in v for c in ('U', 'P0', 'P1')): continue
    med = {c: st.median([x[0] for x in v[c]]) for c in ('U', 'P0', 'P1')}
    iqr = {c: st.mean([x[1] for x in v[c]]) for c in ('U', 'P0', 'P1')}
    btw = {c: (max(x[0] for x in v[c]) - min(x[0] for x in v[c])) / st.mean([x[0] for x in v[c]]) for c in ('U', 'P0', 'P1')}
    pinned_ok = all(x[2] == {'0'} for x in v['P0']) and all(x[2] == {'1'} for x in v['P1'])
    name = f"{k[0].replace('blake3-', '')} {k[1]} {k[2]}"
    print(f"{name:44} | {med['U']:8.3f} {med['P0']:8.3f} {med['P1']:8.3f} | x{med['P1']/med['P0']:.2f} | {100*iqr['U']:4.0f}% {100*iqr['P0']:4.0f}% {100*iqr['P1']:4.0f}% | {100*btw['U']:4.0f}% {100*btw['P0']:4.0f}% {100*btw['P1']:4.0f}%{'' if pinned_ok else '  (PIN NOT HELD)'}")
