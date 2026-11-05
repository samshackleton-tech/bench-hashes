"""Plant the hot path's likely bugs one at a time; run the suite; report caught or survived. Restores each file."""
import subprocess,sys
M=[('src/lib.rs','    if input.len() <= CHUNK_LEN && platform::gpr_chunk_root() {','    if input.len() < CHUNK_LEN && platform::gpr_chunk_root() {','< for <='),
   ('src/lib.rs','    if input.len() <= CHUNK_LEN && platform::gpr_chunk_root() {','    if input.len() <= CHUNK_LEN {','GPR on every CPU'),
   ('src/lib.rs','    if input.len() <= CHUNK_LEN && platform::gpr_chunk_root() {','    if false {','GPR never'),
   ('src/performance.rs','    crate::hash_hot(&Block::bytes(input)[..len], key, flags)','    crate::hash_serial(&Block::bytes(input)[..len], key, flags)','performance::hash cold'),
   ('src/self_test.rs','        Hot { offset, len } => digest(crate::hash_hot_from(platform, &input[offset..][..len], crate::IV, 0)),','        Hot { offset, len } => digest(crate::hash_serial_from(platform, &input[offset..][..len], crate::IV, 0)),','self-test case skips the kernel')]
for f,a,b,what in M:
    s=open(f).read(); assert s.count(a)==1,what; open(f,'w').write(s.replace(a,b))
    try:
        r=subprocess.run(['cargo','nextest','run','--cargo-profile','mutants','--features','serde,zeroize','--lib','--tests','--no-fail-fast'],capture_output=True,text=True,timeout=1500)
        fails=sorted({l.split(']')[-1].strip() for l in (r.stdout+r.stderr).splitlines() if l.strip().startswith('FAIL [')})
        print(f"{what}: {('caught by '+'; '.join(fails[:2])) if r.returncode else 'SURVIVES'}",flush=True)
    finally: open(f,'w').write(s)
