#!/bin/bash
# The candidate's size line (tools/size.py BASE REV), for its record. No timing.
set -uo pipefail
R="$1";O="$R/out";mkdir -p "$O";. <home>/.cargo/env
export CARGO_TARGET_DIR="$R/target" TMPDIR="$R/tmp"; mkdir -p "$TMPDIR"
BASE=$(git -C "$R/baseline" rev-parse HEAD)
cd "$R/library"
git fetch --no-tags "$R/baseline" "$BASE" > "$O/base-object.log" 2>&1
{ for repo in library baseline mutator;do echo "$repo $(git -C "$R/$repo" rev-parse HEAD)";done; uname -m; rustc -V; } > "$O/identity.txt"
CARGO_TARGET_DIR="$R/mutator-target" cargo install --locked --path "$R/mutator" --root "$R/mutator-install" > "$O/install-mutator.log" 2>&1
export PATH="$R/mutator-install/bin:$PATH"
RUSTC_BOOTSTRAP=1 python3 tools/size.py "$BASE" HEAD > "$O/size.txt" 2> "$O/size.err"; echo "size.py rc=$?" > "$O/rc.txt"
cat "$O/size.txt"; cat "$O/rc.txt"
echo "size-line done" > "$O/status.txt"
