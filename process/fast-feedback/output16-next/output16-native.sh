#!/bin/bash
set -euo pipefail
R="$1"
mkdir -p "$R/out"
cd "$R/fork"
export HOME=/root
. /root/.cargo/env
export CARGO_TARGET_DIR="$R/target"
{
    echo "library $(git rev-parse HEAD)"
    echo "reviewed $(git -C "$R/frozen" rev-parse HEAD)"
    rustc -Vv
    uname -m
} > "$R/out/identity.txt"
for file in c/blake3_output16.S tools/gen_output16.py tools/verify/prove_output.py; do
    cmp "$R/fork/$file" "$R/frozen/$file"
    echo "reviewed bytes unchanged: $file" >> "$R/out/frozen.txt"
done
timeout -k 5s 15s cargo fmt --all -- --check > "$R/out/fmt.log" 2>&1
timeout -k 5s 15s python3 tools/gen_output16.py | cmp - c/blake3_output16.S
timeout -k 5s 240s cargo nextest run --release --features serde,zeroize --lib --tests --no-fail-fast > "$R/out/tests.log" 2>&1
timeout -k 5s 60s cargo build --release --no-default-features > "$R/out/no-std.log" 2>&1
timeout -k 5s 90s cargo test --release --doc --features serde,zeroize > "$R/out/docs.log" 2>&1
RUSTDOCFLAGS='-D warnings' timeout -k 5s 90s cargo doc --no-deps --features serde,zeroize > "$R/out/rustdoc.log" 2>&1
printf 'output16 native validation complete\n' > "$R/out/status.txt"
if [[ ${PINNED_RUN_PREFLIGHT:-0} == 1 ]]; then
    printf 'pinned-run preflight complete\n' > "$R/out/preflight.txt"
fi
