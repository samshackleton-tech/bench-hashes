#!/bin/bash
set -euo pipefail
exec timeout -k 5s 240s bash -s -- "$1" <<'LAYOUT_JOB'
set -euo pipefail
R="$1";mkdir -p "$R/out";. /root/.cargo/env
cd "$R/library"
{ echo "library $(git rev-parse HEAD)";rustc -Vv;cargo --version;uname -a;echo 'RUSTC_BOOTSTRAP=1: print-type-sizes diagnostic only; no timing measurement'; } > "$R/out/identity.txt"
RUSTC_BOOTSTRAP=1 CARGO_TARGET_DIR="$R/target" cargo rustc --release --lib -- -Zprint-type-sizes --emit=asm,link > "$R/out/type-layout.log" 2>&1
python3 - "$R" <<'PY'
from pathlib import Path
import sys,json,re,hashlib
r=Path(sys.argv[1]);text=(r/'out/type-layout.log').read_text();entries=[]
for line in text.splitlines():
 if line.startswith('print-type-size type: ') and 'HeldWorkspace<' in line:
  entries.append(line)
assert any(re.search(r'HeldWorkspace<128(?:_usize)?>', x) for x in entries),entries
assert any(re.search(r'HeldWorkspace<1(?:_usize)?>', x) for x in entries),entries
asm_files=sorted((r/'target/release/deps').glob('*.s'));assert asm_files
blocks=[];origins=[]
for path in asm_files:
 source=path.read_text();origins.append({'path':path.name,'sha256':hashlib.sha256(path.read_bytes()).hexdigest()})
 lines=source.splitlines(keepends=True)
 for i,line in enumerate(lines):
  if line.startswith(('_ZN','_R')) and line.rstrip().endswith(':') and any(s in line for s in ['flush_held','hash_held','hash_cohort','held_groups']):
   symbol=line.rstrip()[:-1]
   end=next((j+1 for j in range(i+1,len(lines)) if re.match(r'\s*\.size\s+'+re.escape(symbol)+r'\s*,',lines[j])),None)
   assert end is not None,(path,symbol)
   blocks.append('# source '+path.name+'\n'+''.join(lines[i:end]))
assert blocks,'no named held/cohort frames found in Rust assembly'
(r/'out/held-frames.s').write_text('\n'.join(blocks))
(r/'out/layout-summary.json').write_text(json.dumps({'workspace_types':entries,'source_assembly':origins,'extracted_functions':len(blocks),'scope':'Compiler-native layout and generated Rust frames at this source; no runtime or timing claim.'},indent=2)+'\n')
print(*entries,sep='\n');print('Extracted functions',len(blocks))
PY
test -z "$(git status --porcelain)"
printf 'native workspace layout and held frame diagnostic complete\n' > "$R/out/status.txt"
LAYOUT_JOB
