#!/bin/bash
# How much of the core crate's machine code changes when only the compiler changes (BLAKE3 #361):
# a proof about the bytes has to be made again for every function whose bytes move. The same commit,
# release build, by several rustc versions; for each compiled function its instruction text (addresses
# removed), a hash of it, and the full listings of the functions already proved.
set -uo pipefail
R="$1";O="$R/out";mkdir -p "$O";export HOME=/root;. <home>/.cargo/env
export CARGO_INCREMENTAL=0
cd "$R/library"
{ echo "library $(git rev-parse HEAD)"; rustc -Vv | grep -E '^(rustc|host)'; } > "$O/identity.txt"
cat > "$R/functions.py" <<'FUNCTIONS_PY'
import glob, hashlib, json, re, subprocess, sys
out, tag = sys.argv[1], sys.argv[2]
keep = re.compile(r"CvStack>::merge|Hash>::to_hex|hasher::parent_output|Output<.*>>::chaining_value|hasher::final_node|hasher::feed|hasher::fill|read_x86_features|ChunkState<.*>>::absorb")
def norm(t):
    """An instruction's text without what any rebuild renames: LLVM's suffixes on private names and
    the hash and number in an unnamed constant's name."""
    t = re.sub(r"\s+", " ", t)
    t = re.sub(r"\s*\(\.llvm\.\d+\)", "", t)
    t = re.sub(r"(?:\.L)?anon\.[0-9a-f]+\.\d+(?:\.llvm\.\d+)?", "anon", t)
    return re.sub(r"\.llvm\.\d+", "", t)
funcs = {}
for obj in sorted(glob.glob("*.rcgu.o")):
    text = subprocess.run(["llvm-objdump", "-d", "-r", "-C", "-M", "intel", "--no-show-raw-insn", obj], capture_output=True, text=True).stdout
    name, lines = None, []
    def close():
        if name is not None and lines:
            funcs[name] = lines[:]
    for line in text.splitlines():
        m = re.match(r"^[0-9a-f]+ <(.+)>:$", line)
        if m:
            close(); name, lines = re.sub(r" \(\.llvm\.\d+\)", "", m.group(1)), []; continue
        m = re.match(r"^\s*[0-9a-f]+:\s+(\S.*)$", line)
        if m and name is not None:
            lines.append(norm(m.group(1)))
    close()
rows = {}
for name, lines in funcs.items():
    insns = [l for l in lines if not l.startswith("R_X86_64")]
    rows[name] = {"instructions": len(insns), "sha256": hashlib.sha256("\n".join(lines).encode()).hexdigest()}
    if keep.search(name):
        safe = re.sub(r"[^A-Za-z0-9_]", "_", name)[:70]
        with open(f"{out}/{tag}--{safe}.s", "w") as f:
            f.write("\n".join(lines) + "\n")
# the kept functions once more, as llvm-objdump prints them with their bytes, for the lifters
for obj in sorted(glob.glob("*.rcgu.o")):
    text = subprocess.run(["llvm-objdump", "-d", "-r", "-C", "-M", "intel", obj], capture_output=True, text=True).stdout
    for block in re.split(r"\n(?=[0-9a-f]+ <)", text):
        m = re.match(r"^[0-9a-f]+ <(.+)>:", block)
        if m and keep.search(m.group(1)):
            safe = re.sub(r"[^A-Za-z0-9_]", "_", re.sub(r" \(\.llvm\.\d+\)", "", m.group(1)))[:70]
            with open(f"{out}/{tag}--{safe}.listing", "w") as f:
                f.write(block.rstrip() + "\n")
with open(f"{out}/functions-{tag}.json", "w") as f:
    json.dump(rows, f, indent=0, sort_keys=True)
import gzip
with gzip.open(f"{out}/text-{tag}.json.gz", "wt") as f:
    json.dump(funcs, f)
print(tag, len(rows), "functions", sum(r["instructions"] for r in rows.values()), "instructions")
FUNCTIONS_PY
: > "$O/toolchains.txt"
for T in ${TOOLCHAINS:-1.99.1 1.99.0 1.98.0 1.97.0 1.96.0 beta nightly}; do
  if ! rustup toolchain install "$T" --profile minimal > "$O/install-$T.log" 2>&1 < /dev/null; then echo "$T: not installed" >> "$O/toolchains.txt"; continue; fi
  V=$(rustc "+$T" -V 2>/dev/null || echo unknown)
  if ! CARGO_TARGET_DIR="$R/target-$T" cargo "+$T" build --release > "$O/build-$T.log" 2>&1 < /dev/null; then echo "$T: $V: the crate does not build" >> "$O/toolchains.txt"; continue; fi
  rm -rf "$R/x-$T"; mkdir -p "$R/x-$T"; lib=$(ls "$R/target-$T"/release/lib*.rlib | head -n 1); cp "$lib" "$R/x-$T/"
  (cd "$R/x-$T" && ar x "$(basename "$lib")" && python3 "$R/functions.py" "$O" "$T") >> "$O/toolchains.txt" 2>&1
  echo "$T: $V" >> "$O/toolchains.txt"
done
python3 - "$O" <<'COMPARE_PY' > "$O/summary.txt" 2>&1
import glob, json, os, sys
out = sys.argv[1]
base = json.load(open(f"{out}/functions-1.99.1.json"))
print(f"1.99.1: {len(base)} functions, {sum(r['instructions'] for r in base.values())} instructions")
for path in sorted(glob.glob(f"{out}/functions-*.json")):
    tag = os.path.basename(path)[len("functions-"):-len(".json")]
    if tag == "1.99.1": continue
    other = json.load(open(path))
    both = [n for n in base if n in other]
    same = [n for n in both if base[n]["sha256"] == other[n]["sha256"]]
    same_n = sum(base[n]["instructions"] for n in same)
    print(f"{tag}: {len(other)} functions; {len(both)} names in both; {len(same)} of them the same instructions ({same_n} instructions); "
          f"{len(both) - len(same)} differ; {len(base) - len(both)} only in 1.99.1; {len(other) - len(both)} only in {tag}")
COMPARE_PY
cat "$O/summary.txt"
echo "compilers compared" > "$O/status.txt"
