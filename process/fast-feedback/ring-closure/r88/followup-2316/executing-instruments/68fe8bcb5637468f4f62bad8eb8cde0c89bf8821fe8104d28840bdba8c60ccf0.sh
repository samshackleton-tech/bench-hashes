#!/bin/bash
set -euo pipefail
exec timeout -k 5s 540s bash -s -- "$1" <<'JOB'
set -euo pipefail
R="$1"
mkdir -p "$R/out" "$R/tmp"
export HOME=/root
. /root/.cargo/env
export CARGO_TARGET_DIR="$R/target" TMPDIR="$R/tmp" PYTHONUNBUFFERED=1
cd "$R/library"
{ echo "library $(git rev-parse HEAD)"; echo "baseline $(git -C "$R/base" rev-parse HEAD)"; uname -m; rustc -Vv; } > "$R/out/identity.txt"
BASE="$(git -C "$R/base" rev-parse HEAD)"
git fetch --no-tags "$R/base" "$BASE" > "$R/out/base-object.log" 2>&1
git diff "$BASE" -- src/each.rs tests/allocations.rs > "$R/out/tests.diff"
timeout -k 5s 180s cargo nextest run --release --features serde,zeroize --lib --tests --no-fail-fast > "$R/out/tests.log" 2>&1
timeout -k 5s 60s cargo test --release --doc --features serde,zeroize > "$R/out/docs.log" 2>&1
timeout -k 5s 30s cargo fmt --all -- --check > "$R/out/fmt.log" 2>&1
timeout -k 5s 60s cargo build --release --no-default-features > "$R/out/no-default.log" 2>&1
RUSTDOCFLAGS='-D warnings' timeout -k 5s 60s cargo doc --no-deps --features serde,zeroize > "$R/out/rustdoc.log" 2>&1
python3 - "$R" <<'PY'
from pathlib import Path
import subprocess,sys
r=Path(sys.argv[1]);p=Path('src/each.rs');original=p.read_bytes();old=r/'tmp/original.txt';old.write_bytes(original)
controls=[
 ('grouping','if held.iter().all(|&i| hashers[i].core.chunk_state.flags == 0) {',
  'if held.iter().all(|&i| hashers[i].core.chunk_state.flags == 0) || held.iter().all(|&i| hashers[i].core.key == hashers[_first].core.key && hashers[i].core.chunk_state.flags == hashers[_first].core.chunk_state.flags) {',
  ['--lib','-E','test(held_dispatch_ignores_key_equality_and_prefixes)'],
  'dispatch work independent of key equality and prefix'),
 ('allocation','    let Some(&_first) = held.first() else { return };',
  '    let Some(&_first) = held.first() else { return };\n    if hashers[_first].core.key[7] != 0x6d6d6d6d { std::hint::black_box(vec![0u8; 32]); }',
  ['--test','allocations','-E','test(held_allocations_ignore_key_equality_and_prefixes)'],
  'allocation work independent of key equality and prefix'),
]
for name,needle,value,args,message in controls:
 text=original.decode();assert text.count(needle)==1,needle
 new=r/f'tmp/{name}.txt';new.write_text(text.replace(needle,value))
 with (r/f'out/{name}-diff.log').open('w')as f:
  subprocess.run(['replace','-f',str(p),str(old),str(new)],check=True,stdout=f)
 try:
  with (r/f'out/{name}-red.log').open('w')as f:
   status=subprocess.run(['timeout','-k','5s','120s','cargo','nextest','run','--release','--features','serde,zeroize']+args,stdout=f,stderr=subprocess.STDOUT).returncode
  log=(r/f'out/{name}-red.log').read_text();assert status==100,(name,status);assert message in log,(name,log[-2000:])
 finally:
  with (r/f'out/{name}-restore.log').open('w')as f:
   subprocess.run(['replace','-f',str(p),str(new),str(old)],check=True,stdout=f)
 assert p.read_bytes()==original
 print(name+' control rejected; exact source restored')
PY
timeout -k 5s 120s cargo nextest run --release --features serde,zeroize --lib --test allocations -E 'test(held_dispatch_ignores_key_equality_and_prefixes) | test(held_allocations_ignore_key_equality_and_prefixes) | test(allocation_counter_sees_a_callers_allocation)' > "$R/out/restored.log" 2>&1
git status --porcelain > "$R/out/final-git-status.txt"
test ! -s "$R/out/final-git-status.txt"
printf 'security dispatch/allocation controls passed\n' > "$R/out/status.txt"
JOB
