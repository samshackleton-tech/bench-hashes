#!/bin/bash
set -euo pipefail
exec timeout -k 5s 900s bash -s -- "$1" <<'JOB'
set -euo pipefail
R="$1";mkdir -p "$R/out" "$R/tmp"
export HOME=/root
. /root/.cargo/env
export CARGO_TARGET_DIR="$R/target" TMPDIR="$R/tmp" PYTHONUNBUFFERED=1
cd "$R/library"
BASE="$(git -C "$R/base" rev-parse HEAD)"
git fetch --no-tags "$R/base" "$BASE" > "$R/out/base-object.log" 2>&1
git merge-base --is-ancestor "$BASE" HEAD
{ echo "library $(git rev-parse HEAD)";echo "baseline $BASE";uname -m;rustc -Vv; } > "$R/out/identity.txt"
git diff "$BASE" > "$R/out/integration.diff"
# One clean-source predicate, exercised before the expensive run and used
# again at its end. Only the mutator's two exact scratch producers are exempt.
cat > "$R/source-status.py" <<'AUDIT'
from pathlib import Path
import re, subprocess, sys, tempfile

def git(root, *args):
    return subprocess.check_output(['git', '-C', str(root), *args])

def clean(root):
    for args in [('diff', '--exit-code'), ('diff', '--cached', '--exit-code')]:
        p = subprocess.run(['git', '-C', str(root), *args], capture_output=True)
        assert p.returncode == 0, 'tracked/index change: ' + p.stdout.decode(errors='replace')
    unexpected, generated = [], []
    for raw in git(root, 'ls-files', '--others', '--exclude-standard', '-z').split(b'\0'):
        if not raw: continue
        path = raw.decode()
        if path.startswith('tmp/mutants-last/') or re.fullmatch(r'tmp/mutants-diff-[a-z0-9_]{8}/change\.diff', path):
            generated.append(path)
        else:
            unexpected.append(path)
    assert not unexpected, 'unexpected untracked files: ' + repr(unexpected)
    return generated

def controls():
    with tempfile.TemporaryDirectory() as directory:
        r = Path(directory)
        git(r, 'init', '-q')
        paths = [r/'source.rs', r/'tmp/mutants-last/tracked.txt']
        for p in paths:
            p.parent.mkdir(parents=True, exist_ok=True); p.write_text('original\n')
        git(r, 'add', '.')
        git(r, '-c', 'core.hooksPath=/dev/null', '-c', 'user.name=Audit', '-c', 'user.email=audit@example.invalid', 'commit', '-qm', 'fixture')
        assert clean(r) == []
        generated = [r/'tmp/mutants-last/run/shard/outcomes.json', r/'tmp/mutants-diff-abcdefgh/change.diff']
        for p in generated:
            p.parent.mkdir(parents=True, exist_ok=True); p.write_text('diagnostic\n')
        assert set(clean(r)) == {str(p.relative_to(r)) for p in generated}
        def rejected(label):
            try: clean(r)
            except AssertionError: print(label + ': rejected')
            else: raise AssertionError(label + ' escaped the clean-source check')
        for p in paths:
            p.write_text('changed\n'); rejected('dirty tracked ' + str(p.relative_to(r))); p.write_text('original\n')
            p.write_text('staged\n'); git(r, 'add', str(p.relative_to(r))); p.write_text('original\n')
            rejected('dirty index ' + str(p.relative_to(r))); git(r, 'reset', '-q', 'HEAD', '--', str(p.relative_to(r)))
        for name in ['unexpected.rs', 'tmp/other.txt', 'tmp/mutants-diff-abcdefgh/unexpected.rs']:
            p = r/name; p.parent.mkdir(parents=True, exist_ok=True); p.write_text('unexpected\n')
            rejected(name); p.unlink()
        assert len(clean(r)) == 2
        print('clean-source predicate: positive/restored and seven rejecting controls passed')

if sys.argv[1] == '--self-test': controls()
else:
    for path in clean(Path(sys.argv[1])): print('generated: ' + path)
    print('tracked source/index unchanged; only known mutator diagnostics untracked')
