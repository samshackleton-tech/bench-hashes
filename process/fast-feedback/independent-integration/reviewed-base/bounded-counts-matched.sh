#!/bin/bash
set -euo pipefail
exec timeout -k 5s 540s bash -s -- "$1" <<'COUNT_JOB'
set -euo pipefail
R="$1";O="$R/out";mkdir -p "$O" "$R/tmp";. /root/.cargo/env
{ for side in current common reference;do echo "$side $(git -C "$R/$side" rev-parse HEAD)";done;rustc -Vv;uname -m; } > "$O/identity.txt"
cat > "$R/module.txt" <<'RUST'
#[cfg(all(test, feature = "std"))]
mod bounded_diagnosis {
    use super::*;
    fn clear() {
        crate::COUNTED.with(|c| c.iter().for_each(|x| x.set(0)));
        crate::RAN_ENTRIES.with(|x| x.borrow_mut().clear());
        crate::RAN.with(|x| x.set(0));
        HELD_GROUPS.with(|x| x.borrow_mut().clear());
    }
    fn snapshot() {
        let counts: [u64; 6] = crate::COUNTED.with(|c| core::array::from_fn(|i| c[i].get()));
        eprintln!("S counts={counts:?} selector={}", crate::RAN.with(|x| x.get()));
        HELD_GROUPS.with(|x| eprintln!("G {:?}", &*x.borrow()));
        crate::RAN_ENTRIES.with(|x| eprintln!("K {:?}", &*x.borrow()));
        eprintln!("END");
    }
    #[test]
    fn work_order() {
        eprintln!("ANCHOR {:x}", crate::initialize as *const () as usize);
        clear();eprintln!("BEGIN startup");crate::initialize();snapshot();
        for n in [128usize, 512] {
            for len in [16384usize, 32768] {
                let data: Vec<Vec<u8>> = (0..n).map(|i| (0..len).map(|j| (i * 31 + j * 17) as u8).collect()).collect();
                let keys: Vec<[u8; 32]> = (0..n).map(|i| core::array::from_fn(|j| (i * 37 + j * 11) as u8)).collect();
                for flavor in 0..4 {
                    let mode = |i: usize| match flavor { 0 => Mode::Plain, 1 => Mode::Keyed(&keys[0]), 2 => Mode::Keyed(&keys[i]), _ => match i % 3 { 0 => Mode::Plain, 1 => Mode::Keyed(&keys[i]), _ => Mode::DeriveKey("bounded work-order diagnosis") } };
                    for partition in [usize::MAX, 128] {
                        let mut hashers: Vec<_> = (0..n).map(|i| Hasher::new(mode(i), None)).collect();
                        let first = &hashers[0];
                        eprintln!("LAYOUT n={n} flavor={flavor} partition={partition} size={} align={} base={:x} stride={} core_offset={} key_offset={} stage_offset={} stage_len={}", core::mem::size_of::<Hasher>(), core::mem::align_of::<Hasher>(), first as *const _ as usize, (&hashers[1] as *const _ as usize) - (first as *const _ as usize), (&first.core as *const _ as usize) - (first as *const _ as usize), first.core.key.as_ptr() as usize - (first as *const _ as usize), first.stage.as_ptr() as usize - (first as *const _ as usize), first.stage.len());
                        let mut out = vec![[0u8; OUT_LEN]; n];
                        // Same allocated states/data for both public caller orders.
                        for order in [0usize, 61] {
                        let which: Vec<_> = (0..n).map(|i| if order == 0 { i } else { (i * order) % n }).collect();
                        let expected: Vec<_> = data.iter().enumerate().map(|(i, bytes)| crate::test::official::hash(mode(which[i]), bytes)).collect();
                        for cycle in 0..2 {
                            for (piece, from) in (0..len).step_by(4096).enumerate() {
                                let pieces: Vec<_> = data.iter().enumerate().map(|(i, bytes)| (which[i], &bytes[from..from + 4096])).collect();
                                clear();eprintln!("BEGIN update n={n} len={len} flavor={flavor} partition={partition} order={order} cycle={cycle} piece={piece}");
                                for part in pieces.chunks(partition) { update_each(&mut hashers, part); }
                                snapshot();
                                assert!(hashers.iter().all(|h| h.held_group().is_none()), "each caller turn completes its ready stages");
                            }
                            clear();eprintln!("BEGIN finish n={n} len={len} flavor={flavor} partition={partition} order={order} cycle={cycle}");
                            finalize_each(&mut hashers, &which, &mut out);snapshot();
                            assert_eq!(out, expected, "diagnostic rows must produce their actual digests");
                        }
                        }
                    }
                }
            }
        }
    }
}

