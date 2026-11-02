"""The after-pause protocol experiment: per machine, idle setting, cell and pause, the first call's
median (p10-p90), its cost over steady, the samples' coefficient of variation, and the smallest
difference two runs of 100 samples a side could detect with a test of means (5%, 80% power:
2.8 * sqrt(2) * CV / sqrt(100)). Then, as shipped, how well each recorded counter separates the
slow samples from the fast: the median by the deepest cpuidle state entered, and by the core's
hardware C6 and C1 residency share of the pause."""
import sys, glob, os, math, statistics as st, collections

def q(v, p): v = sorted(v); return v[int(p * (len(v) - 1))]

for run in sys.argv[1:]:
    O = os.path.join(run, 'out')
    m = open(os.path.join(O, 'machine.txt')).read().splitlines()
    names = [l.split()[1] for l in m if l.startswith('state')]
    print(f"== {m[0].split(':', 1)[1].strip()}")
    rows = collections.defaultdict(list)
    for f in sorted(glob.glob(os.path.join(O, '*-[0-9].tsv'))):
        cfg = os.path.basename(f).rsplit('-', 1)[0]
        for l in open(f):
            if l.startswith('#'): continue
            cell, pause, first, steady, du, c1, c6, tsc = l.rstrip('\n').split('\t')
            rows[(cfg, cell, int(pause))].append((int(first), None if steady == '-' else int(steady), [int(x) for x in du.split(',')] if du else [], int(c1), int(c6), int(tsc)))
    cfgs = [c for c in ('shipped', 'noC6', 'C1only') if any(k[0] == c for k in rows)]
    for cell in ('st16x64', 'st1k', 'off1k', 'mt1m'):
        print(f"  {cell}")
        print(f"    {'setting':8} {'pause':>6}  {'median ns':>9} {'p10-p90':>15}  {'x steady':>8}  {'CV':>5}  {'detectable (n=100)':>18}")
        for cfg in cfgs:
            for pause in (20, 200, 1000, 5000):
                v = rows.get((cfg, cell, pause))
                if not v: continue
                first = [r[0] for r in v]; steady = [r[1] for r in v if r[1] is not None]
                mean = st.mean(first); cv = st.stdev(first) / mean
                mde = 2.8 * math.sqrt(2) * cv / 10
                print(f"    {cfg:8} {pause:>5}u  {st.median(first):9.0f} {q(first,.1):7.0f}-{q(first,.9):<7.0f}  {(st.median(first)/st.median(steady) if steady else float('nan')):8.2f}  {cv:5.2f}  {100*mde:16.1f}%")
    if 'shipped' in cfgs:
        print("  as shipped, which counter separates slow from fast (st16x64, median ns):")
        for pause in (200, 1000, 5000):
            v = rows[('shipped', 'st16x64', pause)]
            by = collections.defaultdict(list)
            for first, _, du, c1, c6, tsc in v:
                deep = max((i for i, x in enumerate(du) if x), default=None)
                by['deepest ' + (names[deep] if deep is not None and deep < len(names) else 'none')].append(first)
                if tsc:
                    s6 = c6 / tsc; s1 = c1 / tsc
                    by['C6 share ' + ('0' if s6 < .01 else '<50%' if s6 < .5 else '>=50%')].append(first)
                    by['C1 share ' + ('0' if s1 < .01 else '<50%' if s1 < .5 else '>=50%')].append(first)
            print(f"    pause {pause} us: " + "; ".join(f"{k} {st.median(x):.0f} (n {len(x)})" for k, x in sorted(by.items())))
