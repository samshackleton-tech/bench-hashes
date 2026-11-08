#!/bin/bash
set -euo pipefail
R="$1";mkdir -p "$R/out"
export HOME=/root
. /root/.cargo/env
printf 'old %s\nnew %s\n' "$(git -C "$R/old" rev-parse HEAD)" "$(git -C "$R/new" rev-parse HEAD)" > "$R/out/identity.txt"
# Add the same diagnostic test to each fresh source. Reuse the project's
# Counting allocator/allocated helper; runtime library sources stay untouched.
python3 - "$R" <<'PY'
from pathlib import Path
import sys
r=Path(sys.argv[1])
marker='#[test]\nfn single_threaded_calls_allocate_as_the_memory_section_says() {'
body='''#[test]
fn held_parent_allocated_bytes() {
    blake3_servil::initialize();
    assert!(std::is_x86_feature_detected!("avx2"));
    let data = vec![7u8; 16 * 1024];
    for n in [2usize, 7, 8, 16, 128, 512] {
        let keys: Vec<[u8; 32]> = (0..n).map(|i| core::array::from_fn(|j| (i * 37 + j * 11) as u8)).collect();
        let mut hashers: Vec<_> = keys.iter().map(|key| Hasher::new(Mode::Keyed(key), None)).collect();
        let pieces: Vec<_> = (0..n).map(|i| (i, data.as_slice())).collect();
        for stage in 0..2 {
            let bytes = allocated(|| throughput::update_each(&mut hashers, &pieces));
            assert!(hashers.iter().all(|h| h.count() == ((stage + 1) * data.len()) as u64));
            std::hint::black_box(&hashers);
            println!("HELD_ALLOC n={n} stage={stage} bytes={bytes}");
        }
    }
}

'''
(r/'out/alloc-old.txt').write_text(marker)
(r/'out/alloc-new.txt').write_text(body+marker)
PY
for side in old new; do
    cd "$R/$side"
    test -z "$(git status --porcelain --untracked-files=no)"
    export CARGO_TARGET_DIR="$R/target-$side"
    cp tests/allocations.rs "$R/out/allocations-original-$side.rs"
    replace -f tests/allocations.rs "$R/out/alloc-old.txt" "$R/out/alloc-new.txt" > "$R/out/instrument-$side.diff"
    restore() { replace -f tests/allocations.rs "$R/out/alloc-new.txt" "$R/out/alloc-old.txt" > "$R/out/restore-$side.diff"; }
    trap restore EXIT
    set +e
    cargo nextest run --release --test allocations -E 'test(held_parent_allocated_bytes)' --nocapture > "$R/out/allocations-$side.log" 2>&1
    status=$?
    set -e
    restore
    trap - EXIT
    cmp tests/allocations.rs "$R/out/allocations-original-$side.rs"
    git diff --exit-code > "$R/out/final-input-$side.diff"
    test "$status" = 0
done
python3 - "$R/out" <<'PY'
from pathlib import Path
import re,sys
r=Path(sys.argv[1]);values={}
for side in ['old','new']:
    values[side]={(int(n),int(stage)):int(size)for n,stage,size in re.findall(r'^HELD_ALLOC n=(\d+) stage=(\d+) bytes=(\d+)$',(r/f'allocations-{side}.log').read_text(),re.M)}
assert len(values['old'])==len(values['new'])==12,values
with (r/'allocation-bytes.tsv').open('w')as f:
    f.write('held_messages\tstage\told_requested_bytes\tnew_requested_bytes\tsaved_bytes\n')
    for (n,stage),old in sorted(values['old'].items()):
        new=values['new'][n,stage]
        assert old-new==64*n,(n,stage,old,new)
        f.write(f'{n}\t{stage}\t{old}\t{new}\t{old-new}\n')
PY
printf 'existing allocator records 64 bytes less requested per held message at first and later stages; source restored\n' > "$R/out/status.txt"
