"""Per-CPU medians of the timed pass (cold context), ns a call and cycles a call, relative to CPU 0."""
import sys, statistics as st, collections
O = sys.argv[1]
t = collections.defaultdict(list); c = collections.defaultdict(list); w = collections.defaultdict(list)
procs = collections.defaultdict(lambda: collections.defaultdict(list))
for l in open(O + '/samples.tsv'):
    r = l.rstrip('\n').split('\t')
    mode, proc, rnd, kind, n, cpu, pas = r[:7]
    if pas == 'timed':
        calls = int(r[7]); t[(kind, int(n), int(cpu))].append(int(r[8]) / calls); c[(kind, int(n), int(cpu))].append(int(r[9]) / calls)
        procs[(kind, int(n), int(cpu))][proc].append(int(r[8]) / calls)
    elif pas == 'warm':
        w[(kind, int(n), int(cpu))].append(int(r[8]) / int(r[7]))
cpus = sorted({k[2] for k in t})
print('ns a call (median), and x CPU 0;  cycles x CPU 0 in brackets')
for kind in ('servil', 'official'):
    for n in (1, 2, 8, 64, 1024):
        base = st.median(t[(kind, n, 0)]); cb = st.median(c[(kind, n, 0)])
        cells = [f"{st.median(t[(kind, n, k)]) / base:5.2f}[{st.median(c[(kind, n, k)]) / cb:4.2f}]" for k in cpus]
        print(f"{kind:8} {n:5} cpu0 {base:6.0f} ns | " + ' '.join(f"c{k} {x}" for k, x in zip(cpus, cells)))
print('\nwarm control, x CPU 0:')
for kind in ('servil', 'official'):
    for n in (1, 8):
        base = st.median(w[(kind, n, 0)])
        print(f"{kind:8} {n:5} " + ' '.join(f"c{k} {st.median(w[(kind, n, k)]) / base:5.3f}" for k in cpus))
print('\nper process, servil N=1, odd/even (median of CPUs 1,3,5,7 over 0,2,4,6):')
for p in sorted({p for k in procs for p in procs[k]}, key=int):
    e = [x for k in (0, 2, 4, 6) for x in procs[('servil', 1, k)][p]]; o = [x for k in (1, 3, 5, 7) for x in procs[('servil', 1, k)][p]]
    print(f"  process {p}: {st.median(o) / st.median(e):.3f}")
