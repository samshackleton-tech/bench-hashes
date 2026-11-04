"""b128-lic: each cell's cycles a call per sample, by build (A as is, B official no_avx512).
Pre-registered: a 1 KiB sample is slow above 10,000 cycles a call (Devon's table: fast modes at
most 7,005, slow at least 9,858). Prediction: A's official has slow samples after other work and
controlled; B's official and servil st (both builds) have none."""
import sys, glob, os, re, collections, statistics
O = sys.argv[1]
cells = collections.defaultdict(list)  # (arm, contender, point) -> [cycles a call]
for f in sorted(glob.glob(f"{O}/run-*-*.samples.tsv")):
    arm = re.search(r"run-\d+-([AB])\.samples", f).group(1)
    for line in open(f):
        if line.startswith("#") or line.startswith("contender"): continue
        x = line.rstrip("\n").split("\t")
        c, point, units, counts = x[0], x[2] + " " + x[3], x[5], x[9]
        if counts == "-": continue
        size = 64 if point.endswith("64 B") else 1024
        for u, k in zip(units.split(","), counts.split(",")):
            n = int(u.split("/")[1]) // size
            cells[(arm, c, point)].append(int(k.split(":")[1]) / n)
print(f"{'build':5} {'contender':17} {'point':34} {'n':>4} {'min':>7} {'median':>7} {'max':>7} {'slow>10k':>9}")
for key in sorted(cells):
    v = cells[key]; arm, c, p = key
    slow = sum(1 for y in v if y > 10_000) if "1 KiB" in p else "-"
    print(f"{arm:5} {c:17} {p:34} {len(v):4} {min(v):7.0f} {statistics.median(v):7.0f} {max(v):7.0f} {slow!s:>9}")
print()
for f in sorted(glob.glob(f"{O}/perf-*.csv")):
    vals = {}
    for line in open(f):
        y = line.strip().split(",")
        if len(y) > 2 and y[0].replace(".", "").isdigit(): vals[y[2]] = int(float(y[0]))
    cyc = vals.get("cycles", 0) or 1
    print(os.path.basename(f)[5:-4].ljust(34), "cycles", f"{cyc:>13,}", *[f"{k.split('.')[-1][:4]} {vals.get(k, 0) / cyc:6.1%}" for k in ("core_power.lvl0_turbo_license", "core_power.lvl1_turbo_license", "core_power.lvl2_turbo_license")])
