"""#196 EVERY_LEN: servil mt's large one-shot and stream cells per variant, the mean over 3 runs,
as times relative to the 32 MiB variant (lower = faster), and GB/s for 32."""
import sys, glob, os, statistics as st, collections
O = sys.argv[1]
d = collections.defaultdict(lambda: collections.defaultdict(list))
for f in glob.glob(O + '/*.samples.tsv'):
    v = os.path.basename(f).split('-')[0]
    for l in open(f):
        if l.startswith(('#', 'contender\t')): continue
        x = l.rstrip('\n').split('\t')
        if x[0] != 'blake3-servil-mt': continue
        vals = [int(a) / int(b) for a, b in (y.split('/') for y in x[5].split(','))]
        d[(x[1], x[2], x[3])][v].append(st.mean(vals))
want = lambda k: k[2].endswith('MiB') and (k[1] in ('OneMessage', 'IdleOneMessage', 'LentMessages', 'ContinuousMessages')) and int(k[2].split()[0]) >= 2
vs = ['8', '16', '32', '64', 'never']
print(f"{'cell':36} {'32 MiB GB/s':>11}  " + "  ".join(f"{v:>6}" for v in vs))
for k in sorted((k for k in d if want(k)), key=lambda k: (k[0], k[1], int(k[2].split()[0]))):
    if not all(v in d[k] for v in vs): continue
    ref = st.mean(d[k]['32'])
    print(f"{' '.join(k):36} {1/ref:11.2f}  " + "  ".join(f"x{st.mean(d[k][v])/ref:5.2f}" for v in vs))
