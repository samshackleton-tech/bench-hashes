#!/bin/bash
# bench-hashes check of one commit against another on named points, on a quiet host.
# POINTS and LAYOUTS come from the manifest. The check's exit is the verdict, recorded.
set -euo pipefail
exec timeout -k 15s 3300s bash -s -- "$1" <<'JOB'
set -uo pipefail
R="$1";O="$R/out";mkdir -p "$O";export HOME=/root;. <home>/.cargo/env
export CARGO_TARGET_DIR="$R/target" TMPDIR="$R/check-tmp";mkdir -p "$TMPDIR"
OLD=$(git -C "$R/baseline" rev-parse HEAD)
git -C "$R/library" fetch --no-tags "$R/baseline" "$OLD" > "$O/base-object.log" 2>&1
{ for repo in library baseline bench;do echo "$repo $(git -C "$R/$repo" rev-parse HEAD)";done;echo "points $POINTS";echo "layouts $LAYOUTS";rustc -V;uname -m;grep -m1 'model name' /proc/cpuinfo | cut -d: -f2;lscpu | grep -E 'L3 cache'; } > "$O/identity.txt"
cd "$R/bench"
cargo run --release --quiet -- check --fork "$R/library" --against "$OLD" --when-quiet --keep "$O/samples" --points "$POINTS" --layouts "$LAYOUTS" > "$O/check.log" 2> "$O/check.stderr"
rc=$?
echo "check exit $rc: $(case $rc in 0) echo 'no regression';; 1) echo 'regression';; 2) echo 'no verdict';; 3) echo 'a side stopped';; *) echo 'error';; esac)" > "$O/status.txt"
grep -v '^regress: pair' "$O/check.log" | tail -n 40
case $rc in 0|1) exit 0;; *) exit 1;; esac
JOB
