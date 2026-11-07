#!/bin/bash
set -euo pipefail
R="$1"; O="$R/out"; mkdir -p "$O"; cd "$R/fork"
export HOME=/root; . /root/.cargo/env
export CARGO_TARGET_DIR="$R/target"
echo "library $(git rev-parse HEAD)" > "$O/identity.txt"
cargo nextest run --features serde,zeroize --lib --tests --no-fail-fast > "$O/tests.log" 2>&1
cargo build --no-default-features > "$O/no-std.log" 2>&1
cargo test --doc --features serde,zeroize > "$O/docs.log" 2>&1
RUSTDOCFLAGS='-D warnings' cargo doc --no-deps --features serde,zeroize > "$O/rustdoc.log" 2>&1
echo 'native tests done' > "$O/status.txt"
