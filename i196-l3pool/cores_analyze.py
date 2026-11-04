"""#196 -cores (l3v4 layout): one-caller streams, pinned callers, full runs, against servil (base)."""
import sys, glob, os, re, statistics as st, collections
O = sys.argv[1]; V = tuple(sys.argv[2].split(',')) if len(sys.argv) > 2 else ('base', 'r', 'cores'); W = V[1:]
one = collections.defaultdict(list)
for f in glob.glob(O + '/one-*.txt'):
    _, v, size, rnd = os.path.basename(f)[:-4].split('-')
    for l in open(f):
        if l.startswith('cpu'): one[(v, int(size))].append(float(l.split()[2]))
print("one caller streaming (8 in flight), messages a second, x servil:")
for size in (16384, 65536, 262144):
    b = st.median(one[('base', size)])
    print(f"  {size//1024:4} KiB  servil {b:9.0f} | " + " | ".join(f"{v} x{st.median(one[(v, size)]) / b:.2f}" for v in W))
pin = collections.defaultdict(list)
for f in glob.glob(O + '/*-*-*-*.txt'):
    n = os.path.basename(f)[:-4]
    m = re.match(r'^(base|r|cores|corepin|split|splitwake)-(\d+)-([\d,]+)-(\d)$', n)
    if not m: continue
    tot = sum(float(l.split()[2]) for l in open(f) if l.startswith('cpu'))
    pin[(m.group(1), int(m.group(2)), m.group(3))].append(tot)
print("pinned callers, total messages a second, x servil:")
for size in (64, 1024, 65536):
    TWO = os.environ.get('TWO_DOMAINS', '0,6')
    for cp, name in (('0', 'one caller'), ('0,1', 'two, one domain'), (TWO, 'two, two domains')):
        b = st.median(pin[('base', size, cp)])
        print(f"  {size:6} B {name:17} servil {b:10.0f} | " + " | ".join(f"{v} x{st.median(pin[(v, size, cp)]) / b:.2f}" for v in W))
full = {v: collections.defaultdict(list) for v in V}
for f in glob.glob(O + '/full-*.samples.tsv'):
    _, v, rnd = os.path.basename(f)[:-12].split('-')
    for l in open(f):
        if l.startswith(('#', 'contender\t')): continue
        x = l.rstrip('\n').split('\t')
        if x[0] != 'blake3-servil-mt': continue
        t = [int(a) / int(b) for a, b in (y.split('/') for y in x[5].split(','))]
        full[v][(x[1], x[2], x[3])].append(st.mean(t))
print("full runs, servil mt cells, time x servil (lower = faster), mean of 2 runs:")
for v in W:
    rat = {k: st.mean(full[v][k]) / st.mean(full['base'][k]) for k in full['base'] if k in full[v]}
    fast = sum(1 for x in rat.values() if x < 0.95); slow = sum(1 for x in rat.values() if x > 1.05)
    by = collections.defaultdict(list)
    for k, x in rat.items(): by[k[1]].append(x)
    print(f"  {v:5}: {len(rat)} cells, {fast} faster than x0.95, {slow} slower than x1.05; by use case (median): " + ", ".join(f"{u} x{st.median(xs):.2f}" for u, xs in sorted(by.items())))
    worst = sorted(rat.items(), key=lambda kv: -kv[1])[:5]
    print("     slowest: " + "; ".join(f"{k[0]} {k[1]} {k[2]} x{x:.2f}" for k, x in worst))
