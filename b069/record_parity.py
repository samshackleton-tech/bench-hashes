"""0.20 EPYC record, solo cells after a gap: the odd/even core effect in the record's own samples, and
how much of a cell's spread core parity explains. A sample's core is its CPU mod 24 (SMT pairs
k, k+24); odd = core % 2."""
import sys, math, statistics as st, collections
rows = [l.rstrip('\n').split('\t') for l in open(sys.argv[1]) if not l.startswith('#')]
head, rows = rows[0], rows[1:]
ix = {k: i for i, k in enumerate(head)}
out = collections.defaultdict(list)
for r in rows:
    if r[ix['scenario']] != 'solo' or r[ix['cpu']] in ('-', ''): continue
    uc = r[ix['use_case']]
    if not (uc in ('OneMessage', 'ManyMessages', 'ManyLongMessages', 'IdleOneMessage', 'IdleManyMessages') or uc.startswith('Interleaved')): continue
    t = [int(a) / int(b) for a, b in (x.split('/') for x in r[ix['ns/units']].split(','))]
    c = [int(x) for x in r[ix['cpu']].split(',')]
    if len(t) != len(c): continue
    odd = [x for x, k in zip(t, c) if (k % 24) % 2]
    even = [x for x, k in zip(t, c) if not (k % 24) % 2]
    if len(odd) < 3 or len(even) < 3: continue
    lg = [math.log(x) for x in t]
    total = st.pvariance(lg)
    lo, le = [math.log(x) for x in odd], [math.log(x) for x in even]
    within = (st.pvariance(lo) * len(lo) + st.pvariance(le) * len(le)) / len(lg)
    out[(uc, r[ix['point']])].append((r[ix['contender']], st.median(odd) / st.median(even), 1 - within / total if total > 0 else 0, len(odd), len(even)))
print(f"{'use case':18} {'point':>10} | odd/even (median over contenders, range) | spread explained by parity (median) | contenders")
for (uc, p), v in sorted(out.items(), key=lambda kv: (kv[0][0], kv[0][1])):
    rat = [x[1] for x in v]; ex = [x[2] for x in v]
    print(f"{uc:18} {p:>10} | x{st.median(rat):.3f} ({min(rat):.2f}-{max(rat):.2f}) | {100 * st.median(ex):4.0f}% | {len(v)}")
