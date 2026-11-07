#!/bin/bash
set -euo pipefail
R="$1";O="$R/out";mkdir -p "$O";export HOME=/root;. /root/.cargo/env
for side in old new;do echo "$side $(git -C "$R/$side" rev-parse HEAD)";done > "$O/identity.txt"
python3 - "$R" <<'IDENTITY_EOF'
from pathlib import Path
import hashlib,sys,json
R=Path(sys.argv[1]);maps=[]
for side in ['old','new']:
 d=R/side;paths=[d/'build.rs']+[p for top in ['c','tools']for p in (d/top).rglob('*')if p.is_file()];maps.append({str(p.relative_to(d)):hashlib.sha256(p.read_bytes()).hexdigest()for p in paths})
assert maps[0]==maps[1],'assembly/generator/proof/model snapshot changed'
(R/'out/unchanged-assembly-proof-model.json').write_text(json.dumps(maps[0],sort_keys=True,indent=2))
print('unchanged assembly/generator/proof/model files:',len(maps[0]))
IDENTITY_EOF
pids=()
for side in old new;do
 (
 P="$R/consumer-$side";mkdir -p "$P/src"
 printf '[package]\nname="parentinspect"\nversion="0.1.0"\nedition="2021"\n[dependencies]\nblake3-servil={path="%s/%s"}\n' "$R" "$side" > "$P/Cargo.toml"
 cat > "$P/src/main.rs" <<'CONSUMER_EOF'
use blake3_servil::{Mode,throughput::{self,Hasher}};
fn main(){blake3_servil::initialize();let keys=[[1u8;32],[2u8;32]];let mut hs:Vec<_>=keys.iter().map(|k|Hasher::new(Mode::Keyed(k))).collect();let data=vec![7u8;16384];for part in data.chunks(4096){throughput::update_each(&mut hs,std::hint::black_box(&[(0,part),(1,part)]));}let mut out=[[0u8;32];2];throughput::finalize_each(&hs,&[0,1],&mut out);println!("{:02x?}",out);}
CONSUMER_EOF
 (cd "$P";CARGO_TARGET_DIR="$R/target-$side" RUSTFLAGS='-C metadata=held_parent_inspect' cargo build --release) > "$O/build-$side.log" 2>&1
 E="$R/target-$side/release/parentinspect"
 size "$E" > "$O/size-$side.txt"
 nm -S --size-sort -C "$E" > "$O/symbols-$side.txt"
 objdump -d -C "$E" > "$O/disasm-$side.txt"
 "$E" > "$O/answers-$side.txt"
 ) &
 pids+=("$!")
done
failed=0;for pid in "${pids[@]}";do if ! wait "$pid";then failed=1;fi;done
[ "$failed" = 0 ]
cmp "$O/answers-old.txt" "$O/answers-new.txt"
echo 'held parent identities and size inspection done' > "$O/status.txt"
