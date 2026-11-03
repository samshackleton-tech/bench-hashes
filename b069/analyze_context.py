"""#69 context experiment: odd/even ratios per context, cell and pass."""
import sys, statistics as st, collections, math
O = sys.argv[1]
rows = [l.rstrip('\n').split('\t') for l in open(O + '/samples.tsv')]
timed = collections.defaultdict(list)   # (mode, kind, n, cpu, proc) -> ns a call
warm = collections.defaultdict(list)
cnt = collections.defaultdict(lambda: collections.defaultdict(list))
pinned_wrong = 0
for r in rows:
    mode, proc, rnd, kind, n, cpu, pas = r[:7]
    calls = int(r[7]); n = int(n); cpu = int(cpu); proc = int(proc)
    if pas == 'timed':
        if int(r[11]) != cpu: pinned_wrong += 1
        timed[(mode, kind, n, cpu, proc)].append((int(r[8]) / calls, int(r[9]) / calls, int(r[10]) / calls))
    elif pas == 'warm':
        warm[(mode, kind, n, cpu, proc)].append(int(r[8]) / calls)
    else:
        wall, cyc, ins, ran, l1i, l1d, br, llc = map(int, r[8:16])
        for name, v in (('cyc', cyc), ('ins', ins), ('l1i', l1i), ('l1d', l1d), ('br', br), ('llc', llc)):
            cnt[(mode, kind, n, cpu)][name].append(v / calls)
print('samples off their pinned CPU:', pinned_wrong)
modes = ['cold', 'pool', 'pool+duo']
procs = sorted({k[4] for k in timed})
def med(xs): return st.median(xs)
print('\nodd/even (CPUs 1,3 over 0,2), median ns a call over samples; per process the ratio of medians, then their range')
print(f"{'mode':9} {'kind':8} {'N':>5} | {'even ns':>8} {'odd ns':>8} {'odd/even':>8} | per-process ratios | cycles o/e  instr o/e | warm o/e")
for mode in modes:
    for kind in ('servil', 'official'):
        for n in (1, 2, 6, 8, 64, 1024):
            ev = [x[0] for c in (0, 2) for p in procs for x in timed.get((mode, kind, n, c, p), [])]
            od = [x[0] for c in (1, 3) for p in procs for x in timed.get((mode, kind, n, c, p), [])]
            if not ev: continue
            evc = [x[1] for c in (0, 2) for p in procs for x in timed.get((mode, kind, n, c, p), [])]
            odc = [x[1] for c in (1, 3) for p in procs for x in timed.get((mode, kind, n, c, p), [])]
            evi = [x[2] for c in (0, 2) for p in procs for x in timed.get((mode, kind, n, c, p), [])]
            odi = [x[2] for c in (1, 3) for p in procs for x in timed.get((mode, kind, n, c, p), [])]
            pr = []
            for p in procs:
                e = [x[0] for c in (0, 2) for x in timed.get((mode, kind, n, c, p), [])]
                o = [x[0] for c in (1, 3) for x in timed.get((mode, kind, n, c, p), [])]
                if e and o: pr.append(med(o) / med(e))
            we = [x for c in (0, 2) for p in procs for x in warm.get((mode, kind, n, c, p), [])]
            wo = [x for c in (1, 3) for p in procs for x in warm.get((mode, kind, n, c, p), [])]
            print(f"{mode:9} {kind:8} {n:5} | {med(ev):8.0f} {med(od):8.0f} {med(od)/med(ev):8.3f} | {min(pr):.3f}-{max(pr):.3f} | {med(odc)/med(evc):10.3f} {med(odi)/med(evi):10.3f} | {med(wo)/med(we):.3f}")
print('\ncounted pass, per call (median): even -> odd')
for mode in modes:
    for kind in ('servil', 'official'):
        for n in (1, 8, 64):
            e = cnt[(mode, kind, n, 0)]; e2 = cnt[(mode, kind, n, 2)]; o = cnt[(mode, kind, n, 1)]; o2 = cnt[(mode, kind, n, 3)]
            if not e: continue
            s = ' '.join(f"{k} {med(e[k]+e2[k]):.0f}->{med(o[k]+o2[k]):.0f}" for k in ('cyc', 'ins', 'l1i', 'l1d', 'br', 'llc'))
            print(f"  {mode:9} {kind:8} {n:4}  {s}")
