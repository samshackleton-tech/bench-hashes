"""#196: each CPU's clock while active during the stream (aperf/mperf x 3.2 GHz), by where it is
(the caller's CPU 0, its domain, the others), and its activity (mperf over the run's TSC ticks)."""
import sys, glob, os, statistics as st, collections
O = sys.argv[1]
G = collections.defaultdict(lambda: collections.defaultdict(list))
for f in glob.glob(O + '/perf-*.csv'):
    _, v, n, rnd = os.path.basename(f)[:-4].split('-')
    ap, mp = {}, {}
    for l in open(f):
        x = l.strip().split(',')
        if len(x) < 4 or not x[0].startswith('CPU') or x[1] in ('<not counted>', '<not supported>', ''): continue
        cpu = int(x[0][3:])
        (ap if 'aperf' in x[3] else mp)[cpu] = float(x[1])
    span = max(mp.values()) if mp else 0
    for c in ap:
        busy = mp[c] / (2.1e9 * 3.2) if c in mp else 0
        if c in mp and mp[c] > 0.2 * 2e9 * 3.2:  # active over a fifth of the run
            w = 'caller' if c == 0 else ('home' if c % 24 < 6 else 'away')
            G[(v, n)][w].append((3.2 * ap[c] / mp[c], busy))
for n in ('4', '8'):
    for v in ('base', 'r'):
        parts = []
        for w in ('caller', 'home', 'away'):
            x = G[(v, n)][w]
            parts.append(f"{w}: {st.median([g for g, _ in x]):.2f} GHz ({len(x)} CPU-runs active)" if x else f"{w}: none active")
        print(f"{v:4} {n} in flight | " + ' | '.join(parts))
