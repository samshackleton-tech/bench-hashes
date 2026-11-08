#!/bin/bash
set -euo pipefail
R="$1";mkdir -p "$R/out"
export HOME=/root
. /root/.cargo/env
export CARGO_TARGET_DIR="$R/target"
cd "$R/fork"
printf 'library %s\n' "$(git rev-parse HEAD)" > "$R/out/identity.txt"
uname -m >> "$R/out/identity.txt"
command -v replace >> "$R/out/identity.txt"
test -z "$(git status --porcelain --untracked-files=no)"
# The existing golden/continuation/XOF test mixes first and later held stages.
cargo nextest run --release --lib -E 'test(test_held_key_groups_take_one_partition_pass)' > "$R/out/positive.log" 2>&1
cp src/ffi_output.rs "$R/out/ffi-output-original.rs"
GOOD='result.copy_from_slice(next[2 * k..2 * k + 2].as_flattened());'
BAD='result.copy_from_slice(level[2 * k..2 * k + 2].as_flattened());'
replace src/ffi_output.rs "$GOOD" "$BAD" > "$R/out/fault.diff"
restore() { replace src/ffi_output.rs "$BAD" "$GOOD" > "$R/out/restore.diff"; }
trap restore EXIT
# Wrong but initialized CVs: no invalid pointer or widened unsafe ring schedule.
set +e
timeout -k 5s 120s cargo nextest run --release --lib -E 'test(test_held_key_groups_take_one_partition_pass)' > "$R/out/wrong-buffer.log" 2>&1
status=$?
set -e
restore
trap - EXIT
test "$status" = 100
python3 - "$R" <<'PY'
from pathlib import Path
import sys
r=Path(sys.argv[1]);s=(r/'out/wrong-buffer.log').read_text()
assert 'n=2 lane=0 mixed=false' in s,s
assert 'test_held_key_groups_take_one_partition_pass' in s
assert 'assertion `left == right` failed' in s
assert Path('src/ffi_output.rs').read_bytes()==(r/'out/ffi-output-original.rs').read_bytes()
PY
git diff --exit-code > "$R/out/final-input.diff"
cargo nextest run --release --lib -E 'test(test_held_key_groups_take_one_partition_pass)' > "$R/out/restored-positive.log" 2>&1
printf 'positive and restored golden pass; initialized wrong-buffer control fails canonical root\n' > "$R/out/status.txt"
