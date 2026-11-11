#!/bin/bash
# The core crate's release build, disassembled whole (Intel syntax, relocations, bytes), for
# choosing real functions to prove (BLAKE3 #361).
set -euo pipefail
R="$1";O="$R/out";mkdir -p "$O";export HOME=/root;. <home>/.cargo/env
export CARGO_TARGET_DIR="$R/target" CARGO_INCREMENTAL=0
cd "$R/library"
{ echo "library $(git rev-parse HEAD)"; rustc -Vv | grep -E '^(rustc|host)'; } > "$O/identity.txt"
cargo build --release > "$O/build.log" 2>&1 < /dev/null
mkdir -p "$R/x"; lib=$(ls "$R"/target/release/lib*.rlib | head -n 1); cp "$lib" "$R/x/"; cd "$R/x"; ar x "$(basename "$lib")"
for o in *.rcgu.o; do llvm-objdump -d -r -C -M intel "$o" > "$O/$(echo "$o" | sed -E 's/^[^.]*\.[^.]*\.//').s"; done
(cd "$O" && tar -czf rust-disassembly.tgz *.s && rm -f *.s && ls -la rust-disassembly.tgz)
echo "dump done" > "$O/status.txt"
