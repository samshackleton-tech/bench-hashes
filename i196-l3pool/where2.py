"""Where the workers ran (the sampler's R-state samples, by CPU), per L3 domain, and on the callers'
cores (callers' CPUs and their SMT siblings); with messages a second. Topology: epyc (4 domains of
6 cores, siblings +24) or xeon (2 sockets of 28, siblings +56).
    where2.py OUT epyc|xeon VARIANT..."""
import sys, glob, os, re, collections, statistics as st
O, topo, *V = sys.argv[1:]
N, PER, SIB = (4, 6, 24) if topo == "epyc" else (2, 28, 56)
dom = lambda c: (c % SIB) // PER
rows = collections.defaultdict(list)
for f in sorted(glob.glob(O + "/*-*-*-*.txt")):
    m = re.match(r"^(" + "|".join(V) + r")-(\d+)-([\d,]+)-(\d)$", os.path.basename(f)[:-4])
    if not m: continue
    cps = [int(c) for c in m.group(3).split(",")]
    own = set(cps) | {c + SIB for c in cps}
    rate, n, ran = 0.0, 0, collections.Counter()
    for l in open(f):
        x = l.rstrip("\n").split("\t")
        if l.startswith("cpu "): rate += float(l.split()[2])
        elif x[0] == "samples": n = int(x[1])
        elif x[0] == "ran": ran[int(x[1])] += int(x[2])
    per = [sum(k for c, k in ran.items() if dom(c) == d) / max(n, 1) for d in range(N)]
    rows[(int(m.group(2)), m.group(3), m.group(1))].append((rate, per, sum(ran[c] for c in own) / max(n, 1)))
for k in sorted(rows, key=lambda k: (k[0], k[1], V.index(k[2]))):
    rs = rows[k]
    per = [st.median(r[1][d] for r in rs) for d in range(N)]
    b = rows.get((k[0], k[1], V[0]))
    ratio = st.median(r[0] for r in rs) / st.median(r[0] for r in b) if b else float("nan")
    print(f"{k[0]:6} B callers {k[1]:5} {k[2]:5} {st.median(r[0] for r in rs)/1e3:7.0f}k/s x{ratio:.2f} | running by domain " + " ".join(f"{p:5.2f}" for p in per) + f" | on callers' cores {st.median(r[2] for r in rs):.2f}")
