#!/bin/bash
# check.py's whole run at servil's head on this machine (run cm-whole): where a run's time goes (each
# mutant's phases, from cargo-mutants' outcomes), and whether the list is current (--write's diff).
set -u
R="$1"; O="$R/out"; mkdir -p "$O"; cd "$R"
export HOME=/root; . /root/.cargo/env
arch=$(uname -m)
{ echo "arch $arch"; nproc; grep -m1 'model name' /proc/cpuinfo; free -g | head -2; rustc --version; cargo mutants --version; cargo nextest --version | head -1; git -C fork log -1 --format='fork %H'; } > "$O/machine.txt" 2>&1
cd fork
cp tools/mutants/known-$arch.txt "$O/list-before.txt"; cp tools/mutants/timeouts-$arch.txt "$O/timeouts-before.txt"
date -u +%s > "$O/start.txt"
python3 tools/mutants/check.py --write > "$O/check.txt" 2>&1; echo "check exit $?" >> "$O/status.txt"
date -u +%s > "$O/end.txt"
cp tools/mutants/known-$arch.txt "$O/list-written.txt"; cp tools/mutants/timeouts-$arch.txt "$O/timeouts-written.txt"
git diff --stat > "$O/list-diff-stat.txt"; git diff > "$O/list-diff.txt"
cp -r tmp/mutants-last "$O/mutants-last" 2>/dev/null
find "$O/mutants-last" -name '*.log' -size +2M -delete 2>/dev/null
echo "whole done" >> "$O/status.txt"
