#!/bin/bash
set -euo pipefail
exec timeout -k 5s 600s bash -s -- "$1" <<'JOB'
set -euo pipefail
R="$1"
mkdir -p "$R/out" "$R/tmp"
export HOME=/root
. /root/.cargo/env
export CARGO_TARGET_DIR="$R/target"
export TMPDIR="$R/tmp"
export PYTHONUNBUFFERED=1
BASE=fd048373c8e5cb814ef9fc302709a75a96650a05
TOOL=8ab1dc786a1f61a4e370416cc6c68b81a704e917
cd "$R/fork"
NEW="$(git rev-parse HEAD)"
test "$(git rev-parse HEAD^)" = "$BASE"
git fetch --no-tags "$R/base" "$BASE" > "$R/out/base-object.log" 2>&1
{ echo "library $NEW";echo "base $BASE";echo "mutator $TOOL";uname -m;rustc -Vv;} > "$R/out/identity.txt"
timeout -k 5s 180s cargo nextest run --release --features serde,zeroize --lib --tests --no-fail-fast > "$R/out/tests.log" 2>&1
timeout -k 5s 60s cargo test --release --doc --features serde,zeroize > "$R/out/docs.log" 2>&1
timeout -k 5s 30s cargo fmt --all -- --check > "$R/out/fmt.log" 2>&1
timeout -k 5s 60s cargo build --release --no-default-features > "$R/out/no-default.log" 2>&1
RUSTDOCFLAGS='-D warnings' timeout -k 5s 60s cargo doc --no-deps --features serde,zeroize > "$R/out/rustdoc.log" 2>&1
# Control: the old key-equality partition restored, the new test fails.
python3 - "$R/out" <<'PY'
from pathlib import Path
import subprocess,sys
out=Path(sys.argv[1]);p=Path('src/each.rs');original=p.read_bytes()
new='if plain(first) { held.iter().partition(|&&i| plain(i)) } else { (vec![first], held[1..].to_vec()) };'
old='held.iter().partition(|&&i| hashers[i].core.key == key && hashers[i].core.chunk_state.flags == flags);'
assert original.decode().count(new)==1
subprocess.run(['replace',str(p),new,old],check=True,stdout=(out/'control-edit.log').open('w'))
try:
    with (out/'control-red.log').open('w')as f:
        r=subprocess.run(['timeout','-k','5s','120s','cargo','nextest','run','--release','--features','serde,zeroize','--lib','-E','test(held_groups_pass_by_mode_not_key)'],stdout=f,stderr=subprocess.STDOUT)
    log=(out/'control-red.log').read_text()
    assert r.returncode==100,r.returncode
    assert 'equal keys take the passes distinct keys take' in log
finally:
    subprocess.run(['replace',str(p),old,new],check=True,stdout=(out/'control-restore.log').open('w'))
    assert p.read_bytes()==original
print('old key-equality grouping fails the pass-count test; source restored')
PY
test -z "$(git status --porcelain)"
CARGO_TARGET_DIR="$R/mutator-target" cargo install --locked --path "$R/mutator" --root "$R/mutator-install" > "$R/out/install-mutator.log" 2>&1
export PATH="$R/mutator-install/bin:$PATH"
test "$(cargo mutants --version)" = 'cargo-mutants 27.1.0'
CARGO_TARGET_DIR="$R/b3sum-target" cargo install --locked --version '=1.8.7' b3sum --root "$R/target/b3sum-official-1.8.7" > "$R/out/install-b3sum.log" 2>&1
set +e
timeout -k 5s 240s python3 tools/mutants/check.py --since "$BASE" > "$R/out/mutation.log" 2>&1
status=$?
set -e
echo "$status" > "$R/out/mutation-exit.txt"
git status --porcelain > "$R/out/final-git-status.txt"
test "$status" = 0
grep -q 'no new survivor' "$R/out/mutation.log"
printf 'fix312 Ice native, control and mutation passed\n' > "$R/out/status.txt"
JOB
