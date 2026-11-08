#!/bin/bash
set -euo pipefail
exec timeout -k 5s 240s bash -s -- "$1" <<'JOB'
set -euo pipefail
R="$1"
mkdir -p "$R/out"
export HOME=/root
. /root/.cargo/env
export CARGO_TARGET_DIR="$R/target"
cd "$R/library"
{ echo "library $(git rev-parse HEAD)"; uname -m; rustc -Vv; } > "$R/out/identity.txt"
cargo rustc --release --lib -- --emit=asm,llvm-ir > "$R/out/build.log" 2>&1
python3 - "$R" <<'PY'
from pathlib import Path
import sys,shutil,json
r=Path(sys.argv[1]);deps=r/'target/release/deps';out=r/'out';inventory=[]
for ext in ['s','ll']:
 files=list(deps.glob('blake3_servil-*.'+ext));assert len(files)==1,files
 p=files[0];q=out/('release.'+ext);shutil.copyfile(p,q)
 inventory.append({'file':q.name,'bytes':q.stat().st_size})
 if ext=='ll':
  functions=[];current=None
  for line in p.read_text().splitlines(keepends=True):
   if line.startswith('define '):current=[line]
   elif current is not None:
    current.append(line)
    if line.startswith('}'):
     if any(name in current[0]for name in ['hash_held','hash_cohort','held_groups','update_turn']):functions.append(''.join(current))
     current=None
  assert functions,'expected held/update functions in release IR'
  (out/'held-functions.ll').write_text('\n'.join(functions))
(out/'inventory.json').write_text(json.dumps(inventory,indent=2)+'\n')
PY
git status --porcelain > "$R/out/final-git-status.txt"
test ! -s "$R/out/final-git-status.txt"
printf 'release assembly and IR captured\n' > "$R/out/status.txt"
JOB
