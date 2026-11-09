#!/usr/bin/env python3
"""Validate the nested scripts without mounting a filesystem or invoking Blaze."""
from pathlib import Path
import re
import subprocess
import tempfile
import unittest

ROOT = Path(__file__).resolve().parent

def validate(text):
    opener = re.search(r"<<'([^']+)'\n", text)
    assert opener
    tag = opener[1]
    assert text.splitlines().count(tag) == 1, 'outer delimiter collides with embedded script'
    assert text.endswith(tag + '\n')
    outer = text[opener.end():-(len(tag) + 1)]
    marker = "<<'FUNCTIONAL_DRIVER'\n"
    start = outer.index(marker) + len(marker)
    end = outer.index('\nFUNCTIONAL_DRIVER\n', start)
    driver = outer[start:end] + '\n'
    assert driver == (ROOT / 'canary-functional-fixed.sh').read_text()
    assert "'--target-dir',str(s/project/'target')" in driver
    for name, source in [('wrapper', text), ('outer', outer), ('functional', driver)]:
        result = subprocess.run(['bash', '-n'], input=source, text=True, capture_output=True)
        assert result.returncode == 0 and not result.stderr, (name, result.stderr)
    for tag in ['PREP', 'PY']:
        marker = "<<'" + tag + "'\n"
        start = driver.index(marker) + len(marker)
        end = driver.index('\n' + tag + '\n', start)
        compile(driver[start:end], tag, 'exec')
    marker = "<<'PASSWD_OVERLAY'\n"
    if marker in outer:
        start = outer.index(marker) + len(marker)
        end = outer.index('\nPASSWD_OVERLAY\n', start)
        compile(outer[start:end], 'PASSWD_OVERLAY', 'exec')

class Harness(unittest.TestCase):
    def test_current_wrapper(self):
        validate((ROOT / 'canary-btrfs-fixed.sh').read_text())

    def test_rejects_the_observed_delimiter_collision(self):
        current = (ROOT / 'canary-btrfs-fixed.sh').read_text()
        broken = current.replace("<<'BTRFS_JOB'", "<<'JOB'").removesuffix('BTRFS_JOB\n') + 'JOB\n'
        with self.assertRaisesRegex(AssertionError, 'delimiter collides'):
            validate(broken)

    def test_rejects_missing_explicit_output_directory(self):
        current = (ROOT / 'canary-btrfs-fixed.sh').read_text()
        broken = current.replace(",'--target-dir',str(s/project/'target')", '')
        with self.assertRaises(AssertionError): validate(broken)

if __name__ == '__main__':
    unittest.main(verbosity=2)
