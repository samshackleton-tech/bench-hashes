#!/bin/bash
set -euo pipefail
# Preparation is locked by pinned-run. Bound the entire executing driver,
# including compilation, independently of the mutator's own test backstops.
exec timeout -k 5s 525s bash -s -- "$1" <<'JOB'
set -euo pipefail
R="$1"
mkdir -p "$R/out" "$R/tmp"
export HOME=/root
. /root/.cargo/env
export CARGO_TARGET_DIR="$R/target"
export TMPDIR="$R/tmp"
export PYTHONUNBUFFERED=1
BASE=fbfb319f3414ac7fac4b3d4bce266488a1fdee3b
NEW="$(git -C "$R/fork" rev-parse HEAD)"
TOOL=8ab1dc786a1f61a4e370416cc6c68b81a704e917
cd "$R/fork"
test "$(git rev-parse HEAD)" = "$NEW"
# The owner's exact source, or a child of it changing the x86 registry and
# the allocation test's counter alone.
EXACT=88e215ed79065823a9dadd48fb0a0f4150743989
git merge-base --is-ancestor "$EXACT" "$NEW"
git diff --exit-code "$EXACT" HEAD -- . ':!tools/mutants/known-x86_64.txt' ':!tests/allocations.rs' > "$R/out/registry-only-child.diff"
git diff --stat "$EXACT" HEAD > "$R/out/child-change.txt"
test "$(git -C "$R/base" rev-parse HEAD)" = "$BASE"
test "$(git -C "$R/mutator" rev-parse HEAD)" = "$TOOL"
git fetch --no-tags "$R/base" "$BASE" > "$R/out/base-object.log" 2>&1
test -z "$(git status --porcelain)"
{
    echo "library $NEW"
    echo "base $BASE"
    echo "mutator $TOOL"
    uname -m
    rustc -Vv
} > "$R/out/identity.txt"
# The change leaves generators, assembly and build bindings untouched.
git diff --exit-code "$BASE" HEAD -- c tools/verify tools/gen* build.rs Cargo.toml Cargo.lock > "$R/out/unchanged-kernel-inputs.diff"
timeout -k 5s 180s cargo nextest run --release --features serde,zeroize --lib --tests --no-fail-fast > "$R/out/tests.log" 2>&1
timeout -k 5s 60s cargo test --release --doc --features serde,zeroize > "$R/out/docs.log" 2>&1
timeout -k 5s 30s cargo fmt --all -- --check > "$R/out/fmt.log" 2>&1
timeout -k 5s 60s cargo build --release --no-default-features > "$R/out/no-default.log" 2>&1
RUSTDOCFLAGS='-D warnings' timeout -k 5s 60s cargo doc --no-deps --features serde,zeroize > "$R/out/rustdoc.log" 2>&1
# Fault only the unregistered-source test's delayed-copy boundary. Its
# channels release the worker on failure; dummy payloads are never run.
python3 - "$R/out" <<'PY'
from pathlib import Path
import subprocess,sys
out=Path(sys.argv[1]);p=Path('src/lanes.rs');original=p.read_bytes()
old='if slot.next.load(Ordering::Acquire) != p {'
new='if false { // deterministic old-reuse-boundary control'
assert original.decode().count(old)==1
subprocess.run(['replace',str(p),old,new],check=True,stdout=(out/'control-edit.log').open('w'))
try:
    with (out/'control-red.log').open('w')as f:
        result=subprocess.run(['timeout','-k','5s','60s','cargo','nextest','run','--release','--features','serde,zeroize','--lib','-E','test(ring_reuse_waits_for_the_claimed_task_copy)'],stdout=f,stderr=subprocess.STDOUT)
    assert result.returncode==100,result.returncode
    assert 'publication waits until the old task is copied' in (out/'control-red.log').read_text()
finally:
    subprocess.run(['replace',str(p),new,old],check=True,stdout=(out/'control-restore.log').open('w'))
    assert p.read_bytes()==original
with (out/'control-restored.log').open('w')as f:
    subprocess.run(['timeout','-k','5s','60s','cargo','nextest','run','--release','--features','serde,zeroize','--lib','-E','test(ring_reuse_waits_for_the_claimed_task_copy) | test(ring_slots_advance_after_every_copy)'],check=True,stdout=f,stderr=subprocess.STDOUT)
print('old reuse boundary rejected; exact candidate restored and positive controls pass')
PY
test -z "$(git status --porcelain)"
# Official source-pinned tool, as in the earlier owner-requested gate.
CARGO_TARGET_DIR="$R/mutator-target" cargo install --locked --path "$R/mutator" --root "$R/mutator-install" > "$R/out/install-mutator.log" 2>&1
export PATH="$R/mutator-install/bin:$PATH"
test "$(cargo mutants --version)" = 'cargo-mutants 27.1.0'
B3SUM="$R/target/b3sum-official-1.8.7/bin/b3sum"
CARGO_TARGET_DIR="$R/b3sum-target" cargo install --locked --version '=1.8.7' b3sum --root "$R/target/b3sum-official-1.8.7" > "$R/out/install-b3sum.log" 2>&1
test "$("$B3SUM" --version)" = 'b3sum 1.8.7'
{
    cargo mutants --version
    sha256sum "$(command -v cargo-mutants)"
    "$B3SUM" "$(command -v cargo-mutants)"
} >> "$R/out/identity.txt"
set +e
timeout -k 5s 240s python3 tools/mutants/check.py --since "$BASE" > "$R/out/mutation.log" 2>&1
status=$?
set -e
printf '%s\n' "$status" > "$R/out/mutation-exit.txt"
git status --porcelain > "$R/out/final-git-status.txt"
git diff > "$R/out/final-metadata.diff"
python3 - "$R" <<'PY'
from pathlib import Path
import shutil,sys,json
r=Path(sys.argv[1]);out=r/'out';omitted=[];roots=[]
p=r/'fork/tmp/mutants-last'
if p.exists():roots.append((p,'mutants-last'))
for p in (r/'tmp').glob('blake3-servil-mutants/**/mutants.out'):
    roots.append((p,'uncollected/'+p.parent.parent.name))
for source,label in roots:
    for p in source.rglob('*'):
        if not p.is_file()or p.is_symlink():continue
        rel=p.relative_to(source)
        if p.stat().st_size>=20_000_000:omitted.append(label+'/'+str(rel));continue
        with p.open('rb')as f:magic=f.read(8)
        if magic.startswith((b'\x7fELF',b'MZ'))or magic==b'!<arch>\n':omitted.append(label+'/'+str(rel));continue
        q=out/label/rel;q.parent.mkdir(parents=True,exist_ok=True);shutil.copyfile(p,q)
(out/'omissions.json').write_text(json.dumps(omitted,indent=2)+'\n')
PY
test "$status" = 0
python3 - "$R/out/mutation.log" "$NEW" <<'PY'
from pathlib import Path
import re,sys
s=Path(sys.argv[1]).read_text()
assert 'mutants: BLAKE3-Servil at '+sys.argv[2] in s
assert 'with uncommitted changes' not in s
m=re.search(r"mutants: the change's (\d+) mutants on",s);assert m and int(m[1])>0
assert 'no new survivor' in s
PY
printf 'ring exact-source Ice native and mutation closure passed\n' > "$R/out/status.txt"
JOB
