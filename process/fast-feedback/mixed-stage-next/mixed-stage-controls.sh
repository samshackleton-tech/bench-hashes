#!/bin/bash
set -euo pipefail
R="$1";mkdir -p "$R/out";export HOME=/root;. /root/.cargo/env
export CARGO_TARGET_DIR="$R/target"
cd "$R/fork"
printf 'library %s\n' "$(git rev-parse HEAD)" > "$R/out/identity.txt"
timeout -k 5s 120s cargo nextest run --release --lib -E 'test(test_held_key_groups_take_one_partition_pass)' > "$R/out/positive.log" 2>&1
python3 - "$R/out" <<'PY'
from pathlib import Path
import subprocess,sys
out=Path(sys.argv[1]);p=Path('src/each.rs')
old='if !others.is_empty() && crate::ffi_output::held_groups(hashers, held, platform) {'
new='if false && !others.is_empty() && crate::ffi_output::held_groups(hashers, held, platform) {'
assert p.read_text().count(old)==1
subprocess.run(['replace',str(p),old,new],check=True,stdout=(out/'partition-control-edit.log').open('w'))
try:
    with (out/'partition-control.log').open('w')as f:
        result=subprocess.run(['timeout','-k','5s','120s','cargo','nextest','run','--release','--lib','-E','test(test_held_key_groups_take_one_partition_pass)'],stdout=f,stderr=subprocess.STDOUT)
    assert result.returncode==100,result.returncode
    assert 'one held partition:' in (out/'partition-control.log').read_text()
finally:
    subprocess.run(['replace',str(p),new,old],check=True,stdout=(out/'partition-control-restore.log').open('w'))
print('repeated mixed-key partition rejected at one held partition')
PY
test -z "$(git status --porcelain)"
printf 'mixed stage partition positive and control passed\n' > "$R/out/status.txt"
