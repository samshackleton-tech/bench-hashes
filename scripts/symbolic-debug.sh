#!/bin/bash
set -euo pipefail
R="$1";O="$R/out";mkdir -p "$O";cd "$R/fork"
echo "library $(git rev-parse HEAD)" > "$O/identity.txt"
cat > "$R/debug.py" <<'DEBUG_EOF'
import sys,random
sys.path.insert(0,sys.argv[1]+'/tools/verify')
import prove_last as p,canon,terms
from z3 import BitVecVal,substitute,simplify,is_bv,is_bv_value
old=p.same;setup=p.Setup;captured=[]
def wrap(*args,**kw):
 s=setup(*args,**kw);captured[:]=[s.m];return s
p.Setup=wrap
reported=False
def same(a,b):
 global reported
 if old(a,b):return True
 if reported:return False
 reported=True
 syms={};canon.symbols_of(a,syms,set());canon.symbols_of(b,syms,set())
 rng=random.Random(7)
 for trial in range(3):
  sub=[(v,BitVecVal(rng.getrandbits(v.size()),v.size())) for v in syms.values()]
  av=simplify(substitute(a,*sub));bv=simplify(substitute(b,*sub));print('numeric',trial,av==bv,flush=True)
 print('symbols',[n for n in syms if n.startswith(('end','len','previous'))],flush=True)
 print('simplify both',old(simplify(a),simplify(b)),flush=True)
 # Only small public metadata terms are eligible for the machine's
 # equality-proved standard-fact normalization. No round arithmetic is
 # equated by sampling or by an assumption.
 m=captured[0];seen=set();todo=[a];replacements=[]
 while todo:
  t=todo.pop();i=t.get_id()
  if i in seen:continue
  seen.add(i)
  if is_bv(t) and t.size()==32 and terms.symbols(t)<=m.fact_symbols:
   normal=m.normal(t)
   if not normal.eq(t):replacements.append((t,normal))
  todo.extend(t.children())
 fixed=substitute(a,*replacements) if replacements else a
 print('fact replacements',len(replacements),'same',old(fixed,b),'same simplified',old(simplify(fixed),simplify(b)),flush=True)
 return False
p.same=same
for case in [(8,0,-1),(16,0,-1)]:
 reported=False
 try:print(p.prove(case),flush=True)
 except Exception as e:print(case,type(e).__name__,str(e),flush=True)
DEBUG_EOF
timeout 120 python3 "$R/debug.py" "$R/fork" > "$O/debug.log" 2>&1
echo 'symbolic diagnostics done' > "$O/status.txt"
