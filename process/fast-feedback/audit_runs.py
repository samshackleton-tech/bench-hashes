#!/usr/bin/env python3
"""Summarize existing pinned-run artifacts; no jobs or measurements launched."""
import argparse
import collections
import contextlib
import datetime as dt
import hashlib
import io
import json
import re
import statistics
from pathlib import Path


def pilot_category(run, manifest, state):
    if manifest.get('env', {}).get('PREFLIGHT_PLANT') == 'compile':
        return 'deliberate-failure-control'
    if run.startswith('preflight-gate-check-') and state == 'FAILED':
        return 'control-harness-development-failure'
    if run.startswith(('devon-local-review-repro-', 'local-cancel-window-repro-')):
        return 'bug-reproduction'
    if run.startswith('devon-local-clean-home-'):
        return 'candidate-gate-failure'
    if run.startswith('prepare-ab-'):
        return 'controlled-latency-experiment'
    if run.startswith(('collect-e2e-good-', 'preflight-live-good-', 'optimized-e2e-good-')):
        return 'workflow-fixture'
    if run.startswith(('fast-lane-native-', 'fast-lane-startup-', 'optimized-native-',
                       'optimized-startup-', 'host-auth-startup-', 'startup-scoped-collect-',
                       'fast-lane-machine-')):
        return 'host-or-instrument-validation'
    if run.startswith(('pinned-phase-', 'fast-lane-runner-', 'preflight-gate-check-',
                       'scoped-collect-', 'exact-prepare-', 'host-auth-clean-',
                       'host-auth-final-', 'explicit-key-', 'proof-cache-', 'wait-check-')):
        return 'tool-change-validation'
    raise AssertionError(f'classify the new work explicitly: {run}')


def pilot_audit(base, runner):
    # Reuse the deployed reader's phase/TSV checks and intervals, rather than
    # implementing another result reader or inferring time from Git file mtimes.
    source = runner.read_bytes()
    namespace = {'__name__': 'pilot_review_reader', '__file__': str(runner.resolve())}
    exec(compile(source, str(runner), 'exec'), namespace)
    records = {}
    pre_phase = {
        'pinned-phase-check-arm-20261107T173419-6676eb5c',
        'pinned-phase-check-zen3-20261107T173419-6eea0898',
    }
    excluded = []
    for path in sorted(base.glob('*-runs/*/manifest.json')):
        folder = path.parent
        manifest = json.loads(path.read_text())
        run = folder.name.removeprefix('FAILED-')
        if run in pre_phase:
            assert not (folder / 'phases.jsonl').exists(), 'update the declared phase coverage'
            excluded.append(run)
            continue
        state = (folder / 'STATUS').read_text().strip()
        reasons = (folder / 'REASONS').read_text().strip() if (folder / 'REASONS').exists() else ''
        result = state + ('\n' + reasons if reasons else '')
        if run in records:
            assert records[run]['runner_result'] == result, f'conflicting copies: {run}'
            assert records[run]['script_sha256'] == manifest['script_sha256']
            assert records[run]['repos'] == manifest['repos']
            continue
        with contextlib.redirect_stdout(io.StringIO()):
            summary = namespace['review_card'](str(folder), result)
        summary['category'] = pilot_category(run, manifest, state)
        summary['artifact'] = str(folder.relative_to(base))
        records[run] = summary
    rows = [records[key] for key in sorted(records)]
    assert rows, 'no pilot artifacts'
    output = base / 'pilot-audit.json'
    output.write_text(json.dumps(rows, indent=2, sort_keys=True) + '\n')
    print('REVIEW_READER_SHA256', hashlib.sha256(source).hexdigest())
    print('PRE_PHASE_CONTROLS_EXCLUDED', sorted(excluded))
    print('UNIQUE', len(rows), dict(collections.Counter(r['runner_result'].splitlines()[0] for r in rows)))
    for category in sorted({r['category'] for r in rows}):
        group = [r for r in rows if r['category'] == category]
        totals = sorted(r['durations_ns']['total'] for r in group if 'total' in r['durations_ns'])
        print('CATEGORY', category, 'n', len(group), 'states',
              dict(collections.Counter(r['runner_result'].splitlines()[0] for r in group)),
              'accepted_to_finished_ns', totals)
    print('OUTPUT', output)


parser = argparse.ArgumentParser(description=__doc__)
parser.add_argument('--pilot', nargs='?', type=Path, const=Path(__file__).resolve().parent,
                    help='audit phase-recorded pilot artifacts under this directory')
parser.add_argument('--runner', type=Path, help='canonical pinned-run whose review reader to use')
args = parser.parse_args()
if args.pilot is not None:
    if args.runner is None:
        parser.error('--pilot requires --runner: name the recorded review-reader source')
    pilot_audit(args.pilot, args.runner)
    raise SystemExit(0)
if args.runner is not None:
    parser.error('--runner requires --pilot')

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
