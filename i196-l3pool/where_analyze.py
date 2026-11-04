"""i196-where: messages a second and where the running workers were (the sampler's R-state samples by
the CPU they were on), per socket of the 2x Gold 6330 (0-27,56-83 / 28-55,84-111), and on the callers'
own cores (CPUs 0, 1 and their siblings 56, 57) and CPU 28's (28, 84).
    where_analyze.py OUT"""
import sys, glob, os, re, collections, statistics as st
O = sys.argv[1]
rows = collections.defaultdict(list)
for f in sorted(glob.glob(O + "/*-*-*-*.txt")):
    m = re.match(r"^(base|cores|nospin)-(\d+)-([\d,]+)-(\d)$", os.path.basename(f)[:-4])
    if not m:
        continue
    rate, n, ran = 0.0, 0, collections.Counter()
    for l in open(f):
        x = l.rstrip("\n").split("\t")
        if l.startswith("cpu "): rate += float(l.split()[2])
        elif x[0] == "samples": n = int(x[1])
        elif x[0] == "ran": ran[int(x[1])] += int(x[2])
    sock = lambda c: (c % 56) // 28
    s0 = sum(k for c, k in ran.items() if sock(c) == 0) / max(n, 1)
    s1 = sum(k for c, k in ran.items() if sock(c) == 1) / max(n, 1)
    callers = sum(ran[c] for c in (0, 1, 56, 57)) / max(n, 1)
    rows[(int(m.group(2)), m.group(3), m.group(1))].append((rate, s0, s1, callers, len([c for c in ran if ran[c] > n * 0.05])))
for k in sorted(rows, key=lambda k: (k[0], k[1], k[2])):
    rs = rows[k]
    med = lambda i: st.median(r[i] for r in rs)
    print(f"{k[0]:5} B callers {k[1]:5} {k[2]:5}: {med(0)/1e3:6.0f}k/s | workers running, on average: socket 0 {med(1):5.2f}, socket 1 {med(2):5.2f}, on the callers' cores {med(3):4.2f}; CPUs used >5% of samples {med(4):.0f}")
