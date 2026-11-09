#!/bin/bash
set -euo pipefail
exec timeout -k 5s 570s bash -s -- "$1" <<'JOB'
set -euo pipefail
R="$1"
mkdir -p "$R/out" "$R/tmp"
export HOME=/root
. /root/.cargo/env
export CARGO_TARGET_DIR="$R/target" TMPDIR="$R/tmp" PYTHONUNBUFFERED=1
cd "$R/library"
BASE="$(git -C "$R/base" rev-parse HEAD)"
git fetch --no-tags "$R/base" "$BASE" > "$R/out/base-object.log" 2>&1
git merge-base --is-ancestor "$BASE" HEAD
{ echo "library $(git rev-parse HEAD)"; echo "baseline $BASE"; uname -m; rustc -Vv; } > "$R/out/identity.txt"
git diff "$BASE" -- src/each.rs tests/allocations.rs > "$R/out/tests.diff"
test "$(git diff --name-only "$BASE" | sort | tr '\n' ' ')" = 'src/each.rs tests/allocations.rs '
timeout -k 5s 180s cargo nextest run --release --features serde,zeroize --lib --tests --no-fail-fast > "$R/out/tests.log" 2>&1
timeout -k 5s 60s cargo test --release --doc --features serde,zeroize > "$R/out/docs.log" 2>&1
timeout -k 5s 30s cargo fmt --all -- --check > "$R/out/fmt.log" 2>&1
timeout -k 5s 60s cargo build --release --no-default-features > "$R/out/no-default.log" 2>&1
RUSTDOCFLAGS='-D warnings' timeout -k 5s 60s cargo doc --no-deps --features serde,zeroize > "$R/out/rustdoc.log" 2>&1
python3 - "$R" <<'PY'
from pathlib import Path
import subprocess,sys
r=Path(sys.argv[1]);p=Path('src/each.rs');original=p.read_bytes();old=r/'tmp/original.txt';old.write_bytes(original)
text=original.decode();start=text.index('    // Plain\'s key is the IV, the same for every plain hasher.');end=text.index('\n}\n',start)
secret_grouping='''    let Some((&first, rest)) = held.split_first() else { return };
    let mut alike = vec![first];
    let mut other = Vec::new();
    for &i in rest {
        if hashers[i].core.key == hashers[first].core.key && hashers[i].core.chunk_state.flags == hashers[first].core.chunk_state.flags {
            alike.push(i);
        } else {
            other.push(i);
        }
    }
    hash_cohort(hashers, &alike);
    hash_held(hashers, &other);'''
allocation='''    // Plain's key is the IV, the same for every plain hasher.
    if let Some(&i) = held.first() {
        if hashers[i].core.key[7] != 0x6d6d6d6d { std::hint::black_box(vec![0u8; 32]); }
    }'''
platform='''    let platform = turn.platform();
    // A valid alternate kernel, selected incorrectly from secret bytes.
    let platform = if matches!(platform, Platform::AVX512) && hashers[first].core.key[7] != 0x6d6d6d6d { Platform::AVX2 } else { platform };'''
assert text.count('    let platform = turn.platform();')==1
controls=[
 ('grouping',text[:start]+secret_grouping+text[end:],['--lib','-E','test(held_dispatch_ignores_key_equality_and_prefixes)'],'dispatch work independent of key equality and prefix'),
 ('allocation',text.replace("    // Plain's key is the IV, the same for every plain hasher.",allocation),['--test','allocations','-E','test(held_allocations_ignore_key_equality_and_prefixes)'],'allocation work independent of key equality and prefix'),
 ('kernel',text.replace('    let platform = turn.platform();',platform),['--lib','-E','test(held_dispatch_ignores_key_equality_and_prefixes)'],'dispatch work independent of key equality and prefix')]
for name,value,args,message in controls:
 new=r/f'tmp/{name}.txt';new.write_text(value)
 with (r/f'out/{name}-diff.log').open('w')as f:subprocess.run(['replace','-f',str(p),str(old),str(new)],check=True,stdout=f)
 try:
  with (r/f'out/{name}-red.log').open('w')as f:status=subprocess.run(['timeout','-k','5s','120s','cargo','nextest','run','--release','--features','serde,zeroize']+args,stdout=f,stderr=subprocess.STDOUT).returncode
  log=(r/f'out/{name}-red.log').read_text();assert status==100,(name,status);assert message in log,(name,log[-2000:])
 finally:
  with (r/f'out/{name}-restore.log').open('w')as f:subprocess.run(['replace','-f',str(p),str(new),str(old)],check=True,stdout=f)
 assert p.read_bytes()==original
 print(name+' control rejected; byte-exact source restored')
PY
timeout -k 5s 120s cargo nextest run --release --features serde,zeroize --lib --test allocations -E 'test(held_dispatch_ignores_key_equality_and_prefixes) | test(held_allocations_ignore_key_equality_and_prefixes) | test(allocation_counter_sees_a_callers_allocation)' > "$R/out/restored.log" 2>&1
git status --porcelain > "$R/out/final-git-status.txt"
test ! -s "$R/out/final-git-status.txt"
printf 'safety-source prefix/cohort/allocation and rejecting controls passed\n' > "$R/out/status.txt"
JOB
