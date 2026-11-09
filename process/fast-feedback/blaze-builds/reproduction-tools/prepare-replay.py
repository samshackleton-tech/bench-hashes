#!/usr/bin/env python3
"""Prepare, but do not execute, an upstream replay on a disposable root Linux VM."""
from pathlib import Path
import argparse
import ast
import hashlib
import json
import os
import shutil
import subprocess
import urllib.request

EVIDENCE = Path(__file__).resolve().parents[1]
RUNS = {
    'release': 'blaze-build-speed-paired-20261109T173513-23a257b1',
    'dev': 'blaze-build-speed-dev-paired-20261109T174723-5ee366f7',
}
ARCHIVE_SHA = 'a8b8f3b36b7397671d3a5bcf739e5e1407e5941ee2345aaf5dc2b0868d44d8e6'
ARCHIVE_URL = 'https://blaze-releases.ix.dev/v0.20261105.4/blaze-v0.20261105.4-x86_64-unknown-linux-gnu.tar.gz'


def replay_source(profile):
    run = EVIDENCE / 'runs' / RUNS[profile]
    manifest = json.loads((run / 'manifest.json').read_text())
    original = EVIDENCE / 'executing-drivers' / ('job-' + manifest['script_sha256'] + '.sh')
    data = original.read_bytes()
    assert hashlib.sha256(data).hexdigest() == manifest['script_sha256']
    text = data.decode()
    old = "    call('cargo-fetch', [S / 'cargo-toolchain/bin/cargo', 'fetch', '--manifest-path', S / 'seed-project/Cargo.toml'], S, env(SEED), seed_group)"
    new = "    shutil.copyfile(R / 'repro-Cargo.lock', S / 'seed-project/Cargo.lock')\n" + old.replace("'fetch', '--manifest-path'", "'fetch', '--locked', '--manifest-path'")
    assert text.count(old) == 1
    # One explicit replay-only change: pin the originally resolved dependency
    # lock before fetching. The original executing script remains unchanged.
    text = text.replace(old, new)
    subprocess.run(['bash', '-n'], input=text, text=True, capture_output=True, check=True)
    marker = "<<'BUILD_SPEED_DRIVER_PY'\n"
    start = text.index(marker) + len(marker)
    end = text.index('\nBUILD_SPEED_DRIVER_PY\n', start)
    ast.parse(text[start:end])
    return manifest, text, (run / 'out/probe-Cargo.lock').read_bytes()


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('profile', choices=RUNS)
    parser.add_argument('directory', type=Path, help='new, short absolute path, e.g. /root/bz-release-01')
    args = parser.parse_args()
    assert os.geteuid() == 0, 'use a disposable root Linux VM; this preparer is not for your workstation'
    r = args.directory
    assert r.is_absolute() and not r.exists() and len(str(r)) < 60
    assert Path('/root/.cargo/env').is_file()
    for command in ['git', 'bash', 'python3', 'mkfs.btrfs', 'mount', 'umount', 'findmnt', 'unshare', 'flock', 'cp', 'cc']:
        assert shutil.which(command), command
    rustc = subprocess.check_output(['/root/.cargo/bin/rustc', '-V'], text=True)
    assert rustc.startswith('rustc 1.99.1 '), rustc
    assert Path('/sys/fs/cgroup/cgroup.controllers').is_file(), 'cgroup v2 required'
    for helper in ['replace', 'procs']:
        source = EVIDENCE / 'reproduction-tools' / helper
        destination = Path('/usr/local/bin') / helper
        if destination.exists():
            assert destination.read_bytes() == source.read_bytes(), ('existing different helper; use a fresh VM', destination)
        else:
            shutil.copyfile(source, destination)
            destination.chmod(0o755)
    manifest, text, lock = replay_source(args.profile)
    archive = Path('/var/tmp/blaze-input-' + ARCHIVE_SHA + '.tar.gz')
    if not archive.exists():
        part = archive.with_suffix('.download')
        with urllib.request.urlopen(ARCHIVE_URL, timeout=60) as response, part.open('xb') as output:
            shutil.copyfileobj(response, output)
        assert part.stat().st_size == 179512564
        assert hashlib.sha256(part.read_bytes()).hexdigest() == ARCHIVE_SHA
        part.chmod(0o444)
        part.rename(archive)
    assert archive.stat().st_size == 179512564
    assert hashlib.sha256(archive.read_bytes()).hexdigest() == ARCHIVE_SHA
    r.mkdir()
    for repo in manifest['repos']:
        path = r / repo['path']
        subprocess.run(['git', 'init', str(path)], check=True)
        subprocess.run(['git', '-C', str(path), 'fetch', '--depth=1', repo['url'], repo['commit']], check=True)
        subprocess.run(['git', '-C', str(path), 'checkout', '--detach', 'FETCH_HEAD'], check=True)
        assert subprocess.check_output(['git', '-C', str(path), 'rev-parse', 'HEAD'], text=True).strip() == repo['commit']
    (r / 'repro-Cargo.lock').write_bytes(lock)
    (r / 'replay.sh').write_text(text)
    (r / 'replay-provenance.json').write_text(json.dumps(dict(
        original_run=RUNS[args.profile], original_script_sha256=manifest['script_sha256'],
        replay_script_sha256=hashlib.sha256(text.encode()).hexdigest(),
        replay_only_change='copy published original Cargo.lock before cargo fetch --locked',
        lock_sha256=hashlib.sha256(lock).hexdigest()), indent=2) + '\n')
    print('\nPrepared only; inspect replay.sh before running. On this quiet disposable VM:')
    print(f'flock -n /root/bench-native-afk.lock bash {r}/replay.sh {r}')
    print('Each replay has a 540-second outer bound. Keep outputs even if a step fails.')


if __name__ == '__main__':
    main()
