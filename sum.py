import glob,statistics
for d in sorted(glob.glob('runs/*/out')):
    name=d.split('/')[1].split('-')[2]; b3={}; sha={}; checks=set()
    for side in ['base','gpr']:
        for k in (1,2,3):
            for line in open(f'{d}/{side}-{k}.txt'):
                p=line.split()
                if p[0]=='check': checks.add(p[1]); continue
                b3.setdefault((side,int(p[0])),[]).append(int(p[1])); sha.setdefault(int(p[0]),[]).append(int(p[2]))
    print(f'== {name}: checksums agree {len(checks)==1}')
    print(' len   servil   #252   SHA-256   servil/SHA  #252/SHA')
    for n in [64,128,256,512,768,1024]:
        s,g,h=statistics.median(b3[('base',n)]),statistics.median(b3[('gpr',n)]),statistics.median(sha[n])
        print(f'{n:5} {s:7.0f} {g:7.0f} {h:8.0f}    x{s/h:.2f}      x{g/h:.2f}')
