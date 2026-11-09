#!/bin/bash
set -euo pipefail
exec timeout -k 5s 240s bash -s -- "$1" <<'PROFILE_JOB'
set -euo pipefail
R="$1";O="$R/out";mkdir -p "$O" "$R/tmp" "$R/native/src";. /root/.cargo/env
{ echo "library $(git -C "$R/library" rev-parse HEAD)";echo "bench $(git -C "$R/bench" rev-parse HEAD)";echo "evidence $(git -C "$R/evidence" rev-parse HEAD)";rustc -Vv;python3 --version;perf --version; } > "$O/identity.txt"
S="$R/evidence/process/fast-feedback/formal-substitution/substitution-costs.sh"
python3 - "$R" "$S" <<'EXTRACT'
from pathlib import Path
import hashlib,subprocess,sys
r=Path(sys.argv[1]);p=Path(sys.argv[2]);data=p.read_bytes();assert hashlib.sha256(data).hexdigest()=='9085bbe6f776392215a05c953e98f17214f45399512220aaeee464a325072486';s=data.decode()
def body(tag):
 a=s.index("<<'"+tag+"'\n")+len(tag)+5;return s[a:s.index('\n'+tag,a)]+'\n'
(r/'worker.py').write_text(body('PY_WORKER'));(r/'native/src/lib.rs').write_text(body('RUST_LIBRARY'));(r/'native/src/main.rs').write_text(body('RUST_CHILD'))
p=r/'worker.py';old='   actual,verdict=proof.prove_case(case)';new='''   # Instruction sampling, enabled only around this useful proof case.
   import os
   with open(os.environ['PROOF_PERF_CONTROL'],'w',buffering=1) as control, open(os.environ['PROOF_PERF_ACK'],'rb',buffering=0) as ack:
    def command(value):
     control.write(value+'\\n');control.flush()
     # Linux perf writes sizeof("ack newline"), including its terminating NUL.
     reply=ack.read(5);assert reply==bytes([97,99,107,10,0]),repr(reply)
     result.setdefault('perf_acks',[]).append(reply.hex())
    command('enable')
    try:actual,verdict=proof.prove_case(case)
    finally:command('disable')'''
assert p.read_text().count(old)==1
(r/'old.txt').write_text(old);(r/'new.txt').write_text(new)
subprocess.run(['/usr/local/bin/replace','-f',str(p),str(r/'old.txt'),str(r/'new.txt')],check=True,stdout=subprocess.DEVNULL)
compile(p.read_text(),'profile-worker','exec');(r/'out/profile-worker.py').write_bytes(p.read_bytes())
(r/'native/Cargo.toml').write_text('[package]\nname="proof_measure"\nversion="0.1.0"\nedition="2021"\n[lib]\nname="proofclocks"\ncrate-type=["cdylib"]\n[[bin]]\nname="proof-child"\npath="src/main.rs"\n[dependencies]\nclocks={path="'+str(r/'bench/clocks')+'"}\n')
EXTRACT
CARGO_TARGET_DIR="$R/target" cargo build --release --manifest-path "$R/native/Cargo.toml" > "$O/build.log" 2>&1
mkfifo "$R/tmp/control" "$R/tmp/ack"
exec {control_hold}<>"$R/tmp/control"
exec {ack_hold}<>"$R/tmp/ack"
export PROOF_PERF_CONTROL="$R/tmp/control" PROOF_PERF_ACK="$R/tmp/ack"
# Sample retired instructions, not an alternate timing clock. The existing
# clocks callback/child records wall/CPU/core cycles for this diagnostic.
perf record -e instructions:u -c 100000000 --call-graph dwarf,8192 --delay=-1 --control="fifo:$PROOF_PERF_CONTROL,$PROOF_PERF_ACK" -o "$R/tmp/perf.data" -- taskset -c 2 "$R/target/release/proof-child" "$O/proof.json" "$O/python.err" python3 "$R/worker.py" "$R/library" "$R/target/release/libproofclocks.so" chunk16 > "$O/process.txt" 2> "$O/load-perf.err"
perf report -i "$R/tmp/perf.data" --stdio --no-children --show-nr-samples --sort symbol,dso --percent-limit 0 > "$O/instruction-profile.txt" 2> "$O/report.err"
perf script -i "$R/tmp/perf.data" --ns > "$O/instruction-stacks.txt" 2> "$O/script.err"
python3 - "$R" <<'VERIFY'
from pathlib import Path
import hashlib,json,subprocess,sys
r=Path(sys.argv[1]);o=r/'out';data=json.loads((o/'proof.json').read_text());assert data['shape']=='chunk16'and data['verdict'].startswith('proved (hash_many, 16 inputs of 16 blocks');assert data['p_cycles']>0 and data['p_instructions']>0;assert data['perf_acks']==['61636b0a00','61636b0a00']
assert data['loaded_source_sha256']==hashlib.sha256((r/'library/tools/verify/lean_spec.py').read_bytes()).hexdigest();assert 'success=true'in(o/'process.txt').read_text();assert 'busiest window'in(o/'load-perf.err').read_text();assert len((o/'instruction-stacks.txt').read_text().splitlines())>100
for repo in ['library','bench','evidence']:assert not subprocess.check_output(['git','-C',str(r/repo),'status','--porcelain'],text=True)
(o/'status.txt').write_text('instruction-profile complete; existing clocks measurement bridge/child retained; sampling enabled only around full useful proof; retired-instruction attribution, not elapsed-time percentages or a speed comparison; binary profile retained locally outside published text\n')
VERIFY
PROFILE_JOB
