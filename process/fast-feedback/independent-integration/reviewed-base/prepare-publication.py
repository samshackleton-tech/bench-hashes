#!/usr/bin/env python3
"""Copy text-only raw review evidence and regenerate complete dual-digest catalogs."""
from pathlib import Path
import hashlib
import json
import os
import shutil
import stat
import subprocess

SOURCE = Path(__file__).resolve().parent
TARGET = Path('/home/samshackleton/work/bench-fast-feedback/process/fast-feedback/independent-integration/reviewed-base')
GENERATED = {'FILES.json', 'SHA256SUMS', 'BLAKE3SUMS', 'EXCLUDED.json'}
excluded = []
for p in sorted(SOURCE.rglob('*')):
    relative = p.relative_to(SOURCE)
    if p.is_symlink():
        excluded.append(dict(path=str(relative), reason='link/cache'))
        continue
    if not p.is_file():
        continue
    reason = None
    if p.name.startswith('CHECKPOINT'):
        reason = 'private checkpoint'
    elif p.stat().st_size >= 20 * 1024 * 1024:
        reason = 'file at least20MiB'
    elif any(part in {'.git', '__pycache__'} for part in relative.parts):
        reason = 'private cache'
    data = p.read_bytes() if reason is None else b''
    if reason is None:
        try:
            data.decode('utf-8')
        except UnicodeDecodeError:
            reason = 'binary'
        if b'\0' in data:
            reason = 'binary'
    if reason is not None:
        excluded.append(dict(path=str(relative), reason=reason))
        assert not (TARGET / relative).exists(), f'Previously published excluded item: {relative}'
        continue
    destination = TARGET / relative
    destination.parent.mkdir(parents=True, exist_ok=True)
    if destination.exists():
        destination.chmod(stat.S_IMODE(destination.stat().st_mode) | stat.S_IWUSR)
    shutil.copy2(p, destination)
    assert destination.read_bytes() == data
(TARGET / 'EXCLUDED.json').write_text(json.dumps(excluded, indent=2) + '\n')
payload = sorted(p for p in TARGET.rglob('*') if p.is_file() and not (p.parent == TARGET and p.name in GENERATED - {'EXCLUDED.json'}))
blake3 = []
for start in range(0, len(payload), 128):
    batch = payload[start:start + 128]
    values = subprocess.check_output(['b3sum', '--no-names', *map(str, batch)], text=True).splitlines()
    assert len(values) == len(batch) and all(len(v) == 64 for v in values)
    blake3.extend(values)
records = []
for p, digest in zip(payload, blake3):
    data = p.read_bytes()
    records.append(dict(path=str(p.relative_to(TARGET)), bytes=len(data), mode=oct(stat.S_IMODE(p.stat().st_mode)), sha256=hashlib.sha256(data).hexdigest(), blake3=digest))
(TARGET / 'FILES.json').write_text(json.dumps(records, indent=2) + '\n')
for filename, key in [('SHA256SUMS', 'sha256'), ('BLAKE3SUMS', 'blake3')]:
    (TARGET / filename).write_text(''.join(f"{v[key]}  {v['path']}\n" for v in records))
print(json.dumps(dict(payload_files=len(records), payload_bytes=sum(v['bytes'] for v in records), excluded=excluded), indent=2))
