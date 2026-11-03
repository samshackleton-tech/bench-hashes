"""i196-ctask: per bench version, the servil mt ContinuousMessages 64 KiB streams, task by task.
Each stream (a begin/end pair on the caller's thread) with the tasks that start inside it."""
import sys, glob, gzip, os, statistics as st, collections, bisect
O = sys.argv[1]
TPN = 3.2  # ticks a ns (the EPYC's TSC, 3.2 GHz)
def dom(c): return (c % 24) // 6
def samples(f):
    out = {}
    for l in open(f):
        if l.startswith(('#', 'contender\t')): continue
        x = l.rstrip('\n').split('\t')
        if x[1] == 'solo' and x[2] == 'ContinuousMessages':
            out[x[0]] = [int(a) / int(b) for a, b in (y.split('/') for y in x[5].split(','))]
    return out
res = collections.defaultdict(lambda: collections.defaultdict(list))
for f in sorted(glob.glob(O + '/log-*.gz')):
    b = os.path.basename(f).split('-')[1]
    rows = [l.split('\t') for l in gzip.open(f, 'rt').read().splitlines()]
    tasks = sorted((int(a), int(e), int(c)) for t, k, a, e, c in rows if k == '0')
    marks = sorted((int(a), int(k)) for t, k, a, e, c in rows if k in ('1', '2'))
    starts = [s for s, _, _ in tasks]
    by_cpu = collections.defaultdict(list)
    for s, e, c in tasks: by_cpu[c].append((s, e))
    begin = None
    for at, k in marks:
        if k == 1: begin = at; continue
        if begin is None: continue
        i, j = bisect.bisect_left(starts, begin), bisect.bisect_left(starts, at)
        seg = tasks[i:j]; begin_ = begin; begin = None
        if len(seg) < 50: continue  # not a 64 KiB train's stream (another cell, or empty)
        hashes = [(e - s) / TPN / 1000 for s, e, c in seg]
        doms = collections.Counter(dom(c) for _, _, c in seg)
        sib = 0
        for s, e, c in seg:
            o = c + 24 if c < 24 else c - 24
            if any(ss < e and ee > s for ss, ee in by_cpu.get(o, [])[max(0, bisect.bisect_left(by_cpu.get(o, []), (s,)) - 2):bisect.bisect_left(by_cpu.get(o, []), (e,)) + 1]): sib += 1
        dur = (at - begin_) / TPN
        r = res[b]
        r['tasks'].append(len(seg)); r['hash'].append(st.median(hashes)); r['sib'].append(sib / len(seg))
        r['home'].append(doms.most_common(1)[0][1] / len(seg)); r['doms'].append(len(doms))
        r['first'].append((seg[0][0] - begin_) / TPN / 1000); r['tail'].append((at - max(e for _, e, _ in seg)) / TPN / 1000)
        r['gbps'].append(len(seg) * 65536 / dur)
        r['cpus'].append(len({c for _, _, c in seg}))
for b, r in sorted(res.items()):
    print(f"{b}: {len(r['tasks'])} streams of 50+ tasks")
    print(f"   tasks a stream {st.median(r['tasks']):.0f} | stream GB/s {st.median(r['gbps']):.1f} (p10 {sorted(r['gbps'])[len(r['gbps'])//10]:.1f}) | task hash {st.median(r['hash']):.2f} us | tasks with a busy sibling {100*st.median(r['sib']):.0f}% | CPUs used {st.median(r['cpus']):.0f}, domains {st.median(r['doms']):.0f}, most in one domain {100*st.median(r['home']):.0f}% | begin to first task {st.median(r['first']):.1f} us, last task to end {st.median(r['tail']):.1f} us")
for f in sorted(glob.glob(O + '/run-*.samples.tsv')):
    s = samples(f)
    print(os.path.basename(f), ' '.join(f"{k}: {st.median(v):.4f} ns/B" for k, v in sorted(s.items())))
