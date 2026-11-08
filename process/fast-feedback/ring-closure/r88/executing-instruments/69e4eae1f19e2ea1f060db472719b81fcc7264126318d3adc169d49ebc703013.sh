#!/bin/bash
set -euo pipefail
exec timeout -k 5s 900s bash -s -- "$1" <<'JOB'
set -euo pipefail
R="$1"
mkdir -p "$R/out"
export HOME=/root
. /root/.cargo/env
export CARGO_TARGET_DIR="$R/target"
cd "$R/fork"
NEW="$(git rev-parse HEAD)"
test "$(git rev-parse HEAD^)" = fbfb319f3414ac7fac4b3d4bce266488a1fdee3b
{ echo "library $NEW";echo "fix $FIX";rustc -Vv;uname -m;} > "$R/out/identity.txt"
git diff --stat HEAD^ HEAD > "$R/out/change.txt"
timeout -k 5s 300s cargo nextest run --release --features serde,zeroize --lib --tests --no-fail-fast > "$R/out/tests.log" 2>&1
timeout -k 5s 120s cargo test --release --doc --features serde,zeroize > "$R/out/docs.log" 2>&1
timeout -k 5s 30s cargo fmt --all -- --check > "$R/out/fmt.log" 2>&1
timeout -k 5s 120s cargo build --release --no-default-features > "$R/out/no-default.log" 2>&1
RUSTDOCFLAGS='-D warnings' timeout -k 5s 120s cargo doc --no-deps --features serde,zeroize > "$R/out/rustdoc.log" 2>&1
# Negative control: the fix's own check fails on the old code, restored after.
python3 - "$R/out" "$FIX" <<'PY'
from pathlib import Path
import subprocess,sys
out=Path(sys.argv[1]);fix=sys.argv[2]
if fix=='packed':
    path=Path('src/block.rs');old='let lines = count.div_ceil(128 / N);';new='let lines = (count * N).div_ceil(128);'
    command=['cargo','nextest','run','--release','--features','serde,zeroize','--lib','-E','test(packed_rejects_a_count_its_bytes_overflow_32) | test(packed_rejects_a_count_its_bytes_overflow_16)']
    want=100;marker='2 failed'
else:
    path=Path('src/stream.rs');old='    fn open(mode: Mode, done: D) -> Self {';new='    pub fn open(mode: Mode, done: D) -> Self {'
    command=['cargo','test','--release','--doc','--features','serde,zeroize','::open']
    want=101;marker='Test compiled successfully, but it\'s marked `compile_fail`'
original=path.read_bytes();assert original.decode().count(old)==1
subprocess.run(['replace',str(path),old,new],check=True,stdout=(out/'control-edit.log').open('w'))
try:
    with (out/'control-red.log').open('w')as f:
        p=subprocess.run(['timeout','-k','5s','300s',*command],stdout=f,stderr=subprocess.STDOUT)
    log=(out/'control-red.log').read_text()
    assert p.returncode==want,(p.returncode,log[-2000:])
    assert marker in log,log[-2000:]
finally:
    subprocess.run(['replace',str(path),new,old],check=True,stdout=(out/'control-restore.log').open('w'))
    assert path.read_bytes()==original
print('control: the old code fails the fix check; source restored byte for byte')
PY
test -z "$(git status --porcelain)"
printf 'fix %s validated with its failing control\n' "$FIX" > "$R/out/status.txt"
JOB
