#!/bin/bash
set -euo pipefail
R="$1"
mkdir -p "$R/out"
export HOME=/root
. /root/.cargo/env
printf 'library %s\n' "$(git -C "$R/fork" rev-parse HEAD)" > "$R/out/identity.txt"
python3 - "$R" <<'PY'
import difflib, os
from pathlib import Path
import shutil, signal, subprocess, sys
r = Path(sys.argv[1])
test = 'incremental_roots_batch_all_modes_and_selected_indices'

def run(directory, label, expected, message=None):
    command = ['cargo', 'nextest', 'run', '--release', '--lib', '-E', f'test({test})']
    with (r/'out'/f'{label}.log').open('w') as log:
        child = subprocess.Popen(command, cwd=directory, env=dict(os.environ, CARGO_TARGET_DIR=str(r/f'target-{label}')),
                                 stdout=log, stderr=subprocess.STDOUT, start_new_session=True)
        try:
            code = child.wait(timeout=180)
        except subprocess.TimeoutExpired:
            # The unreaped child still reserves its PID/group identity.
            try:
                os.killpg(child.pid, signal.SIGKILL)
            except ProcessLookupError:
                pass
            child.wait()
            raise
    output = (r/'out'/f'{label}.log').read_text()
    assert code == expected, output
    assert test in output and 'error[E' not in output, output
    if message:
        assert message in output, output
    print(label, 'accepted' if code == 0 else 'rejected by the intended test')

run(r/'fork', 'positive', 0)
source = (r/'fork/src/each.rs').read_text()
controls = [
    ('missing-reset', '                    for &i in which {\n                        hashers[i].reset(None);\n                    }\n', '',
     'selected hashers reset'),
    ('repeated-indices-batched', 'which[..at].contains(&i)', 'false',
     'repeated indices observe the earlier reset'),
]
for name, old, new, message in controls:
    assert source.count(old) == 1, name
    changed = source.replace(old, new)
    directory = r/name
    shutil.copytree(r/'fork', directory, ignore=shutil.ignore_patterns('.git', 'target'))
    # Isolated fault fixture; the named baseline checkout stays untouched.
    (directory/'src/each.rs').write_text(changed)
    (r/'out'/f'{name}.patch').write_text(''.join(difflib.unified_diff(source.splitlines(True), changed.splitlines(True),
                                                                 fromfile='a/src/each.rs', tofile='b/src/each.rs')))
    run(directory, name, 100, message)
PY
cd "$R/fork"
timeout -k 5s 30s python3 -m unittest discover -s tools/verify -p test_long_proof_inputs.py -v > "$R/out/proof-inputs.log" 2>&1
printf 'output16 reset and index controls complete\n' > "$R/out/status.txt"
