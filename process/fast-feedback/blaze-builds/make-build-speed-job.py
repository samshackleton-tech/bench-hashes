#!/usr/bin/env python3
"""Reuse the proven private-filesystem setup; embed every executing input."""
from pathlib import Path
import ast
import json
import subprocess
import sys

root = Path(__file__).resolve().parent
pairs = int(sys.argv[1])
profile = sys.argv[2] if len(sys.argv) == 3 else 'release'
assert pairs in (1, 4) and profile in ('release', 'dev')
working = (root / 'canary-btrfs-fixed.sh').read_text()
prefix = working.split("cat > \"$R/functional-driver.sh\" <<'FUNCTIONAL_DRIVER'\n")[0]
prefix = prefix.replace("<<'BTRFS_JOB'", "<<'BUILD_SPEED_JOB'")
# AF_UNIX's 108-byte sun_path also bounds dev's nested inproc socket.
assert prefix.count('S="/var/tmp/$(basename "$R")"') == 1
prefix = prefix.replace('S="/var/tmp/$(basename "$R")"', 'S="/var/tmp/bz-${R##*-}"')
parts = [prefix, '\n. /root/.cargo/env\n',
         '{ echo "source $(git -C "$R/library" rev-parse HEAD)"; echo "clocks $(git -C "$R/bench" rev-parse HEAD)"; ',
         'echo "canary 0.20261105.4 e93029602544df9882fffb18bf272d048a1a7136"; ',
         'echo "build-speed trial; process-tree hardware counters NA; speed unjudged"; } > "$O/identity.txt"\n']
for name, source, tag in [('bridge.rs', 'build-speed-bridge.rs', 'BUILD_CLOCKS_RUST'),
                          ('build-speed.py', 'build-speed.py', 'BUILD_SPEED_DRIVER_PY')]:
    body = (root / source).read_text()
    assert tag not in body.splitlines()
    parts += [f'cat > "$R/{name}" <<\'{tag}\'\n', body, tag + '\n']
parts += [f'python3 "$R/build-speed.py" "$R" "$S" {pairs} {profile} > "$O/driver.stdout" 2> "$O/driver.stderr"\n',
          'git -C "$R/library" diff --exit-code > "$O/original-source-diff.txt"\n', 'BUILD_SPEED_JOB\n']
text = ''.join(parts)
assert text.splitlines().count('BUILD_SPEED_JOB') == 1
assert text.endswith('BUILD_SPEED_JOB\n')
subprocess.run(['bash', '-n'], input=text, text=True, check=True, capture_output=True)
outer = text[text.index("<<'BUILD_SPEED_JOB'\n") + len("<<'BUILD_SPEED_JOB'\n"):-len('BUILD_SPEED_JOB\n')]
subprocess.run(['bash', '-n'], input=outer, text=True, check=True, capture_output=True)
ast.parse((root / 'build-speed.py').read_text())
suffix = ('dev-' if profile == 'dev' else '') + ('pilot' if pairs == 1 else 'paired')
path = root / ('build-speed-' + suffix + '.sh')
path.write_text(text)
manifest = dict(name='blaze-build-speed-' + suffix, study='blaze-builds-20261109',
                host='root@88.216.222.150', lock='/root/bench-native-afk.lock',
                repos=[dict(url='https://github.com/samshackleton-tech/BLAKE3', commit='1cbdf5d72d70d8ed511870b18c7f017cce83da15', path='library'),
                       dict(url='https://github.com/servil-software-factory/bench-hashes', commit='9994de190259648ede82f7c5e4dbac4f1534a41d', path='bench')],
                script=str(path), expect=[
                    dict(file='out/identity.txt', contains=['source 1cbdf5d72d70d8ed511870b18c7f017cce83da15', 'clocks 9994de190259648ede82f7c5e4dbac4f1534a41d', 'process-tree hardware counters NA']),
                    dict(file='out/canary-version.stdout', contains=['blaze 0.20261105.4 (e930296']),
                    dict(file='out/rustc-version.stdout', contains=['rustc 1.99.1']),
                    dict(file='out/measurement-controls.json', contains=['"failure_propagated": true']),
                    dict(file='out/outcome.json', contains=['"complete": true', '"library_bytes_restored": true', '"speed_verdict": "unjudged"']),
                    dict(file='out/status.txt', contains=['digest and restoration controls pass', 'all-worker cgroup CPU collected'])])
path.with_suffix('.json').write_text(json.dumps(manifest, indent=2) + '\n')
print(path)
