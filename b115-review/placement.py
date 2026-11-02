"""#115: the v8 samples' cpu column, classified by the machine's topology. For each shared cell, its
pairs (copy 0's i-th sample beside copy 1's): one CPU, one core's SMT pair, one L3 domain, two L3
domains, two packages; and, where the placement varies within a cell, whether the figure follows it.
Usage: placement.py OUT_DIR (with full.samples.tsv and topology.txt)."""
import sys, os, statistics as st, collections
O = sys.argv[1]
topo = {}
for l in open(os.path.join(O, 'topology.txt')):
    cpu, core, pkg, l3 = l.split()
    topo[int(cpu)] = (int(core), int(pkg), l3)
def kind(a, b):
    if a == b: return 'one CPU'
    (ca, pa, la), (cb, pb, lb) = topo[a], topo[b]
    if pa == pb and ca == cb: return 'SMT pair'
    if la == lb: return 'one L3'
    if pa == pb: return 'two L3s'
    return 'two packages'
lines = [l.rstrip('\n').split('\t') for l in open(os.path.join(O, 'full.samples.tsv')) if not l.startswith('#')]
head = lines[0]; ic = head.index('cpu'); iv = head.index('ns/units')
total = collections.Counter(); per = collections.defaultdict(lambda: collections.defaultdict(list)); missing = 0
solo_cpus = collections.Counter()
for f in lines[1:]:
    if f[ic] == '-': missing += 1; continue
    cpus = [int(x) for x in f[ic].split(',')]
    vals = [int(a) / int(b) for a, b in (x.split('/') for x in f[iv].split(','))]
    if f[1] == 'solo':
        solo_cpus.update(topo[c][2] for c in cpus); continue
    for i in range(0, len(cpus) - 1, 2):
        k = kind(cpus[i], cpus[i + 1]); total[k] += 1
        per[(f[0], f[2], f[3])][k] += [vals[i], vals[i + 1]]
print(f"{os.path.basename(os.path.dirname(O.rstrip('/')))}: rows without CPUs {missing}")
print("  solo samples by L3 domain:", dict(solo_cpus.most_common()))
print("  shared pairs by placement:", dict(total.most_common()))
mixed = [(k, d) for k, d in per.items() if len(d) > 1]
print(f"  shared cells whose pairs met more than one placement: {len(mixed)} of {len(per)}")
for (c, uc, pt), d in sorted(mixed, key=lambda x: -max(st.mean(v) for v in x[1].values()) / min(st.mean(v) for v in x[1].values()))[:8]:
    print(f"    {c} {uc} {pt}: " + "; ".join(f"{k} {st.mean(v):.4f} ns/unit (n {len(v)//2})" for k, v in sorted(d.items())))
