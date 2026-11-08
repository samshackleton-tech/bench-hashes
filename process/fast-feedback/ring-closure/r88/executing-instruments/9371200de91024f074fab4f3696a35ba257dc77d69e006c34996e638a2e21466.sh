#!/bin/bash
set -euo pipefail
exec timeout -k 5s 600s bash -s -- "$1" <<'JOB'
set -euo pipefail
R="$1"
mkdir -p "$R/out"
export HOME=/root
. /root/.cargo/env
export CARGO_TARGET_DIR="$R/target"
cd "$R/fork"
{ echo "library $(git rev-parse HEAD)";rustc -Vv;uname -m;} > "$R/out/identity.txt"
cargo nextest run --release --features serde,zeroize --test allocations > "$R/out/suite.log" 2>&1
bin=$(ls -t "$R"/target/release/deps/allocations-* | grep -v '\.d$' | head -1)
python3 - "$R/out" "$bin" <<'PY'
import subprocess,sys,concurrent.futures as cf
out,b=sys.argv[1:]
def run(_):
    p=subprocess.run([b,'--exact','resource_admission_allocates_nothing_when_ready_or_waiting'],capture_output=True,text=True,timeout=60)
    return p.returncode,p.stdout+p.stderr
with cf.ThreadPoolExecutor(16) as ex: r=list(ex.map(run,range(400)))
fails=[t for c,t in r if c!=0]
open(out+'/repeat.txt','w').write(f'per-thread counter: admission test failures {len(fails)} of 400\n'+''.join(t[-600:] for t in fails[:3]))
assert not fails
PY
test -z "$(git status --porcelain)"
printf 'per-thread allocation counter: 0 of 400 failures\n' > "$R/out/status.txt"
JOB
