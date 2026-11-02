"""Compact: per machine, block and cell, the detectable change (n=100 a side) and x steady at the
four pauses; and, as shipped, the counters' separation (st16x64 at 1 ms)."""
import sys, glob, os, math, statistics as st, collections
for run in sys.argv[1:]:
    O = os.path.join(run, 'out')
    m = open(os.path.join(O, 'machine.txt')).read().splitlines()
    rows = collections.defaultdict(list)
    for f in glob.glob(os.path.join(O, '*-[0-9].tsv')):
        cfg = os.path.basename(f).rsplit('-', 1)[0]
        for l in open(f):
            if l.startswith('#'): continue
            x = l.rstrip('\n').split('\t') + ['0', '0']
            rows[(cfg, x[0], int(x[1]))].append((int(x[2]), None if x[3] == '-' else int(x[3]), x[4], int(x[5]), int(x[6]), int(x[7]), int(x[8]), int(x[9])))
    cfgs = sorted({k[0] for k in rows}, key=lambda c: (c != 'shipped', c))
    states = {c: (open(os.path.join(O, c + '-1.states')).read().split() if os.path.exists(os.path.join(O, c + '-1.states')) else []) for c in cfgs}
    print(f"== {m[0].split(':', 1)[1].strip()}   (detectable %, n=100 a side, at 20us/200us/1ms/5ms; then x steady at 1 ms)")
    for c in cfgs:
        on = [s.split('=')[0] for s in states[c] if s.endswith('=0')]
        cells = []
        for cell in ('st16x64', 'st1k', 'off1k', 'mt1m'):
            ds = []
            for p in (20, 200, 1000, 5000):
                v = [r[0] for r in rows[(c, cell, p)]]
                ds.append(100 * 2.8 * math.sqrt(2) * st.stdev(v) / st.mean(v) / 10)
            v = [r[0] for r in rows[(c, cell, 1000)]]; s = [r[1] for r in rows[(c, cell, 1000)] if r[1]]
            cells.append(f"{cell} {'/'.join(f'{d:.0f}' for d in ds)} x{st.median(v)/st.median(s):.1f}")
        print(f"  {c:8} [{','.join(on)}]  " + "  ".join(cells))
    v = rows[('shipped', 'st16x64', 1000)]
    by = collections.defaultdict(list)
    for first, _, du, c1, c6, tsc, c7, c3 in v:
        for nm, x in (('C1', c1), ('C3', c3), ('C6', c6), ('C7', c7)):
            sh = x / tsc if tsc else 0
            by[nm + (' 0' if sh < .01 else ' <50%' if sh < .5 else ' >=50%')].append(first)
    print("  shipped st16x64 1 ms, median ns by the core's hardware residency share:", "; ".join(f"{k} {st.median(x):.0f} (n {len(x)})" for k, x in sorted(by.items())))