AUDIT
python3 "$R/source-status.py" --self-test > "$R/out/source-status-controls.log" 2>&1
python3 "$R/source-status.py" "$R/library" > "$R/out/initial-source-status.txt"
# This port leaves the ownership/protocol, core, API and first-chunk paths alone.
test -z "$(git diff "$BASE" -- src/lanes.rs src/stream.rs src/incremental.rs src/hasher.rs src/lib.rs Cargo.toml Cargo.lock)"
timeout -k 5s 180s cargo nextest run --release --features serde,zeroize --lib --tests --no-fail-fast > "$R/out/tests.log" 2>&1
grep -q 'test_self_test_run_checks_every_case' "$R/out/tests.log"
timeout -k 5s 60s cargo test --release --doc --features serde,zeroize > "$R/out/docs.log" 2>&1
timeout -k 5s 30s cargo fmt --all -- --check > "$R/out/fmt.log" 2>&1
timeout -k 5s 60s cargo build --release --no-default-features > "$R/out/no-default.log" 2>&1
RUSTDOCFLAGS='-D warnings' timeout -k 5s 60s cargo doc --no-deps --features serde,zeroize > "$R/out/rustdoc.log" 2>&1
python3 - "$R" <<'PY'
from pathlib import Path
import subprocess,sys
r=Path(sys.argv[1]);each=Path('src/each.rs');ffi=Path('src/ffi_output.rs');e=each.read_bytes();f=ffi.read_bytes()
def changed(source,old,new):
 assert source.count(old)==1,(old,source.count(old))
 return source.replace(old,new)
def function(source,name):
 a=source.index('fn '+name+'(');b=source.index('\n}',a)+2
 return source[a:b]
needle='if held.iter().all(|&i| hashers[i].core.chunk_state.flags == 0) {'
shared=needle[:-2]+' || held.iter().all(|&i| hashers[i].core.key == hashers[_first].core.key && hashers[i].core.chunk_state.flags == hashers[_first].core.chunk_state.flags) {'
first='    let Some(&_first) = held.first() else { return };'
allocation=first+'\n    if hashers[_first].core.key[7] != 0x6d6d6d6d { std::hint::black_box(vec![0u8; 32]); }'
width='    let width = lanes(platform);\n    debug_assert!(!held.is_empty() && width != 0);'
secret_platform='    let platform = if matches!(platform, Platform::AVX512) && hashers[held[0]].core.key[7] != 0x6d6d6d6d { Platform::AVX2 } else { platform };\n'+width
base=subprocess.check_output(['git','-C',str(r/'base'),'show','HEAD:src/each.rs']).decode()
reference=subprocess.check_output(['git','-C',str(r/'reference'),'show','HEAD:src/ffi_output.rs']).decode()
wide='        unsafe { hash_on_platform(platform, inputs, out) };'
eight='            unsafe { hash_eight_groups(inputs, out) };'
controls=[
 ('grouping',each,e,changed(e.decode(),needle,shared),['--lib','-E','test(held_dispatch_ignores_key_equality_and_prefixes)'],'dispatch work independent of key equality and prefix'),
 ('allocation',each,e,changed(e.decode(),first,allocation),['--test','allocations','-E','test(grouped_cycles_reuse_storage_for_every_key_prefix)'],'prepared grouped cycles:'),
 ('kernel',ffi,f,changed(f.decode(),width,secret_platform),['--lib','-E','test(held_dispatch_ignores_key_equality_and_prefixes)'],'dispatch work independent of key equality and prefix'),
 ('singleton',each,e,changed(e.decode(),function(e.decode(),'hash_held'),function(base,'hash_held')),['--lib','-E','test(held_passes_do_not_depend_on_keys)'],'key-independent passes:'),
 ('heap-backend',ffi,f,changed(f.decode(),'pub(crate) '+function(f.decode(),'held_groups'),'pub(crate) '+function(reference,'held_groups')),['--test','allocations','-E','test(grouped_cycles_reuse_storage_for_every_key_prefix)'],'prepared grouped cycles:'),
 ('startup-wide',ffi,f,changed(f.decode(),wide,wide+' out[0][0] ^= 1;'),['--lib','-E','test(test_self_test_run_checks_every_case)'],'startup self-test failed'),
 ('startup-eight',ffi,f,changed(f.decode(),eight,eight+' out[0][0] ^= 1;'),['--lib','-E','test(test_self_test_run_checks_every_case)'],'startup self-test failed'),
 ('wrong-row',ffi,f,changed(f.decode(),'block: level.as_flattened()[j * BLOCK_LEN..(j + 1) * BLOCK_LEN].try_into().unwrap(),','block: level.as_flattened()[(j % per_message) * BLOCK_LEN..(j % per_message + 1) * BLOCK_LEN].try_into().unwrap(),'),['--lib','-E','test(held_workspace_preserves_distinct_message_rows)'],'n=2 flavor=1 row=1'),
 ('missing-swap',ffi,f,changed(f.decode(),'core::mem::swap(&mut level, &mut next);','// planted: parent levels not exchanged'),['--lib','-E','test(held_workspace_preserves_distinct_message_rows)'],'n=2 flavor=1 row=0'),
]
for name,p,original,value,args,message in controls:
 old=r/f'tmp/{name}-old.txt';new=r/f'tmp/{name}-new.txt';old.write_bytes(original);new.write_text(value)
 with (r/f'out/{name}-diff.log').open('w')as log:subprocess.run(['replace','-f',str(p),str(old),str(new)],check=True,stdout=log)
 try:
  with (r/f'out/{name}-red.log').open('w')as log:s=subprocess.run(['timeout','-k','5s','120s','cargo','nextest','run','--release','--features','serde,zeroize']+args,stdout=log,stderr=subprocess.STDOUT).returncode
  log=(r/f'out/{name}-red.log').read_text();assert s==100,(name,s);assert message in log,(name,log[-2000:])
 finally:
  with (r/f'out/{name}-restore.log').open('w')as log:subprocess.run(['replace','-f',str(p),str(new),str(old)],check=True,stdout=log)
 assert p.read_bytes()==original
 print(name+' rejected; byte-exact source restored')
