#!/bin/bash
# The size of the whole problem (BLAKE3 #361): every instruction in a release build of the core
# crate (the repository's root crate), by function and by mnemonic: how much is assembly kernels,
# how much compiled Rust, how many loops (backward branches), calls out of the crate, indirect
# jumps. No proof: a count of what a proof of "every instruction that can run" has to cover.
set -euo pipefail
R="$1";O="$R/out";mkdir -p "$O";export HOME=/root;. <home>/.cargo/env
export CARGO_TARGET_DIR="$R/target" CARGO_INCREMENTAL=0
cd "$R/library"
{ echo "library $(git rev-parse HEAD)"; rustc -Vv | grep -E '^(rustc|host)'; grep -m1 '^name' Cargo.toml; } > "$O/identity.txt"
cargo build --release > "$O/build.log" 2>&1 < /dev/null
mkdir -p "$R/x"; lib=$(ls "$R"/target/release/lib*.rlib | head -n 1); echo "rlib $(basename "$lib")" >> "$O/identity.txt"
cp "$lib" "$R/x/"; cd "$R/x"; ar x "$(basename "$lib")"
cat > "$R/inventory.py" <<'INVENTORY_PY'
import collections, glob, json, re, subprocess, sys
out = sys.argv[1]
funcs = []                     # (object, name, instructions, backward branches, calls out, indirect)
mn_rust, mn_asm = collections.Counter(), collections.Counter()
callees = collections.Counter()
for obj in sorted(glob.glob("*.o")):
    text = subprocess.run(["llvm-objdump", "-d", "-r", "-C", "--no-show-raw-insn", obj], capture_output=True, text=True).stdout
    rust = ".rcgu." in obj
    name, n, back, calls, ind, start = None, 0, 0, 0, 0, 0
    def close():
        if name is not None and n:
            funcs.append((obj, name, n, back, calls, ind, rust))
    for line in text.splitlines():
        m = re.match(r"^([0-9a-f]+) <(.+)>:$", line)
        if m:
            close(); name, n, back, calls, ind, start = m.group(2), 0, 0, 0, 0, int(m.group(1), 16); continue
        m = re.match(r"^\s*([0-9a-f]+):\s+(\S+)\s*(.*)$", line)
        if m and name is not None:
            at, op, args = int(m.group(1), 16), m.group(2), m.group(3)
            if op.startswith(("R_X86_64", "R_AARCH64")):
                if "PLT32" in op or "CALL26" in op or "JUMP26" in op:
                    callees[re.sub(r"[-+]0x[0-9a-f]+$", "", args.strip())] += 1
                continue
            n += 1; (mn_rust if rust else mn_asm)[op] += 1
            t = re.match(r"^(?:.*,\s*)?(?:0x)?([0-9a-f]+) <", args)
            if (op.startswith(("j", "b", "cb", "tb", "loop")) and op not in ("bl", "blr", "bic", "bics", "bfi", "bfxil", "bsf", "bsr", "bt", "bswap", "blsr", "blsi", "bextr", "bzhi", "br")) and t and int(t.group(1), 16) <= at:
                back += 1
            if op in ("call", "bl"): calls += 1
            if (op in ("jmp", "call") and "<" not in args) or op in ("br", "blr"): ind += 1
    close()
rust = [f for f in funcs if f[6]]; asm = [f for f in funcs if not f[6]]
def total(fs, i): return sum(f[i] for f in fs)
summary = {
    "functions": {"rust": len(rust), "assembly": len(asm)},
    "instructions": {"rust": total(rust, 2), "assembly": total(asm, 2)},
    "backward branches (loops)": {"rust": total(rust, 3), "assembly": total(asm, 3)},
    "calls": {"rust": total(rust, 4), "assembly": total(asm, 4)},
    "indirect jumps and calls": {"rust": total(rust, 5), "assembly": total(asm, 5)},
    "distinct mnemonics": {"rust": len(mn_rust), "assembly": len(mn_asm), "both": len(set(mn_rust) | set(mn_asm))},
    "rust functions with no backward branch": sum(1 for f in rust if f[3] == 0),
    "rust functions of at most 100 instructions": sum(1 for f in rust if f[2] <= 100),
}
json.dump({"summary": summary, "mnemonics_rust": mn_rust.most_common(), "mnemonics_assembly": mn_asm.most_common(),
           "callees": callees.most_common(), "functions": sorted(funcs, key=lambda f: -f[2])}, open(out + "/inventory.json", "w"), indent=1)
with open(out + "/summary.txt", "w") as f:
    for k, v in summary.items(): f.write(f"{k}: {v}\n")
    f.write("\nrust mnemonics: " + " ".join(f"{m}:{c}" for m, c in mn_rust.most_common()) + "\n")
    f.write("\nassembly mnemonics: " + " ".join(f"{m}:{c}" for m, c in mn_asm.most_common()) + "\n")
    f.write("\ncalled, not by a direct address in the same object (top 60):\n" + "\n".join(f"  {c:5} {n}" for n, c in callees.most_common(60)) + "\n")
    f.write("\nlargest Rust functions:\n" + "\n".join(f"  {x[2]:6} insns {x[3]:3} loops {x[4]:3} calls  {x[1][:110]}" for x in sorted(rust, key=lambda f: -f[2])[:40]) + "\n")
print(open(out + "/summary.txt").read()[:3000])
INVENTORY_PY
python3 "$R/inventory.py" "$O"
echo "inventory done" > "$O/status.txt"
