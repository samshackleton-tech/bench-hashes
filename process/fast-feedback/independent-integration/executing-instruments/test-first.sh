#!/bin/bash
set -euo pipefail
exec timeout -k 5s 240s bash -s -- "$1" <<'JOB'
set -euo pipefail
R="$1"
mkdir -p "$R/out" "$R/tmp"
export HOME=/root
. /root/.cargo/env
export CARGO_TARGET_DIR="$R/target" TMPDIR="$R/tmp"
cd "$R/library"
{ echo "library $(git rev-parse HEAD)"; rustc -Vv; uname -m; } > "$R/out/identity.txt"
set +e
timeout -k 5s 180s cargo nextest run --release --features serde,zeroize --lib -E 'test(held_passes_do_not_depend_on_keys)' > "$R/out/test-first-red.log" 2>&1
s=$?
set -e
echo "$s" > "$R/out/test-first-exit.txt"
test "$s" = 100
grep -q 'assertion.*failed: key-independent passes:' "$R/out/test-first-red.log"
printf 'singleton remedy rejected by desired independent-pass test\n' > "$R/out/status.txt"
JOB
