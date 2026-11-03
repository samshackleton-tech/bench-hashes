"""#69 counted passes: per CPU, median misses a call (groups A, B), only samples whose group ran the whole time."""
import sys, statistics as st, collections
O = sys.argv[1]
A = collections.defaultdict(lambda: collections.defaultdict(list)); mux = tot = 0
T = collections.defaultdict(list); C = collections.defaultdict(list)
for l in open(O + '/samples.tsv'):
    r = l.rstrip('\n').split('\t')
    if r[6] == 'timed':
        T[(r[3], int(r[4]), int(r[5]))].append(int(r[8]) / int(r[7])); C[(r[3], int(r[4]), int(r[5]))].append(int(r[9]) / int(r[7]))
    if not r[6].startswith('counted'): continue
    tot += 1
    g = r[6][-1]; calls = int(r[7]); en, run = int(r[8]), int(r[9])
    if run != en: mux += 1; continue
    A[(r[3], int(r[4]), int(r[5]))][g].append([int(x) / calls for x in r[10:13]])
print(f'counted samples {tot}; dropped as not counted the whole time: {mux}')
names = {'A': ('L1i miss', 'L2 miss (ifetch)', 'iTLB miss, L2 hit'), 'B': ('L1d miss', 'L2 miss (i+d)', 'branch miss')}
cpus = range(8)
for kind in ('servil', 'official'):
    for n in (1, 2, 8, 64):
        print(f"{kind} N={n}:  ns  " + ' '.join(f"{st.median(T[(kind, n, c)]):6.0f}" for c in cpus) + "   cycles " + ' '.join(f"{st.median(C[(kind, n, c)]):6.0f}" for c in cpus))
        for g in 'AB':
            for i, nm in enumerate(names[g]):
                vals = [st.median([x[i] for x in A[(kind, n, c)][g]]) if A[(kind, n, c)][g] else float('nan') for c in cpus]
                print(f"    {nm:18} " + ' '.join(f"{v:6.1f}" for v in vals))
