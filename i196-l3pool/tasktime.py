"""#196 task times: per side and depth, a task's hash time by where it ran (the caller's CPU 0,
its domain 0-5/24-29, other domains), the share of tasks in each, and a message's submit-to-collect."""
import sys, gzip, glob, os, statistics as st, collections
O = sys.argv[1]
res = {}
for l in open(O + '/results.txt'):
    v, n, rnd, rate, tpn = l.split(); res[(v, n, rnd)] = (float(rate), float(tpn))
def where(c):
    if c == 0: return 'caller'
    return 'home' if (c % 24) < 6 else 'away'
agg = collections.defaultdict(lambda: collections.defaultdict(list)); lat = collections.defaultdict(list); share = collections.defaultdict(collections.Counter)
for (v, n, rnd), (rate, tpn) in res.items():
    for l in gzip.open(f"{O}/{v}-{n}-{rnd}.tasks.gz", 'rt'):
        s, e, c = map(int, l.split()); w = where(c)
        agg[(v, n)][w].append((e - s) / tpn / 1000); share[(v, n)][w] += 1
    for l in gzip.open(f"{O}/{v}-{n}-{rnd}.msgs.gz", 'rt'):
        s, c = map(int, l.split())
        if s: lat[(v, n)].append((c - s) / tpn / 1000)
print(f"{'side':5} {'in flight':9} | {'GB/s':>6} | {'msg latency us':>14} | task hash us (median) and share: caller | home domain | other domains")
for n in sorted({k[1] for k in res}, key=int):
    for v in [x for x in ('base', 'r', 'cores') if (x, n, '1') in res]:
        rate = st.median([res[(v, n, r)][0] for r in '123']) * 65536 / 1e9
        tot = sum(share[(v, n)].values())
        cells = ' | '.join(f"{st.median(agg[(v, n)][w]):5.2f} us {100 * share[(v, n)][w] / tot:4.0f}%" if agg[(v, n)][w] else f"{'-':>5}    {0:4.0f}%" for w in ('caller', 'home', 'away'))
        print(f"{v:5} {n:9} | {rate:6.1f} | {st.median(lat[(v, n)]):14.2f} | {cells}")
