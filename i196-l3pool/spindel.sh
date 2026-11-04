#!/bin/bash
# BLAKE3 #196 / #219, a deletion trial for SPIN in John's candidate (run i196-spindel): bench-hashes check
# --cells all on this machine, probe/l3-pool-splitfloat de0451dc with SPIN 0 (an idle worker parks at
# once; committed in the job's checkout) against de0451dc itself, as Zooko's rule asks of a knob whose
# benefit is in doubt. Bench 0.20.4.
set -u
R="$1"; O="$R/out"; mkdir -p "$O"; cd "$R"
. /root/.cargo/env
B=$(git -C cand rev-parse HEAD)
python3 - "$R/cand/src/lanes.rs" <<'PY_NOSPIN_END' || { echo "patch nospin failed" >> "$O/status.txt"; exit 2; }
import sys
p = sys.argv[1]; s = open(p).read()
a = "const SPIN: std::time::Duration = std::time::Duration::from_micros(5);"
assert s.count(a) == 1
open(p, "w").write(s.replace(a, "const SPIN: std::time::Duration = std::time::Duration::from_micros(0); // deletion trial"))
PY_NOSPIN_END
git -C cand -c user.name=job -c user.email=job@localhost -c core.hooksPath=/dev/null commit -qam "job: SPIN 0 (deletion trial)"
{ grep -m1 'model name' /proc/cpuinfo; nproc; echo "against $B"; echo "trial $(git -C cand rev-parse HEAD)"; git -C cand show --stat HEAD | tail -2; echo "bench $(git -C bench rev-parse HEAD)"; } > "$O/machine.txt"
cd bench && cargo build --release -q > "$O/bench-build.log" 2>&1 || { echo "bench build failed" >> "$O/status.txt"; exit 2; }
./target/release/bench-hashes check --fork "$R/cand" --against "$B" --cells all > "$O/check.out" 2> "$O/check.err"; echo "check exit $?" >> "$O/status.txt"
echo "spindel done" >> "$O/status.txt"
