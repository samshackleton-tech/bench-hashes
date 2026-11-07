#!/bin/bash
set -euo pipefail
R="$1";O="$R/out";mkdir -p "$O";export HOME=/root;. /root/.cargo/env
{ date -u;uname -a;rustc --version;for repo in old new;do echo "$repo $(git -C "$R/$repo" rev-parse HEAD)";done; } > "$O/identity.txt"
for side in old new;do
 P="$R/probe-$side";mkdir -p "$P/src"
 printf '[package]\nname="incrementalroots"\nversion="0.1.0"\nedition="2021"\n[dependencies]\nblake3-servil={path="%s/%s"}\n' "$R" "$side" > "$P/Cargo.toml"
 printf 'fn main(){blake3_servil::initialize();let mut h:Vec<_>=(0..16).map(|_|blake3_servil::throughput::Hasher::new(blake3_servil::Mode::Plain)).collect();for h in &mut h{h.update(std::hint::black_box(&[7u8;64]));}let mut out=[[0u8;32];16];blake3_servil::throughput::finalize_each(std::hint::black_box(&h),std::hint::black_box(&(0..16).collect::<Vec<_>>()),&mut out);std::hint::black_box(out);}\n' > "$P/src/main.rs"
 (cd "$P" && CARGO_TARGET_DIR="$R/target-$side" RUSTFLAGS='-C metadata=incrementalroots_1' cargo build --release && cargo tree -p blake3-servil --depth 0) > "$O/build-$side.log" 2>&1
 nm -S -C "$R/target-$side/release/incrementalroots" > "$O/symbols-$side.txt"
 objdump -C -d --no-show-raw-insn "$R/target-$side/release/incrementalroots" > "$R/disasm-$side.txt"
 python3 - "$R/disasm-$side.txt" "$O/disasm-$side.txt" <<'PY'
import sys
from pathlib import Path
s=Path(sys.argv[1]).read_text().splitlines();keep=False;out=[]
for line in s:
 if line.endswith('>:'):
  keep=any(x in line for x in ['blake3_servil::each::finalize','blake3_servil::ffi_output::hash_group','blake3_servil_output16'])
 if keep:out.append(line)
Path(sys.argv[2]).write_text('\n'.join(out)+'\n')
PY
done
echo 'output8 code inspection done' > "$O/status.txt"
