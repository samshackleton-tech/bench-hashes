#!/bin/bash
# cargo-mutants' extra mutations on AArch64 (run cm-a64neon): servil's check.py --write on
# src/ffi_neon_hybrid.rs alone (its NEON wrappers are unsafe fns, which cargo-mutants 27.1.0 never
# mutates), with the cargo-mutants fork (sam/blind-spots) first on PATH and --extra-mutations
# added to check.py's cargo-mutants arguments, both in a job commit of the checkout (check.py
# runs worktrees of HEAD). Every survivor comes out as a row: UNCLASSIFIED, or same code.
set -u
R="$1"; O="$R/out"; mkdir -p "$O"; cd "$R"
export HOME=/root; . /root/.cargo/env
# pool_fairness::two_callers_share_the_pool times two callers for 1 s and fails on this loaded
# 4-vCPU guest (the first launch: every shard's baseline, ratios 1.57-1.91 against its 1.5): its
# emulation skip, as on QEMU. No mutant of ffi_neon_hybrid.rs is caught by a fairness ratio alone.
export BLAKE3_EMULATED=1
( cd cm && cargo build -q --release ) > "$O/cm-build.log" 2>&1 || { echo "cm build failed" >> "$O/status.txt"; exit 1; }
export PATH="$R/cm/target/release:$PATH"
arch=$(uname -m)
{ echo "arch $arch"; echo "BLAKE3_EMULATED=$BLAKE3_EMULATED"; nproc; grep -m1 -E 'model name|Features' /proc/cpuinfo; rustc --version; command -v cargo-mutants; cargo mutants --version; cargo nextest --version | head -1; git -C fork log -1 --format='fork %H'; git -C cm log -1 --format='cm %H'; } > "$O/machine.txt" 2>&1
cd fork
python3 - tools/mutants/known-$arch.txt tools/mutants/check.py <<'PY_CUT_END'
import sys
known, check = sys.argv[1:]
lines = open(known).read().splitlines()
open(known, "w").write("\n".join([l for l in lines if l.startswith("#")] + ["files: src/ffi_neon_hybrid.rs"]) + "\n")
s = open(check).read()
old = '"--test-tool", "nextest", *extra]'
assert s.count(old) == 1, "check.py's cargo-mutants arguments moved"
open(check, "w").write(s.replace(old, '"--test-tool", "nextest", "--extra-mutations", *extra]'))
PY_CUT_END
git -c user.name=job -c user.email=job@localhost -c core.hooksPath=/dev/null commit -qam "job: the list cut to ffi_neon_hybrid.rs, --extra-mutations" && git log -1 --format='job commit %H' >> "$O/machine.txt"
grep -c -- "--extra-mutations" tools/mutants/check.py >> "$O/machine.txt"
python3 tools/mutants/check.py --write > "$O/check.txt" 2>&1; echo "check exit $?" >> "$O/status.txt"
cp tools/mutants/known-$arch.txt "$O/list-written.txt"; cp tools/mutants/timeouts-$arch.txt "$O/timeouts-written.txt" 2>/dev/null
cp -r tmp/mutants-last "$O/mutants-last" 2>/dev/null
find "$O/mutants-last" -name '*.log' -size +2M -delete 2>/dev/null
echo "a64neon done" >> "$O/status.txt"
