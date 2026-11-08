#!/bin/bash
set -euo pipefail
exec timeout -k 5s 240s bash -s -- "$1" <<'JOB'
set -euo pipefail
R="$1"
mkdir -p "$R/out" "$R/probe/src"
export HOME=/root
. /root/.cargo/env
export CARGO_TARGET_DIR="$R/target"
NEW=ddb7199d7f0b0f04390e923474b630ffc7ff2811
test "$(git -C "$R/fork" rev-parse HEAD)" = "$NEW"
{ echo "library $NEW";rustc -Vv;uname -m;} > "$R/out/identity.txt"
printf '[package]\nname="pipeline-forget-audit"\nversion="0.0.0"\nedition="2024"\n[dependencies]\nblake3-servil={path="%s/fork"}\n' "$R" > "$R/probe/Cargo.toml"
# Compile-only: every function is type-checked, none is called or polled.
write() {
cat > "$R/probe/src/lib.rs" <<RS
use blake3_servil::{Mode, throughput::{Batch, Block, pipeline::{Event, Limits, Stream}}};
#[allow(dead_code)]
async fn borrowed_batch_then_release_storage() {
    let mut blocks = vec![Block::ZERO; 2];
    let mut places = [[0u8; 32]; 2];
    let s = Stream::new(Mode::Plain, Limits { buffers: 4, messages: 4 }, |_: Event<'_, u8>| {});
    s.submit_batch(Batch::from_blocks(&blocks, 64), &mut places, 0).await;
    $1
    blocks.fill(Block([1; 64]));
    drop(blocks);
    places[0] = [1; 32];
    $2
}
RS
}
write 'std::mem::forget(s);' ''
cargo check --manifest-path "$R/probe/Cargo.toml" > "$R/out/forget-witness.log" 2>&1
echo 'forgotten pipeline: borrowed batch/places released after submission; type-checks, never polled' >> "$R/out/forget-witness.log"
write '' 's.finish();'
set +e
cargo check --manifest-path "$R/probe/Cargo.toml" > "$R/out/borrow-control.log" 2>&1
status=$?
set -e
test "$status" = 101
grep -E 'error\[E05(02|05|06)\]' "$R/out/borrow-control.log" > /dev/null
echo 'control: the same release before finish is rejected by the borrow checker' >> "$R/out/borrow-control.log"
test -z "$(git -C "$R/fork" status --porcelain)"
printf 'pipeline forget witness compiles; finishing control rejected; nothing polled or executed\n' > "$R/out/status.txt"
JOB
