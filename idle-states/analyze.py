"""#106 probe: per condition, the first call's ns a message (16 messages) by the deepest state entered in the pause, and the warm second call."""
import sys, glob, os, statistics as st, collections
def q(v, p): v = sorted(v); return v[int(p * (len(v) - 1))]
for run in sys.argv[1:]:
    O = os.path.join(run, 'out'); m = open(os.path.join(O, 'machine.txt')).read()
    names = [l.split()[1] for l in m.splitlines() if l.startswith('state')]
    print(os.path.basename(run)); print('  ' + m.splitlines()[0])
    for cond in ('free', 'noread', 'sibbusy', 'noC6', 'C1only', 'before', 'none', 'after', 'none-noC6', 'none-C1only', 'after-sibbusy', 'none-d20'):
        files = sorted(glob.glob(os.path.join(O, f'{cond}-[0-9].tsv')))
        if not files: continue
        first, second, by = [], [], collections.defaultdict(list)
        for f in files:
            for l in open(f):
                v, a, b, du, dt = (l.rstrip('\n').split('\t') + ['', ''])[:5]
                a, b = int(a) / 16, int(b) / 16; first.append(a); second.append(b)
                if du:
                    u = [int(x) for x in du.split(',')]
                    deep = max((i for i, x in enumerate(u) if x), default=None)
                    by[names[deep] if deep is not None else 'none'].append(a)
        print(f"  {cond:8} n={len(first)} first p10 {q(first,.1):6.1f} p50 {q(first,.5):6.1f} p90 {q(first,.9):6.1f} (p90/p10 {q(first,.9)/q(first,.1):.2f}); warm second p50 {q(second,.5):5.1f}")
        for k in names + ['none']:
            if by.get(k): print(f"      deepest {k:5} {len(by[k]):5} visits ({100*len(by[k])/len(first):4.1f}%): p10 {q(by[k],.1):6.1f} p50 {q(by[k],.5):6.1f} p90 {q(by[k],.9):6.1f}")
    for f in sorted(glob.glob(os.path.join(O, '*.states'))): print('   ', os.path.basename(f), open(f).read().strip())
