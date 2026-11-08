#!/bin/bash
set -euo pipefail
exec timeout -k 5s 240s bash -s -- "$1" <<'JOB'
set -euo pipefail
R="$1"
mkdir -p "$R/out" "$R/tmp"
export HOME=/root
. /root/.cargo/env
export CARGO_TARGET_DIR="$R/target"
cd "$R/library"
{ echo "library $(git rev-parse HEAD)"; rustc -Vv; } > "$R/out/identity.txt"
cargo nextest run --release --features serde,zeroize --lib -E 'test(held_dispatch_ignores_key_equality_and_prefixes)' > "$R/out/positive.log" 2>&1
python3 - "$R" <<'PY'
from pathlib import Path
import subprocess,sys
r=Path(sys.argv[1]);p=Path('src/each.rs');original=p.read_bytes();text=original.decode()
a='if held.iter().all(|&i| hashers[i].core.chunk_state.flags == 0) {'
b='if held.iter().all(|&i| hashers[i].core.chunk_state.flags == 0) || held.iter().all(|&i| hashers[i].core.key == hashers[_first].core.key && hashers[i].core.chunk_state.flags == hashers[_first].core.chunk_state.flags) {'
assert text.count(a)==1;text=text.replace(a,b)
# Same complete platform list, reversed: expose the wide-kernel entry-set
# check before SSE4.1's cohort-membership assertion stops the test.
a='fn held_dispatch_ignores_key_equality_and_prefixes() {\n        crate::initialize();\n        let input = vec![42u8; 2 * crate::STAGE_LEN];\n        for platform in crate::test::every_platform() {'
b=a.replace('crate::test::every_platform() {','crate::test::every_platform().into_iter().rev() {')
assert text.count(a)==1;text=text.replace(a,b)
old=r/'tmp/old.txt';new=r/'tmp/new.txt';old.write_bytes(original);new.write_text(text)
with (r/'out/control-diff.log').open('w')as f:subprocess.run(['replace','-f',str(p),str(old),str(new)],stdout=f,check=True)
try:
 with (r/'out/control-red.log').open('w')as f:
  status=subprocess.run(['cargo','nextest','run','--release','--features','serde,zeroize','--lib','-E','test(held_dispatch_ignores_key_equality_and_prefixes)'],stdout=f,stderr=subprocess.STDOUT).returncode
 log=(r/'out/control-red.log').read_text()
 assert status==100,status
 assert 'dispatch work independent of key equality and prefix: AVX512' in log,log[-2000:]
finally:
 with (r/'out/restore-diff.log').open('w')as f:subprocess.run(['replace','-f',str(p),str(new),str(old)],stdout=f,check=True)
assert p.read_bytes()==original
PY
cargo nextest run --release --features serde,zeroize --lib -E 'test(held_dispatch_ignores_key_equality_and_prefixes)' > "$R/out/restored.log" 2>&1
git status --porcelain > "$R/out/final-git-status.txt"
test ! -s "$R/out/final-git-status.txt"
printf 'wide-kernel entry-set control rejected and restored\n' > "$R/out/status.txt"
JOB
