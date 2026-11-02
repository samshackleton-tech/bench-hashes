"""#113 split: per machine, the timed call's median ns per filler, and against no filler."""
import sys, statistics as st, collections
for path in sys.argv[1:]:
    d = collections.defaultdict(list); spin = None
    for l in open(path):
        if l.startswith('# perf reads median ns'): spin = l.split('\t')[1].strip(); continue
        f, h, size, ns = l.split('\t'); d[(h, int(size), f)].append(int(ns))
    print(path.split('/')[-3], f'(perf reads {spin} ns; spin the same)')
    print(f"  {'call':18} {'none':>7} {'perf':>14} {'getppid':>14} {'spin':>14}   (median ns; x against none)")
    for h in ('servil', 'official'):
        for size in (64, 1024, 16384):
            base = st.median(d[(h, size, 'none')])
            cells = [f"{st.median(d[(h,size,f)]):7.0f} x{st.median(d[(h,size,f)])/base:4.2f}" for f in ('perf', 'getppid', 'spin')]
            print(f"  {h+' '+str(size)+' B':18} {base:7.0f} " + " ".join(f"{c:>14}" for c in cells))
