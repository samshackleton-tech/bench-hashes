#!/usr/bin/env python3
"""Audit the paired shard-rule executions and feed exact totals to the frozen judge.

    analyze-shards.py RUN_WITH_PAIRS_1_2 RUN_WITH_PAIRS_3_4

Offline: no new measurement. "old" is the candidate checkout with the shard
limit the tool had (SHARDS everywhere); "new" is the candidate unmodified.
Wall is the complete command (clocks, adopted children reaped); CPU is the
cgroup-v2 leaf's cpu.stat usage, every descendant included. Cycles,
instructions and energy for the process tree are NA.
"""
from pathlib import Path
import hashlib
import json
import re
import subprocess
import sys

ROOT = Path(__file__).resolve().parent
SOURCE = '719c6f2f90e5d269e6b1a67adc51e6091f1d7089'
BASE = '0b5bf7b71cb5f850067fa4182d9a3c724d7e5710'
CLOCKS = '9994de190259648ede82f7c5e4dbac4f1534a41d'
runs = [Path(a).resolve() for a in sys.argv[1:]]
assert len(runs) == 2
header = 'shape\titems\tbytes\talgorithm\tcalls\twall_ns\tcpu_ns\tcycles\tinstructions\tpackage_nj\n'
analysis = ROOT / 'analysis-shards-ab'
analysis.mkdir(exist_ok=True)
records, orders, sites = [], {}, None
for run, pairs in zip(runs, [(1, 2), (3, 4)]):
    assert (run / 'STATUS').read_text().strip() == 'VERIFIED', run
    out = run / 'out'
    identity = (out / 'identity.txt').read_text()
    assert f'library {SOURCE}' in identity and f'mutation_baseline {BASE}' in identity and f'bench {CLOCKS}' in identity
    check = json.loads((out / 'obligation-check.json').read_text())
    assert check['exact_sites'] == 163 and check['same_sites_and_raw_outcomes'] and check['same_selected_test_commands']
    assert check['labels'] == [f'p{p}-{s}' for p in pairs for s in (['prepare', 'old', 'new'] if p % 2 else ['prepare', 'new', 'old'])]
    if sites is None:
        sites = check['sites']
    assert check['sites'] == sites, 'both jobs test the same exact sites with the same raw outcomes'
    for line in (out / 'order.txt').read_text().splitlines():
        p, first, second = line.split()
        orders[int(p)] = [first, second]
    for p in pairs:
        for side, shards in [('prepare', 12), ('old', 6), ('new', 12)]:
            label = f'p{p}-{side}'
            assert (out / f'{label}-exit.txt').read_text().strip() == '0' and (out / f'{label}-clock-exit.txt').read_text().strip() == '0'
            log = (out / f'{label}.log').read_text()
            assert f'163 mutants on {shards} shards' in log and 'no new survivor' in log and f'BLAKE3-Servil at {SOURCE}' in log
            process = (out / f'{label}-process.txt').read_text().splitlines()
            assert process[0] == 'measurement_control adopted_sleeping_child=true reaped_child=true'
            fields = dict(x.split('=', 1) for x in process[1].split(' adopted_children=')[0].split())
            assert fields['success'] == 'true'
            load = (out / f'{label}-load.txt').read_text().splitlines()
            summary = [l for l in load if l.startswith('load: ')]
            assert len(summary) == 1 and summary[0].startswith('load: quiet:'), (label, summary)
            windows = [l.split() for l in load if l.startswith('window ')]
            assert windows and all(len(w) == 5 for w in windows)
            cpu = dict(l.split() for l in (out / f'{label}-cgroup-cpu.txt').read_text().splitlines())
            usage = int(cpu['usage_usec'])
            assert abs(usage - int(cpu['user_usec']) - int(cpu['system_usec'])) <= 2000
            assert (out / f'{label}-cgroup-left.txt').read_text() == '', 'the leaf was empty when read'
            assert (out / f'{label}-runtime-diff.txt').read_text() == '' and (out / f'{label}/source-status.txt').read_text() == ''
            peak = out / f'{label}-cgroup-memory-peak.txt'
            trees = json.loads((out / label / 'worktree-files.json').read_text())
            records.append(dict(run=run.name, pair=p, side=side, shards=shards, wall_ns=int(fields['complete_wall_ns']),
                                cgroup_cpu_ns=usage * 1000, primary_wait4_cpu_ns=int(fields['primary_wait4_cpu_ns'].strip('Some()')),
                                cgroup_memory_charge_peak_bytes=int(peak.read_text()) if peak.exists() else None,
                                load_windows=len(windows), layout_worktrees=sorted(t['path'] for t in trees if f'/layout-{p}/' in t['path'])))
