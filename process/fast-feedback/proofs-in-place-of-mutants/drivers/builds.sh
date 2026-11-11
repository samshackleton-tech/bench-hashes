#!/bin/bash
# Which build do the proved bytes belong to (BLAKE3 #361)? A Rust library is compiled by its user. The
# core crate's machine code under the settings a user may choose, compared function by function with
# the plain release build the proofs were made on: other codegen-units, opt-level, panic strategy,
# target-cpu, and a consumer program built with fat LTO (where the library's code is optimised again
# inside the program). Same compiler, same source.
set -uo pipefail
R="$1";O="$R/out";mkdir -p "$O";export HOME=/root;. <home>/.cargo/env
export CARGO_INCREMENTAL=0
cd "$R/library"
{ echo "library $(git rev-parse HEAD)"; rustc -Vv | grep -E '^(rustc|host)'; } > "$O/identity.txt"
cat > "$R/functions.py" <<'FUNCTIONS_PY'
import glob, gzip, json, re, subprocess, sys
out, tag, objs = sys.argv[1], sys.argv[2], sys.argv[3:]
def norm(t):
    t = re.sub(r"\s+", " ", t)
    t = re.sub(r"\s*\(\.llvm\.\d+\)", "", t)
    t = re.sub(r"(?:\.L)?anon\.[0-9a-f]+\.\d+(?:\.llvm\.\d+)?", "anon", t)
    t = re.sub(r"\.llvm\.\d+", "", t)
    return re.sub(r"Cs[0-9A-Za-z]{8,14}_", "Cs_", t)
funcs = {}
for obj in objs:
    text = subprocess.run(["llvm-objdump", "-d", "-r", "-C", "-M", "intel", "--no-show-raw-insn", obj], capture_output=True, text=True).stdout
    name, lines = None, []
    def close():
        if name is not None and lines and name not in funcs:
            funcs[name] = lines[:]
    for line in text.splitlines():
        m = re.match(r"^[0-9a-f]+ <(.+)>:$", line)
        if m:
            close(); name, lines = re.sub(r" \(\.llvm\.\d+\)", "", m.group(1)), []; continue
        m = re.match(r"^\s*[0-9a-f]+:\s+(\S.*)$", line)
        if m and name is not None:
            lines.append(norm(m.group(1)))
    close()
with gzip.open(f"{out}/text-{tag}.json.gz", "wt") as f:
    json.dump(funcs, f)
# the functions already proved, as llvm-objdump prints them with their bytes, for the lifters
keep = re.compile(r"CvStack>::merge|Hash>::to_hex|hasher::parent_output|Output<.*>>::chaining_value")
for obj in objs:
    text = subprocess.run(["llvm-objdump", "-d", "-r", "-C", "-M", "intel", obj], capture_output=True, text=True).stdout
    for block in re.split(r"\n(?=[0-9a-f]+ <)", text):
        m = re.match(r"^[0-9a-f]+ <(.+)>:", block)
        if m and keep.search(m.group(1)):
            safe = re.sub(r"[^A-Za-z0-9_]", "_", re.sub(r" \(\.llvm\.\d+\)", "", m.group(1)))[:60]
            with open(f"{out}/{tag}--{safe}.listing", "w") as f:
                f.write(block.rstrip() + "\n")
print(tag, len(funcs), "functions", sum(1 for ls in funcs.values() for l in ls if not l.startswith("R_X86_64")), "instructions")
FUNCTIONS_PY
: > "$O/builds.txt"
lib() {  # tag, then environment assignments for cargo
  local tag="$1"; shift
  if ! env "$@" CARGO_TARGET_DIR="$R/target-$tag" cargo build --release > "$O/build-$tag.log" 2>&1 < /dev/null; then echo "$tag: does not build" >> "$O/builds.txt"; return; fi
  rm -rf "$R/x-$tag"; mkdir -p "$R/x-$tag"; local l; l=$(ls "$R/target-$tag"/release/lib*.rlib | head -n 1); cp "$l" "$R/x-$tag/"
  (cd "$R/x-$tag" && ar x "$(basename "$l")" && python3 "$R/functions.py" "$O" "$tag" *.rcgu.o) >> "$O/builds.txt" 2>&1
}
lib release
lib release-again
lib codegen-units-1 CARGO_PROFILE_RELEASE_CODEGEN_UNITS=1
lib opt-level-2 CARGO_PROFILE_RELEASE_OPT_LEVEL=2
lib panic-abort CARGO_PROFILE_RELEASE_PANIC=abort
lib target-cpu-native RUSTFLAGS=-Ctarget-cpu=native
lib debug-assertions CARGO_PROFILE_RELEASE_DEBUG_ASSERTIONS=true
NAME=$(grep -m1 '^name' "$R/library/Cargo.toml" | sed 's/.*"\(.*\)".*/\1/'); CRATE=$(echo "$NAME" | tr - _)
mkdir -p "$R/p/src"; cd "$R/p"
cat > Cargo.toml <<TOML
[package]
name = "consumer"
version = "0.0.0"
edition = "2021"
[dependencies]
$NAME = { path = "$R/library" }
TOML
cat > src/main.rs <<RS
use $CRATE as b3;
fn main() {
    let input: Vec<u8> = std::env::args().nth(1).unwrap_or_default().into_bytes();
    let a = b3::hash_serial(&input, b3::IV, 0);
    let b = b3::hash_serial(&input[..input.len() / 2], b3::IV, 0);
    println!("{} {}", a.to_hex(), a == b);
}
RS
program() {  # tag, then environment assignments
  local tag="$1"; shift
  if ! env "$@" CARGO_TARGET_DIR="$R/ptarget-$tag" cargo rustc --release -- --emit=obj > "$O/build-$tag.log" 2>&1 < /dev/null; then echo "$tag: does not build" >> "$O/builds.txt"; return; fi
  python3 "$R/functions.py" "$O" "$tag" "$R/ptarget-$tag"/release/deps/consumer-*.o >> "$O/builds.txt" 2>&1
}
program program-plain
program program-fat-lto CARGO_PROFILE_RELEASE_LTO=fat
program program-fat-lto-cgu1 CARGO_PROFILE_RELEASE_LTO=fat CARGO_PROFILE_RELEASE_CODEGEN_UNITS=1
cat "$O/builds.txt"
echo "builds compared" > "$O/status.txt"
