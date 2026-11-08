#!/bin/bash
set -euo pipefail
R="$1"
mkdir -p "$R/out"
export HOME=/root
. /root/.cargo/env
export CARGO_TARGET_DIR="$R/target"
cd "$R/fork"
{
    echo "library $(git rev-parse HEAD)"
    echo "reviewed16 $(git -C "$R/frozen16" rev-parse HEAD)"
    echo "reviewed8 $(git -C "$R/frozen8" rev-parse HEAD)"
    rustc -Vv
    uname -m
} > "$R/out/identity.txt"
for width in 16 8;do
    for file in "c/blake3_output$width.S" "tools/gen_output$width.py" "tools/verify/prove_output$width.py";do
        # The sixteen-lane proof retains its original name.
        [ "$file" != tools/verify/prove_output16.py ] || file=tools/verify/prove_output.py
        cmp "$R/fork/$file" "$R/frozen$width/$file"
        echo "reviewed bytes unchanged: $file" >> "$R/out/frozen.txt"
    done
    timeout -k 5s 15s python3 "tools/gen_output$width.py" | cmp - "c/blake3_output$width.S"
done
timeout -k 5s 15s cargo fmt --all -- --check > "$R/out/fmt.log" 2>&1
timeout -k 5s 240s cargo nextest run --release --features serde,zeroize --lib --tests --no-fail-fast > "$R/out/tests.log" 2>&1
timeout -k 5s 60s cargo build --release --no-default-features > "$R/out/no-std.log" 2>&1
timeout -k 5s 90s cargo test --release --doc --features serde,zeroize > "$R/out/docs.log" 2>&1
RUSTDOCFLAGS='-D warnings' timeout -k 5s 90s cargo doc --no-deps --features serde,zeroize > "$R/out/rustdoc.log" 2>&1
printf 'output8 native validation complete\n' > "$R/out/status.txt"
if [[ ${PINNED_RUN_PREFLIGHT:-0} == 1 ]];then printf 'pinned-run preflight complete\n' > "$R/out/preflight.txt";fi