assert sorted(orders) == [1, 2, 3, 4] and [orders[p][0] for p in [1, 2, 3, 4]] == ['old', 'new', 'old', 'new'], 'adjacent sides alternate'
by = {(r['pair'], r['side']): r for r in records}
for p in [1, 2, 3, 4]:
    # Each pair's own fresh layout: its twelve worktrees, used by all three executions.
    assert len(by[(p, 'prepare')]['layout_worktrees']) == 12 and by[(p, 'old')]['layout_worktrees'] == by[(p, 'new')]['layout_worktrees'] == by[(p, 'prepare')]['layout_worktrees']
    for side, label in [('old', 'old'), ('new', 'new')]:
        r = by[(p, side)]
        (analysis / f'{label}-{p}.tsv').write_text(header + f"since163\t163\t0\tcheck\t1\t{r['wall_ns']}\t{r['cgroup_cpu_ns']}\tNA\tNA\tNA\n")
frozen = Path('~/work/bench-fast-feedback/process/fast-feedback/ring-closure/r88/sampler-2355/mixed-stage-costs.sh')
assert hashlib.sha256(frozen.read_bytes()).hexdigest() == '3a0595df2a83d2c2c42b5decf50ebad56449f26d82721ac3c32ba89cdd3782cb'
text = frozen.read_text()
start = text.index("<<'JUDGE_EOF'\n") + len("<<'JUDGE_EOF'\n")
(analysis / 'judge.rs').write_text(text[start:text.index('\nJUDGE_EOF', start)] + '\n')
bench = Path('~/work/bench-blaze-builds')
assert subprocess.check_output(['git', '-C', str(bench), 'rev-parse', 'HEAD'], text=True).strip() == CLOCKS
assert not subprocess.check_output(['git', '-C', str(bench), 'status', '--porcelain'])
with (analysis / 'compile.log').open('wb') as log:
    subprocess.run(['rustc', '--edition=2021', '--crate-type=rlib', '--crate-name', 'clocks', '-O',
                    str(bench / 'clocks/src/lib.rs'), '-o', str(analysis / 'libclocks.rlib')], check=True, stdout=log, stderr=log)
    subprocess.run(['rustc', '--edition=2021', '-O', str(analysis / 'judge.rs'), '--extern',
                    'clocks=' + str(analysis / 'libclocks.rlib'), '-o', str(analysis / 'judge')], check=True, stdout=log, stderr=log)
with (analysis / 'judgments.tsv').open('wb') as report:
    subprocess.run([str(analysis / 'judge'), str(analysis), 'check'], check=True, stdout=report)
audit = dict(source=SOURCE, mutation_base=BASE, clocks=CLOCKS, runs=[r.name for r in runs], pairs=4, exact_sites=163,
             same_sites_raw_outcomes_and_test_commands_in_all_12_executions=True, orders=orders,
             judged_metrics=dict(wall_ns='complete command, clocks::now/since_ns, adopted children reaped',
                                 cpu_ns='cgroup-v2 leaf cpu.stat usage_usec x 1000: every descendant'),
             process_tree_cycles=None, process_tree_instructions=None, energy=None,
             load='every execution quiet: no busy window', records=records,
             frozen_judge_driver_sha256='3a0595df2a83d2c2c42b5decf50ebad56449f26d82721ac3c32ba89cdd3782cb',
             judge='clocks::summary::discoveries(cells, 50, 30): 5% FDR, 3% practical margin')
(analysis / 'AUDIT.json').write_text(json.dumps(audit, indent=2) + '\n')
print((analysis / 'judgments.tsv').read_text())
for r in records:
    print(r['pair'], r['side'], r['shards'], 'wall %.2f s' % (r['wall_ns'] / 1e9), 'cgroup cpu %.0f s' % (r['cgroup_cpu_ns'] / 1e9),
          'wait4 cpu %.0f s' % (r['primary_wait4_cpu_ns'] / 1e9), 'memory charge peak', r['cgroup_memory_charge_peak_bytes'])
