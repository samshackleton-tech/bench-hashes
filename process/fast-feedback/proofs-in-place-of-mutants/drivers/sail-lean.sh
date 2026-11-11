#!/bin/bash
# Experiment (BLAKE3 #361): can Sail's x86-64 model (the one translated from ACL2's x86isa)
# be turned into Lean by Sail's Lean backend, and does Lean accept the result? Records each
# step's time and result; no step's failure hides the rest.
set -euo pipefail
exec timeout -k 15s 3300s bash -s -- "$1" <<'JOB'
set -uo pipefail
R="$1";O="$R/out";mkdir -p "$O";export HOME=/root;. <home>/.cargo/env
{ echo "model $(git -C "$R/model" rev-parse HEAD)"; echo "sail $(git -C "$R/sail" rev-parse HEAD)"; nproc; } > "$O/identity.txt"
step() { local n="$1"; shift; local s=$SECONDS; "$@" > "$O/$n.log" 2>&1 < /dev/null; echo "$n rc=$? $((SECONDS-s))s" >> "$O/steps.txt"; }
: > "$O/steps.txt"
export DEBIAN_FRONTEND=noninteractive OPAMROOT="$R/opam" OPAMYES=1 OPAMROOTISOK=1
export ELAN_HOME="$R/elan"; export PATH="$ELAN_HOME/bin:$PATH"
step apt sh -c 'apt-get update -qq && apt-get install -y -qq opam m4 pkg-config libgmp-dev zlib1g-dev z3 build-essential unzip rsync'
step opam-init opam init --disable-sandboxing --bare --no-setup
step opam-switch opam switch create 5.3.0
cd "$R/sail"
step sail-install sh -c 'eval $(opam env --switch=5.3.0) && opam install . --deps-only && opam install .'
step sail-version sh -c 'eval $(opam env --switch=5.3.0) && sail --version && sail --help 2>&1 | grep -i -E "lean|plugin" | head -n 30'
step elan sh -c 'curl -sSf https://elan.lean-lang.org/elan-init.sh | sh -s -- -y --default-toolchain none --no-modify-path'
step regfp sh -c "eval \$(opam env --switch=5.3.0) && cd $R/sail && git fetch -q --unshallow 2>/dev/null; c=\$(git log --diff-filter=D --format=%H -n 1 -- lib/regfp.sail) && echo deleted in \$c && git show \$c^:lib/regfp.sail > \$(opam var sail:share)/lib/regfp.sail && ls -la \$(opam var sail:share)/lib/regfp.sail"
cd "$R/model/model"
S="prelude.sail register_types.sail registers.sail register_accessors.sail opcode_ext.sail memory_accessors.sail init.sail config.sail logging.sail step.sail main.sail"
step sail-check sh -c "eval \$(opam env --switch=5.3.0) && sail $S"
mkdir -p "$O/lean"
step sail-lean sh -c "eval \$(opam env --switch=5.3.0) && sail --lean --lean-output-dir $O/lean -o X86 $S"
find "$O/lean" -name '*.lean' -exec wc -l {} + > "$O/lean-lines.txt" 2>&1 || true
find "$O/lean" -maxdepth 3 > "$O/lean-files.txt" 2>&1 || true
D=$(dirname "$(find "$O/lean" -name lakefile.toml -o -name lakefile.lean 2>/dev/null | head -n 1)" 2>/dev/null)
if [ -n "$D" ] && [ -d "$D" ]; then cd "$D"; cat lean-toolchain lakefile.* > "$O/lean-project.txt" 2>&1; step lake-update lake update; step lake-build timeout 2400 lake build; du -sh .lake > "$O/lake-size.txt" 2>&1; fi
cat "$O/steps.txt"; echo "sail experiment done" > "$O/status.txt"
JOB
