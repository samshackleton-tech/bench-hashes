#!/bin/bash
# The lib test binary's code hash (code_hash.py) of the checkout in the cwd, release-like (mutants profile, incremental off).
export CARGO_PROFILE_MUTANTS_INCREMENTAL=false
cargo test --profile mutants --features serde,zeroize --lib --no-run --message-format=json 2>/dev/null | python3 -c "
import json,sys,subprocess
for l in sys.stdin:
    if l.startswith('{'):
        m=json.loads(l)
        if m.get('reason')=='compiler-artifact' and m.get('executable') and 'blake3_servil-' in m['executable']:
            print(subprocess.run(['python3','tools/mutants/code_hash.py',m['executable']],capture_output=True,text=True,check=True).stdout.strip()[:16])"
