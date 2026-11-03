"""i196-threads2: messages a second, and the workers' CPU time and voluntary switches by domain
(their CPUs: the EPYC's domains 0-5,24-29 / 6-11,30-35 / 12-17,36-41 / 18-23,42-47) and, for -split,
by role: the workers in TID order are workers 1..47 (worker 1 spawns the rest in order); a worker's
local index in its domain at or past the domain's 6 cores is a second worker.
    threads2_analyze.py OUT"""
import sys, glob, os, re, collections, statistics as st

O = sys.argv[1]


def domain(cpus):
    first = int(re.split("[-,]", cpus)[0])
    return (first % 24) // 6


rows = collections.defaultdict(lambda: collections.defaultdict(list))
for f in sorted(glob.glob(O + "/*-*-*-*.txt")):
    m = re.match(r"^(base|split|corepin)-(\d+)-([\d,]+)-(\d)$", os.path.basename(f)[:-4])
    if not m:
        continue
    v, size, callers = m.group(1), int(m.group(2)), m.group(3)
    rate, workers = 0.0, []
    for l in open(f):
        x = l.rstrip("\n").split("\t")
        if l.startswith("cpu "):
            rate += float(l.split()[2])
        elif x[0] == "thread" and x[1].startswith("blake3-worker"):
            workers.append((int(x[4]), int(x[2]), int(x[3] or 0), x[5]))
    workers.sort()
    seen = collections.Counter()
    acc = collections.Counter()
    for tid, ns, vol, cpus in workers:
        d = domain(cpus)
        local = seen[d]; seen[d] += 1
        role = "" if v != "split" else (" primary" if local < 6 else " second")
        acc[f"d{d}{role} s"] += ns / 1e9
        acc[f"d{d}{role} wakes/1k"] += vol / 1e3
    rows[(size, callers)][v].append((rate, acc, len(workers)))

for k in sorted(rows, key=lambda k: (-k[0], k[1])):
    print(f"{k[0]:6} B, callers on CPUs {k[1]}:")
    for v in ("base", "split", "corepin"):
        rs = rows[k][v]
        if not rs:
            continue
        keys = sorted({key for _, a, _ in rs for key in a if key.endswith(" s")})
        parts = " | ".join(f"{key[:-2]} {st.median(a[key] for _, a, _ in rs):5.2f}s {st.median(a[key[:-2] + ' wakes/1k'] for _, a, _ in rs):4.0f}k" for key in keys)
        print(f"   {v:8} {st.median(r for r, _, _ in rs):9.0f}/s ({rs[0][2]} workers) | {parts}")
