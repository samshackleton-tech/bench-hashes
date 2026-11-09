#!/bin/bash
set -euo pipefail
exec timeout -k 5s 900s bash -s -- "$1" <<'FORMAL_COST_JOB'
set -euo pipefail
R="$1";O="$R/out";mkdir -p "$O";. /root/.cargo/env
{ for repo in old new bench evidence;do echo "$repo $(git -C "$R/$repo" rev-parse HEAD)";done;rustc -Vv;python3 --version;python3 -c 'import z3;print(z3.get_full_version(),z3.__file__)';clang --version; } > "$O/identity.txt"
for path in c c2sp;do diff -qr "$R/old/$path" "$R/new/$path" > "$O/unchanged-$path.txt";done
for path in canon.py terms.py prove_hybrid.py prove_x86.py x86.py aarch64.py;do cmp "$R/old/tools/verify/$path" "$R/new/tools/verify/$path";done
cat > "$R/worker.py" <<'PY_WORKER'
import argparse,ctypes,hashlib,json,resource,struct,sys,traceback
from pathlib import Path
p=argparse.ArgumentParser();p.add_argument('source',type=Path);p.add_argument('library');p.add_argument('shape');a=p.parse_args()
sys.path.insert(0,str(a.source/'tools/verify'))
import z3
import lean_spec as spec
assert Path(spec.__file__).resolve().is_relative_to(a.source.resolve())
expected_source=hashlib.sha256((a.source/'tools/verify/lean_spec.py').read_bytes()).hexdigest()
assert hashlib.sha256(Path(spec.__file__).read_bytes()).hexdigest()==expected_source
proof=None
if a.shape in ['compress','chunk16']:
 import prove_x86 as proof
 case=('avx512','compress',None) if a.shape=='compress' else ('avx512','hash_many',(16,16,True))
 so=proof.assemble('avx512');syms=proof.x86.symbols(so);proof.x86.image(so)
 name='blake3_servil_compress_in_place_avx512' if a.shape=='compress' else 'blake3_servil_hash_many_avx512'
 proof.x86.disassemble(so,syms[name],proof.x86.text_end(so))
lib=ctypes.CDLL(a.library);callback=ctypes.CFUNCTYPE(None)
lib.measure_proof.argtypes=[callback,ctypes.POINTER(ctypes.c_uint64)];lib.measure_proof.restype=ctypes.c_uint8
result={};errors=[]
@callback
def work():
 try:
  if a.shape=='fail':raise RuntimeError('planted measurement payload failure')
  if a.shape=='substitution64':
   answers=[]
   for i in range(64):
    cv=[z3.BitVecVal((i*137+j*1234567)&0xffffffff,32) for j in range(8)]
    block=[z3.BitVecVal((i*391+j*1000003)&0xffffffff,32) for j in range(16)]
    words=spec.compress(cv,block,z3.BitVecVal(((i+1)<<40)|i,64),z3.BitVecVal(i%65,32),z3.BitVecVal((i*13)&127,32))
    assert len(words)==16
    answers.append(words)
   result['answers']=answers
   result['verdict']='64 complete compression-reference substitutions'
  else:
   actual,verdict=proof.prove_case(case)
   assert actual==case and verdict.startswith('proved ('),(actual,verdict)
   result['verdict']=verdict
 except BaseException:
  errors.append(traceback.format_exc())
values=(ctypes.c_uint64*8)()
assert lib.measure_proof(work,values)==1,'proof-thread hardware counters unavailable'
if errors:
 print(errors[0],file=sys.stderr);raise SystemExit(1)
if a.shape=='substitution64':
 words=[z3.simplify(w).as_long() for w in result.pop('answers')[-1]]
 result['semantic_fingerprint']=hashlib.sha256(struct.pack('<16I',*words)).hexdigest()
result.update(shape=a.shape,loaded_source_sha256=expected_source,wall_ns=values[0],cpu_ns=values[1],p_cycles=values[2],p_instructions=values[3],e_cycles=values[4],e_instructions=values[5],p_time_ns=values[6],e_time_ns=values[7],max_rss_bytes=resource.getrusage(resource.RUSAGE_SELF).ru_maxrss*1024)
print(json.dumps(result,sort_keys=True))
PY_WORKER
pids=()
for pair in 1 2 3 4;do
 (
 P="$R/native-$pair";mkdir -p "$P/src"
 printf '[package]\nname="proof_measure"\nversion="0.1.0"\nedition="2021"\n[lib]\nname="proofclocks"\ncrate-type=["cdylib"]\n[[bin]]\nname="proof-child"\npath="src/main.rs"\n[dependencies]\nclocks={path="%s/bench/clocks"}\n' "$R" > "$P/Cargo.toml"
 cat > "$P/src/lib.rs" <<'RUST_LIBRARY'
// Benchmark-only callback bridge. The caller owns eight aligned writable
// u64s and a live non-unwinding C callback on this proof thread.
#[unsafe(no_mangle)]
pub unsafe extern "C" fn measure_proof(call: extern "C" fn(), output: *mut u64) -> u8 {
    let Some(before) = clocks::Counts::read() else { return 0 };
    let cpu = clocks::process_cpu_ns();
    let start = clocks::now();
    call();
    let wall = clocks::since_ns(start);
    let cpu = clocks::process_cpu_ns() - cpu;
    let Some(after) = clocks::Counts::read() else { return 0 };
    let c = after.since(before);
    let values = [wall, cpu, c.p.cycles, c.p.instructions, c.e.cycles, c.e.instructions, c.p.time_ns, c.e.time_ns];
    // Sound: the benchmark's ctypes uint64[8] is live, disjoint and aligned.
    unsafe { std::ptr::copy_nonoverlapping(values.as_ptr(), output, values.len()) };
    1
}
RUST_LIBRARY
 cat > "$P/src/main.rs" <<'RUST_CHILD'
use std::{fs::File, process::{Command, Stdio}};
fn main() {
    let a: Vec<_> = std::env::args().skip(1).collect();
    assert!(a.len() >= 3);
    clocks::load::tick();
    if let Err(reason) = clocks::load::quiet_for(1) { eprintln!("proof measurement abstained: {reason}"); std::process::exit(2); }
    clocks::load::tick();
    let mut c = Command::new(&a[2]);
    c.args(&a[3..]).stdout(Stdio::from(File::create(&a[0]).unwrap())).stderr(Stdio::from(File::create(&a[1]).unwrap()));
    let r = clocks::child::run(&mut c);
    let windows = clocks::load::windows();
    assert!(!windows.is_empty());
    eprintln!("load: {}", clocks::load::describe(&windows));
    println!("process_wall_ns={} process_cpu_ns={:?} max_rss_bytes={:?} storage_read_bytes={:?} major_faults={:?} success={}", r.wall_ns, r.cpu_ns, r.max_rss_bytes, r.storage_read_bytes, r.major_faults, r.success);
    if !r.success { eprintln!("measurement payload failed"); std::process::exit(1); }
    if windows.iter().any(|w| w.busy()) { std::process::exit(2); }
}
RUST_CHILD
 CARGO_TARGET_DIR="$R/native-target-$pair" RUSTFLAGS="-C metadata=formal_$pair" cargo build --release --manifest-path "$P/Cargo.toml" > "$O/build-native-$pair.log" 2>&1
 for side in old new;do
  D="$R/source-$side-$pair";mkdir -p "$D";cp -a "$R/$side/tools" "$R/$side/c" "$R/$side/c2sp" "$D/"
  python3 -m compileall -q -f "$D/tools/verify"
 done
 ) &
 pids+=("$!")
