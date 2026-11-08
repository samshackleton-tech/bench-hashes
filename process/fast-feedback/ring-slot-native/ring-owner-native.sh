#!/bin/bash
set -euo pipefail
R="$1"
mkdir -p "$R/out"
export HOME=/root
. /root/.cargo/env
export CARGO_TARGET_DIR="$R/target"
cd "$R/fork"
{
    echo "library $(git rev-parse HEAD)"
    rustc -Vv
    uname -m
} > "$R/out/identity.txt"
timeout -k 5s 240s cargo nextest run --release --features serde,zeroize --lib --tests --no-fail-fast > "$R/out/tests.log" 2>&1
timeout -k 5s 90s cargo test --release --doc --features serde,zeroize > "$R/out/docs.log" 2>&1
for i in $(seq 1 16);do
    timeout -k 5s 40s cargo test --release --doc --features serde,zeroize throughput::pipeline > "$R/out/pipeline-$i.log" 2>&1
    echo "pipeline ordinary parallel run $i passed"
done
timeout -k 5s 30s cargo fmt --all -- --check > "$R/out/fmt.log" 2>&1
timeout -k 5s 90s cargo build --release --no-default-features > "$R/out/no-default.log" 2>&1
RUSTDOCFLAGS='-D warnings' timeout -k 5s 90s cargo doc --no-deps --features serde,zeroize > "$R/out/rustdoc.log" 2>&1
# Deterministically restore the original unsafe reuse boundary ONLY in the
# owner's unregistered-source schedule test. Channels order writes/copy;
# payloads never execute. No widened unsafe production pipeline run.
python3 - "$R/out" <<'PY'
from pathlib import Path
import subprocess,sys
out=Path(sys.argv[1]);p=Path('src/lanes.rs')
old='if slot.next.load(Ordering::Acquire) != p {'
new='if false { // deterministic control: reuse ignores the delayed copy'
assert p.read_text().count(old)==1
subprocess.run(['replace',str(p),old,new],check=True,stdout=(out/'reuse-control-edit.log').open('w'))
try:
    with (out/'reuse-control.log').open('w')as f:
        result=subprocess.run(['timeout','-k','5s','90s','cargo','nextest','run','--release','--features','serde,zeroize','--lib','-E','test(ring_reuse_waits_for_the_claimed_task_copy)'],stdout=f,stderr=subprocess.STDOUT)
    assert result.returncode==100,result.returncode
    assert 'publication waits until the old task is copied' in (out/'reuse-control.log').read_text()
finally:
    subprocess.run(['replace',str(p),new,old],check=True,stdout=(out/'reuse-control-restore.log').open('w'))
print('original reuse protocol rejected at publication waits until the old task is copied')
PY
test -z "$(git status --porcelain)"
printf 'ring owner exact-source native and deterministic control passed\n' > "$R/out/status.txt"
if [[ ${PINNED_RUN_PREFLIGHT:-0} == 1 ]];then printf 'pinned-run preflight complete\n' > "$R/out/preflight.txt";fi
