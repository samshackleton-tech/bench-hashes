#!/usr/bin/env python3
"""Collect this study's immutable pinned-run records once, preserving failures."""
import json, subprocess, shutil
from pathlib import Path
D=Path(__file__).resolve().parent
prefixes=('clone-prefix-','clone-direct-','clone-from-')
records=[json.loads(line)for line in Path.home().joinpath('.cache/pinned-run/launched.jsonl').read_text().splitlines()]
records=[x for x in records if x['run'].startswith(prefixes) and '20261107T' in x['run']]
archive=D/'archive-runs';archive.mkdir(exist_ok=True)
results=[]
for record in records:
 run,host=record['run'],record['host']
 candidates=[p for p in D.glob('*/'+run)if p.parent!=archive]+[p for p in D.glob('*/FAILED-'+run)if p.parent!=archive]
 existing=[p for p in [archive/run,archive/('FAILED-'+run)]if (p/'STATUS').exists()]
 if existing:
  folder=existing[0]
 elif candidates:
  source=candidates[0];folder=archive/source.name
  shutil.copytree(source,folder)
 else:
  q=subprocess.run(['pinned-run','status',host,run],capture_output=True,text=True)
  status=q.stdout.strip()
  if not(status.startswith('VERIFIED')or status.startswith('FAILED')):
   results.append(dict(record,status=status or q.stderr.strip(),pending=True));print(run,status,flush=True);continue
  command=['pinned-run','fetch',host,run,str(archive)]+([]if status.startswith('VERIFIED')else['--failed'])
  q=subprocess.run(command,capture_output=True,text=True)
  if q.returncode:raise RuntimeError(q.stderr+q.stdout)
  folder=archive/(run if status.startswith('VERIFIED')else'FAILED-'+run)
 status=(folder/'STATUS').read_text().strip()
 manifest=json.loads((folder/'manifest.json').read_text())
 results.append(dict(record,status=status,path=str(folder.relative_to(D)),script_sha256=manifest['script_sha256'],repos=manifest['repos']))
 print(run,status,flush=True)
(D/'inventory.json').write_text(json.dumps(results,indent=2)+'\n')
print('records',len(results),'pending',sum(x.get('pending',False)for x in results),'verified',sum(x['status'].startswith('VERIFIED')for x in results),'failed',sum(x['status'].startswith('FAILED')for x in results),flush=True)