done
failed=0;for pid in "${pids[@]}";do if ! wait "$pid";then failed=1;fi;done;test "$failed" = 0
set +e
taskset -c 2 "$R/native-target-1/release/proof-child" "$O/control.json" "$O/control-python.err" python3 "$R/worker.py" "$R/source-new-1" "$R/native-target-1/release/libproofclocks.so" fail > "$O/control-process.txt" 2> "$O/control-load.err"
s=$?
set -e
test "$s" = 1;grep -q 'planted measurement payload failure' "$O/control-python.err";grep -q 'measurement payload failed' "$O/control-load.err"
printf 'failed Python callback propagates through clocks child\n' > "$O/control-status.txt"
for shape in substitution64 compress chunk16;do
 for pair in 1 2 3 4;do
  sides='old new';[ "$((pair%2))" != 0 ] || sides='new old'
  for side in $sides;do
   tag="$side-$pair-$shape"
   timeout -k 5s 120s taskset -c 2 "$R/native-target-$pair/release/proof-child" "$O/$tag.json" "$O/$tag-python.err" python3 "$R/worker.py" "$R/source-$side-$pair" "$R/native-target-$pair/release/libproofclocks.so" "$shape" > "$O/$tag-process.txt" 2> "$O/$tag-load.err"
  done
 done
done
python3 - "$R" <<'COLLECT'
from pathlib import Path
import json,sys
r=Path(sys.argv[1]);o=r/'out'
for pair in range(1,5):
 fingerprints=[]
 for side in ['old','new']:
  with(o/f'{side}-{pair}.tsv').open('w')as f:
   print('shape\titems\tbytes\talgorithm\tcalls\twall_ns\tcpu_ns\tcycles\tinstructions\tpackage_nj',file=f)
   for shape in ['substitution64','compress','chunk16']:
    x=json.loads((o/f'{side}-{pair}-{shape}.json').read_text());assert x['wall_ns']>0 and x['p_cycles']+x['e_cycles']>0
    print(shape,1,0,'proof',1,x['wall_ns'],x['cpu_ns'],x['p_cycles']+x['e_cycles'],x['p_instructions']+x['e_instructions'],'NA',sep='\t',file=f)
    if shape=='substitution64':fingerprints.append(x['semantic_fingerprint'])
 assert len(set(fingerprints))==1,'semantic fingerprint changed'
p=r/'evidence/process/fast-feedback/ring-closure/r88/sampler-2355/mixed-stage-costs.sh';s=p.read_text();assert __import__('hashlib').sha256(p.read_bytes()).hexdigest()=='3a0595df2a83d2c2c42b5decf50ebad56449f26d82721ac3c32ba89cdd3782cb';start=s.index("<<'JUDGE_EOF'\n")+len("<<'JUDGE_EOF'\n");stop=s.index('\nJUDGE_EOF',start)
(r/'judge/src').mkdir(parents=True);(r/'judge/src/main.rs').write_text(s[start:stop]+'\n');(r/'judge/Cargo.toml').write_text('[package]\nname="proof_judge"\nversion="0.1.0"\nedition="2021"\n[dependencies]\nclocks={path="'+str(r/'bench/clocks')+'"}\n')
COLLECT
CARGO_TARGET_DIR="$R/judge-target" cargo test --release --manifest-path "$R/judge/Cargo.toml" > "$O/judge-tests.log" 2>&1
CARGO_TARGET_DIR="$R/judge-target" cargo run --release --manifest-path "$R/judge/Cargo.toml" -- "$O" proof > "$O/judgments.tsv" 2> "$O/judge.log"
for side in old new bench evidence;do test -z "$(git -C "$R/$side" status --porcelain)";done
printf 'proof case matrix complete; core cycles/wall through clocks; fresh private source/bytecode/native-adapter pairs; assembly/disassembly imports prepared outside proof counters; RSS includes preparation\n' > "$O/status.txt"
FORMAL_COST_JOB
