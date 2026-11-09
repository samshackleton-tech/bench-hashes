#!/bin/bash
set -euo pipefail
exec timeout -k 5s 480s bash -s -- "$1" <<'JOB'
set -euo pipefail
R="$1";O="$R/out";mkdir -p "$O";. /root/.cargo/env
S="/var/tmp/$(basename "$R")";mkdir -p "$S";chmod 755 "$S"
cleanup() {
  for realm in stable canary; do
    home="$S/$realm-home"
    if [ -d "$home" ]; then
      while IFS= read -r binary; do
        runuser -u nobody -- env -i HOME="$home" BLAZE_HOME="$home/.blaze" PATH=/usr/local/bin:/usr/bin:/bin timeout -k 2s 8s "$binary" stop >> "$O/cleanup.log" 2>&1 || true
      done < <(find "$S/$realm" -type f -name blaze)
    fi
  done
}
trap cleanup EXIT
{ echo "source $(git -C "$R/library" rev-parse HEAD)";rustc -Vv;cargo -V;uname -a;echo "compatibility-only; no timing or speed verdict"; } > "$O/identity.txt"
python3 - "$S" "$O" <<'PREP'
from pathlib import Path
import urllib.request,hashlib,tarfile,subprocess,shutil,sys,json
s,o=map(Path,sys.argv[1:]);versions=[('stable','0.20261027.0','df61ce6d8216087a40e986d4f84cf2a230638bde014e38519e08b50282e90e5d'),('canary','0.20261105.4','a8b8f3b36b7397671d3a5bcf739e5e1407e5941ee2345aaf5dc2b0868d44d8e6')];pins=[]
for kind,v,sha in versions:
 name=f'blaze-v{v}-x86_64-unknown-linux-gnu.tar.gz';url=f'https://blaze-releases.ix.dev/v{v}/{name}';p=s/name
 cached=Path('/var/tmp/blaze-input-'+sha+'.tar.gz');assert hashlib.sha256(cached.read_bytes()).hexdigest()==sha
 shutil.copyfile(cached,p)
 assert hashlib.sha256(p.read_bytes()).hexdigest()==sha
 target=s/kind;target.mkdir()
 with tarfile.open(p)as tf:tf.extractall(target,filter='data')
 pins.append(dict(channel=kind,version=v,url=url,sha256=sha,bytes=p.stat().st_size))
