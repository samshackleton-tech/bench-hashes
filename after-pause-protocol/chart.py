"""SVG: cost of the first call after a pause, over steady, by pause length (log), per idle setting;
and the smallest detectable difference (n=100). servil st 16 x 64 B and servil st 1 KiB."""
import sys, glob, os, math, statistics as st, collections
runs = {'Xeon Gold 6330': glob.glob('runs/protocol-icelake-*')[0], 'EPYC 9255': glob.glob('runs/protocol-epyc9255-*')[0]}
data = collections.defaultdict(dict)
for mach, run in runs.items():
    rows = collections.defaultdict(list)
    for f in glob.glob(os.path.join(run, 'out', '*-[0-9].tsv')):
        cfg = os.path.basename(f).rsplit('-', 1)[0]
        for l in open(f):
            if l.startswith('#'): continue
            x = l.split('\t'); rows[(cfg, x[0], int(x[1]))].append((int(x[2]), None if x[3] == '-' else int(x[3])))
    for (cfg, cell, p), v in rows.items():
        first = [a for a, _ in v]; steady = [b for _, b in v if b]
        data[(mach, cfg, cell)][p] = (st.median(first) / st.median(steady), 100 * 2.8 * math.sqrt(2) * st.stdev(first) / st.mean(first) / 10)
series = [('Xeon Gold 6330', 'shipped', '#c4423a', 'Xeon, as shipped'), ('Xeon Gold 6330', 'noC6', '#e0912e', 'Xeon, C6 off'),
          ('Xeon Gold 6330', 'C1only', '#0f8f84', 'Xeon, C1E + C6 off'), ('EPYC 9255', 'shipped', '#3a6fd8', 'EPYC (no idle states)')]
pauses = [20, 200, 1000, 5000]
W, H, L, T, PW, PH, G = 1150, 430, 70, 70, 300, 260, 60
def px(i): return i * PW / 3
out = [f'<svg xmlns="http://www.w3.org/2000/svg" width="{W}" height="{H}" font-family="system-ui,sans-serif" font-size="13">',
       '<rect width="100%" height="100%" fill="#fff"/>',
       f'<text x="{L}" y="30" font-size="18" font-weight="650" fill="#1d1d1f">A small call after a pause: cost over steady, and the change a comparison can detect</text>']
panels = [('st16x64', 'cost', 'servil st, 16 × 64 B: × steady'), ('st16x64', 'mde', 'detectable change, 100 samples a side'), ('st1k', 'mde', 'the same, servil st 1 KiB')]
for k, (cell, what, title) in enumerate(panels):
    x0 = L + k * (PW + G)
    out.append(f'<text x="{x0}" y="{T-12}" font-weight="600" fill="#1d1d1f">{title}</text>')
    if what == 'cost': lo, hi, ticks, fmt = math.log10(0.8), math.log10(14), [1, 2, 4, 8], lambda t: f'{t}×'
    else: lo, hi, ticks, fmt = math.log10(0.2), math.log10(60), [0.5, 1, 2, 5, 10, 20, 50], lambda t: f'{t:g}%'
    y = lambda v: T + PH - (math.log10(v) - lo) / (hi - lo) * PH
    for t in ticks:
        out.append(f'<line x1="{x0}" x2="{x0+PW}" y1="{y(t):.1f}" y2="{y(t):.1f}" stroke="#eee"/><text x="{x0-6}" y="{y(t)+4:.1f}" text-anchor="end" fill="#8a8a8e" font-size="11">{fmt(t)}</text>')
    for i, p in enumerate(pauses):
        lab = f'{p} µs' if p < 1000 else f'{p//1000} ms'
        out.append(f'<text x="{x0+px(i):.1f}" y="{T+PH+18}" text-anchor="middle" fill="#8a8a8e" font-size="11">{lab}</text>')
    out.append(f'<text x="{x0+PW/2}" y="{T+PH+36}" text-anchor="middle" fill="#8a8a8e" font-size="11">pause before the call</text>')
    if k == 0: out.append(f'<rect x="{x0+px(2)-6}" y="{T}" width="12" height="{PH}" fill="#1d1d1f" opacity=".06"/><text x="{x0+px(2)}" y="{T+12}" text-anchor="middle" fill="#8a8a8e" font-size="10">today</text>')
    for mach, cfg, color, _ in series:
        d = data.get((mach, cfg, cell))
        if not d: continue
        pts = [(x0 + px(i), y(d[p][0 if what == 'cost' else 1])) for i, p in enumerate(pauses)]
        out.append(f'<polyline fill="none" stroke="{color}" stroke-width="2.5" points="{" ".join(f"{a:.1f},{b:.1f}" for a, b in pts)}"/>')
        out += [f'<circle cx="{a:.1f}" cy="{b:.1f}" r="3.5" fill="{color}"/>' for a, b in pts]
for j, (_, _, color, name) in enumerate(series):
    x = L + j * 250
    out.append(f'<rect x="{x}" y="{H-22}" width="14" height="4" fill="{color}"/><text x="{x+20}" y="{H-16}" fill="#3a3a3c">{name}</text>')
out.append('</svg>')
open('after-pause.svg', 'w').write('\n'.join(out))
print('written')
