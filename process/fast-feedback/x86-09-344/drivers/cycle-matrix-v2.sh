#!/bin/bash
# The complete-cycle matrix (the frozen sampler of the evidence repository), with the
# two calls that left BLAKE3-Servil's public API on November 10 (9c532849) replaced:
#   Hasher::reset(None)   ->  clone_from a pristine Hasher of the same mode
#   Hasher::count() == 0  ->  each state finalizes, cloned, to its mode's empty-message hash
# The frozen file is checked by its hash first; each replacement must match exactly once.
set -euo pipefail
exec timeout -k 5s 1500s bash -s -- "$1" <<'JOB'
set -euo pipefail
R="$1";export HOME=/root
. <home>/.cargo/env
mkdir -p "$R/out"
S="$R/evidence/process/fast-feedback/ring-closure/r88/sampler-2355/mixed-stage-costs.sh"
test "$(sha256sum "$S" | cut -d' ' -f1)" = 3a0595df2a83d2c2c42b5decf50ebad56449f26d82721ac3c32ba89cdd3782cb
python3 - "$S" "$R/sampler-v2.sh" <<'PY'
import sys
from pathlib import Path
t=Path(sys.argv[1]).read_text()
def rep(old,new):
    global t
    assert t.count(old)==1,(t.count(old),old)
    t=t.replace(old,new)
rep('''    let mut hs: Vec<_> = (0..open).map(|i| Hasher::new(mode(i, flavor, &keys), None)).collect();
''','''    let mut hs: Vec<_> = (0..open).map(|i| Hasher::new(mode(i, flavor, &keys), None)).collect();
    let fresh = hs.clone();
''')
rep('''if algorithm == "update" { for &i in &which { hs[i].reset(None); } }''','''if algorithm == "update" { for &i in &which { hs[i].clone_from(&fresh[i]); } }''')
rep('''        assert!(hs.iter().all(|h| h.count() == 0), "selected states reset and idle states untouched");
''','''        for (i, h) in hs.iter().enumerate() {
            assert_eq!(*h.clone().finalize().as_bytes(), expected(i, flavor, &keys, &[]), "selected states reset and idle states untouched");
        }
''')
Path(sys.argv[2]).write_text(t)
PY
sha256sum "$R/sampler-v2.sh" | cut -d' ' -f1 > "$R/out/sampler-v2.sha256"
test "${API_FAMILY:-}" = next
bash "$R/sampler-v2.sh" "$R" > "$R/out/driver.log" 2>&1
JOB
