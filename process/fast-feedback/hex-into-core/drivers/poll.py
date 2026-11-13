#!/usr/bin/env python3
"""poll.py FROM [TO]: status of the study's launched runs (lines FROM.. of ids.txt), fetching finished ones."""
import json,subprocess,glob,os,sys
ids=[l.strip() for l in open('ids.txt') if l.strip()]
a=int(sys.argv[1]); b=int(sys.argv[2]) if len(sys.argv)>2 else len(ids)
hosts={}
for f in glob.glob('*.json'):
    x=json.load(open(f)); hosts[x['name']]=x['host'] if isinstance(x['host'],str) else x['host'][0]
for i in ids[a:b]:
    h=hosts[i.rsplit('-',2)[0]]
    r=subprocess.run(['pinned-run','status',h,i],capture_output=True,text=True,stdin=subprocess.DEVNULL)
    st=(r.stdout+r.stderr).strip().splitlines()[0][:40]
    line=''
    if st in ('VERIFIED','FAILED'):
        if not glob.glob('runs/*'+i+'*'):
            subprocess.run(['pinned-run','fetch',h,i,'runs','--failed'],capture_output=True,text=True,stdin=subprocess.DEVNULL)
        d=next(iter(glob.glob('runs/*'+i+'*/out')),None)
        if d and 'speed' in i:
            line=' | '.join(open(f).read().strip().splitlines()[-1][8:60] for f in sorted(glob.glob(d+'/run-*.txt')))
        elif d and os.path.exists(d+'/status.txt'): line=open(d+'/status.txt').read().strip()[:200]
    print(i.split('-2026')[0], st, line)
