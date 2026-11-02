"""Bars: the smallest change a comparison detects (n=100 a side), at the 1 ms pause, as shipped
against the shallow block (POLL and C1 only), per machine and cell. Log scale."""
import glob, os, math, statistics as st, collections
runs = [('Xeon Gold 6330 (2021)', 'runs/ladder-icelake-*'), ('Xeon E3-1240L v5, Skylake (2015)', 'runs/ladder-skylake-*'),
        ('Xeon E3-1241 v3, Haswell (2014)', 'runs/ladder-haswell-*')]
cells = [('st16x64', 'servil 16×64 B'), ('st1k', 'servil 1 KiB'), ('off1k', 'official 1 KiB'), ('mt1m', 'servil mt 1 MiB')]
def det(run, cfg, cell, p=1000):
    v = []
    for f in glob.glob(os.path.join(run, 'out', f'{cfg}-[0-9].tsv')):
        for l in open(f):
            if l.startswith('#'): continue
            x = l.split('\t')
            if x[0] == cell and int(x[1]) == p: v.append(int(x[2]))
    return 100 * 2.8 * math.sqrt(2) * st.stdev(v) / st.mean(v) / 10
W, H, L, T, PW, PH, G = 1100, 420, 60, 80, 310, 250, 45
lo, hi = math.log10(0.5), math.log10(100)
y = lambda v: T + PH - (math.log10(max(v, 0.5)) - lo) / (hi - lo) * PH
out = [f'<svg xmlns="http://www.w3.org/2000/svg" width="{W}" height="{H}" font-family="system-ui,sans-serif" font-size="13"><rect width="100%" height="100%" fill="#fff"/>',
       f'<text x="{L}" y="30" font-size="18" font-weight="650" fill="#1d1d1f">The smallest change a comparison can detect, a call after 1 ms of idle</text>',
       f'<text x="{L}" y="52" fill="#8a8a8e">100 samples a side · shorter is better · grey: idle states as shipped · green: only POLL and C1 kept</text>']
for k, (name, pat) in enumerate(runs):
    run = glob.glob(pat)[0]; x0 = L + k * (PW + G)
    out.append(f'<text x="{x0}" y="{T-8}" font-weight="600" fill="#1d1d1f">{name}</text>')
    for t in (1, 2, 5, 10, 20, 50, 100):
        out.append(f'<line x1="{x0}" x2="{x0+PW}" y1="{y(t):.1f}" y2="{y(t):.1f}" stroke="#eee"/><text x="{x0-5}" y="{y(t)+4:.1f}" text-anchor="end" fill="#8a8a8e" font-size="10">{t}%</text>')
    bw = PW / len(cells)
    for i, (cell, lab) in enumerate(cells):
        cx = x0 + i * bw
        for j, (cfg, color) in enumerate((('shipped', '#b5b5ba'), ('upto1', '#0f8f84'))):
            d = det(run, cfg, cell); bx = cx + 10 + j * (bw / 2 - 8)
            out.append(f'<rect x="{bx:.1f}" y="{y(d):.1f}" width="{bw/2-14:.1f}" height="{T+PH-y(d):.1f}" fill="{color}" rx="2"/>')
            out.append(f'<text x="{bx+(bw/2-14)/2:.1f}" y="{y(d)-4:.1f}" text-anchor="middle" font-size="10" fill="#3a3a3c">{d:.0f}</text>')
        out.append(f'<text x="{cx+bw/2:.1f}" y="{T+PH+16}" text-anchor="middle" font-size="10.5" fill="#6e6e73">{lab}</text>')
out.append('</svg>')
open('detectable.svg', 'w').write('\n'.join(out)); print('ok')
