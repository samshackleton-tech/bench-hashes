#!/usr/bin/env python3
"""Deterministic spawn/cancel interleaving; every process belongs to this fixture."""
import builtins
import importlib.machinery
import importlib.util
import io
import json
import os
from pathlib import Path
import signal
import subprocess
import sys
import time

mode, base = sys.argv[1], Path(sys.argv[2])
source = base / 'tools/tools/pinned-run/pinned-run'
loader = importlib.machinery.SourceFileLoader('reviewed_runner', str(source))
spec = importlib.util.spec_from_loader(loader.name, loader)
pr = importlib.util.module_from_spec(spec)
loader.exec_module(pr)
pr.SUPERVISOR = 'process'
pr.RUNS = str(base)
run_id = 'cancel-window-20261107T000001-00000001'
run = base / run_id

if mode == 'controller':
    real_open = builtins.open
    real_popen = subprocess.Popen

    def spawn(*args, **kwargs):
        child = real_popen(*args, **kwargs)
        with real_open(run / 'owned-job-pid', 'w') as f:
            f.write(str(child.pid))
        return child

    def delayed_job_record(path, mode='r', *args, **kwargs):
        if os.fspath(path) == str(run / 'JOB_PGID') and mode == 'w':
            with real_open(run / 'at-spawn-window', 'w'):
                pass
            # Pause metadata publication, not process creation. Parent cancels here.
            with real_open(run / 'barrier', 'rb') as barrier:
                barrier.read(1)
        return real_open(path, mode, *args, **kwargs)

    subprocess.Popen = spawn
    builtins.open = delayed_job_record
    with real_open(run / 'job.log', 'w') as log:
        pr.run_job(['sleep', '30'], str(run), dict(os.environ), log, {})
else:
    assert mode == 'parent'
    run.mkdir()
    os.mkfifo(run / 'barrier')
    controller = subprocess.Popen([sys.executable, __file__, 'controller', str(base)], start_new_session=True)
    (run / 'PGID').write_text(str(controller.pid) + '\n')
    job_pid = None
    try:
        end = time.monotonic() + 5
        while not (run / 'at-spawn-window').exists():
            assert controller.poll() is None, 'controller exited before the interleaving'
            assert time.monotonic() < end, 'spawn barrier not reached'
            time.sleep(0.01)
        job_pid = int((run / 'owned-job-pid').read_text())
        assert not (run / 'JOB_PGID').exists()
        response = io.BytesIO()
        pr.serve('cancel', [run_id], stdout=response)
        controller.wait(timeout=3)
        stat = Path(f'/proc/{job_pid}/stat').read_text()
        job_state = stat.rsplit(')', 1)[1].split()[0]
        findings = dict(controller_returncode=controller.returncode,
                        recorded_status=(run / 'STATUS').read_text().strip(),
                        job_survived_cancel=job_state not in ('Z', 'X'), job_state=job_state,
                        response=response.getvalue().decode().strip())
        assert controller.returncode == -signal.SIGKILL
        assert findings['recorded_status'] == 'CANCELLED' and findings['job_survived_cancel']
        (base / 'out/cancel-window.json').write_text(json.dumps(findings, indent=2) + '\n')
        print('spawn-window cancellation race reproduced with owned processes')
    finally:
        if job_pid is None and (run / 'owned-job-pid').exists():
            job_pid = int((run / 'owned-job-pid').read_text())
        for pid in [job_pid, controller.pid if controller.poll() is None else None]:
            if pid is not None:
                try:
                    os.killpg(pid, signal.SIGKILL)
                except ProcessLookupError:
                    pass
        controller.wait()
