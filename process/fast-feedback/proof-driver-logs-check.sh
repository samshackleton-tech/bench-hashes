#!/bin/bash
# Cache identity only: no proof campaign, compiler, credential or status post.
set -euo pipefail
R="$1"
mkdir -p "$R/out"
{
    echo "fork $(git -C "$R/fork" rev-parse HEAD)"
    python3 --version
    uname -m
} > "$R/out/identity.txt"
sh -n "$R/fork/tools/verify/long-proofs.sh"
timeout -k 5s 90s python3 -m unittest discover -s "$R/fork/tools/verify" \
    -p 'test_long_proof*.py' -v > "$R/out/tests.log" 2>&1
python3 - "$R" <<'PY'
import difflib, os
from pathlib import Path
import subprocess, sys, tempfile
r = Path(sys.argv[1])
source = (r/'fork/tools/verify/long-proofs.sh').read_text()
prior = subprocess.check_output(['git', '-C', str(r/'fork'), 'show',
    '31c11c254c3bce80ff2cd00543fd693f6969fb37:tools/verify/long-proofs.sh'], text=True)
expression = [line for line in source.splitlines() if line.startswith('inputs=$(')]
old_expression = [line for line in prior.splitlines() if line.startswith('inputs=$(')]
assert len(expression) == len(old_expression) == 1
omitted = ' tools/gen_sme2_hybrid.py tools/gen_x86.py'
assert source.count(omitted) == 1
logs = [line for line in source.splitlines() if line.startswith('logs=')]
old_logs = [line for line in prior.splitlines() if line.startswith('logs=')]
assert len(logs) == len(old_logs) == 1
assert source.count('$prior-$inputs') == 1
log_test = 'test_log_destinations_and_cache_lookup_preserve_each_input'
controls = [
    ('omitted-generators', source.replace(omitted, ''),
     'test_each_checked_generator_invalidates_the_cache_key'),
    ('omitted-caller', source.replace(expression[0], old_expression[0]),
     'test_caller_verification_changes_invalidate_but_relocation_keeps_the_key'),
    ('shared-log-directory', source.replace(logs[0], old_logs[0]), log_test),
    ('wrong-cache-log-lookup', source.replace('$prior-$inputs', '$prior'), log_test),
]
for name, changed, test in controls:
    assert changed != source
    with tempfile.TemporaryDirectory(prefix='proof-driver-control-') as d:
        script = Path(d)/'long-proofs.sh'
        script.write_text(changed)
        result = subprocess.run([sys.executable, '-m', 'unittest', 'discover', '-s',
                                 str(r/'fork/tools/verify'), '-p', 'test_long_proof*.py', '-v'],
                                env=dict(os.environ, LONG_PROOFS_SCRIPT=str(script)),
                                capture_output=True, text=True, timeout=90)
        output = result.stdout + result.stderr
        diff = ''.join(difflib.unified_diff(source.splitlines(True), changed.splitlines(True),
                                          fromfile='fixed-key', tofile=name))
        (r/'out'/f'{name}.log').write_text(diff + output)
        assert result.returncode == 1 and 'FAIL: ' + test in output, output
        assert 'ERROR:' not in output, output
        print('control rejected:', name)
PY
printf 'proof driver input checks complete\n' > "$R/out/status.txt"
if [[ ${PINNED_RUN_PREFLIGHT:-0} == 1 ]]; then
    printf 'pinned-run preflight complete\n' > "$R/out/preflight.txt"
fi
