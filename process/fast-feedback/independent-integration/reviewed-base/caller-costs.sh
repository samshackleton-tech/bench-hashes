#!/bin/bash
set -euo pipefail
exec timeout -k 5s 540s bash -s -- "$1" <<'CALLER_JOB'
set -euo pipefail
R="$1";export HOME=/root;. /root/.cargo/env;mkdir -p "$R/out"
test "${API_FAMILY:-}" = next
case "${CALLER_COMPARISON:-}" in aa|split|linear) ;; *) exit 2;; esac
S="$R/evidence/process/fast-feedback/ring-closure/r88/sampler-2355/mixed-stage-costs.sh"
python3 - "$R" "$S" <<'PREPARE'
from pathlib import Path
import hashlib,subprocess,sys
r=Path(sys.argv[1]);s=Path(sys.argv[2]);assert hashlib.sha256(s.read_bytes()).hexdigest()=='3a0595df2a83d2c2c42b5decf50ebad56449f26d82721ac3c32ba89cdd3782cb'
t=r/'caller-sampler.sh';t.write_bytes(s.read_bytes())
changes=[
('const FINALIZATION_CONTRACT: &str = "next: finalize_each resets; no additional cycle/finish reset";','const FINALIZATION_CONTRACT: &str = "next: finalize_each resets; no additional cycle/finish reset";\nconst CALLER_PARTITION: usize = __CALLER_PARTITION__;'),
('        throughput::update_each(hs, std::hint::black_box(pieces.as_slice()));','        for part in pieces.chunks(CALLER_PARTITION) {\n            throughput::update_each(hs, std::hint::black_box(part));\n        }'),
('    eprintln!("finalization_contract={FINALIZATION_CONTRACT}");','    eprintln!("finalization_contract={FINALIZATION_CONTRACT}");\n    eprintln!("diagnostic_caller_partition={CALLER_PARTITION}; unchanged library; caller order remains (i*61)%open");'),
('    for n in [2, 8, 16, 17, 24, 128, 512] { for len in [16384, 32768] { for flavor in 0..4 { run(n, n, len, 4096, flavor, reverse); } } }\n    for active in [7, 8, 15, 16] { for flavor in [0, 3] { run(1024, active, 16384, 4096, flavor, reverse); } }','    // Diagnostic scope: both sides retain128controls and512targets in all four modes.\n    for n in [128, 512] { for len in [16384, 32768] { for flavor in 0..4 { run(n, n, len, 4096, flavor, reverse); } } }'),
('PROBE_EOF\n (cd "$P"', '''PROBE_EOF
 python3 - "$P/src/main.rs" "$side" "$CALLER_COMPARISON" <<'PARTITION'
from pathlib import Path
import subprocess,sys
p=Path(sys.argv[1]);assert p.read_text().count('__CALLER_PARTITION__')==1
value='128' if sys.argv[2]=='new' and sys.argv[3]=='split' else 'usize::MAX'
a=p.parent/'partition-old.txt';b=p.parent/'partition-new.txt';a.write_text('__CALLER_PARTITION__');b.write_text(value)
subprocess.run(['/usr/local/bin/replace','-f',str(p),str(a),str(b)],check=True,stdout=subprocess.DEVNULL)
if sys.argv[2]=='new' and sys.argv[3]=='linear':
 changes=[('let which: Vec<_> = (0..active).map(|i| (i * 61) % open).collect();','let which: Vec<_> = (0..active).collect();'),('caller order remains (i*61)%open','caller order is identity')]
 for i,(old,new)in enumerate(changes):
  assert p.read_text().count(old)==1
  x=p.parent/f'order-old-{i}.txt';y=p.parent/f'order-new-{i}.txt';x.write_text(old);y.write_text(new)
  subprocess.run(['/usr/local/bin/replace','-f',str(p),str(x),str(y)],check=True,stdout=subprocess.DEVNULL)
PARTITION
 cp "$P/src/main.rs" "$O/probe-$side-$pair.rs"
 (cd "$P"''')]
for i,(a,b)in enumerate(changes):
 assert t.read_text().count(a)==1,i
 old=r/f'caller-old-{i}.txt';new=r/f'caller-new-{i}.txt';old.write_text(a);new.write_text(b)
 subprocess.run(['/usr/local/bin/replace','-f',str(t),str(old),str(new)],check=True,stdout=subprocess.DEVNULL)
(r/'out/caller-sampler.sh').write_bytes(t.read_bytes())
(r/'out/caller-derived-sha256.txt').write_text(hashlib.sha256(t.read_bytes()).hexdigest()+'\n')
PREPARE
bash "$R/caller-sampler.sh" "$R" > "$R/out/driver.log" 2>&1
python3 - "$R" "$CALLER_COMPARISON" <<'VERIFY'
from pathlib import Path
import csv,json,re,subprocess,sys
r=Path(sys.argv[1]);o=r/'out';mode=sys.argv[2];records=[]
for side in ['old','new']:
 for pair in range(1,5):
  p=o/f'{side}-{pair}.tsv';rows=list(csv.DictReader(p.open(),delimiter='\t'));assert len(rows)==48
  text=(o/f'{side}-{pair}.err').read_text();partition=128 if side=='new'and mode=='split'else 2**64-1
  assert f'diagnostic_caller_partition={partition};'in text
  assert ('caller order is identity' if side=='new'and mode=='linear'else'caller order remains (i*61)%open') in text
  assert 'busiest window'in text and 'busy load window: abstaining'not in text
  counts={}
  for line in text.splitlines():
   if line.startswith('core_counts '):
    fields=dict(v.split('=',1)for v in line.split()[1:]);key=(fields['shape'],int(fields['items']),fields['algorithm']);assert key not in counts;counts[key]=fields
  assert len(counts)==48
  for x in rows:
   key=(x['shape'],int(x['items']),x['algorithm']);c=counts[key]
   assert int(c['calls'])==int(x['calls'])
   assert int(c['p_cycles'])+int(c['e_cycles'])==int(x['cycles'])
   assert int(c['p_instructions'])+int(c['e_instructions'])==int(x['instructions'])
   assert int(x['calls'])>0 and int(x['wall_ns'])>0
   if x['algorithm']=='finish':assert x['calls']=='64'and x['package_nj']=='NA'
  records.append(dict(side=side,pair=pair,rows=len(rows),caller_partition=partition))
for repo in ['old','new','bench','evidence']:assert not subprocess.check_output(['git','-C',str(r/repo),'status','--porcelain'],text=True)
(o/'caller-integrity.json').write_text(json.dumps(dict(comparison=mode,scope='16diagnostic shapes, not a canonical/preservation gate',rows=384,records=records),indent=2)+'\n')
condition={'aa':'matched whole-caller61permuted order','split':'whole512 versus four adjacent128piece calls; original61permuted order','linear':'whole caller retained;61permuted versus identity state order'}[mode]
(o/'caller-status.txt').write_text('caller-only diagnostic complete; exact unchanged libraries; '+condition+'; complete cycle/update/consume-once finish; existing frozen judge unchanged\n')
VERIFY
CALLER_JOB
