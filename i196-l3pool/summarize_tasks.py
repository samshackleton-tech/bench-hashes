"""Per run of tasktime.sh/clock.sh: quantiles of a task's hash time by where it ran, and of a
message's submit-to-collect; plus the first 20,000 records of each log (the raw logs are kept
elsewhere: about 300 MB a run)."""
import sys, gzip, glob, os, statistics as st, collections
O, OUT = sys.argv[1], sys.argv[2]
os.makedirs(OUT, exist_ok=True)
res = {}
for l in open(O + '/results.txt'):
    v, n, rnd, rate, tpn = l.split()[:5]; res[(v, n, rnd)] = float(tpn)
def where(c): return 'caller' if c == 0 else ('home' if (c % 24) < 6 else 'away')
Q = (1, 5, 25, 50, 75, 95, 99)
with open(OUT + '/summary.tsv', 'w') as s:
    s.write("side\tin_flight\tround\tkind\twhere\tcount\t" + "\t".join(f"p{q}_us" for q in Q) + "\n")
    for (v, n, rnd), tpn in sorted(res.items()):
        by = collections.defaultdict(list)
        with gzip.open(f"{O}/{v}-{n}-{rnd}.tasks.gz", 'rt') as f, open(f"{OUT}/{v}-{n}-{rnd}.tasks.head", 'w') as h:
            for i, l in enumerate(f):
                if i < 20000: h.write(l)
                a, b, c = map(int, l.split()); by[where(c)].append((b - a) / tpn / 1000)
        lat = []
        with gzip.open(f"{O}/{v}-{n}-{rnd}.msgs.gz", 'rt') as f, open(f"{OUT}/{v}-{n}-{rnd}.msgs.head", 'w') as h:
            for i, l in enumerate(f):
                if i < 20000: h.write(l)
                a, c = map(int, l.split())
                if a: lat.append((c - a) / tpn / 1000)
        for kind, w, xs in [('task', w, by[w]) for w in ('caller', 'home', 'away')] + [('message', 'all', lat)]:
            if not xs: continue
            qs = st.quantiles(xs, n=100)
            s.write(f"{v}\t{n}\t{rnd}\t{kind}\t{w}\t{len(xs)}\t" + "\t".join(f"{qs[q - 1]:.3f}" for q in Q) + "\n")
print("summarized", O)
