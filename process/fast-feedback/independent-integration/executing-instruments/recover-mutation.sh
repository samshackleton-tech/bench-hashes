#!/bin/bash
set -euo pipefail
R="$1"
mkdir -p "$R/out"
P=/root/pinned-runs/independent-next-quality-ice-20261109T030827-45aecb8c
S="$P/library"
test "$(git -C "$S" rev-parse HEAD)" = "$(git -C "$R/reference" rev-parse HEAD)"
{ echo 'recovered_from independent-next-quality-ice-20261109T030827-45aecb8c';echo "library $(git -C "$S" rev-parse HEAD)"; } > "$R/out/identity.txt"
git -C "$S" status --porcelain > "$R/out/original-final-git-status.txt"
git -C "$S" diff > "$R/out/original-uncommitted.diff"
cp -a "$S/tmp/mutants-last" "$R/out/mutants-last"
printf 'original failed-run mutation raw evidence recovered without rerunning tests\n' > "$R/out/status.txt"
