import sys, glob, re, statistics, collections
Q = sys.argv[1]
d = collections.defaultdict(list)
for f in glob.glob(f"{Q}/*-*-*.txt"):
    m = re.search(r"/(one|pool)-(base|change)-\d\.txt$", f)
    if not m: continue
    for line in open(f):
        x = re.match(r"\s*((?:mixed\s+)?\d+) B x\s+\d+: hash\(\) ([\d.]+) ns/B \(cpu ([\d.]+)\) \| stream ([\d.]+) \(cpu ([\d.]+)\) \| sha256 ([\d.]+)", line)
        if x: d[(m.group(1), x.group(1).replace('mixed ','~').replace(' ',''))].append((m.group(2),) + tuple(float(v) for v in x.groups()[1:]))
print(f"{'mode':5} {'size':>6} {'hash()':>7} {'stream base':>12} {'stream change':>14} {'SHA-256':>8} {'change/SHA-256':>15} {'cpu base':>9} {'cpu change':>11}")
for (mode, size), rows in sorted(d.items()):
    med = lambda side, i: statistics.median(r[i] for r in rows if r[0] == side)
    print(f"{mode:5} {size:>6} {med('base',1):7.3f} {med('base',3):12.3f} {med('change',3):14.3f} {med('base',5):8.3f} {med('change',3)/med('base',5):15.2f} {med('base',4):9.3f} {med('change',4):11.3f}")
