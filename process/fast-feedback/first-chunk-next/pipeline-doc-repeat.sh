#!/bin/bash
set -euo pipefail
R="$1"
mkdir -p "$R/out"
export HOME=/root
. /root/.cargo/env
python3 - "$R" <<'PY'
from concurrent.futures import ThreadPoolExecutor
from pathlib import Path
import hashlib, json, os, signal, subprocess, sys
r = Path(sys.argv[1])
for name in ['src/stream/receiver.rs', 'src/stream/frontend.rs']:
    a, b = [(r/s/name).read_bytes() for s in ['old', 'new']]
    assert a == b, name
    print('unchanged stream source', name, hashlib.sha256(a).hexdigest())

def repeat(side):
    results = []
    for rep in range(16):
        path = r/'out'/f'{side}-{rep}.log'
        with path.open('w') as log:
            child = subprocess.Popen(['cargo', 'test', '--release', '--doc', '--features', 'serde,zeroize'],
                                     cwd=r/side, env=dict(os.environ, CARGO_TARGET_DIR=str(r/f'target-{side}')),
                                     stdout=log, stderr=subprocess.STDOUT, start_new_session=True)
            try:
                code = child.wait(timeout=180)
            except subprocess.TimeoutExpired:
                try:
                    os.killpg(child.pid, signal.SIGKILL)
                except ProcessLookupError:
                    pass
                child.wait()
                raise
        text = path.read_text()
        hit = 'a task claims one queued job' in text
        assert code == 0 or (code == 101 and hit), text
        results.append(dict(repetition=rep, exit_code=code, queue_invariant=hit))
    return dict(side=side, commit=subprocess.check_output(['git', 'rev-parse', 'HEAD'], cwd=r/side, text=True).strip(),
                queue_failures=sum(x['queue_invariant'] for x in results), repetitions=results)

# Correctness only: both sources retain the ordinary parallel doctest run.
# No worker cap, cross-process lock, test-thread override, or timing claim.
with ThreadPoolExecutor(max_workers=2) as executor:
    rows = list(executor.map(repeat, ['old', 'new']))
(r/'out/results.json').write_text(json.dumps(rows, indent=2)+'\n')
for row in rows:
    print(row['side'], row['commit'], 'queue invariant failures', row['queue_failures'], 'of16')
if rows[0]['queue_failures']:
    print('baseline queue invariant reproduced')
print('ordinary parallel pipeline doc repetitions complete')
PY
