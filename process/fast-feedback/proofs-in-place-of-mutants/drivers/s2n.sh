#!/bin/bash
# Experiment (BLAKE3 #361): what a skeptic waits for with s2n-bignum's method (x86-64 machine code
# proved in HOL Light): install HOL Light, check the proof of one small function and one larger one.
# Records each step's time and result; no step's failure hides the rest.
set -euo pipefail
exec timeout -k 15s 3400s bash -s -- "$1" <<'JOB'
set -uo pipefail
R="$1";O="$R/out";mkdir -p "$O";export HOME=/root;. <home>/.cargo/env
{ echo "s2n-bignum $(git -C "$R/s2n" rev-parse HEAD)"; echo "hol-light $(git -C "$R/hol" rev-parse HEAD)"; nproc; } > "$O/identity.txt"
step() { local n="$1"; shift; local s=$SECONDS; "$@" > "$O/$n.log" 2>&1 < /dev/null; echo "$n rc=$? $((SECONDS-s))s" >> "$O/steps.txt"; }
: > "$O/steps.txt"
export DEBIAN_FRONTEND=noninteractive OPAMROOT="$R/opam" OPAMYES=1 OPAMROOTISOK=1
step apt sh -c 'apt-get update -qq && apt-get install -y -qq opam m4 pkg-config libgmp-dev zlib1g-dev build-essential unzip rsync libipc-system-simple-perl libstring-shellquote-perl'
step opam-init opam init --disable-sandboxing --bare --no-setup
step opam-switch opam switch create 4.14.2
step hol-deps sh -c 'eval $(opam env --switch=4.14.2) && opam install --confirm-level=unsafe-yes zarith ledit num camlp5'
cd "$R/hol"
step hol-make sh -c 'eval $(opam env --switch=4.14.2) && HOLLIGHT_USE_MODULE=1 make'
ls -la "$R/hol" | grep -E 'hol\.sh|hol_lib|\.cmxa|\.cma' > "$O/hol-files.txt" 2>&1 || true
export HOLDIR="$R/hol" HOLLIGHT_DIR="$R/hol"
cd "$R/s2n/x86"
wc -l proofs/bignum_add.ml proofs/bignum_montmul_p256.ml proofs/base.ml ../common/*.ml proofs/x86.ml proofs/instruction.ml proofs/decode.ml 2>/dev/null > "$O/proof-lines.txt" || true
ls proofs | wc -l >> "$O/proof-lines.txt"
step s2n-objects sh -c 'eval $(opam env --switch=4.14.2) && make -j 16 generic/bignum_add.o p256/bignum_montmul_p256.o'
step proof-add sh -c 'eval $(opam env --switch=4.14.2) && make generic/bignum_add.correct; tail -n 5 generic/bignum_add.correct'
step proof-montmul sh -c 'eval $(opam env --switch=4.14.2) && make p256/bignum_montmul_p256.correct; tail -n 5 p256/bignum_montmul_p256.correct'
cat "$O/steps.txt"; echo "s2n experiment done" > "$O/status.txt"
JOB
