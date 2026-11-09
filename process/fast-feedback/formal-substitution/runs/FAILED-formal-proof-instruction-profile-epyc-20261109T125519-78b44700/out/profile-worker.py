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
   # Instruction sampling, enabled only around this useful proof case.
   import os
   with open(os.environ['PROOF_PERF_CONTROL'],'w',buffering=1) as control, open(os.environ['PROOF_PERF_ACK'],'r') as ack:
    def command(value):
     control.write(value+'\n');control.flush();assert ack.readline().strip()=='ack'
    command('enable')
    try:actual,verdict=proof.prove_case(case)
    finally:command('disable')
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
