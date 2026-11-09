#!/usr/bin/env python3
"""Verify the owner's integer rows and decompose the existing suspects exactly.

This computes diagnostic fractions, not a second statistical judge. The owner's
canonical Rust verdicts remain unchanged. Round only the human-readable strings.
"""
from pathlib import Path
from fractions import Fraction
import csv
import json
import sys

root = Path(sys.argv[1])
rows_by_key = {}; checked = 0
for phase in ['aa', 'ab']:
    out = root / phase / 'out'
    for side in ['old', 'new']:
        for pair in range(1, 5):
            diagnostics = {}
            for line in (out / f'{side}-{pair}.err').read_text().splitlines():
                if line.startswith('core_counts '):
                    fields = dict(v.split('=', 1) for v in line.split()[1:])
                    key = (fields['shape'], int(fields['items']), fields['algorithm'])
                    assert key not in diagnostics
                    diagnostics[key] = fields
            rows = list(csv.DictReader((out / f'{side}-{pair}.tsv').open(), delimiter='\t'))
            assert len(rows) == len(diagnostics) == 192
            for row in rows:
                key = (row['shape'], int(row['items']), row['algorithm']); counts = diagnostics[key]
                assert int(counts['calls']) == int(row['calls'])
                assert int(counts['p_cycles']) + int(counts['e_cycles']) == int(row['cycles'])
                assert int(counts['p_instructions']) + int(counts['e_instructions']) == int(row['instructions'])
                calls, items = int(row['calls']), int(row['items']); assert calls > 0 and items > 0
                if row['algorithm'] == 'finish': assert calls == 64 and row['package_nj'] == 'NA'
                raw = {v: int(row[v]) for v in ['wall_ns', 'cpu_ns', 'cycles', 'instructions']}
                raw.update({v: int(counts[v]) for v in ['p_time_ns', 'p_cycles', 'p_instructions', 'e_time_ns', 'e_cycles', 'e_instructions']})
                rows_by_key[phase, side, pair, key] = (raw, {v: Fraction(n, calls * items) for v, n in raw.items()})
                checked += 1

def mean(values):
    return sum(values, Fraction()) / len(values)

def display(value, places=6):
    sign = '-' if value < 0 else ''; value = abs(value); scale = 10 ** places
    rounded = (2 * value.numerator * scale + value.denominator) // (2 * value.denominator)
    return sign + str(rounded // scale) + ('.' + str(rounded % scale).zfill(places) if places else '')

def encode(value):
    if isinstance(value, Fraction): return dict(numerator=value.numerator, denominator=value.denominator, display=display(value))
    if isinstance(value, dict): return {k: encode(v) for k, v in value.items()}
    if isinstance(value, list): return [encode(v) for v in value]
    return value

verdicts = list(csv.DictReader((root / 'ab/out/judgments-finish.tsv').open(), delimiter='\t'))
targets = [x for x in verdicts if x['metric'] == 'cycles' and x['verdict'] == 'Slower']; assert len(targets) == 4
suspects = []
for target in targets:
    key = (target['shape'], int(target['items']), 'finish'); sides = {}; pairs = []
    for side in ['old', 'new']:
        samples = [rows_by_key['ab', side, pair, key][1] for pair in range(1, 5)]
        values = {field: mean([sample[field] for sample in samples]) for field in samples[0]}
        values['p_cycles_per_ns'] = sum(x['p_cycles'] for x in samples) / sum(x['p_time_ns'] for x in samples)
        assert all(x[v] == 0 for x in samples for v in ['e_time_ns', 'e_cycles', 'e_instructions'])
        values['p_time_minus_wall_ns'] = values['p_time_ns'] - values['wall_ns']; sides[side] = values
    old, new = sides['old'], sides['new']
    percent = {field: 100 * (new[field] / old[field] - 1) for field in ['wall_ns', 'cpu_ns', 'cycles', 'instructions', 'p_time_ns', 'p_cycles_per_ns']}
    gap_delta = new['p_time_minus_wall_ns'] - old['p_time_minus_wall_ns']
    for pair in range(1, 5):
        a = rows_by_key['ab', 'old', pair, key][1]; b = rows_by_key['ab', 'new', pair, key][1]
        pairs.append(dict(pair=pair, wall_percent=100*(b['wall_ns']/a['wall_ns']-1), cycle_percent=100*(b['cycles']/a['cycles']-1), p_time_percent=100*(b['p_time_ns']/a['p_time_ns']-1), p_frequency_percent=100*((b['p_cycles']/b['p_time_ns'])/(a['p_cycles']/a['p_time_ns'])-1)))
    suspects.append(dict(shape=key[0], items=key[1], canonical_verdict=target, means_per_message=sides, diagnostic_percent=percent, p_time_minus_wall_gap_delta_ns=gap_delta, pairs=pairs))
    print(key[0], {k: display(v, 3) for k, v in percent.items()}, 'gap_delta_ns', display(gap_delta, 3))
result = dict(schema=1, source_evidence='e4953a0902e0794176627cd906cd555d981a4b6a', checked_rows=checked, arithmetic='Exact integer/rational diagnostic decomposition; rounded display strings only; canonical Rust verdicts unchanged', reader='9994de190259648ede82f7c5e4dbac4f1534a41d:clocks/src/lib.rs; thread_selfcounts THSC_TIME_CPI_PER_PERF_LEVEL', scope='Offline analysis, no native execution/new statistical verdict. Counter time encloses a wider interval than wall and includes reader/timer bookkeeping.', finish_counter_suspects=suspects)
(root / 'OFFLINE-ATTRIBUTION.json').write_text(json.dumps(encode(result), indent=2) + '\n')
print('Counter/TSV rows checked', checked)
