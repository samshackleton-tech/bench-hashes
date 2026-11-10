#!/bin/bash
# Diagnostic only: where one mutant's rebuild spends its time, one build at a
# time on a quiet host. Not a benchmark and not a speed verdict.
set -euo pipefail
exec timeout -k 15s 540s bash -s -- "$1" <<'MUTATION_ANATOMY'
set -euo pipefail
R="$1"; O="$R/out"; mkdir -p "$O"; . <home>/.cargo/env
export CARGO_TARGET_DIR="$R/target"
{ printf 'library %s\n' "$(git -C "$R/library" rev-parse HEAD)"; rustc -Vv; cargo -V; uname -a; } > "$O/identity.txt"
cd "$R/library"
cargo fetch > "$O/fetch.log" 2>&1
python3 - "$R" <<'MUTATION_ANATOMY_PY'
from pathlib import Path
import json,re,resource,shutil,subprocess,sys,time
r=Path(sys.argv[1]);o=r/'out';lib=r/'library'
BASE=['cargo','test','--no-run','--profile','mutants','--features','serde,zeroize']
rows=[]
def build(label,targets):
    before=resource.getrusage(resource.RUSAGE_CHILDREN);start=time.monotonic_ns()
    with (o/f'{label}.log').open('w') as log:
        p=subprocess.run([*BASE,*targets,'--timings'],cwd=lib,stdout=log,stderr=subprocess.STDOUT)
    wall=time.monotonic_ns()-start;after=resource.getrusage(resource.RUSAGE_CHILDREN)
    assert p.returncode==0,label
    html=r/'target/cargo-timings/cargo-timing.html';shutil.copy2(html,o/f'{label}.html')
    m=re.search(r'const UNIT_DATA = (\[.*?\]);\s*\n',html.read_text(),re.S)
    assert m,'no UNIT_DATA in '+label
    units=json.loads(m.group(1));(o/f'{label}-units.json').write_text(json.dumps(units,indent=1)+'\n')
    row=dict(label=label,targets=targets,wall_s=wall/1e9,cpu_s=(after.ru_utime+after.ru_stime)-(before.ru_utime+before.ru_stime),
             units=[dict(name=u.get('name'),target=u.get('target'),start=u.get('start'),duration=u.get('duration'))for u in units])
    rows.append(row);(o/'anatomy.json').write_text(json.dumps(rows,indent=1)+'\n')
    print(label,'wall %.2f cpu %.1f units %d'%(row['wall_s'],row['cpu_s'],len(units)),flush=True)
def swap(path,line,column,old,new):
    p=lib/path;lines=p.read_text().split('\n');text=lines[line-1]
    assert text[column-1:column-1+len(old)]==old,(path,line,column,text)
    lines[line-1]=text[:column-1]+new+text[column-1+len(old):];p.write_text('\n'.join(lines))
def restore(path):
    subprocess.run(['git','checkout','--',path],cwd=lib,check=True)
ALL=['--lib','--tests']
build('baseline',ALL);build('noop',ALL)
MUTANTS=[('each','src/each.rs',326,111,'|','^'),('held','src/ffi_output.rs',123,49,'|','^'),('input','src/ffi_output.rs',57,24,'|','^')]
for name,path,line,column,old,new in MUTANTS:
    swap(path,line,column,old,new);build(name+'-mutant',ALL)
    restore(path);build(name+'-restored',ALL)
# The same first mutant in two steps: the library's own test binary alone,
# then everything else that the full selection still needs.
name,path,line,column,old,new=MUTANTS[0]
swap(path,line,column,old,new);build('each-lib-only',['--lib']);build('each-then-rest',ALL)
restore(path);build('each-restored-lib-only',['--lib']);build('each-restored-then-rest',ALL)
assert subprocess.run(['git','status','--porcelain','--untracked-files=no'],cwd=lib,capture_output=True,text=True,check=True).stdout==''
MUTATION_ANATOMY_PY
printf 'single-build anatomy complete; diagnostic only; no speed verdict\n' > "$O/status.txt"
MUTATION_ANATOMY
