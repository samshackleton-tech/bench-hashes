#!/bin/bash
# The same functions three ways, on a rented machine (BLAKE3 #361): the branch's lang/run.sh against the
# two-crate trial's core crate. Single execution: inventory, no speed verdict.
set -uo pipefail
R="$1";O="$R/out";mkdir -p "$O";export HOME=/root;. <home>/.cargo/env
export ELAN_HOME="$R/elan"; export PATH="$ELAN_HOME/bin:$PATH"
{ echo "library $(git -C "$R/library" rev-parse HEAD)"; echo "crate $(git -C "$R/crate" rev-parse HEAD)"; rustc -V; nproc; grep -m1 'model name' /proc/cpuinfo | sed 's/.*: //'; } > "$O/identity.txt" 2>&1
curl -sSf https://elan.lean-lang.org/elan-init.sh | sh -s -- -y --default-toolchain none --no-modify-path > "$O/elan.log" 2>&1
LAB_OWN="${LAB_OWN:-0}" LAB_SOURCE="${LAB_SOURCE:-lean}" "$R/library/tools/verify/machine/lang/run.sh" "$R/crate" "$R/work" > "$O/run.log" 2>&1; rc=$?
cp "$R/work"/way_a.rs "$R/work"/way_a.s "$R/work"/way_b.S "$R/work"/bench.txt "$R/work"/sizes.txt "$R/work"/cargo.log "$R/work"/rustc.log "$O/" 2>/dev/null
cat "$O/run.log"
[ $rc = 0 ] && grep -q "three ways compared" "$O/run.log" && echo "three ways compared" > "$O/status.txt"
