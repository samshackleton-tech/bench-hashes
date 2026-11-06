#!/bin/bash
set -euo pipefail
R="$1"; O="$R/out"; mkdir -p "$O"; cd "$R/fork"
export HOME=/root; . /root/.cargo/env
export CARGO_TARGET_DIR="$R/target"
echo "library $(git rev-parse HEAD)" > "$O/identity.txt"
python3 - "$O" <<'CONTROL_EOF'
import pathlib,re,subprocess,sys
out=pathlib.Path(sys.argv[1]);p=pathlib.Path('src/ffi_last.rs');source=p.read_text()
i=source.index('fn byte_mask(');j=source.index('\n}\n',i)+3;old=source[i:j]
cmd=['cargo','nextest','run','--features','serde,zeroize','--lib','-E','test(test_byte_last_blocks_against_a_guard_page)']
r=subprocess.run(cmd,capture_output=True,text=True,timeout=180);(out/'positive.log').write_text(r.stdout+r.stderr);assert r.returncode==0
p.write_text(source.replace(old,'fn byte_mask(_len: u32) -> u64 { u64::MAX }\n'))
try:
 r=subprocess.run(cmd,capture_output=True,text=True,timeout=180);text=r.stdout+r.stderr;(out/'fault.log').write_text(text)
 assert r.returncode!=0 and 'SIGSEGV' in text,'bad mask must fault on the guard page, not merely fail to build\n'+text[-2000:]
finally:p.write_text(source)
print('zero-length boundary faults with an all-ones mask; positive control passes')
CONTROL_EOF
echo 'byte guard control done' > "$O/status.txt"
