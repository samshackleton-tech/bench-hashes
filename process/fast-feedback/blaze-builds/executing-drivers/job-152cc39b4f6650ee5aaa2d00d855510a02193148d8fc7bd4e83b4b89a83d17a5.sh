#!/bin/bash
# Reuse the exact executed memlock/functional driver on a disposable Btrfs filesystem.
set -euo pipefail
exec timeout -k 15s 540s unshare --mount --propagation private bash -s -- "$1" <<'JOB'
set -euo pipefail
R="$1";O="$R/out";mkdir -p "$O";S="/var/tmp/$(basename "$R")"
IMAGE="$R/canary-btrfs.img";mkdir -p "$S";truncate -s 16G "$IMAGE"
mkfs.btrfs -f "$IMAGE" > "$O/filesystem-create.txt" 2>&1
mount -o loop,nosuid,nodev "$IMAGE" "$S"
cleanup() { umount "$S" >> "$O/filesystem-cleanup.txt" 2>&1; }
trap cleanup EXIT
findmnt -J --target "$S" > "$O/filesystem-mounted.json"
printf 'reflink-control-payload\n' > "$S/reflink-source"
cp --reflink=always "$S/reflink-source" "$S/reflink-clone"
cmp "$S/reflink-source" "$S/reflink-clone"
printf 'modified-clone\n' > "$S/reflink-clone"
grep -Fx 'reflink-control-payload' "$S/reflink-source" > "$O/reflink-control.txt"
cat > "$R/functional-driver.sh" <<'FUNCTIONAL_DRIVER'
#!/bin/bash
set -euo pipefail
exec timeout -k 15s 480s bash -s -- "$1" <<'JOB'
set -euo pipefail
R="$1";O="$R/out";mkdir -p "$O";. /root/.cargo/env
S="/var/tmp/$(basename "$R")";mkdir -p "$S"
{ echo "source $(git -C "$R/library" rev-parse HEAD)";rustc -Vv;echo 'canary 0.20261105.4 e93029602544df9882fffb18bf272d048a1a7136';echo 'compatibility and memlock ablation; no speed verdict'; } > "$O/identity.txt"
python3 - "$R" "$S" <<'PREP'
from pathlib import Path
import hashlib,tarfile,shutil,sys,os
r,s=map(Path,sys.argv[1:]);h='a8b8f3b36b7397671d3a5bcf739e5e1407e5941ee2345aaf5dc2b0868d44d8e6';p=Path('/var/tmp/blaze-input-'+h+'.tar.gz');assert hashlib.sha256(p.read_bytes()).hexdigest()==h
(s/'tool').mkdir()
with tarfile.open(p)as tf:tf.extractall(s/'tool',filter='data')
shutil.copytree(r/'library',s/'library',symlinks=True);shutil.rmtree(s/'library/.git')
for name in ['home','hello/src','probe/src']:(s/name).mkdir(parents=True)
(s/'home/.blaze').mkdir();(s/'home/.blaze/config.toml').write_text('[update]\nmode="offline"\n')
(s/'hello/Cargo.toml').write_text('[package]\nname="blaze_hello"\nversion="0.1.0"\nedition="2024"\n')
(s/'hello/src/main.rs').write_text('fn value()->u32{7}\nfn main(){println!("{}",value());}\n')
(s/'probe/Cargo.toml').write_text('[package]\nname="blaze_b3_probe"\nversion="0.1.0"\nedition="2024"\n[dependencies]\nblake3-servil={path="'+str(s/'library')+'"}\n')
(s/'probe/src/main.rs').write_text('fn main(){blake3_servil::initialize();let h=blake3_servil::convenience::hash(b"abc").to_hex().to_string();println!("source 1cbdf5d72d70d8ed511870b18c7f017cce83da15 digest {}",h);if h!="6437b3ac38465133ffb63b75273a8db548c558465d79db03fd359c6cd5bd9d85"{std::process::exit(42);}}\n')
for p in [s,*s.rglob('*')]:os.chown(p,65534,65534,follow_symlinks=False)
PREP
cat > "$R/driver.py" <<'PY'
from pathlib import Path
import os,sys,subprocess,resource,signal,json,hashlib
s,o=map(Path,sys.argv[1:]);blaze=next(p for p in(s/'tool').rglob('blaze')if p.is_file());home=s/'home';state=home/'.blaze';results=[]
env={'HOME':str(home),'USER':'nobody','LOGNAME':'nobody','PATH':str(blaze.parent)+':/usr/local/bin:/usr/bin:/bin','CARGO_HOME':str(home/'.cargo'),'RUSTUP_HOME':str(home/'.rustup'),'BLAZE_HOME':str(state),'BLAZE_CORES':'all','TMPDIR':str(home),'TERM':'dumb'}
def term(sig,frame):raise RuntimeError('outer job deadline or cancellation')
signal.signal(signal.SIGTERM,term)
def call(label,args,cwd,memlock,limit=60):
 def child():
  resource.setrlimit(resource.RLIMIT_MEMLOCK,(memlock,memlock));os.setgroups([]);os.setgid(65534);os.setuid(65534)
 with (o/(label+'.stdout')).open('wb')as out,(o/(label+'.stderr')).open('wb')as err:
  p=subprocess.Popen(args,cwd=cwd,env=env,stdin=subprocess.DEVNULL,stdout=out,stderr=err,start_new_session=True,preexec_fn=child)
  (o/'active-child.json').write_text(json.dumps(dict(pid=p.pid,label=label,memlock=memlock)))
  try:
   try:rc=p.wait(timeout=limit)
   except subprocess.TimeoutExpired:rc=124
  finally:
   if p.poll()is None:
    os.killpg(p.pid,signal.SIGTERM)
    try:p.wait(timeout=5)
    except subprocess.TimeoutExpired:os.killpg(p.pid,signal.SIGKILL);p.wait()
 results.append(dict(label=label,args=list(map(str,args)),exit=rc,child_memlock_bytes=memlock));(o/'commands.json').write_text(json.dumps(results,indent=2)+'\n');return rc
