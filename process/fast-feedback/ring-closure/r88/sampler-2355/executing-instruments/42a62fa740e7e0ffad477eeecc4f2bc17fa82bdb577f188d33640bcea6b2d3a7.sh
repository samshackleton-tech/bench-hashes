#!/bin/bash
set -euo pipefail
exec timeout -k 5s 540s bash -s -- "$1" <<'JOB'
set -euo pipefail
R="$1"
export HOME=/root
. /root/.cargo/env
export PINNED_RUN_PREFLIGHT=1
S="$R/evidence/process/fast-feedback/ring-closure/r88/sampler-2355/mixed-stage-costs.sh"
export SHARED_SAMPLER="$S"
mkdir -p "$R/out"
sha256sum "$S" > "$R/out/sampler-sha256.txt"
b3sum "$S" > "$R/out/sampler-blake3.txt"
test "$(sha256sum "$S" | cut -d ' ' -f1)" = 3a0595df2a83d2c2c42b5decf50ebad56449f26d82721ac3c32ba89cdd3782cb
bash "$S" "$R" > "$R/out/preflight-driver.log" 2>&1
CARGO_TARGET_DIR="$R/target-judge" cargo nextest run --release --manifest-path "$R/judge/Cargo.toml" -E 'test(per_item_rounds_with_integers)' > "$R/out/rounding-test.log" 2>&1
python3 - "$R" <<'PY'
from pathlib import Path
import subprocess,sys,os,csv
r=Path(sys.argv[1]);s=Path(os.environ['SHARED_SAMPLER']);family=os.environ['API_FAMILY'];feature=family+'-api'
expected='shape\titems\tbytes\talgorithm\tcalls\twall_ns\tcpu_ns\tcycles\tinstructions\tpackage_nj\n'
for side in ['old','new']:
 assert (r/f'out/preflight-{side}.txt').read_text()==expected
 log=(r/f'out/preflight-{side}.err').read_text()
 assert 'finalization_contract='+family+':' in log
 assert 'preflight: quiet wait and timing skipped' in log
 assert log.count('core_counts shape=')==192
 assert log.count('algorithm=finish')==64
 assert log.count('p_time_ns=NA')==192
 assert 'busy load window:' not in log
p=r/'probe-new-1';src=p/'src/main.rs';original=src.read_bytes();old=r/'out/digest-positive-source.rs';old.write_bytes(original)
needle='    let wanted: Vec<_> = data.iter().enumerate().map(|(i, d)| expected(which[i], flavor, &keys, d)).collect();'
text=original.decode();assert text.count(needle)==1
new=r/'out/digest-fault-source.rs';new.write_text(text.replace(needle,needle.replace('let wanted:', 'let mut wanted:')+'\n    wanted[0][0] ^= 1;'))
env=dict(os.environ,CARGO_TARGET_DIR=str(r/'target-new-1'),RUSTFLAGS='-C metadata=incrementalroots_1')
def build(args,log):
 with (r/'out'/log).open('w')as f:return subprocess.run(['cargo','build','--release','--manifest-path',str(p/'Cargo.toml')]+args,env=env,stdout=f,stderr=subprocess.STDOUT).returncode
for features,log in [([], 'no-api-feature.log'),(['--features','main-api,next-api'],'both-api-features.log')]:
 assert build(features,log)==101
 assert 'select exactly one finalization contract' in (r/'out'/log).read_text()
with (r/'out/digest-fault-diff.log').open('w')as f:subprocess.run(['replace','-f',str(src),str(old),str(new)],stdout=f,check=True)
try:
 assert build(['--features',feature],'digest-fault-build.log')==0
 for arg,message in [([], 'update canonical digest'),(['reverse'],'consume-once finish canonical digest')]:
  label='reverse' if arg else 'forward'
  with (r/f'out/digest-fault-{label}.out').open('w')as out,(r/f'out/digest-fault-{label}.err').open('w')as err:
   status=subprocess.run([str(r/'target-new-1/release/incrementalroots')]+arg,env=env,stdout=out,stderr=err).returncode
  assert status==101,(label,status)
  assert message in (r/f'out/digest-fault-{label}.err').read_text()
finally:
 with (r/'out/digest-fault-restore.log').open('w')as f:subprocess.run(['replace','-f',str(src),str(new),str(old)],stdout=f,check=True)
assert src.read_bytes()==original
assert build(['--features',feature],'restored-build.log')==0
with (r/'out/restored-reverse.out').open('w')as out,(r/'out/restored-reverse.err').open('w')as err:
 subprocess.run([str(r/'target-new-1/release/incrementalroots'),'reverse'],env=env,stdout=out,stderr=err,check=True)
assert (r/'out/restored-reverse.out').read_text()==expected
# Compare unchanged discovery decisions on frozen samples, not new timings.
prior=r/'evidence/process/fast-feedback/ring-closure/r88/sampler-2355/executing-instruments/f484d04c38974e6f4b2d6b61448499ee99a15a5f15a7ab893151d1c8fd77214c.sh'
oldtext=prior.read_text();newtext=s.read_text()
for marker in ['for n in [2, 8, 16, 17, 24, 128, 512]','for active in [7, 8, 15, 16]','pairs.push((mean([(av, a.units)]), mean([(bv, b.units)])));','let judged = discoveries(&cells, 50, 30);']:
 assert next(l for l in oldtext.splitlines()if marker in l)==next(l for l in newtext.splitlines()if marker in l)
judge=oldtext.split("<<'JUDGE_EOF'\n",1)[1].split('\nJUDGE_EOF',1)[0]
j=r/'prior-judge';(j/'src').mkdir(parents=True);(j/'src/main.rs').write_text(judge)
(j/'Cargo.toml').write_text('[package]\nname="priorjudge"\nversion="0.1.0"\nedition="2021"\n[dependencies]\nclocks={path="'+str(r/'bench/clocks')+'"}\n')
with (r/'out/prior-judge-build.log').open('w')as f:subprocess.run(['cargo','build','--release','--manifest-path',str(j/'Cargo.toml')],env=dict(os.environ,CARGO_TARGET_DIR=str(r/'target-prior-judge')),stdout=f,stderr=subprocess.STDOUT,check=True)
fixtures=r/'evidence/process/fast-feedback/ring-closure/r88/runs/independent-plain-costs-epyc-20261108T225842-e5565d65/out'
for algorithm in ['update','cycle','finish']:
 paths=[]
 for name,exe in [('old',r/'target-prior-judge/release/priorjudge'),('new',r/'target-judge/release/incrementalrootjudge')]:
  q=r/f'out/frozen-{algorithm}-{name}-judgments.tsv';q.write_bytes(subprocess.check_output([str(exe),str(fixtures),algorithm]));paths.append(q)
 a,b=[list(csv.DictReader(q.open(),delimiter='\t'))for q in paths]
 assert len(a)==len(b)>0
 for x,y in zip(a,b,strict=True):
  assert {k:v for k,v in x.items()if k not in ['old_per_item','new_per_item']}=={k:v for k,v in y.items()if k not in ['old_per_item','new_per_item']}
print(f'{family} finalization contract selected at compile time; digest faults rejected; frozen decisions unchanged')
PY
printf 'shared sampler compile/preflight controls passed; no new timing\n' > "$R/out/validation.txt"
JOB
