#!/bin/bash
# Experiment (BLAKE3 #361): Jasmin. Install the compiler, see what vector code it accepts (AVX2;
# AVX-512), compile a third party's BLAKE3 in Jasmin and run its constant-time checker on it.
# Records each step's time and result; no step's failure hides the rest.
set -euo pipefail
exec timeout -k 15s 3300s bash -s -- "$1" <<'JOB'
set -uo pipefail
R="$1";O="$R/out";mkdir -p "$O";export HOME=/root;. <home>/.cargo/env
{ echo "blake3-in-jasmin $(git -C "$R/b3j" rev-parse HEAD)"; nproc; } > "$O/identity.txt"
step() { local n="$1"; shift; local s=$SECONDS; "$@" > "$O/$n.log" 2>&1 < /dev/null; echo "$n rc=$? $((SECONDS-s))s" >> "$O/steps.txt"; }
: > "$O/steps.txt"
export DEBIAN_FRONTEND=noninteractive OPAMROOT="$R/opam" OPAMYES=1 OPAMROOTISOK=1
step apt sh -c 'apt-get update -qq && apt-get install -y -qq opam m4 pkg-config libgmp-dev libmpfr-dev libppl-dev zlib1g-dev; apt-get install -y -qq libpcre3-dev || apt-get install -y -qq libpcre2-dev; apt-get install -y -qq build-essential unzip rsync'
step opam-init opam init --disable-sandboxing --bare --no-setup
step opam-switch opam switch create 4.14.2
step jasmin-install sh -c 'eval $(opam env --switch=4.14.2) && opam install jasmin'
step jasmin-version sh -c 'eval $(opam env --switch=4.14.2) && jasminc -version && ls $(dirname $(which jasminc)) | grep -i jasmin'
mkdir -p "$R/p"; cd "$R/p"
cat > avx2_old.jazz <<'J'
export fn probe(reg u64 p) {
  reg u256 a b t;
  a = (u256)[p];
  b = (u256)[p + 32];
  a = #VPADD_8u32(a, b);
  a = #VPXOR_256(a, b);
  t = #VPSLL_8u32(a, 25);
  a = #VPSRL_8u32(a, 7);
  a = #VPOR_256(a, t);
  (u256)[p] = a;
}
J
cat > avx2_new.jazz <<'J'
export fn probe(reg u64 p) {
  reg u256 a b t;
  a = [:u256 p];
  b = [:u256 p + 32];
  a = #VPADD_8u32(a, b);
  a = #VPXOR_256(a, b);
  t = #VPSLL_8u32(a, 25);
  a = #VPSRL_8u32(a, 7);
  a = #VPOR_256(a, t);
  [:u256 p] = a;
}
J
cat > avx512.jazz <<'J'
export fn probe(reg u64 p) {
  reg u512 a b;
  a = [:u512 p];
  b = [:u512 p + 64];
  a = #VPADD_16u32(a, b);
  [:u512 p] = a;
}
J
for f in avx2_old avx2_new avx512; do step "compile-$f" sh -c "eval \$(opam env --switch=4.14.2) && jasminc -o $f.s $f.jazz && cat $f.s"; done
for f in avx2_old avx2_new; do step "ct-$f" sh -c "eval \$(opam env --switch=4.14.2) && jasmin-ct --infer $f.jazz"; done
cd "$R/b3j"; find . -name '*.jazz' -o -name '*.jinc' | head -n 40 > "$O/b3j-files.txt"; wc -l $(find . -name '*.jazz' -o -name '*.jinc') > "$O/b3j-lines.txt" 2>&1 || true
i=0; for f in $(find . -name '*.jazz' | head -n 6); do i=$((i+1)); step "b3j-compile-$i" sh -c "eval \$(opam env --switch=4.14.2) && cd $(dirname $f) && jasminc -o /tmp/b3j-$i.s $(basename $f) && grep -c . /tmp/b3j-$i.s"; echo "$i $f" >> "$O/b3j-files.txt"
  step "b3j-ct-$i" sh -c "eval \$(opam env --switch=4.14.2) && cd $(dirname $f) && (jasmin-ct $(basename $f) || jasminc -checkCT $(basename $f))"; done
cat "$O/steps.txt"; echo "jasmin experiment done" > "$O/status.txt"
JOB