assert each.read_bytes()==e and ffi.read_bytes()==f
PY
timeout -k 5s 120s cargo nextest run --release --features serde,zeroize --lib --test allocations -E 'test(held_dispatch_ignores_key_equality_and_prefixes) | test(grouped_cycles_reuse_storage_for_every_key_prefix) | test(grouped_fragmentation_reuses_storage_at_table_boundaries) | test(held_passes_do_not_depend_on_keys) | test(test_held_key_groups_take_one_partition_pass) | test(test_self_test_run_checks_every_case) | test(held_workspace_preserves_distinct_message_rows)' > "$R/out/restored.log" 2>&1
printf 'inplace independent suites and nine rejecting controls passed\n' > "$R/out/native-status.txt"
CARGO_TARGET_DIR="$R/mutator-target" timeout -k 5s 240s cargo install --locked --path "$R/mutator" --root "$R/mutator-install" > "$R/out/install-mutator.log" 2>&1
export PATH="$R/mutator-install/bin:$PATH"
test "$(cargo mutants --version)" = 'cargo-mutants 27.1.0'
CARGO_TARGET_DIR="$R/b3sum-target" timeout -k 5s 120s cargo install --locked --version '=1.8.7' b3sum --root "$R/target/b3sum-official-1.8.7" > "$R/out/install-b3sum.log" 2>&1
set +e
timeout -k 5s 240s python3 tools/mutants/check.py --since "$BASE" > "$R/out/mutation.log" 2>&1
s=$?
set -e
echo "$s" > "$R/out/mutation-exit.txt"
python3 - "$R" <<'PY'
from pathlib import Path
import shutil,sys
r=Path(sys.argv[1]);source=r/'library/tmp/mutants-last'
if source.exists():shutil.copytree(source,r/'out/mutants-last')
PY
git status --porcelain > "$R/out/final-git-status.txt"
test "$s" = 0
grep -q 'no new survivor' "$R/out/mutation.log"
python3 "$R/source-status.py" "$R/library" > "$R/out/final-source-status.txt"
printf 'inplace independent quality complete\n' > "$R/out/status.txt"
JOB
