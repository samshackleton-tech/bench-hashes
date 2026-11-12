#!/bin/bash
# The scratch layout's test on AArch64: it passes on the code as it is and fails with the mutant the Mac's
# whole run found surviving (replace + with - in scratch_layout, the level above's place).
set -uo pipefail
R="$1";O="$R/out";mkdir -p "$O";. <home>/.cargo/env
export CARGO_TARGET_DIR="$R/target"
cd "$R/library"
{ echo "library $(git rev-parse HEAD)"; uname -m; rustc -V; } > "$O/identity.txt"
cargo fmt --check > "$O/fmt.log" 2>&1; echo "fmt rc=$?" > "$O/rc.txt"
cargo test --profile mutants --lib scratch_layout > "$O/plain.log" 2>&1; echo "unchanged rc=$?" >> "$O/rc.txt"
grep -c "test_scratch_layout_keeps_the_buffers_apart_and_inside ... ok" "$O/plain.log" >> "$O/rc.txt"
python3 - <<'PY'
from pathlib import Path
p=Path('src/ffi_sme2.rs'); t=p.read_text()
old="    let half = cvs + (32 * n.max(32)).saturating_sub(2048).next_multiple_of(4096) + 2048;"
assert t.count(old)==1
p.write_text(t.replace(old,"    let half = cvs - (32 * n.max(32)).saturating_sub(2048).next_multiple_of(4096) + 2048;"))
PY
cargo test --profile mutants --lib scratch_layout > "$O/mutant.log" 2>&1; echo "with the mutant rc=$?" >> "$O/rc.txt"
grep -h "panicked\|chunks:" "$O/mutant.log" | head -n 3 >> "$O/rc.txt"
cat "$O/rc.txt"
echo "layout-test done" > "$O/status.txt"
