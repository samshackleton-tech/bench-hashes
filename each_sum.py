import sys, glob, re, statistics, collections
Q = sys.argv[1]; d = collections.defaultdict(list)
for f in glob.glob(f"{Q}/each-*-*.txt"):
    side = re.search(r"each-(base|change)-\d", f).group(1)
    for line in open(f):
        x = re.match(r"mixed ~\s*(\d+) B x\s+\d+: hash_each ([\d.]+) ns/B \| hash\(\) ([\d.]+) \| sha256 ([\d.]+)", line)
        if x: d[int(x.group(1))].append((side,) + tuple(float(v) for v in x.groups()[1:]))
print(f"{'~size':>6} {'hash_each base':>15} {'change':>8} {'hash()':>7} {'SHA-256':>8} {'change/SHA':>11}")
for size, rows in sorted(d.items()):
    m = lambda side, i: statistics.median(r[i] for r in rows if r[0] == side)
    print(f"{size:6} {m('base',1):15.3f} {m('change',1):8.3f} {m('base',2):7.3f} {m('base',3):8.3f} {m('change',1)/m('base',3):11.2f}")
