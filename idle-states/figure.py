"""#105: each shared cell's figure (the mean of its samples) with step 6 against without it, and Devon's named cells."""
import sys, statistics as st, collections
NAMED = {('blake3-servil-mt','LentMessages','64 MiB'),('blake3-servil-mt','LentMessages','16 MiB'),('blake3-servil-mt','ContinuousMessages','4 KiB'),('blake3-servil-st','LentMessages','64 MiB')}
for path in sys.argv[1:]:
    print(path.split('/')[-2])
    eff = collections.defaultdict(list)
    for l in open(path):
        if l.startswith(('#','contender\t')): continue
        f = l.rstrip('\n').split('\t')
        if f[1] != 'shared': continue
        v = [int(a)/int(b) for a, b in (x.split('/') for x in f[5].split(','))]
        if len(v) % 12: continue
        keep = [x for i, x in enumerate(v) if (i // 2) % 6 != 5]
        r = st.mean(v) / st.mean(keep)  # the report's figure is the cell's mean (METHODOLOGY)
        eff[f[0]].append(r)
        if (f[0], f[2], f[3]) in NAMED:
            pairs = [(v[i], v[i+1]) for i in range(0, len(v), 2)]
            s6 = [x for k, p in enumerate(pairs) if k % 6 == 5 for x in p]; s15 = [x for k, p in enumerate(pairs) if k % 6 != 5 for x in p]
            ap6 = [max(p)/min(p) for k, p in enumerate(pairs) if k % 6 == 5]; ap15 = [max(p)/min(p) for k, p in enumerate(pairs) if k % 6 != 5]
            print(f"  {f[0]} {f[2]} {f[3]}: step6 x{st.median(s6)/st.median(s15):.3f}, apart {st.median(ap6):.2f} ({st.median(ap15):.2f}); figure moves x{r:.4f}")
    for c, L in sorted(eff.items()):
        L.sort(); print(f"  figure with/without step 6, {c:18}: median x{st.median(L):.4f}, min x{L[0]:.4f}, max x{L[-1]:.4f}, |change|>1%: {sum(abs(x-1)>.01 for x in L)}/{len(L)}")
