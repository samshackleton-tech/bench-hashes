#!/usr/bin/env python3
from pathlib import Path
import ast
import re
import subprocess
import unittest

ROOT = Path(__file__).resolve().parent

def validate(text):
    marker = "<<'BUILD_SPEED_JOB'\n"
    assert marker in text
    assert text.splitlines().count('BUILD_SPEED_JOB') == 1, 'outer delimiter collides'
    assert text.endswith('BUILD_SPEED_JOB\n')
    outer = text[text.index(marker) + len(marker):-len('BUILD_SPEED_JOB\n')]
    for source in [text, outer]:
        parsed = subprocess.run(['bash', '-n'], input=source, text=True, capture_output=True)
        assert parsed.returncode == 0 and not parsed.stderr, parsed.stderr
    bodies = {}
    for tag in ['PASSWD_OVERLAY', 'BUILD_SPEED_DRIVER_PY', 'BUILD_CLOCKS_RUST']:
        marker = "<<'" + tag + "'\n"
        assert text.splitlines().count(tag) == 1
        start = text.index(marker) + len(marker)
        bodies[tag] = text[start:text.index('\n' + tag + '\n', start)] + '\n'
    for tag in ['PASSWD_OVERLAY', 'BUILD_SPEED_DRIVER_PY']:
        ast.parse(bodies[tag])
    assert "'--target-dir', probe / 'target'" in bodies['BUILD_SPEED_DRIVER_PY'], 'explicit target directory required'
    assert "result['exit'] = p.wait()" in bodies['BUILD_SPEED_DRIVER_PY'], 'blocking child wait required'
    assert bodies['BUILD_SPEED_DRIVER_PY'] == (ROOT / 'build-speed.py').read_text()
    assert bodies['BUILD_CLOCKS_RUST'] == (ROOT / 'build-speed-bridge.rs').read_text()
    assert text.index('python3 "$R/build-speed.py"') > text.index('\nBUILD_SPEED_DRIVER_PY\n')
    assert "CLOCK.build_load_report" in bodies['BUILD_SPEED_DRIVER_PY']

class Harness(unittest.TestCase):
    def test_current(self):
        validate((ROOT / 'build-speed-pilot.sh').read_text())

    def test_reject_delimiter_collision(self):
        text = (ROOT / 'build-speed-pilot.sh').read_text()
        text = text.replace("<<'BUILD_SPEED_DRIVER_PY'", "<<'BUILD_SPEED_JOB'")
        text = text.replace('\nBUILD_SPEED_DRIVER_PY\n', '\nBUILD_SPEED_JOB\n')
        with self.assertRaisesRegex(AssertionError, 'delimiter collides'):
            validate(text)

    def test_reject_polling_wait(self):
        text = (ROOT / 'build-speed-pilot.sh').read_text().replace("result['exit'] = p.wait()", "result['exit'] = p.wait(timeout=limit)")
        with self.assertRaisesRegex(AssertionError, 'blocking child wait'):
            validate(text)

    def test_reject_missing_output_path(self):
        text = (ROOT / 'build-speed-pilot.sh').read_text().replace(", '--target-dir', probe / 'target'", '')
        with self.assertRaisesRegex(AssertionError, 'explicit target directory'):
            validate(text)

if __name__ == '__main__':
    unittest.main(verbosity=2)
