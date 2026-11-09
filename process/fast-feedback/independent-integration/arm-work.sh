#!/bin/bash
set -euo pipefail
exec timeout -k 5s 540s bash -s -- "$1" <<'JOB'
set -euo pipefail
R="$1";mkdir -p "$R/out" "$R/tmp"
export HOME=/root
. /root/.cargo/env
export CARGO_TARGET_DIR="$R/target" TMPDIR="$R/tmp" PYTHONUNBUFFERED=1
cd "$R/library"
{ echo "library $(git rev-parse HEAD)";echo "old_selector $(git -C "$R/old-selector" rev-parse HEAD)";uname -m;rustc -Vv; } > "$R/out/identity.txt"
run_work() {
 timeout -k 5s 180s cargo nextest run --release --features serde,zeroize --lib --test allocations --nocapture -E 'test(characterize_arm_held_cohorts) | test(characterize_held_allocation_work)' > "$1" 2>&1
}
run_work "$R/out/current-work.log"
python3 - "$R" <<'PY'
from pathlib import Path
import subprocess,sys
r=Path(sys.argv[1]);p=Path('src/each.rs');original=p.read_bytes();text=original.decode()
prior=subprocess.check_output(['git','-C',str(r/'old-selector'),'show','HEAD:src/each.rs'],text=True)
start=prior.index('fn hash_held(hashers');a=prior.index('    let Some(&first)',start);b=prior.index('    let turn =',a)
selector=prior[a:b]
old_body=prior[b:prior.index('    hash_held(hashers, &others);',b)]
c=text.index('    let turn =',text.index('fn hash_cohort('));d=text.index('\n}\n',c)
assert old_body.strip()==text[c:d].strip(),'same cohort body, only selector varies'
x=text.index("    // Plain's key is the IV, the same for every plain hasher.");y=text.index('\n}\n',x)
changed=text[:x]+selector+'    hash_cohort(hashers, &alike);\n    hash_held(hashers, &others);'+text[y:]
old=r/'tmp/current-each.txt';new=r/'tmp/old-selector-each.txt';old.write_bytes(original);new.write_text(changed)
with (r/'out/old-selector-diff.log').open('w')as log:subprocess.run(['replace','-f',str(p),str(old),str(new)],check=True,stdout=log)
try:
 with (r/'out/old-cohort-work.log').open('w')as log:subprocess.run(['timeout','-k','5s','180s','cargo','nextest','run','--release','--features','serde,zeroize','--lib','--test','allocations','--nocapture','-E','test(characterize_arm_held_cohorts) | test(characterize_held_allocation_work)'],check=True,stdout=log,stderr=subprocess.STDOUT)
finally:
 with (r/'out/restoration.log').open('w')as log:subprocess.run(['replace','-f',str(p),str(new),str(old)],check=True,stdout=log)
assert p.read_bytes()==original
print('old selector characterized; byte-exact current source restored')
PY
run_work "$R/out/restored-work.log"
timeout -k 5s 120s cargo nextest run --release --features serde,zeroize --lib --test allocations -E 'test(held_dispatch_ignores_key_equality_and_prefixes) | test(held_allocations_ignore_key_equality_and_prefixes)' > "$R/out/restored-security.log" 2>&1
python3 - "$R" <<'PY'
from pathlib import Path
import sys
r=Path(sys.argv[1]);records={}
for side,name in [('current','current-work'),('old_cohort','old-cohort-work'),('restored','restored-work')]:
 lines=(r/f'out/{name}.log').read_text().splitlines();rows=[]
 for line in lines:
  for marker in ['HELD_ALLOCATION_WORK ','HELD_COHORT_WORK ']:
   if marker in line:rows.append(line[line.index(marker):])
 assert sum(x.startswith('HELD_ALLOCATION_WORK ')for x in rows)==28
 assert sum(x.startswith('HELD_COHORT_WORK ')for x in rows)>=28,'ARM observer executed, not compiled out'
 assert len(rows)==len(set(rows)), 'one record per shape/observer'
 records[side]=sorted(rows)
 (r/f'out/{side}-counts.txt').write_text('\n'.join(sorted(rows))+'\n')
assert records['current']==records['restored'],'restored work counts/entry sets agree'
PY
git status --porcelain > "$R/out/final-git-status.txt"
test ! -s "$R/out/final-git-status.txt"
printf 'ARM held work counted against exact old selector; source restored; no timing\n' > "$R/out/status.txt"
JOB
