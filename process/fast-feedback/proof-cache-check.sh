#!/bin/bash
# Focused cache identity tests; no proof, compiler, credential or GitHub status.
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
    -p test_long_proof_inputs.py -v > "$R/out/tests.log" 2>&1
python3 - "$R" <<'PY'
import difflib, os
from pathlib import Path
import subprocess, sys, tempfile
r = Path(sys.argv[1])
source = (r/'fork/tools/verify/long-proofs.sh').read_text()
omitted = ' tools/gen_sme2_hybrid.py tools/gen_x86.py'
assert source.count(omitted) == 1
old = source.replace(omitted, '')
with tempfile.TemporaryDirectory(prefix='proof-input-control-') as d:
    script = Path(d)/'long-proofs.sh'
    script.write_text(old)
    result = subprocess.run([sys.executable, '-m', 'unittest', 'discover', '-s',
                             str(r/'fork/tools/verify'), '-p', 'test_long_proof_inputs.py', '-v'],
                            env=dict(os.environ, LONG_PROOFS_SCRIPT=str(script)),
                            capture_output=True, text=True, timeout=90)
    output = result.stdout + result.stderr
    (r/'out/control.log').write_text(''.join(difflib.unified_diff(source.splitlines(True), old.splitlines(True),
                                                               fromfile='fixed-key', tofile='omitted-generators')) + output)
    assert result.returncode == 1 and 'FAIL: test_each_checked_generator_invalidates_the_cache_key' in output, output
    assert 'ERROR:' not in output, output
print('omitted-generator control rejected')
PY
printf 'proof cache input checks complete\n' > "$R/out/status.txt"
