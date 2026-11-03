#!/bin/bash
# BLAKE3 #218, stream.rs's mutation run before it joins the lists (run b218-streammut): servil's
# check.py --write, its list cut to `files: src/stream.rs` (no rows, no model files; committed in
# the job's checkout, as check.py runs worktrees of HEAD), so every survivor comes out as a row:
# UNCLASSIFIED, or same code with its reason. This machine's CPU decides the [cpu ...] rows.
set -u
R="$1"; O="$R/out"; mkdir -p "$O"; cd "$R"
export HOME=/root; . /root/.cargo/env
arch=$(uname -m)
{ echo "arch $arch"; nproc; grep -m1 -E 'model name|Features' /proc/cpuinfo; grep -o -w -E 'avx512f|sme2|sha3' /proc/cpuinfo | sort -u | tr '\n' ' '; echo; rustc --version; cargo mutants --version; cargo nextest --version | head -1; git -C fork log -1 --format='fork %H'; } > "$O/machine.txt" 2>&1
cd fork
L=tools/mutants/known-$arch.txt
python3 - "$L" <<'PY_CUT_END'
import sys
p = sys.argv[1]
lines = open(p).read().splitlines()
out = [l for l in lines if l.startswith("#")] + ["files: src/stream.rs"]
open(p, "w").write("\n".join(out) + "\n")
PY_CUT_END
git -c user.name=job -c user.email=job@localhost -c core.hooksPath=/dev/null commit -qam "job: the list cut to stream.rs" && git log -1 --format='job commit %H' >> "$O/machine.txt"
cat "$L" | grep -v "^#" > "$O/list-before.txt"
python3 tools/mutants/check.py --write > "$O/check.txt" 2>&1; echo "check exit $?" >> "$O/status.txt"
cp "$L" "$O/list-written.txt"
cp -r tmp/mutants-last "$O/mutants-last" 2>/dev/null
find "$O/mutants-last" -name '*.log' -size +2M -delete 2>/dev/null
git status --porcelain --untracked-files=no > "$O/tree-after.txt"
echo "streammut done" >> "$O/status.txt"
