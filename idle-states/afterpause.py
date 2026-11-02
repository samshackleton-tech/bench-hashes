"""#106: the after-pause cells' sample spread per machine (one sample a visit): quantiles and a crude mode count."""
import sys, statistics as st
for path in sys.argv[1:]:
    print(path.split('/')[-2])
    for l in open(path):
        if l.startswith(('#','contender\t')): continue
        f = l.rstrip('\n').split('\t')
        if not f[2].startswith('Idle') or f[1] != 'solo' or f[0] not in ('blake3-servil-st','blake3-official','sha256'): continue
        v = sorted(int(a)/int(b) for a, b in (x.split('/') for x in f[5].split(',')))
        q = lambda p: v[int(p*(len(v)-1))]
        print(f"  {f[0]:17} {f[2]:17} {f[3]:6} n={len(v):3}  p10 {q(.1):7.2f} p50 {q(.5):7.2f} p90 {q(.9):7.2f}  p90/p10 {q(.9)/q(.1):.2f}")
