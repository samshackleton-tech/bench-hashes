"""#196: L2 fills per task by source, by where the task ran: each CPU's fills (perf stat -a -A,
l2_fill_rsp_src) over the tasks it ran (the run's logs); CPUs that ran under 1000 tasks skipped."""
import sys, glob, gzip, os, statistics as st, collections
O = sys.argv[1]
def where(c): return 'caller' if c == 0 else ('home' if (c % 24) < 6 else 'away')
out = collections.defaultdict(lambda: collections.defaultdict(list))
for f in glob.glob(O + '/perf-*.csv'):
    _, v, n, rnd = os.path.basename(f)[:-4].split('-')
    ev = collections.defaultdict(dict)
    for l in open(f):
        x = l.strip().split(',')
        if len(x) < 4 or not x[0].startswith('CPU') or x[1] in ('<not counted>', '<not supported>', ''): continue
        ev[int(x[0][3:])][x[3].split('.')[-1]] = float(x[1])
    tasks = collections.Counter()
    for l in gzip.open(f"{O}/{v}-{n}-{rnd}.tasks.gz", 'rt'):
        tasks[int(l.split()[2])] += 1
    for c, k in tasks.items():
        if k < 1000 or c not in ev: continue
        e = ev[c]
        out[(v, n)][where(c)].append({s: e.get(s, 0) / k for s in ('local_ccx', 'near_cache', 'dram_io_near', 'all')})
print("L2 fills per 64 KiB task (1024 lines), median over CPUs that ran tasks: this CCD | another CCD's cache | DRAM | all")
for n in ('4', '8'):
    for v in ('base', 'r'):
        cells = []
        for w in ('home', 'away'):
            x = out[(v, n)][w]
            if not x: cells.append(f"{w}: -"); continue
            m = {s: st.median([d[s] for d in x]) for s in ('local_ccx', 'near_cache', 'dram_io_near', 'all')}
            cells.append(f"{w} ({len(x)} CPU-runs): {m['local_ccx']:6.0f} | {m['near_cache']:6.0f} | {m['dram_io_near']:5.0f} | {m['all']:6.0f}")
        print(f"{v:4} {n} in flight  " + '   '.join(cells))
