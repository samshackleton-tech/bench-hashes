#!/bin/bash
# Review reproductions use only process groups this job creates and owns.
set -euo pipefail
R="$1"
mkdir -p "$R/out"
echo "tools $(git -C "$R/tools" rev-parse HEAD)" > "$R/out/identity.txt"
python3 - "$R" <<'PY'
import importlib.machinery, importlib.util, json, os
from pathlib import Path
import signal, subprocess, sys
r = Path(sys.argv[1])
source = r/'tools/tools/pinned-run/pinned-run'
loader = importlib.machinery.SourceFileLoader('reviewed_local_runner', str(source))
spec = importlib.util.spec_from_loader(loader.name, loader)
pr = importlib.util.module_from_spec(spec)
loader.exec_module(pr)
pr.SUPERVISOR = 'process'
findings = {}
for case in ['terminal', 'unrelated']:
    run = r/('review-'+case)
    run.mkdir()
    sentinel = subprocess.Popen(['sleep', '30'], start_new_session=True)
    try:
        (run/'PGID').write_text(str(sentinel.pid)+'\n')
        if case == 'terminal':
            (run/'STATUS').write_text('VERIFIED\n')
            pr.stop(str(run), 'review: terminal cancellation')
            sentinel.wait(timeout=3)
            findings['terminal_cancel'] = {'sentinel_returncode': sentinel.returncode,
                'recorded_status': (run/'STATUS').read_text().strip(),
                'observation': 'cancelling a terminal record signalled its saved numeric PGID'}
            assert sentinel.returncode == -signal.SIGKILL
        else:
            findings['unrelated_group'] = {'reported_active': pr.executor_active(str(run)),
                'sentinel_argv': ['sleep', '30'],
                'observation': 'a saved PGID alone accepts an unrelated live group as the executor'}
            assert findings['unrelated_group']['reported_active']
    finally:
        if sentinel.poll() is None:
            os.killpg(sentinel.pid, signal.SIGKILL)
        sentinel.wait()
(r/'out/findings.json').write_text(json.dumps(findings, indent=2)+'\n')
print('local backend review reproductions complete')
PY
printf 'review reproductions complete\n' > "$R/out/status.txt"
