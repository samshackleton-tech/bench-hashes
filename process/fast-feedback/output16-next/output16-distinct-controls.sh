#!/bin/bash
set -euo pipefail
R="$1"
mkdir -p "$R/out"
export HOME=/root
. /root/.cargo/env
printf 'library %s\n' "$(git -C "$R/fork" rev-parse HEAD)" > "$R/out/identity.txt"
python3 - "$R" <<'PY'
from pathlib import Path
import difflib, os, shutil, signal, subprocess, sys
r = Path(sys.argv[1])
def run(directory, label, release, test, expected, message=None):
    args = ['cargo', 'nextest', 'run'] + (['--release'] if release else []) + ['--lib', '-E', f'test({test})']
    with (r/'out'/f'{label}.log').open('w') as log:
        child = subprocess.Popen(args, cwd=directory, env=dict(os.environ, CARGO_TARGET_DIR=str(r/f'target-{label}')),
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
    output = (r/'out'/f'{label}.log').read_text()
    assert code == expected and 'error[E' not in output, output
    if message:
        assert message in output, output
    print(label, 'accepted' if code == 0 else 'rejected by the intended test')
source = (r/'fork/src/each.rs').read_text()
run(r/'fork', 'debug-positive', False, 'finalize_each_rejects_', 0)
run(r/'fork', 'reset-positive', True, 'incremental_roots_batch_all_modes_and_selected_indices', 0)
controls = [
    ('missing-debug-contract', '    debug_assert!(which.iter().enumerate().all(|(at, i)| !which[..at].contains(i)), "each finalized index is distinct");\n',
     False, 'finalize_each_rejects_', 'test did not panic as expected'),
    ('missing-reset', '                    for &i in which {\n                        hashers[i].reset(None);\n                    }\n',
     True, 'incremental_roots_batch_all_modes_and_selected_indices', 'selected hashers reset'),
]
for label, old, release, test, message in controls:
    assert source.count(old) == 1, label
    changed = source.replace(old, '')
    directory = r/label
    shutil.copytree(r/'fork', directory, ignore=shutil.ignore_patterns('.git', 'target'))
    (directory/'src/each.rs').write_text(changed)
    (r/'out'/f'{label}.patch').write_text(''.join(difflib.unified_diff(source.splitlines(True), changed.splitlines(True),
                                                                 fromfile='a/src/each.rs', tofile='b/src/each.rs')))
    run(directory, label, release, test, 100, message)
PY
printf 'output16 distinct-index contract and reset controls complete\n' > "$R/out/status.txt"
