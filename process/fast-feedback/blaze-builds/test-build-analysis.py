#!/usr/bin/env python3
"""Reject corrupted collection inputs before the frozen statistical judge runs."""
from pathlib import Path
import concurrent.futures
import json
import shutil
import subprocess
import tempfile

ROOT = Path(__file__).resolve().parent
SOURCE = ROOT / 'runs/blaze-build-speed-paired-20261109T173513-23a257b1'

def reject(case):
    with tempfile.TemporaryDirectory(prefix='blaze-reader-control-') as scratch:
        run = Path(scratch) / SOURCE.name
        shutil.copytree(SOURCE, run)
        out = run / 'out'
        if case == 'busy':
            p = out / 'load.json'
            value = json.loads(p.read_text())
            value[0]['busy'] = True
        elif case == 'missing-build':
            p = out / 'samples.json'
            value = json.loads(p.read_text())
            value = [r for r in value if r['label'] != 'canary-4-edit-4']
        elif case == 'cpu-mismatch':
            p = out / 'samples.json'
            value = json.loads(p.read_text())
            row = next(r for r in value if r['label'] == 'canary-1-fresh')
            row['cpu_ns'] += 1
        elif case == 'accepted-wrong-digest':
            p = out / 'commands.json'
            value = json.loads(p.read_text())
            next(r for r in value if r['label'] == 'canary-1-edit-1-check')['exit'] = 0
        else:
            raise AssertionError(case)
        p.write_text(json.dumps(value) + '\n')
        result = subprocess.run(['python3', str(ROOT / 'analyze-build-speed.py'), str(run)], capture_output=True, text=True)
        assert result.returncode != 0 and 'AssertionError' in result.stderr, (case, result)
        print(case + ': rejected')

with concurrent.futures.ThreadPoolExecutor() as pool:
    list(pool.map(reject, ['busy', 'missing-build', 'cpu-mismatch', 'accepted-wrong-digest']))
print('four independent reader-corruption controls rejected; original inputs untouched')
