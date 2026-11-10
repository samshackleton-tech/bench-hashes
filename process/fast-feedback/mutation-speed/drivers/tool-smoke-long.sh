#!/bin/bash
set -euo pipefail
# The aarch64 VM is slow: its first smoke call alone took five minutes, and the 540 s limit cut the second.
exec timeout -k 15s 1500s bash -s -- "$1" <<'MUTATION_TOOL_SMOKE'
set -euo pipefail
R="$1"; O="$R/out"; mkdir -p "$O"; . <home>/.cargo/env
export CARGO_TARGET_DIR="$R/target" TMPDIR="$R/private-tmp"
mkdir -p "$TMPDIR"
{ for name in library mutator;do printf '%s %s\n' "$name" "$(git -C "$R/$name" rev-parse HEAD)";done;rustc -Vv;cargo -V;uname -a; } > "$O/identity.txt"
CARGO_TARGET_DIR="$R/mutator-target" cargo install --locked --path "$R/mutator" --root "$R/mutator-install" > "$O/install-mutator.log" 2>&1
export PATH="$R/mutator-install/bin:$PATH"
test "$(cargo mutants --version)" = 'cargo-mutants 27.1.0'
CARGO_TARGET_DIR="$R/b3sum-target" cargo install --locked --version '=1.8.7' b3sum --root "$R/target/b3sum-official-1.8.7" > "$O/install-b3sum.log" 2>&1
export MUTANTS_B3SUM="$R/target/b3sum-official-1.8.7/bin/b3sum"
cd "$R/library"
cargo fetch > "$O/fetch.log" 2>&1
python3 -m unittest discover -s tools/mutants -p 'test_*.py' > "$O/unit.log" 2>&1
# Execute the repository's actual integration smoke. The observer only saves
# each completed call before smoke.py replaces its normal last-run artifacts.
python3 - "$R" > "$O/smoke.log" 2>&1 <<'SMOKE_OBSERVER_PY'
from pathlib import Path
import json,runpy,shutil,sys
r=Path(sys.argv[1]);lib=r/'library';out=r/'out'
sys.path.insert(0,str(lib/'tools/mutants'))
import check
original=check.run
calls=[]
def observed(*args,**kwargs):
 result=original(*args,**kwargs)
 dest=out/f'smoke-call-{len(calls)+1}';dest.mkdir()
 shutil.copytree(lib/'tmp/mutants-last',dest/'mutants-last')
 for p in (r/'target/mutants').glob('model-only-targets.*'):shutil.copy2(p,dest/p.name)
 calls.append(dict(arguments=list(args),keywords=kwargs,survivors=dict(result[0]),timeouts=dict(result[2])))
 (out/'smoke-calls.json').write_text(json.dumps(calls,indent=2)+'\n')
 return result
check.run=observed
runpy.run_path(str(lib/'tools/mutants/smoke.py'),run_name='__main__')
assert len(calls)==2
assert calls[0]['survivors']==calls[1]['survivors'] and calls[0]['timeouts']==calls[1]['timeouts']
print('smoke observer: both exact calls retained, equal survivors and timeouts; no timing claim')
SMOKE_OBSERVER_PY
git status --porcelain --untracked-files=no > "$O/final-source-status.txt"
test ! -s "$O/final-source-status.txt"
printf 'native mutation-tool unit and integration smoke complete; functional evidence only; no speed verdict\n' > "$O/status.txt"
MUTATION_TOOL_SMOKE
