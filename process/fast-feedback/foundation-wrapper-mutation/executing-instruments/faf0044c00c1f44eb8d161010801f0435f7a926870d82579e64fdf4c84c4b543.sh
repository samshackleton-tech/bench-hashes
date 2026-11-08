#!/bin/bash
set -euo pipefail
R="$1";mkdir -p "$R/out" "$R/tmp"
export HOME=/root
. /root/.cargo/env
export CARGO_TARGET_DIR="$R/target"
export TMPDIR="$R/tmp"
export PYTHONUNBUFFERED=1
cd "$R/fork"
BASE=7ee5c1f8cfad7937fb490e6510f8f36fe5ce912f
NEW=f16ee3829554fd66ef47c5b60e516c6be9d86a44
test "$(git rev-parse HEAD)" = "$NEW"
test "$(git -C "$R/base" rev-parse HEAD)" = "$BASE"
git fetch --no-tags "$R/base" "$BASE" > "$R/out/base-object.log" 2>&1
test -z "$(git status --porcelain --untracked-files=no)"
# Match tools/runner/setup-mac.sh: official cargo-mutants27.1.0, source-pinned.
test "$(git -C "$R/mutator" rev-parse HEAD)" = 8ab1dc786a1f61a4e370416cc6c68b81a704e917
CARGO_TARGET_DIR="$R/mutator-target" cargo install --locked --path "$R/mutator" --root "$R/mutator-install" > "$R/out/install-tool.log" 2>&1
export PATH="$R/mutator-install/bin:$PATH"
test "$(cargo mutants --version)" = 'cargo-mutants 27.1.0'
# Reuse check.py's own official_b3sum location; Ice has no PATH b3sum.
B3SUM="$R/target/b3sum-official-1.8.7/bin/b3sum"
CARGO_TARGET_DIR="$R/b3sum-target" cargo install --locked --version '=1.8.7' b3sum --root "$R/target/b3sum-official-1.8.7" > "$R/out/install-b3sum.log" 2>&1
test "$("$B3SUM" --version)" = 'b3sum 1.8.7'
{
    echo "library $NEW"
    echo "base $BASE"
    echo 'mutator 8ab1dc786a1f61a4e370416cc6c68b81a704e917'
    uname -m
    rustc -Vv
    cargo mutants --version
    command -v cargo-mutants
    sha256sum "$(command -v cargo-mutants)"
    "$B3SUM" --version
    "$B3SUM" "$(command -v cargo-mutants)"
} > "$R/out/identity.txt"
# Check the requested new wrapper is in the exact x86 registry and nonempty plan.
python3 - <<'PY'
from pathlib import Path
s=Path('tools/mutants/known-x86_64.txt').read_text()
assert 'src/ffi_output.rs' in next(l for l in s.splitlines()if l.startswith('files:')).split()
PY
cargo mutants --list --profile mutants --features serde,zeroize --file src/ffi_output.rs > "$R/out/wrapper-plan.txt" 2> "$R/out/wrapper-plan.err"
python3 - "$R/out/wrapper-plan.txt" <<'PY'
from pathlib import Path
import sys
s=Path(sys.argv[1]).read_text();rows=[l for l in s.splitlines()if l.startswith('src/ffi_output.rs:')]
assert rows,'new Rust wrapper plan is empty'
print(f'expanded Rust wrapper plan: {len(rows)} places')
PY
set +e
timeout -k 15s 14400s python3 tools/mutants/check.py --since "$BASE" > "$R/out/mutation.log" 2>&1
status=$?
set -e
printf '%s\n' "$status" > "$R/out/exit-status.txt"
git status --porcelain > "$R/out/final-git-status.txt"
git diff > "$R/out/final-metadata.diff"
python3 - "$R" <<'PY'
from pathlib import Path
import shutil,sys,json
r=Path(sys.argv[1]);out=r/'out';omitted=[]
roots=[]
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
python3 - "$R/out/mutation.log" <<'PY'
from pathlib import Path
import re,sys
s=Path(sys.argv[1]).read_text()
assert 'mutants: BLAKE3-Servil at f16ee3829554fd66ef47c5b60e516c6be9d86a44' in s
assert 'with uncommitted changes' not in s
m=re.search(r"mutants: the change's (\d+) mutants on",s);assert m and int(m[1])>0
assert 'no new survivor' in s
PY
printf 'expanded foundation Rust mutation gate passed\n' > "$R/out/status.txt"
