"""b069-pinaa: each cell's spread of pair log ratios (new mean / old mean), pinned against unpinned.
A run's cell mean is its samples' total ns over total units (clocks::summary's mean). regress --keep
writes run-NNN-old.tsv / run-NNN-new.tsv, a pair's two runs consecutive."""
import glob, math, re, statistics, sys, collections
O = sys.argv[1]
def means(path):
    m = {}
    for line in open(path):
        if line.startswith("#") or line.startswith("contender"): continue
        x = line.rstrip("\n").split("\t")
        if x[1] != "solo": continue
        ns = units = 0
        for s in x[5].split(","):
            a, b = s.split("/"); ns += int(a); units += int(b)
        m[f"{x[0]}|{x[2]}|{x[3]}"] = ns / units
    return m
def pairs(d):
    runs = sorted(glob.glob(f"{d}/run-*.tsv"))
    out = collections.defaultdict(list)
    for a, b in zip(runs[0::2], runs[1::2]):
        side = {("old" if a.endswith("-old.tsv") else "new"): means(a), ("old" if b.endswith("-old.tsv") else "new"): means(b)}
        for k in side["old"]:
            if k in side["new"]: out[k].append(math.log(side["new"][k] / side["old"][k]))
    return out
mode = {m: collections.defaultdict(list) for m in ("pinned", "unpinned")}
for m in mode:
    for d in sorted(glob.glob(f"{O}/{m}-*")):
        if not glob.glob(f"{d}/run-*.tsv"): continue
        for k, v in pairs(d).items(): mode[m][k] += v
print(f"{'cell':55} {'pairs':>5} {'sd unpinned':>11} {'sd pinned':>10} {'ratio':>6} {'mean unp':>8} {'mean pin':>8}")
ratios = []
for k in sorted(set(mode["pinned"]) & set(mode["unpinned"])):
    u, p = mode["unpinned"][k], mode["pinned"][k]
    if len(u) < 3 or len(p) < 3: continue
    su, sp = statistics.stdev(u), statistics.stdev(p)
    ratios.append((k, su / sp if sp else float("inf")))
    print(f"{k:55} {len(p):5} {100*su:10.1f}% {100*sp:9.1f}% {su/sp if sp else 0:6.2f} {100*(math.exp(statistics.mean(u))-1):+7.1f}% {100*(math.exp(statistics.mean(p))-1):+7.1f}%")
small = [r for k, r in ratios if "idle" not in k.lower() and "1 MiB" not in k and "|1024" not in k]
print("median spread ratio (unpinned/pinned), small cells after other work:", round(statistics.median(small), 2) if small else None)
