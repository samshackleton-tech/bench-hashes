#!/usr/bin/env bash
set -euo pipefail
export PATH=/root/.cargo/bin:/usr/local/bin:/usr/bin:/bin
export HOME=/root
PINNED_ROOT="$1"
PINNED_OUT="$PINNED_ROOT/out"
mkdir -p "$PINNED_OUT"
cd "$PINNED_ROOT/fork"
printf 'library %s\n' "$(git rev-parse HEAD)" > "$PINNED_OUT/identity.txt"
export CARGO_TARGET_DIR="$PINNED_ROOT/target"
# Deliberately isolated output/startup checks: no source-ring/pipeline execution.
cargo nextest run --release --lib -E 'test(ffi_output::tests) or test(test_self_test_run_checks_every_case)' > "$PINNED_OUT/positive.log" 2>&1
python3 - "$PINNED_OUT" <<'PY'
from pathlib import Path
import os,subprocess,sys
out=Path(sys.argv[1])
def control(name,file,old,new,test,marker):
    p=Path(file);s=p.read_text();assert s.count(old)==1,(file,s.count(old))
    # Exact atomic replacement, never regex edits.
    subprocess.run(['replace',str(p),old,new],check=True,stdout=(out/(name+'-edit.log')).open('w'))
    try:
        with (out/(name+'.log')).open('w')as f:
            result=subprocess.run(['cargo','nextest','run','--release','--lib','-E','test('+test+')'],stdout=f,stderr=subprocess.STDOUT)
        assert result.returncode==100,(name,result.returncode)
        assert marker in (out/(name+'.log')).read_text(),name
    finally:
        subprocess.run(['replace',str(p),new,old],check=True,stdout=(out/(name+'-restore.log')).open('w'))
    print(name+' rejected at '+marker)
old='''if crate::platform::avx2_detected() {
                        unsafe { finalize_groups::<8>(hashers, tail, tail_out) };
                    } else {'''
control('missing-eight-selection','src/each.rs',old,old.replace('finalize_groups::<8>', 'finalize_groups::<16>'),'incremental_roots_batch_all_modes_and_selected_indices','maximum=16 count=8 width=8')
control('missing-eight-startup','src/ffi_output.rs','unsafe { hash_eight_groups(inputs, &mut eight) };','unsafe { hash_group::<16>(inputs, &mut eight) };','test_self_test_run_checks_every_case','startup left out compression width 8')
PY
# Verify the exact input restored after each deterministic fault control.
test -z "$(git status --porcelain)"
printf 'isolated output8 positive and two controls passed\n' > "$PINNED_OUT/status.txt"
