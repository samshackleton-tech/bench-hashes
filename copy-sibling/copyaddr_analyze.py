"""copyaddr: each process's rate and quarters, the source's address bits, and the rooms' offset from the
source (mod 4096) and alignment; grouped by the rate's level.
    copyaddr_analyze.py OUT"""
import sys, glob, os, re, collections, statistics as st
O = sys.argv[1]
rows = collections.defaultdict(list)
for f in sorted(glob.glob(O + "/*-*-*.txt")):
    m = re.match(r"^(dom|all)-(\d+)-(\d+)$", os.path.basename(f)[:-4])
    if not m: continue
    d = {}
    for l in open(f):
        k, _, v = l.rstrip("\n").partition("\t")
        d[k] = v
    if "rate" not in d: continue
    rate = float(d["rate"].split("\t")[0]); qs = [float(x) for x in d["rate"].split("\t")[2].split(",")]
    src = int(d["src"], 16)
    rooms = [int(x, 16) for x in d["rooms"].split(",") if x]
    offs = [int(x) for x in d["room-src mod 4096"].split(",") if x]
    rows[(m.group(1), int(m.group(2)))].append((rate, qs, src, rooms, offs, int(m.group(3))))
for k in sorted(rows):
    rs = sorted(rows[k])
    print(f"== {k[0]} {k[1]//1024} KiB: rates {[round(r[0]) for r in rs]}")
    for rate, qs, src, rooms, offs, i in rs:
        roff = sorted(set(offs))
        print(f"   {rate:8.0f}  q {[round(q) for q in qs]}  src {src:#x} (mod 4096 {src % 4096}, mod 2 MiB {src % (2<<20):#x})  rooms mod 4096 {roff[:6]}{'...' if len(roff)>6 else ''}  room0 {rooms[0]:#x} (mod 2 MiB {rooms[0] % (2<<20):#x})")
