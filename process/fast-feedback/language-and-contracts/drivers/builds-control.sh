#!/bin/bash
# A control for the gate's `builds` step on this machine: tools/check-builds.sh at the baseline (without the
# change) and at the candidate, each in its own checkout, and the hexadecimal's own check at the candidate.
set -uo pipefail
R="$1";O="$R/out";mkdir -p "$O";. <home>/.cargo/env
{ for repo in library baseline;do echo "$repo $(git -C "$R/$repo" rev-parse HEAD)";done; uname -m; } > "$O/identity.txt"
(cd "$R/baseline" && CARGO_TARGET_DIR="$R/target-base" sh tools/check-builds.sh > "$O/builds-baseline.log" 2>&1; echo "baseline check-builds rc=$?" > "$O/rc.txt")
(cd "$R/library" && CARGO_TARGET_DIR="$R/target-cand" sh tools/check-builds.sh > "$O/builds-candidate.log" 2>&1; echo "candidate check-builds rc=$?" >> "$O/rc.txt")
(cd "$R/library" && sh tools/verify/hex/check-shipped.sh > "$O/shipped.log" 2>&1; echo "candidate check-shipped rc=$?" >> "$O/rc.txt")
grep -h "is not a C compiler\|failed to find tool" "$O/builds-baseline.log" | sort -u | head -n 3 > "$O/why-baseline.txt"
grep -h "is not a C compiler\|failed to find tool" "$O/builds-candidate.log" | sort -u | head -n 3 > "$O/why-candidate.txt"
cat "$O/rc.txt"; cat "$O/shipped.log"
echo "builds-control done" > "$O/status.txt"