RUST
python3 - "$R" <<'PATCH'
from pathlib import Path
import subprocess,sys
r=Path(sys.argv[1]);module=(r/'module.txt').read_text()
for side in ['current','common','reference']:
 p=r/side/'src/each.rs';old='#[cfg(test)]\nmod test {';new=module+old
 lib=r/side/'src/lib.rs';lo='RAN_ENTRIES.with(|r| r.borrow_mut().insert(entry as usize));';ln='RAN_ENTRIES.with(|r| { eprintln!("E {:x}", entry as usize); r.borrow_mut().insert(entry as usize) });'
 platform=r/side/'src/platform.rs';po='        const { assert!(N > 0 && N % BLOCK_LEN == 0, "hash_many inputs are whole blocks") };';pn='        #[cfg(all(test, feature = "std"))]\n        eprintln!("H {:?} {} {} {} {} {} {} {:x} {:x} {:x}", self, N, inputs.len(), counter, increment_counter.yes() as u8, flags, out.len(), inputs.first().map_or(0, |b| b.as_ptr() as usize), out.as_mut_ptr() as usize, key.as_ptr() as usize);\n'+po
 for name,path,a,b in [('each',p,old,new),('lib',lib,lo,ln),('platform',platform,po,pn)]:
  assert path.read_text().count(a)==1,(side,name)
  (r/f'orig-{side}-{name}').write_bytes(path.read_bytes());(r/f'old-{side}-{name}').write_text(a);(r/f'new-{side}-{name}').write_text(b)
  subprocess.run(['/usr/local/bin/replace','-f',str(path),str(r/f'old-{side}-{name}'),str(r/f'new-{side}-{name}')],check=True,stdout=subprocess.DEVNULL)
 with(r/'out'/f'patch-{side}.diff').open('w')as out:subprocess.run(['git','-C',str(r/side),'diff'],stdout=out,check=True)
PATCH
pids=()
for side in current common reference;do
 ( cd "$R/$side";export CARGO_TARGET_DIR="$R/target-$side" TMPDIR="$R/tmp";cargo nextest run --release --lib -E 'test(=each::bounded_diagnosis::work_order)' --success-output immediate --failure-output immediate > "$O/count-$side.log" 2>&1 ) &
 pids+=("$!")
done
failed=0;for pid in "${pids[@]}";do if ! wait "$pid";then failed=1;fi;done
test "$failed" = 0
python3 - "$R" <<'RESTORE'
from pathlib import Path
import os,subprocess,sys
r=Path(sys.argv[1]);o=r/'out'
for side in ['current','common','reference']:
 candidates=[p for p in(r/f'target-{side}'/'release/deps').glob('blake3_servil-*')if p.is_file()and os.access(p,os.X_OK)and'.'not in p.name];assert len(candidates)==1,candidates
 symbols=subprocess.check_output(['nm','-anC',str(candidates[0])],text=True)
 lines=[line for line in symbols.splitlines()if'blake3_servil_'in line or line.endswith('blake3_servil::initialize')]
 (o/f'symbols-{side}.txt').write_text('\n'.join(lines)+'\n')
 for name,relative in [('each','src/each.rs'),('lib','src/lib.rs'),('platform','src/platform.rs')]:
  path=r/side/relative;patched=r/f'patched-{side}-{name}';patched.write_bytes(path.read_bytes())
  subprocess.run(['/usr/local/bin/replace','-f',str(path),str(patched),str(r/f'orig-{side}-{name}')],check=True,stdout=subprocess.DEVNULL)
 assert not subprocess.check_output(['git','-C',str(r/side),'status','--porcelain'],text=True)
 (o/f'restored-{side}.txt').write_text('tracked/index/source restored byte-exact; no production capacity/layout/owner/cache change\n')
 # Retain all raw bytes in bounded text chunks if a log exceeds publication's20MiB limit.
 p=o/f'count-{side}.log';data=p.read_bytes()
 if len(data)>=20*1024*1024:
  for i,start in enumerate(range(0,len(data),4*1024*1024)):(o/f'count-{side}.part{i:03}.log').write_bytes(data[start:start+4*1024*1024])
RESTORE
printf 'bounded work-order counting complete; three pinned sources plus declared test-only observer patch; actual startup/update/finish/repeated-cycle cohorts/selectors/entry invocations/request shapes; no timing claim\n' > "$O/status.txt"
COUNT_JOB
