#!/usr/bin/env python3
"""Summarize existing pinned-run artifacts; no jobs or measurements launched."""
import collections
import datetime as dt
import json
import re
import statistics
from pathlib import Path

ROOT = Path('/home/samshackleton/blake3-reports')
STUDIES = ['held-stage-next', 'clone-prefix-next', 'xof-cache-next', 'root-direct-next', 'finalize-root', 'first-chunk-batch', 'output8-next', 'small8-next', 'multiblock-next']
records = {}
for study in STUDIES:
    base = ROOT / study
    for manifest in base.glob('*/*/manifest.json'):
        folder = manifest.parent
        status = folder / 'STATUS'
        if not status.exists():
            continue
        m = json.loads(manifest.read_text())
        if not m.get('launched', '').startswith(('2026-11-06', '2026-11-07')):
            continue
        run = folder.name.removeprefix('FAILED-')
        # Prefer archives; repeated fetched copies identify the same run.
        if run in records and folder.parent.name != 'archive-runs':
            continue
        launched = dt.datetime.fromisoformat(m['launched'].replace('Z', '+00:00')).timestamp()
        finish = status.stat().st_mtime
        identity = folder / 'out/identity.txt'
        job = folder / 'job.log'
        prepared = folder / 'prepare.log'
        if identity.exists():
            started = identity.stat().st_mtime
        elif job.exists():
            started = None  # job.log can be updated all through execution.
        else:
            started = None
        logs = list((folder / 'out').glob('build*.log'))
        build_times = []
        for log in logs:
            for x in re.findall(r'Finished .*? in ([0-9.]+)(ms|s|m [0-9.]+s)', log.read_text(errors='replace')):
                number, unit = x
                if unit == 's':
                    build_times.append(float(number))
                elif unit == 'ms':
                    build_times.append(float(number) / 1000)
                else:
                    build_times.append(float(number)*60 + float(unit[2:-1]))
        if logs and started is not None:
            build_end = max(p.stat().st_mtime for p in logs)
            build_span = build_end - started
        else:
            build_end = build_span = None
        state = status.read_text().strip()
        reasons = (folder / 'REASONS').read_text() if (folder / 'REASONS').exists() else ''
        errors = []
        if state == 'FAILED':
            for p in [job] + list((folder / 'out').glob('*.log')):
                if p.exists():
                    for line in p.read_text(errors='replace').splitlines():
                        if re.match(r'(error(?:\[E\d+\])?:|warning:)', line):
                            errors.append(line[:200])
        row = dict(run=run, study=study, path=str(folder), host=m['host'], state=state,
                   launch=m['launched'], elapsed_s=finish-launched,
                   queue_plus_prepare_s=None if started is None else started-launched,
                   execution_s=None if started is None else finish-started,
                   build_phase_span_s=build_span,
                   after_build_s=None if build_end is None else finish-build_end,
                   cargo_finished_s=build_times, reasons=reasons, errors=sorted(set(errors)),
                   script_sha256=m['script_sha256'])
        records[run] = row

rows = sorted(records.values(), key=lambda r:r['launch'])
Path(__file__).with_name('run-audit.json').write_text(json.dumps(rows,indent=2)+'\n')
print('UNIQUE',len(rows), dict(collections.Counter(r['state'] for r in rows)))
for study in STUDIES:
    group = [r for r in rows if r['study'] == study]
    if group:
        print('STUDY',study,len(group),dict(collections.Counter(r['state'] for r in group)))
for key in ['elapsed_s','queue_plus_prepare_s','execution_s','build_phase_span_s','after_build_s']:
    vals = sorted(r[key] for r in rows if r[key] is not None and r[key] >= 0)
    print('TIME',key,'n',len(vals),'median',round(statistics.median(vals),2),'p90',round(vals[int((len(vals)-1)*.9)],2),'max',round(max(vals),2))
print('LONGEST QUEUE+PREP')
for r in sorted((r for r in rows if r['queue_plus_prepare_s'] is not None),key=lambda r:r['queue_plus_prepare_s'],reverse=True)[:12]:
    print(r['run'], 'queue+prep',round(r['queue_plus_prepare_s'],1),'exec',round(r['execution_s'],1),'state',r['state'])
print('FAILED')
for r in rows:
    if r['state']=='FAILED':
        print(r['run'],r['reasons'].strip()[:160],r['errors'][:4])