(o/'release-pins.json').write_text(json.dumps(pins,indent=2)+'\n')
# A private copy of the already installed Cargo toolchain, without root's settings,
# tokens, git cache or SSH material. Blaze gets a separate HOME and state per release.
sysroot=Path(subprocess.check_output(['rustc','--print','sysroot'],text=True).strip());shutil.copytree(sysroot,s/'cargo-toolchain',symlinks=True)
PREP
cp -a "$R/library" "$S/library-template"
rm -rf "$S/library-template/.git"
# The upstream archive lists only SHA256SUMS for stable; compute a BLAKE3 digest
# with the official reference, and retain its own version/locked build log.
cargo install b3sum --version 1.8.7 --locked --root "$R/reference" > "$O/reference-build.log" 2>&1
"$R/reference/bin/b3sum" --version > "$O/digest-tool.txt"
"$R/reference/bin/b3sum" "$S"/*.tar.gz > "$O/release-BLAKE3SUMS"
chown -R nobody:nogroup "$S"
cat > "$S/experiment.py" <<'PY'
from pathlib import Path
import os,sys,subprocess,json,shutil,signal
s=Path(sys.argv[1]);o=Path(sys.argv[2]);results=[]
# Every native command has a finite limit; outputs/failures remain distinct.
def call(label,args,cwd,env,limit=120):
 with (o/(label+'.stdout')).open('wb')as out,(o/(label+'.stderr')).open('wb')as err:
  p=subprocess.Popen(args,cwd=cwd,env=env,stdout=out,stderr=err,start_new_session=True)
  try:rc=p.wait(timeout=limit)
  except subprocess.TimeoutExpired:
   os.killpg(p.pid,signal.SIGTERM)
   try:p.wait(timeout=5)
   except subprocess.TimeoutExpired:os.killpg(p.pid,signal.SIGKILL);p.wait()
   rc=124
 results.append(dict(label=label,args=list(map(str,args)),exit=rc));(o/'commands.json').write_text(json.dumps(results,indent=2)+'\n');return rc
baseline=s/'cargo-probe';(baseline/'src').mkdir(parents=True);basehome=s/'cargo-home';basehome.mkdir()
(baseline/'Cargo.toml').write_text('[package]\nname="blaze_b3_probe"\nversion="0.1.0"\nedition="2024"\n[dependencies]\nblake3-servil={path="'+str(s/'library-template')+'"}\n')
(baseline/'src/main.rs').write_text('fn main(){blake3_servil::initialize();let h=blake3_servil::convenience::hash(b"abc").to_hex().to_string();println!("source 1cbdf5d72d70d8ed511870b18c7f017cce83da15 digest {}",h);assert_eq!(h,"6437b3ac38465133ffb63b75273a8db548c558465d79db03fd359c6cd5bd9d85");}\n')
baseenv={'HOME':str(basehome),'USER':'nobody','LOGNAME':'nobody','PATH':str(s/'cargo-toolchain/bin')+':/usr/local/bin:/usr/bin:/bin','CARGO_HOME':str(basehome/'.cargo'),'RUSTUP_HOME':str(basehome/'.rustup'),'TERM':'dumb'}
assert call('cargo-build',[str(s/'cargo-toolchain/bin/cargo'),'build','--release'],baseline,baseenv,100)==0
assert call('cargo-positive',[str(baseline/'target/release/blaze_b3_probe')],baseline,baseenv,20)==0
for kind in ['stable','canary']:
 home=s/(kind+'-home');home.mkdir();bhome=home/'.blaze';bhome.mkdir();(bhome/'config.toml').write_text('[update]\nmode="offline"\n')
 binaries=list((s/kind).rglob('blaze'));assert len(binaries)==1,binaries;blaze=binaries[0]
 env={'HOME':str(home),'USER':'nobody','LOGNAME':'nobody','PATH':str(blaze.parent)+':'+str(s/'cargo-toolchain/bin')+':/usr/local/bin:/usr/bin:/bin','BLAZE_HOME':str(bhome),'CARGO_HOME':str(home/'.cargo'),'RUSTUP_HOME':str(home/'.rustup'),'BLAZE_CORES':'all','TMPDIR':str(home),'TERM':'dumb'}
 call(kind+'-version',[str(blaze),'--version'],s,env,20);call(kind+'-help',[str(blaze),'--help'],s,env,20)
 # Stable implements toolchain bootstrap; current canary may report unsupported.
 setup=call(kind+'-toolchain',[str(blaze),'toolchain'],s,env,140)
 lib=s/(kind+'-library');shutil.copytree(s/'library-template',lib,symlinks=True)
 probe=s/(kind+'-probe');(probe/'src').mkdir(parents=True)
 (probe/'Cargo.toml').write_text('[package]\nname="blaze_b3_probe"\nversion="0.1.0"\nedition="2024"\n[dependencies]\nblake3-servil={path="'+str(lib)+'"}\n')
 (probe/'src/main.rs').write_text('fn main(){blake3_servil::initialize();let h=blake3_servil::convenience::hash(b"abc").to_hex().to_string();println!("source 1cbdf5d72d70d8ed511870b18c7f017cce83da15 digest {}",h);assert_eq!(h,"6437b3ac38465133ffb63b75273a8db548c558465d79db03fd359c6cd5bd9d85");}\n')
 args=[str(blaze),'build','--release','--manifest-path',str(probe/'Cargo.toml')]
 try:
  if call(kind+'-build',args,probe,env,100)!=0:continue
  artifact=probe/'target/release/blaze_b3_probe'
  if call(kind+'-positive',[str(artifact)],probe,env,20)!=0:continue
  original=(lib/'src/convenience.rs').read_bytes();old=b'pub fn hash(input: &[u8]) -> Hash {\n    crate::hash_serial_cold(input, IV, 0)\n}';new=old.replace(b'(input, IV, 0)',b'(&input[..0], IV, 0)');assert original.count(old)==1
  # Exact replace, restored byte-for-byte even on failure. No source checkpoint changes.
  (s/'old.txt').write_bytes(old);(s/'new.txt').write_bytes(new)
  subprocess.run(['/usr/local/bin/replace','-f',str(lib/'src/convenience.rs'),str(s/'old.txt'),str(s/'new.txt')],check=True,stdout=subprocess.DEVNULL)
  try:
   redbuild=call(kind+'-changed-build',args,probe,env,100)
   if redbuild==0:
    red=call(kind+'-changed-digest',[str(artifact)],probe,env,20);assert red!=0,'incremental build reused stale digest'
  finally:
   subprocess.run(['/usr/local/bin/replace','-f',str(lib/'src/convenience.rs'),str(s/'new.txt'),str(s/'old.txt')],check=True,stdout=subprocess.DEVNULL)
   assert (lib/'src/convenience.rs').read_bytes()==original
  if call(kind+'-restored-build',args,probe,env,100)==0:assert call(kind+'-restored-positive',[str(artifact)],probe,env,20)==0
 finally:call(kind+'-stop',[str(blaze),'stop'],s,env,20)
(o/'status.txt').write_text('compatibility experiment complete; inspect command outcomes individually; no speed verdict; original source unchanged; isolated per-release HOME and daemon stop requested\n')
PY
mkdir -p "$S/results";chown nobody:nogroup "$S/results"
set +e
runuser -u nobody -- env -i PATH=/usr/local/bin:/usr/bin:/bin python3 "$S/experiment.py" "$S" "$S/results" > "$O/experiment.stdout" 2> "$O/experiment.stderr"
rc=$?
set -e
cp -a "$S/results/." "$O/"
printf 'experiment_driver_exit=%s\n' "$rc" >> "$O/identity.txt"
test "$rc" = 0
git -C "$R/library" diff --exit-code > "$O/original-source-diff.txt"
JOB
