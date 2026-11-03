"""#196: for each task, whether its SMT sibling CPU (c +/- 24) ran another task at the same time,
and the hash time of tasks with and without a busy sibling."""
import sys, gzip, statistics as st, collections, bisect
O = sys.argv[1]
res = {}
for l in open(O + '/results.txt'):
    v, n, rnd, rate, tpn = l.split()[:5]; res[(v, n, rnd)] = float(tpn)
print(f"{'side':4} {'in flight':9} | tasks with a busy sibling | hash us: sibling busy / sibling idle | CPUs used")
for n in ('4', '8'):
    for v in ('base', 'r'):
        both = []; alone = []; cpus = collections.Counter()
        for rnd in '123':
            tpn = res[(v, n, rnd)]
            by = collections.defaultdict(list)
            for l in gzip.open(f"{O}/{v}-{n}-{rnd}.tasks.gz", 'rt'):
                s, e, c = map(int, l.split()); by[c].append((s, e)); cpus[c] += 1
            for c in by: by[c].sort()
            starts = {c: [s for s, _ in by[c]] for c in by}
            for c, ts in by.items():
                sib = c + 24 if c < 24 else c - 24
                if sib not in by: alone += [(e - s) / tpn / 1000 for s, e in ts]; continue
                ss = starts[sib]; sl = by[sib]
                for s, e in ts:
                    i = bisect.bisect_left(ss, e)  # sibling tasks starting before this one ends
                    busy = any(sl[j][1] > s for j in range(max(0, i - 3), i))
                    (both if busy else alone).append((e - s) / tpn / 1000)
        tot = len(both) + len(alone)
        top = ','.join(str(c) for c, _ in cpus.most_common(14))
        print(f"{v:4} {n:9} | {100 * len(both) / tot:5.1f}% | {st.median(both) if both else float('nan'):5.2f} / {st.median(alone):5.2f} | {top}")
