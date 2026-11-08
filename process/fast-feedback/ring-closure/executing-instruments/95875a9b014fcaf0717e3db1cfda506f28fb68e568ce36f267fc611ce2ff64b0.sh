#!/bin/bash
set -euo pipefail
exec timeout -k 5s 240s bash -s -- "$1" <<'JOB'
set -euo pipefail
R="$1"
mkdir -p "$R/out" "$R/probe"
export HOME=/root
. /root/.cargo/env
export CARGO_TARGET_DIR="$R/target"
NEW=ddb7199d7f0b0f04390e923474b630ffc7ff2811
test "$(git -C "$R/fork" rev-parse HEAD)" = "$NEW"
{ echo "library $NEW";echo 'release overflow checks: Cargo release defaults';rustc -Vv;uname -m;} > "$R/out/identity.txt"
printf '[package]\nname="cursory-reader-audit"\nversion="0.0.0"\nedition="2024"\n[lib]\npath="probe.rs"\n[dependencies]\nblake3-servil={path="%s/fork"}\n' "$R" > "$R/probe/Cargo.toml"
cat > "$R/probe/probe.rs" <<'RS'
#[cfg(test)]
mod tests {
    use blake3_servil::{Hash, Mode, convenience, throughput::{self, Block, Packed, Stream}};

    #[test]
    fn packed_count_capacity_is_checked_before_constructing() {
        // Deliberately never dereference/inspect a bad Packed. Its constructor
        // alone is safe to call; the returned object is dropped without use.
        let count = std::hint::black_box(usize::MAX / 32 + 1);
        let result = std::panic::catch_unwind(|| Packed::<32>::new(count));
        assert!(result.is_err(), "constructor accepted an impossible packed count; no slice was created in this probe");
    }

    // This function is TYPE-CHECKED BUT NEVER CALLED. No dangling task runs.
    // Safe public open permits forgetting the guard, then reusing/freeing
    // externally borrowed buffers while a published task could remain.
    #[allow(dead_code)]
    fn safe_rust_can_forget_a_borrowing_stream() {
        blake3_servil::initialize_multithreaded(None);
        let mut bytes = vec![Block([0x31; 64]); (4 << 20) / 64];
        let mut out = Hash::from_bytes([0; 32]);
        let mut stream = Stream::open(Mode::Plain, |_| {});
        stream.submit(&bytes, 4 << 20, &mut out);
        std::mem::forget(stream);
        bytes.fill(Block([0x52; 64]));
        drop(bytes);
        out = Hash::from_bytes([0x73; 32]);
        std::hint::black_box(out);
    }

    #[test]
    fn forgetting_stream_witness_type_checks_without_execution() {
        // Taking its function pointer proves the body was type checked.
        std::hint::black_box(safe_rust_can_forget_a_borrowing_stream as fn());
        println!("public safe Stream::open forget witness compiled; its body was never executed");
    }

    #[test]
    fn sequential_stream_room_contents_cross_message_boundary() {
        blake3_servil::initialize_multithreaded(None);
        const LEN: usize = 4096;
        let marker: Vec<u8> = (0..LEN).map(|i| (i % 251 + 1) as u8).collect();
        let mut out = Hash::from_bytes([0; 32]);
        let mut initial = Vec::new();
        throughput::stream(Mode::Plain, |_| {}, |s| {
            s.submit_with(LEN, |_, room| { initial.extend_from_slice(room);room.fill(0);room.len() }, &mut out);
            s.finish();
        });
        assert_ne!(initial, marker, "negative control: no marker has been submitted");
        throughput::stream(Mode::Plain, |_| {}, |s| {
            s.submit_with(LEN, |_, room| { room.copy_from_slice(&marker);room.len() }, &mut out);
            s.finish();
        });
        assert_eq!(out, convenience::hash(&marker));
        let mut residue = Vec::new();
        throughput::stream(Mode::Plain, |_| {}, |s| {
            s.submit_with(LEN, |_, room| { residue.extend_from_slice(room);room.fill(0);room.len() }, &mut out);
            s.finish();
        });
        assert_eq!(residue, marker, "audit exposure: a new stream's safe callback reads all of the prior stream's synthetic plaintext");
        assert_eq!(out, convenience::hash(&[0; LEN]));
        let mut cleared = Vec::new();
        throughput::stream(Mode::Plain, |_| {}, |s| {
            s.submit_with(LEN, |_, room| { cleared.extend_from_slice(room);room.fill(0);room.len() }, &mut out);
            s.finish();
        });
        assert_eq!(cleared, vec![0; LEN], "negative control: overwriting the room removes this marker");
        println!("prior-stream synthetic plaintext: absent before submission; present across stream boundary; absent after overwrite");
    }
}
RS
set +e
cargo nextest run --release --manifest-path "$R/probe/Cargo.toml" --lib --no-fail-fast --nocapture > "$R/out/probes.log" 2>&1
status=$?
set -e
printf '%s\n' "$status" > "$R/out/probes-exit.txt"
test "$status" = 100
python3 - "$R/out/probes.log" <<'PY'
from pathlib import Path
import sys
s=Path(sys.argv[1]).read_text()
for marker in ['constructor accepted an impossible packed count','public safe Stream::open forget witness compiled; its body was never executed','prior-stream synthetic plaintext: absent before submission; present across stream boundary; absent after overwrite']:
    assert marker in s,marker
assert '2 passed, 1 failed' in s
PY
if [[ ${SAFETY_CONTROLS:-0} == 1 ]];then
    python3 - "$R" <<'PY'
from pathlib import Path
import subprocess,sys
r=Path(sys.argv[1]);out=r/'out';manifest=r/'probe/Cargo.toml'
def temporary(path,old,new,command,label,want,marker):
    original=path.read_bytes();assert original.decode().count(old)==1
    subprocess.run(['replace',str(path),old,new],check=True,stdout=(out/(label+'-edit.log')).open('w'))
    try:
        with (out/(label+'.log')).open('w')as f:
            p=subprocess.run(command,stdout=f,stderr=subprocess.STDOUT)
        assert p.returncode==want,(label,p.returncode)
        assert marker in (out/(label+'.log')).read_text(),label
    finally:
        subprocess.run(['replace',str(path),new,old],check=True,stdout=(out/(label+'-restore.log')).open('w'))
        assert path.read_bytes()==original
command=['cargo','nextest','run','--release','--manifest-path',str(manifest),'--lib','-E','test(packed_count_capacity_is_checked_before_constructing)','--nocapture']
temporary(r/'fork/src/block.rs','let lines = (count * N).div_ceil(128);','let lines = count.div_ceil(128 / N);',command,'capacity-remedy',0,'1 passed')
command=['cargo','check','--release','--tests','--manifest-path',str(manifest)]
temporary(r/'fork/src/stream.rs','pub fn open(mode: Mode, done: D) -> Self {','fn open(mode: Mode, done: D) -> Self {',command,'private-open-remedy',101,'associated function `open` is private')
(out/'remedy-controls.txt').write_text('capacity remedy passes desired release assertion; private open rejects compile-only forgetting witness; both library inputs restored byte-for-byte\n')
PY
fi
test -z "$(git -C "$R/fork" status --porcelain)"
printf 'safety audit: capacity assertion red; compile-only forget witness and room exposure controls confirmed; no invalid slices or dangling tasks executed\n' > "$R/out/status.txt"
JOB
