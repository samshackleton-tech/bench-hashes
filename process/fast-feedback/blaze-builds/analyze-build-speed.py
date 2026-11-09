#!/usr/bin/env python3
"""Validate collected outcomes and feed exact totals to the existing frozen judge."""
from pathlib import Path
import hashlib
import json
import re
import subprocess
import sys

ROOT = Path(__file__).resolve().parent
run = Path(sys.argv[1]).resolve()
assert (run / 'STATUS').read_text().strip() == 'VERIFIED'
out = run / 'out'
result = json.loads((out / 'outcome.json').read_text())
assert result['pairs'] == 4 and result['complete'] and not result['pilot']
profile = result.get('profile', 'release')  # The first release writer predates this field.
assert profile in ('release', 'dev')
assert result['source'] == '1cbdf5d72d70d8ed511870b18c7f017cce83da15'
assert result['library_bytes_restored'] and result['process_tree_cycles'] is None
windows = json.loads((out / 'load.json').read_text())
assert windows and not any(w['busy'] for w in windows)
controls = json.loads((out / 'measurement-controls.json').read_text())
assert controls['failure_propagated'] and controls['deadline_propagated'] and controls['deadline_child_exited']
rows = json.loads((out / 'samples.json').read_text())
commands = json.loads((out / 'commands.json').read_text())
lifetimes = json.loads((out / 'lifetimes.json').read_text())
cleanup = json.loads((out / 'cgroup-cleanup.json').read_text())
assert len(lifetimes) == 8 and all(x['empty'] and x['source_restored'] for x in lifetimes)
assert len(cleanup) == 10 and all(not x['initially_alive'] and not x['remaining'] for x in cleanup)
pattern = re.compile(r'(cargo|canary)-([1-4])-(fresh|noop|edit|restore)(?:-([1-4]))?\Z')
measured = {}
for row in rows:
    match = pattern.fullmatch(row['label'])
    if not match:
        assert row['label'] in {'launch-control-true', 'cpu-control-sleep', 'cpu-control-work', 'failure-control', 'deadline-control'}
        continue
    assert row['exit'] == 0 and row['wall_ns'] > 0 and row['cpu_ns'] > 0
    assert all(row[k] is None for k in ['core_cycles', 'instructions', 'energy_nj'])
    # These executed drivers scale cpu.stat to ns while retaining its kernel
    # dictionary key names ending _usec. cpu_ns is correctly named and scaled.
    before, after = row['cpu_before'], row['cpu_after']
    assert after['usage_usec'] - before['usage_usec'] == row['cpu_ns']
    assert all(after[k] >= before[k] for k in before)
    for snapshot in [before, after]:
        assert abs(snapshot['usage_usec'] - snapshot['user_usec'] - snapshot['system_usec']) <= 2000
    side, pair, case, iteration = match.groups()
    key = (side, int(pair), case)
    measured.setdefault(key, []).append(row)
    stderr = (out / (row['label'] + '.stderr')).read_text()
    assert not re.search(r'\bDownloading\b|attempting to make an HTTP request', stderr)
    checks = [c for c in commands if c['label'] == row['label'] + '-check']
    assert len(checks) == 1 and checks[0]['exit'] == (42 if case == 'edit' else 0)
    digest = 'af1349b9f5f9a1a6a0404dea36dcc9499bcb25c9adc112b7cc9a93cae41f3262' if case == 'edit' else '6437b3ac38465133ffb63b75273a8db548c558465d79db03fd359c6cd5bd9d85'
    assert 'digest ' + digest in (out / (row['label'] + '-check.stdout')).read_text()
