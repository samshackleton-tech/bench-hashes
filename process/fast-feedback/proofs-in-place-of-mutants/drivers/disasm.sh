#!/bin/bash
# The machine code rustc and LLVM make of x86-64 detection, for the proof experiments (BLAKE3 #361):
# the release build's objects, and the disassembly of every function whose name mentions the detection.
set -euo pipefail
R="$1";O="$R/out";mkdir -p "$O";export HOME=/root;. <home>/.cargo/env
export CARGO_TARGET_DIR="$R/target" CARGO_INCREMENTAL=0
cd "$R/library"
{ echo "library $(git rev-parse HEAD)"; rustc -Vv; llvm-objdump --version | head -n 2; } > "$O/identity.txt" 2>&1 || true
cargo build --release > "$O/build.log" 2>&1 < /dev/null
mkdir -p "$R/x"; cp "$R/target/release/libblake3_servil.rlib" "$R/x/"; cd "$R/x"; ar x libblake3_servil.rlib
python3 - "$O" <<'DISASM_PY'
import subprocess, sys, re, glob
out = sys.argv[1]
want = re.compile(r"xgetbv|read_x86_features|features_of|read_cpu_words|os_saves_avx|x86_features$|platform::family|wide_cpu|hash_many_rounded|lane_widths|rounded_lanes|x86_platform|Platform::detect")
rows = []
for obj in sorted(glob.glob("*.o")):
    plain = subprocess.run(["nm", "--defined-only", obj], capture_output=True, text=True).stdout.splitlines()
    nice = subprocess.run(["nm", "-C", "--defined-only", obj], capture_output=True, text=True).stdout.splitlines()
    for p, n in zip(plain, nice):
        pf, nf = p.split(None, 2), n.split(None, 2)
        if len(pf) == 3 and len(nf) == 3 and pf[1] in "Tt" and want.search(nf[2]):
            rows.append((obj, pf[2], nf[2]))
with open(out + "/symbols.tsv", "w") as f:
    for obj, mangled, name in rows:
        safe = re.sub(r"[^A-Za-z0-9_]", "_", name)[:80]
        f.write(f"{obj}\t{mangled}\t{name}\t{safe}\n")
        for suffix, raw in ((".s", ["--no-show-raw-insn"]), (".bytes.s", [])):
            d = subprocess.run(["llvm-objdump", "-d", "-r", *raw, "-M", "intel", f"--disassemble-symbols={mangled}", obj], capture_output=True, text=True).stdout
            with open(f"{out}/{safe}{suffix}", "w") as g:
                g.write(d)
print(len(rows), "functions")
DISASM_PY
echo "disassembled" > "$O/status.txt"
