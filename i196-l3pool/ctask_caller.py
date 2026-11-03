"""i196-ctask2/3: the caller's side of the bench's servil mt ContinuousMessages 64 KiB samples, per variant."""
import sys, glob, gzip, os, statistics as st, collections, bisect
O = sys.argv[1]; TPN = float(sys.argv[2]) if len(sys.argv) > 2 else 3.2
SIZES = {int(x) for x in sys.argv[3].split(',')} if len(sys.argv) > 3 else {142, 146}
variants = sorted({os.path.basename(f).split('-')[1] for f in glob.glob(O + '/log-*.gz')})
for v in variants:
    R = collections.defaultdict(list)
    for f in sorted(glob.glob(f"{O}/log-{v}-*.gz")):
        rows = [l.split('\t') for l in gzip.open(f, 'rt').read().splitlines()]
        by_t = collections.defaultdict(list)
        for t, k, a, e, c in rows: by_t[int(t)].append((int(a), int(k), int(e), int(c)))
        tasks = sorted((a, e, c) for t in by_t for a, k, e, c in by_t[t] if k == 0)
        starts = [x[0] for x in tasks]
        for t, ev in by_t.items():
            if not any(k == 1 for _, k, _, _ in ev): continue
            ev.sort(); begin = None; cur = []
            for a, k, e, c in ev:
                if k == 1: begin = a; cur = []; continue
                if k in (3, 5, 6, 4) and begin is not None: cur.append((a, k)); continue
                if k == 2 and begin is not None:
                    i, j = bisect.bisect_left(starts, begin), bisect.bisect_left(starts, a)
                    if j - i in SIZES:
                        fill = []; hand = []
                        for q in range(0, len(cur) - 3, 4):
                            (a3, k3), (a5, k5), (a6, k6), (a4, k4) = cur[q:q + 4]
                            if (k3, k5, k6, k4) != (3, 5, 6, 4): break
                            fill.append((a6 - a5) / TPN / 1000); hand.append((a4 - a6) / TPN / 1000)
                        if fill:
                            R['dur'].append((a - begin) / TPN / 1000); R['fill'].append(st.median(fill)); R['hand'].append(st.median(hand))
                            R['hash'].append(st.median([(x[1] - x[0]) / TPN / 1000 for x in tasks[i:j]]))
                            R['doms'].append(len({(x[2] % 24) // 6 for x in tasks[i:j]}))
                    begin = None
    samples = []
    for f in glob.glob(f"{O}/run-{v}-*.samples.tsv"):
        for l in open(f):
            x = l.rstrip('\n').split('\t')
            if len(x) > 5 and x[0] == 'blake3-servil-mt' and x[1] == 'solo' and x[2] == 'ContinuousMessages':
                samples += [int(a) / int(b) for a, b in (y.split('/') for y in x[5].split(','))]
    print(f"{v:11}: bench reads mt {st.median(samples):.4f} ns/B | streams {len(R['dur'])}: {st.median(R['dur']):.0f} us; fill {st.median(R['fill']):.2f} us a message; hand-over {st.median(R['hand']):.2f}; task hash {st.median(R['hash']):.2f} us; domains a stream {st.median(R['doms']):.0f}")
