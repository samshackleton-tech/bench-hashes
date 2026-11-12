#!/bin/bash
# tools/size.py before and after the fix of its kernel-object rule, at the same library code (next), on this machine.
set -uo pipefail
R="$1";O="$R/out";mkdir -p "$O";. <home>/.cargo/env
export TMPDIR="$R/tmp"; mkdir -p "$TMPDIR"
{ for repo in library baseline mutator;do echo "$repo $(git -C "$R/$repo" rev-parse HEAD)";done; uname -m; rustc -V; } > "$O/identity.txt"
CARGO_TARGET_DIR="$R/mutator-target" cargo install --locked --path "$R/mutator" --root "$R/mutator-install" > "$O/install-mutator.log" 2>&1
export PATH="$R/mutator-install/bin:$PATH"
(cd "$R/baseline" && RUSTC_BOOTSTRAP=1 python3 tools/size.py > "$O/size-before.txt" 2> "$O/size-before.err"; echo "before rc=$?" > "$O/rc.txt")
(cd "$R/library" && python3 -m unittest tools/test_size.py > "$O/test.log" 2>&1; echo "test rc=$?" >> "$O/rc.txt")
(cd "$R/library" && RUSTC_BOOTSTRAP=1 python3 tools/size.py > "$O/size-after.txt" 2> "$O/size-after.err"; echo "after rc=$?" >> "$O/rc.txt")
cat "$O/size-before.txt" "$O/size-after.txt" "$O/rc.txt"
echo "size-fix done" > "$O/status.txt"
