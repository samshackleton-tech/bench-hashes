#!/bin/bash
set -euo pipefail
exec timeout -k 5s 570s bash -s -- "$1" <<'JOB'
set -euo pipefail
R="$1"
mkdir -p "$R/out" "$R/tmp"
export HOME=/root
. /root/.cargo/env
export CARGO_TARGET_DIR="$R/target" TMPDIR="$R/tmp" PYTHONUNBUFFERED=1
cd "$R/fork"
BASE="$(git -C "$R/base" rev-parse HEAD)"
NEW="$(git rev-parse HEAD)"
git merge-base --is-ancestor "$BASE" HEAD
git fetch --no-tags "$R/base" "$BASE" > "$R/out/base-object.log" 2>&1
{ echo "library $NEW"; echo "base $BASE"; uname -m; rustc -Vv; } > "$R/out/identity.txt"
git diff "$BASE" -- src/each.rs > "$R/out/change.diff"
test -z "$(git diff "$BASE" -- c tools/gen_x86.py tools/gen_x86_chunk_root.py tools/verify build.rs Cargo.toml Cargo.lock)"
timeout -k 5s 180s cargo nextest run --release --features serde,zeroize --lib --tests --no-fail-fast > "$R/out/tests.log" 2>&1
timeout -k 5s 60s cargo test --release --doc --features serde,zeroize > "$R/out/docs.log" 2>&1
timeout -k 5s 30s cargo fmt --all -- --check > "$R/out/fmt.log" 2>&1
timeout -k 5s 60s cargo build --release --no-default-features > "$R/out/no-default.log" 2>&1
RUSTDOCFLAGS='-D warnings' timeout -k 5s 60s cargo doc --no-deps --features serde,zeroize > "$R/out/rustdoc.log" 2>&1
# The test-only parent has both new controls with the original runtime.
# Never execute malformed tasks or invalid memory accesses in a control.
python3 - "$R" <<'PY'
from pathlib import Path
import subprocess,sys
r=Path(sys.argv[1]); p=Path('src/each.rs'); original=p.read_bytes()
old=r/'tmp/source-current.txt'; new=r/'tmp/source-test-only.txt'
old.write_bytes(original)
new.write_bytes(subprocess.check_output(['git','show','HEAD^:src/each.rs']))
assert original != new.read_bytes()
subprocess.run(['replace','-f',str(p),str(old),str(new)],check=True,stdout=(r/'out/control-diff.log').open('w'))
try:
    with (r/'out/control-red.log').open('w') as f:
        status=subprocess.run(['timeout','-k','5s','120s','cargo','nextest','run','--release','--features','serde,zeroize','--lib','--no-fail-fast','-E','test(held_passes_do_not_depend_on_keys) | test(test_held_key_groups_take_one_partition_pass)'],stdout=f,stderr=subprocess.STDOUT).returncode
    log=(r/'out/control-red.log').read_text()
    assert status==100,status
    assert 'key-independent passes:' in log or 'independent parent entry:' in log,log[-2000:]
finally:
    subprocess.run(['replace','-f',str(p),str(new),str(old)],check=True,stdout=(r/'out/control-restore-diff.log').open('w'))
assert p.read_bytes()==original
print('original key-dependent routing rejected; exact source restored')
PY
timeout -k 5s 120s cargo nextest run --release --features serde,zeroize --lib -E 'test(held_passes_do_not_depend_on_keys) | test(test_held_key_groups_take_one_partition_pass)' > "$R/out/control-restored.log" 2>&1
test -z "$(git status --porcelain)"
printf 'independent-key native and controls passed\n' > "$R/out/native-status.txt"
if [ "$(uname -m)" = x86_64 ]; then
 CARGO_TARGET_DIR="$R/mutator-target" cargo install --locked --path "$R/mutator" --root "$R/mutator-install" > "$R/out/install-mutator.log" 2>&1
 export PATH="$R/mutator-install/bin:$PATH"
 test "$(cargo mutants --version)" = 'cargo-mutants 27.1.0'
 CARGO_TARGET_DIR="$R/b3sum-target" cargo install --locked --version '=1.8.7' b3sum --root "$R/target/b3sum-official-1.8.7" > "$R/out/install-b3sum.log" 2>&1
 set +e
 timeout -k 5s 240s python3 tools/mutants/check.py --since "$BASE" > "$R/out/mutation.log" 2>&1
 status=$?
 set -e
 echo "$status" > "$R/out/mutation-exit.txt"
 test "$status" = 0
 grep -q 'no new survivor' "$R/out/mutation.log"
fi
git status --porcelain > "$R/out/final-git-status.txt"
printf 'independent-key quality done\n' > "$R/out/status.txt"
JOB
