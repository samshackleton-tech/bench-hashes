#!/bin/bash
# Reuse the exact executed memlock/functional driver on a disposable Btrfs filesystem.
set -euo pipefail
exec timeout -k 15s 540s unshare --mount --propagation private bash -s -- "$1" <<'JOB'
set -euo pipefail
R="$1";O="$R/out";mkdir -p "$O";S="/var/tmp/$(basename "$R")"
IMAGE="$R/canary-btrfs.img";mkdir -p "$S";truncate -s 16G "$IMAGE"
mkfs.btrfs -f "$IMAGE" > "$O/filesystem-create.txt" 2>&1
mount -o loop,nosuid,nodev "$IMAGE" "$S"
cleanup() { umount "$S" >> "$O/filesystem-cleanup.txt" 2>&1; }
trap cleanup EXIT
findmnt -J --target "$S" > "$O/filesystem-mounted.json"
printf 'reflink-control-payload\n' > "$S/reflink-source"
cp --reflink=always "$S/reflink-source" "$S/reflink-clone"
cmp "$S/reflink-source" "$S/reflink-clone"
printf 'modified-clone\n' > "$S/reflink-clone"
grep -Fx 'reflink-control-payload' "$S/reflink-source" > "$O/reflink-control.txt"
python3 - <<'VERIFY'
from pathlib import Path
import hashlib
p=Path('/root/pinned-runs/scripts/job-7aa9af8dae326febb48a6a3ea391df8358b6a4cc617c30e2c6214c4ce2ddd27b.sh')
assert hashlib.sha256(p.read_bytes()).hexdigest()=='7aa9af8dae326febb48a6a3ea391df8358b6a4cc617c30e2c6214c4ce2ddd27b'
VERIFY
bash /root/pinned-runs/scripts/job-7aa9af8dae326febb48a6a3ea391df8358b6a4cc617c30e2c6214c4ce2ddd27b.sh "$R"
JOB