def snapshot(label):
 for path in [state/'v2/serve.log',state/'v2/serve.pid']:
  if path.is_file():(o/(label+'-'+path.name)).write_bytes(path.read_bytes())
def build(label,project,memlock,limit):return call(label,[str(blaze),'build','--release','--manifest-path',str(s/project/'Cargo.toml'),'--target-dir',str(s/project/'target')],s/project,memlock,limit)
low=8388608;high=268435456
original=(s/'library/src/convenience.rs').read_bytes();outcome={'source_sha256':hashlib.sha256(original).hexdigest(),'low_memlock':low,'high_memlock':high,'stage':'bootstrap'}
try:
 call('version',[str(blaze),'--version'],s,low,20)
 assert call('toolchain',[str(blaze),'toolchain'],s,low,90)==0
 outcome['low_exit']=build('low-hello','hello',low,30);snapshot('low')
 call('low-stop',[str(blaze),'stop'],s,low,15)
 outcome['stage']='high-hello';outcome['high_exit']=build('high-hello','hello',high,180);snapshot('high')
 if outcome['high_exit']==0:
  outcome['hello_run']=call('high-hello-run',[str(s/'hello/target/release/blaze_hello')],s,high,15)
  assert outcome['hello_run']==0 and(o/'high-hello-run.stdout').read_text().strip()=='7'
  outcome['stage']='b3-build';outcome['b3_build_exit']=build('b3-build','probe',high,90);snapshot('b3')
  if outcome['b3_build_exit']==0:
   binary=s/'probe/target/release/blaze_b3_probe';outcome['b3_positive']=call('b3-positive',[str(binary)],s,high,15);assert outcome['b3_positive']==0
   old=b'pub fn hash(input: &[u8]) -> Hash {\n    crate::hash_serial_cold(input, IV, 0)\n}';new=old.replace(b'(input, IV, 0)',b'(&input[..0], IV, 0)');assert original.count(old)==1
   (s/'old.txt').write_bytes(old);(s/'new.txt').write_bytes(new)
   subprocess.run(['/usr/local/bin/replace','-f',str(s/'library/src/convenience.rs'),str(s/'old.txt'),str(s/'new.txt')],check=True,stdout=subprocess.DEVNULL)
   try:
    outcome['stage']='changed-source';outcome['changed_build']=build('b3-changed-build','probe',high,45)
    if outcome['changed_build']==0:
     outcome['changed_digest']=call('b3-changed-digest',[str(binary)],s,high,15)
     assert outcome['changed_digest']==42,'source change did not reach the explicit wrong-digest exit'
     assert 'af1349b9f5f9a1a6a0404dea36dcc9499bcb25c9adc112b7cc9a93cae41f3262' in(o/'b3-changed-digest.stdout').read_text()
   finally:subprocess.run(['/usr/local/bin/replace','-f',str(s/'library/src/convenience.rs'),str(s/'new.txt'),str(s/'old.txt')],check=True,stdout=subprocess.DEVNULL)
   assert(s/'library/src/convenience.rs').read_bytes()==original
   outcome['stage']='restored';outcome['restored_build']=build('b3-restored-build','probe',high,45)
   if outcome['restored_build']==0:outcome['restored_positive']=call('b3-restored-positive',[str(binary)],s,high,15);assert outcome['restored_positive']==0
finally:
 snapshot('final');call('final-stop',[str(blaze),'stop'],s,high,15)
 # stop acknowledges the request; wait for this private executable's daemon
 # to exit before the wrapper unmounts its filesystem. Exact argv selector.
 stopped=subprocess.run(['/usr/local/bin/procs','--exe',str(blaze),'--signal','TERM','--wait','10'],stdout=subprocess.PIPE,stderr=subprocess.STDOUT,text=True)
 (o/'daemon-exit.txt').write_text(stopped.stdout+'exit='+str(stopped.returncode)+'\n');assert stopped.returncode in(0,1)
 outcome['library_bytes_restored']=(s/'library/src/convenience.rs').read_bytes()==original
 (o/'outcome.json').write_text(json.dumps(outcome,indent=2)+'\n')
(o/'status.txt').write_text('canary memlock ablation collected; classify each outcome; no speed verdict; library source restored\n')
PY
python3 "$R/driver.py" "$S" "$O" > "$O/driver.stdout" 2> "$O/driver.stderr"
git -C "$R/library" diff --exit-code > "$O/original-source-diff.txt"
JOB
FUNCTIONAL_DRIVER
cp "$R/functional-driver.sh" "$O/functional-driver.sh"
bash "$R/functional-driver.sh" "$R"
JOB