assert sum(map(len, measured.values())) == 104
analysis = ROOT / ('analysis-' + run.name)
analysis.mkdir(exist_ok=True)
header = 'shape\titems\tbytes\talgorithm\tcalls\twall_ns\tcpu_ns\tcycles\tinstructions\tpackage_nj\n'
side_totals = []
for side, label in [('cargo', 'old'), ('canary', 'new')]:
    artifact_hashes = []
    for pair in range(1, 5):
        lines = [header]
        total_build_cpu = 0
        for case in ['fresh', 'noop', 'edit', 'restore']:
            samples = measured[(side, pair, case)]
            assert len(samples) == (1 if case == 'fresh' else 4)
            wall = sum(s['wall_ns'] for s in samples)
            used_cpu = sum(s['cpu_ns'] for s in samples)
            total_build_cpu += used_cpu
            lines.append(f'{case}\t1\t0\tbuild\t{len(samples)}\t{wall}\t{used_cpu}\tNA\tNA\tNA\n')
        (analysis / f'{label}-{pair}.tsv').write_text(''.join(lines))
        lifetime = next(x for x in lifetimes if x['side'] == side and x['pair'] == pair)
        lifetime_cpu = lifetime['cpu_after']['usage_usec'] - lifetime['cpu_before']['usage_usec']
        assert lifetime_cpu >= total_build_cpu
        side_totals.append(dict(side=side, pair=pair, build_cpu_ns=total_build_cpu,
                                lifetime_cpu_ns=lifetime_cpu, outside_build_brackets_cpu_ns=lifetime_cpu-total_build_cpu,
                                memory_charge=lifetime['memory']))
        artifact_hashes.append((out / f'{side}-{pair}-artifact.sha256').read_text().strip())
    assert len(set(artifact_hashes)) == 4, 'four separately linked probe layouts per side'
frozen = Path('/home/samshackleton/work/bench-fast-feedback/process/fast-feedback/ring-closure/r88/sampler-2355/mixed-stage-costs.sh')
assert hashlib.sha256(frozen.read_bytes()).hexdigest() == '3a0595df2a83d2c2c42b5decf50ebad56449f26d82721ac3c32ba89cdd3782cb'
text = frozen.read_text()
start = text.index("<<'JUDGE_EOF'\n") + len("<<'JUDGE_EOF'\n")
stop = text.index('\nJUDGE_EOF', start)
(analysis / 'judge.rs').write_text(text[start:stop] + '\n')
# Offline analysis, not a new measurement: build the exact pinned summary code.
bench = Path('/home/samshackleton/work/bench-blaze-builds')
assert subprocess.check_output(['git', '-C', str(bench), 'rev-parse', 'HEAD'], text=True).strip() == result['clocks']
assert not subprocess.check_output(['git', '-C', str(bench), 'status', '--porcelain'])
with (analysis / 'compile.log').open('wb') as log:
    subprocess.run(['rustc', '--edition=2021', '--crate-type=rlib', '--crate-name', 'clocks', '-O',
                    str(bench / 'clocks/src/lib.rs'), '-o', str(analysis / 'libclocks.rlib')], check=True, stdout=log, stderr=log)
    subprocess.run(['rustc', '--edition=2021', '-O', str(analysis / 'judge.rs'), '--extern',
                    'clocks=' + str(analysis / 'libclocks.rlib'), '-o', str(analysis / 'judge')], check=True, stdout=log, stderr=log)
with (analysis / 'judgments.tsv').open('wb') as report:
    subprocess.run([str(analysis / 'judge'), str(analysis), 'build'], check=True, stdout=report)
audit = dict(source=result['source'], clocks=result['clocks'], profile=profile, build_records=104, pairs=4,
             changed_digest_checks=32, other_digest_checks=72, all_sources_restored=True,
             cgroup_leaves_removed=10, load_windows=len(windows), busy_windows=0,
             all_worker_cpu_includes_persistent_daemon=True, process_tree_hardware_counts=None,
             per_side_lifetimes=side_totals,
             reader_unit_note='cpu_before/cpu_after kernel-named _usec fields store nanoseconds; cpu_ns is nanoseconds',
             frozen_judge_driver_sha256=hashlib.sha256(frozen.read_bytes()).hexdigest())
(analysis / 'AUDIT.json').write_text(json.dumps(audit, indent=2) + '\n')
print(analysis)
print((analysis / 'judgments.tsv').read_text())
