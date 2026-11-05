import glob,statistics,sys,os
for d in sorted(glob.glob('runs/*-2*/out')):
    if not os.path.exists(d+'/v32-3.txt'): continue
    name=d.split('/')[1].split('-')[2]
    data={}; checks={}
    for side in ['base','v16','v32']:
        for k in (1,2,3):
            for line in open(f'{d}/{side}-{k}.txt'):
                a,b=line.split()
                if a=='check': checks.setdefault(side,set()).add(b)
                else: data.setdefault((side,int(a)),[]).append(int(b))
    print(f'== {name}: checksums agree: {len(set().union(*checks.values()))==1}')
    print(' KiB   base    v16  (vs base)    v32  (vs base)   [ns, median of 3 runs\' medians; runs\' range]')
    for kib in range(1,33):
        m={s:statistics.median(data[(s,kib)]) for s in ['base','v16','v32']}
        r={s:(min(data[(s,kib)]),max(data[(s,kib)])) for s in m}
        mark=lambda s: f"{m[s]:6.0f} {100*(m[s]/m['base']-1):+6.1f}%"
        if kib>=8: print(f'{kib:4} {m["base"]:6.0f} {mark("v16")} {mark("v32")}   base {r["base"][0]}-{r["base"][1]}, v16 {r["v16"][0]}-{r["v16"][1]}, v32 {r["v32"][0]}-{r["v32"][1]}')
