#!/bin/bash
set -euo pipefail
exec timeout -k 5s 480s bash -s -- "$1" <<'JOB'
set -euo pipefail
R="$1";mkdir -p "$R/out"
cd "$R/library"
{ echo "library $(git rev-parse HEAD)";echo "reference $(git -C "$R/reference" rev-parse HEAD)";python3 --version;python3 -c 'import z3; print("Z3",z3.get_full_version())';clang --version; } > "$R/out/identity.txt"
for path in c c2sp;do diff -qr "$R/reference/$path" "$R/library/$path" > "$R/out/unchanged-$path.txt";done
python3 -m unittest discover -s tools/verify -p 'test_*.py' -v > "$R/out/helpers.log" 2>&1
python3 - "$R" <<'PY'
from pathlib import Path
import subprocess,sys
r=Path(sys.argv[1]);p=r/'library/tools/verify/lean_spec.py';original=p.read_bytes();text=original.decode()
controls=[('reversed-output-order','.children()', '.children()[::-1]'),
          ('lost-counter-binding','[counter, block_len, flags]','[BitVecVal(0, 64), block_len, flags]')]
for name,old,new in controls:
 assert text.count(old)==1,(name,text.count(old))
 before=r/f'{name}-old.txt';after=r/f'{name}-new.txt';before.write_bytes(original);after.write_text(text.replace(old,new))
 with (r/f'out/{name}-patch.log').open('w')as log:subprocess.run(['replace','-f',str(p),str(before),str(after)],stdout=log,check=True)
 try:
  with (r/f'out/{name}-red.log').open('w')as log:s=subprocess.run(['python3','-m','unittest','test_helpers.SpecificationTests.test_all_outputs_preserve_simultaneous_bindings','-v'],cwd=p.parent,stdout=log,stderr=subprocess.STDOUT).returncode
  assert s==1,(name,s)
  assert 'False is not true' in (r/f'out/{name}-red.log').read_text(),name
 finally:
  with (r/f'out/{name}-restore.log').open('w')as log:subprocess.run(['replace','-f',str(p),str(after),str(before)],stdout=log,check=True)
 assert p.read_bytes()==original
 print(name+': rejected; source restored byte-exactly')
PY
(cd tools/verify && python3 -m unittest test_helpers.SpecificationTests -v) > "$R/out/restored.log" 2>&1
timeout -k 5s 120s python3 tools/verify/prove_output.py > "$R/out/output16.log" 2>&1
timeout -k 5s 120s python3 tools/verify/prove_output8.py > "$R/out/output8.log" 2>&1
git status --porcelain > "$R/out/final-source-status.txt"
test ! -s "$R/out/final-source-status.txt"
printf 'shared substitution: helpers, exact ASTs, two rejecting controls, output16/output8 proofs and eight kernel fault controls passed\n' > "$R/out/status.txt"
JOB
