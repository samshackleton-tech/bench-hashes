#!/bin/bash
# Experiment (BLAKE3 #361): can Aeneas (Rust to Lean) be installed in under an hour, and what does it
# make of x86-64 detection's decisions? Records each step's time and result; no step's failure hides the rest.
set -euo pipefail
exec timeout -k 15s 3300s bash -s -- "$1" <<'JOB'
set -uo pipefail
R="$1";O="$R/out";mkdir -p "$O";export HOME=/root;. <home>/.cargo/env
cat > "$R/extract.py" <<'EXTRACT_PY'
"""A standalone Rust file of x86-64 detection's pure decisions, cut from src/platform.rs as it is:
the constants, CpuWords, os_saves_avx, features_of, family, wide_cpu. Fails if a piece is missing."""
import re, sys
src = open(sys.argv[1]).read()
def item(start, end="\n}\n"):
    a = src.index(start); b = src.index(end, a) + len(end); return src[a:b]
bits = item("mod x86_bits {")
out = ["#![allow(dead_code)]", bits.replace("mod x86_bits", "pub mod x86_bits"),
       item("#[derive(Clone, Copy, Default, PartialEq, Eq, Debug)]\nstruct CpuWords {"),
       item("const fn os_saves_avx("), item("const fn features_of("), item("const fn family("), item("const fn wide_cpu(")]
text = "\n".join(out)
text = text.replace("struct CpuWords", "pub struct CpuWords").replace("    leaf1_eax: u32", "    pub leaf1_eax: u32").replace("    leaf1_ecx: u32", "    pub leaf1_ecx: u32")
text = text.replace("    xcr0: u32", "    pub xcr0: u32").replace("    leaf7_ebx: u32", "    pub leaf7_ebx: u32").replace("    amd: bool", "    pub amd: bool")
for f in ("os_saves_avx", "features_of", "family", "wide_cpu"):
    text = text.replace(f"const fn {f}(", f"pub const fn {f}(")
text = re.sub(r"(?m)^\s*#\[cfg[^\n]*\]\n", "", text)
open(sys.argv[2], "w").write(text + "\n")
EXTRACT_PY
{ echo "library $(git -C "$R/library" rev-parse HEAD)"; echo "aeneas $(git -C "$R/aeneas" rev-parse HEAD)"; rustc -V; nproc; } > "$O/identity.txt"
step() { local n="$1"; shift; local s=$SECONDS; "$@" > "$O/$n.log" 2>&1 < /dev/null; echo "$n rc=$? $((SECONDS-s))s" >> "$O/steps.txt"; }
: > "$O/steps.txt"
export DEBIAN_FRONTEND=noninteractive OPAMROOT="$R/opam" OPAMYES=1 OPAMROOTISOK=1
step apt sh -c 'apt-get update -qq && apt-get install -y -qq opam m4 pkg-config libgmp-dev build-essential bubblewrap unzip rsync'
step opam-init opam init --disable-sandboxing --bare --no-setup
step opam-switch opam switch create 5.3.0
cd "$R/aeneas"
step setup-charon sh -c 'eval $(opam env --switch=5.3.0) && make setup-charon'
step opam-deps sh -c 'eval $(opam env --switch=5.3.0) && (opam install ./src --deps-only || opam install ./src/aeneas.opam --deps-only)'
step charon-deps sh -c 'eval $(opam env --switch=5.3.0) && (opam install ./charon/charon-ml --deps-only || opam install ppx_deriving_hash)'
step opam-list sh -c 'eval $(opam env --switch=5.3.0) && opam list --installed --short | tr "\n" " "'
step build sh -c 'eval $(opam env --switch=5.3.0) && make build'
ls -la bin charon/bin 2>/dev/null > "$O/bins.txt" || true
mkdir -p "$R/k/src"; cd "$R/k"
printf '[package]\nname = "detect"\nversion = "0.1.0"\nedition = "2021"\n' > Cargo.toml
python3 "$R/extract.py" "$R/library/src/platform.rs" src/lib.rs; cp src/lib.rs "$O/detect.rs"
step charon sh -c "$R/aeneas/charon/bin/charon cargo --preset=aeneas"
ls -la *.llbc > "$O/llbc.txt" 2>&1 || true
step aeneas sh -c "$R/aeneas/bin/aeneas -backend lean -dest $O/lean *.llbc"
cp -r "$R/aeneas/backends/lean/lean-toolchain" "$O/aeneas-lean-toolchain" 2>/dev/null || true
ls -la "$O/lean" > "$O/lean-files.txt" 2>&1 || true
cat "$O/steps.txt"; echo "aeneas experiment done" > "$O/status.txt"
JOB
