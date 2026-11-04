#!/bin/bash
# bench-hashes #125, the draft (candidate/sam-same-code) at work (run b125-gate): `bench-hashes check`
# from the draft's checkout, with the fork's checkout:
#   1. at #228 merged (53cf44cc) against its base 759a1f44: expected "same code", exit 0;
#   2. at 759a1f44 with MIN_SPLIT_LEN halved in its working tree, against HEAD: expected the
#      functions named and the check going on (stopped by timeout after its first verdict);
#   3. at 759a1f44 with PREFETCH_BELOW halved (AArch64-only code): same code on x86-64, not on AArch64.
set -u
R="$1"; O="$R/out"; mkdir -p "$O"; cd "$R"
. /root/.cargo/env
{ uname -m; grep -m1 -E 'model name' /proc/cpuinfo; rustc --version; echo "bench $(git -C bench rev-parse HEAD)"; echo "fork $(git -C fork rev-parse HEAD)"; } > "$O/machine.txt"
B=759a1f44962a8ce280c51adfee743b4306692af6; M=53cf44cc7b50de5207e979d89ade3f7bdef2315d
git -C fork cat-file -e "$M^{commit}" 2>/dev/null || git -C fork fetch -q https://github.com/johnservil/BLAKE3 "$M"
(cd bench && cargo build --release) > "$O/bench-build.log" 2>&1 || { echo "bench build failed" >> "$O/status.txt"; exit 2; }
BH="$R/bench/target/release/bench-hashes"
run() { # name limit
  (cd "$R/bench" && timeout "$2" "$BH" check --fork "$R/fork" --against "$B") > "$O/check-$1.out" 2> "$O/check-$1.err"
  echo "check $1 exit $?" >> "$O/status.txt"
}
git -C fork checkout -q --detach "$M"; run merged 1800
git -C fork checkout -q --detach "$B"
python3 - fork/src/lanes.rs "pub(crate) const MIN_SPLIT_LEN: usize = 512 * 1024;" "pub(crate) const MIN_SPLIT_LEN: usize = 256 * 1024;" <<'PY_SUB_END'
import sys
p, a, b = sys.argv[1:4]; s = open(p).read(); assert s.count(a) == 1; open(p, "w").write(s.replace(a, b))
PY_SUB_END
run splitlen 600
git -C fork checkout -q -- .
python3 - fork/src/lib.rs "const PREFETCH_BELOW: usize = 64 * 1024;" "const PREFETCH_BELOW: usize = 32 * 1024;" <<'PY_SUB_END'
import sys
p, a, b = sys.argv[1:4]; s = open(p).read(); assert s.count(a) == 1; open(p, "w").write(s.replace(a, b))
PY_SUB_END
run prefetch 600
git -C fork checkout -q -- .
echo "gate done" >> "$O/status.txt"
