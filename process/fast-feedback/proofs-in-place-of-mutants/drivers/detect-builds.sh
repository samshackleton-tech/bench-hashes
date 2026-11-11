#!/bin/bash
# Does a proof about the bytes run on a user's own build (BLAKE3 #361)? x86-64 detection, the first
# experiment (tools/verify/machine, the top folder): its proof is a symbolic run with fuel and
# bv_decide, and names no address. For each build setting a user may choose: build the library, lift
# read_x86_features and its callees as check.sh does, and build the theorem on that code, with no
# edit of the proof. Recorded: whether the code differs from the plain release build's, and whether
# the theorem checks.
set -uo pipefail
R="$1";O="$R/out";mkdir -p "$O";export HOME=/root;. <home>/.cargo/env
export ELAN_HOME="$R/elan"; export PATH="$ELAN_HOME/bin:$PATH" CARGO_INCREMENTAL=0
cd "$R/library"; { echo "library $(git rev-parse HEAD)"; rustc -V; } > "$O/identity.txt"
curl -sSf https://elan.lean-lang.org/elan-init.sh | sh -s -- -y --default-toolchain none --no-modify-path > "$O/elan.log" 2>&1
M="$R/library/tools/verify/machine"
(cd "$M" && lake build > "$O/build-1.99.1.log" 2>&1) && echo "1.99.1 (the code the branch holds): the theorem checks" > "$O/results.txt" || echo "1.99.1: the theorem does NOT check" > "$O/results.txt"
cat > "$R/listings.py" <<'LISTINGS_PY'
import glob, re, subprocess, sys
work = sys.argv[1]
want = {"blake3_servil::platform::read_x86_features": "features", "blake3_servil::platform::read_cpu_words": "words", "core::core_arch::x86::xsave::_xgetbv": "xgetbv"}
found = {}
for obj in sorted(glob.glob(work + "/x/*.o")):
    plain = subprocess.run(["nm", "--defined-only", obj], capture_output=True, text=True).stdout.splitlines()
    nice = subprocess.run(["nm", "-C", "--defined-only", obj], capture_output=True, text=True).stdout.splitlines()
    for p, n in zip(plain, nice):
        pf, nf = p.split(None, 2), n.split(None, 2)
        if len(pf) == 3 and len(nf) == 3 and pf[1] in "Tt" and nf[2] in want and nf[2] not in found:
            found[nf[2]] = (obj, pf[2])
print("functions found:", sorted(want[k] for k in found), "missing:", sorted(want[k] for k in set(want) - set(found)))
for name, short in want.items():
    if name not in found: continue
    obj, mangled = found[name]
    text = subprocess.run(["llvm-objdump", "-d", "-r", "-M", "intel", f"--disassemble-symbols={mangled}", obj], capture_output=True, text=True, check=True).stdout
    with open(f"{work}/{short}.s", "w") as f: f.write(text)
LISTINGS_PY
while IFS='|' read -r T SET; do
  [ -n "$T" ] || continue
  W="$R/w-$T"; mkdir -p "$W/x"; V="$SET"
  env $SET CARGO_TARGET_DIR="$W/target" cargo build --release > "$O/cargo-$T.log" 2>&1 < /dev/null || { echo "$T ($V): the crate does not build" >> "$O/results.txt"; continue; }
  cp "$W/target/release/libblake3_servil.rlib" "$W/x/" && (cd "$W/x" && ar x libblake3_servil.rlib)
  python3 "$R/listings.py" "$W" > "$O/listings-$T.txt" 2>&1 < /dev/null
  args=""; for pair in 0x1000:features 0x2000:words 0x3000:xgetbv; do f="$W/${pair#*:}.s"; [ -s "$f" ] && args="$args ${pair%%:*}:$f"; done
  if ! python3 "$M/lift.py" "$W/Code.lean" Code $args > "$O/lift-$T.log" 2>&1 < /dev/null; then
    echo "$T ($V): the lifter stops: $(tail -n 1 "$O/lift-$T.log" | cut -c1-160); $(cat "$O/listings-$T.txt")" >> "$O/results.txt"; cp "$W"/*.s "$O/" 2>/dev/null; for f in features words xgetbv; do [ -f "$O/$f.s" ] && mv "$O/$f.s" "$O/$T-$f.s"; done; continue
  fi
  n=$(grep -c "^  (0x" "$W/Code.lean" || true)
  if cmp -s <(sed "s/ *--.*//" "$W/Code.lean") <(sed "s/ *--.*//" "$M/Code.lean"); then echo "$T ($V): the same machine code as the plain release build ($n instructions)" >> "$O/results.txt"; continue; fi
  d=$(diff <(sed "s/ *--.*//" "$W/Code.lean") <(sed "s/ *--.*//" "$M/Code.lean") | grep -c '^<' || true)
  rm -rf "$W/m"; mkdir -p "$W/m"; cp "$M"/*.lean "$M"/lakefile.toml "$M"/lean-toolchain "$M"/lake-manifest.json "$W/m/" 2>/dev/null; cp "$W/Code.lean" "$W/m/Code.lean"; cp "$W/Code.lean" "$O/Code-$T.lean"
  s=$(date +%s)
  if (cd "$W/m" && timeout 900 lake build > "$O/build-$T.log" 2>&1 < /dev/null) && ! grep -q "sorryAx" "$O/build-$T.log"; then
    echo "$T ($V): different code ($n instructions, $d of them and their lemmas differ); the theorem checks on it with no edit, in $(( $(date +%s) - s )) s" >> "$O/results.txt"
  else
    echo "$T ($V): different code ($n instructions, $d of them and their lemmas differ); the theorem does NOT check: $(grep -m1 -E 'error' "$O/build-$T.log" | cut -c1-200)" >> "$O/results.txt"
  fi
done <<'VARIANTS'
codegen-units-1|CARGO_PROFILE_RELEASE_CODEGEN_UNITS=1
opt-level-2|CARGO_PROFILE_RELEASE_OPT_LEVEL=2
opt-level-1|CARGO_PROFILE_RELEASE_OPT_LEVEL=1
opt-level-s|CARGO_PROFILE_RELEASE_OPT_LEVEL=s
panic-abort|CARGO_PROFILE_RELEASE_PANIC=abort
target-cpu-native|RUSTFLAGS=-Ctarget-cpu=native
debug-assertions|CARGO_PROFILE_RELEASE_DEBUG_ASSERTIONS=true
overflow-checks|CARGO_PROFILE_RELEASE_OVERFLOW_CHECKS=true
VARIANTS
cat "$O/results.txt"
echo "builds tried" > "$O/status.txt"
