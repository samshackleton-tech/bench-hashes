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
# This port leaves the ownership/protocol, core, API and first-chunk paths alone.
test -z "$(git diff "$BASE" -- src/lanes.rs src/stream.rs src/incremental.rs src/hasher.rs src/lib.rs Cargo.toml Cargo.lock)"
timeout -k 5s 180s cargo nextest run --release --features serde,zeroize --lib --tests --no-fail-fast > "$R/out/tests.log" 2>&1
timeout -k 5s 60s cargo test --release --doc --features serde,zeroize > "$R/out/docs.log" 2>&1
timeout -k 5s 30s cargo fmt --all -- --check > "$R/out/fmt.log" 2>&1
timeout -k 5s 60s cargo build --release --no-default-features > "$R/out/no-default.log" 2>&1
RUSTDOCFLAGS='-D warnings' timeout -k 5s 60s cargo doc --no-deps --features serde,zeroize > "$R/out/rustdoc.log" 2>&1
python3 - "$R" <<'PY'
from pathlib import Path
import subprocess,sys
r=Path(sys.argv[1]);each=Path('src/each.rs');ffi=Path('src/ffi_output.rs');e=each.read_bytes();f=ffi.read_bytes()
needle='if held.iter().all(|&i| hashers[i].core.chunk_state.flags == 0) {'
assert e.decode().count(needle)==1
shared=needle[:-2]+' || held.iter().all(|&i| hashers[i].core.key == hashers[_first].core.key && hashers[i].core.chunk_state.flags == hashers[_first].core.chunk_state.flags) {'
first='    let Some(&_first) = held.first() else { return };'
assert e.decode().count(first)==1
allocation=first+'\n    if hashers[_first].core.key[7] != 0x6d6d6d6d { std::hint::black_box(vec![0u8; 32]); }'
width='    let width = lanes(platform);'
assert f.decode().count(width)==1
secret_platform='    let platform = if matches!(platform, Platform::AVX512) && hashers[held[0]].core.key[7] != 0x6d6d6d6d { Platform::AVX2 } else { platform };\n'+width
base=subprocess.check_output(['git','-C',str(r/'base'),'show','HEAD:src/each.rs']).decode()
bs=base.index('/// Hash the whole groups `held` names');be=base.index('/// Hash one nonempty cohort',bs)
es=e.decode().index('/// Hash held stages with an independent key');ee=e.decode().index('/// Hash one nonempty cohort',es)
controls=[
 ('grouping',each,e,e.decode().replace(needle,shared),['--lib','-E','test(held_dispatch_ignores_key_equality_and_prefixes)'],'dispatch work independent of key equality and prefix'),
 ('allocation',each,e,e.decode().replace(first,allocation),['--test','allocations','-E','test(held_allocations_ignore_key_equality_and_prefixes)'],'allocation work independent of key equality and prefix'),
 ('kernel',ffi,f,f.decode().replace(width,secret_platform),['--lib','-E','test(held_dispatch_ignores_key_equality_and_prefixes)'],'dispatch work independent of key equality and prefix'),
 ('singleton',each,e,e.decode()[:es]+base[bs:be]+e.decode()[ee:],['--lib','-E','test(held_passes_do_not_depend_on_keys)'],'key-independent passes:'),
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
timeout -k 5s 120s cargo nextest run --release --features serde,zeroize --lib --test allocations -E 'test(held_dispatch_ignores_key_equality_and_prefixes) | test(held_allocations_ignore_key_equality_and_prefixes) | test(held_passes_do_not_depend_on_keys) | test(test_held_key_groups_take_one_partition_pass)' > "$R/out/restored.log" 2>&1
printf 'integrated native suites and four rejecting controls passed\n' > "$R/out/native-status.txt"
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
test ! -s "$R/out/final-git-status.txt"
printf 'independent next quality complete\n' > "$R/out/status.txt"
JOB
