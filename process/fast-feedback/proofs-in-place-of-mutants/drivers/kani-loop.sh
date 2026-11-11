#!/bin/bash
# Experiment (BLAKE3 #361): Kani on a loop over a slice. It proves the function for slices up to
# a length given as an unwinding bound: the time for bounds 4, 16, 64, 256, and what it says with
# no bound. Records each step; no step's failure hides the rest.
set -euo pipefail
exec timeout -k 15s 2400s bash -s -- "$1" <<'JOB'
set -uo pipefail
R="$1";O="$R/out";mkdir -p "$O";export HOME=/root;. <home>/.cargo/env
{ echo "library $(git -C "$R/library" rev-parse HEAD)"; cargo kani --version 2>&1 | head -n 2; nproc; } > "$O/identity.txt"
: > "$O/steps.txt"
mkdir -p "$R/k/src"; cd "$R/k"
printf '[package]\nname = "scan-proof"\nversion = "0.1.0"\nedition = "2021"\n[lints.rust]\nunexpected_cfgs = { level = "allow" }\n' > Cargo.toml
gen() { # bound
cat > src/lib.rs <<RS
pub fn scan(words: &mut [u32], seed: u32) -> u32 {
    let mut a = seed;
    for w in words.iter_mut() {
        a = a.rotate_left(5) ^ *w;
        *w = a;
    }
    a
}
#[cfg(kani)]
mod proof {
    use super::*;
    const N: usize = $1;
    /// The rule: the fold of the first i words.
    fn fold(seed: u32, ws: &[u32], upto: usize) -> u32 {
        let mut a = seed; let mut i = 0;
        while i < upto { a = a.rotate_left(5) ^ ws[i]; i += 1; }
        a
    }
    #[kani::proof]
    $2
    fn scan_is_the_scan() {
        let mut ws: [u32; N] = kani::any();
        let before = ws;
        let len: usize = kani::any();
        kani::assume(len <= N);
        let seed: u32 = kani::any();
        let r = scan(&mut ws[..len], seed);
        assert_eq!(r, fold(seed, &before, len));
        let i: usize = kani::any();
        kani::assume(i < len);
        assert_eq!(ws[i], fold(seed, &before, i + 1));
    }
}
RS
}
for n in 4 16 64 256; do
  gen $n "#[kani::unwind($((n + 2)))]"
  s=$(date +%s.%N); timeout 900 cargo kani > "$O/kani-$n.log" 2>&1 < /dev/null; rc=$?
  echo "bound $n rc=$rc $(python3 -c "import sys,time; print(round(time.time()-float(sys.argv[1]),1))" "$s")s $(grep -E 'VERIFICATION|Verification Time' "$O/kani-$n.log" | tr '\n' ' ')" >> "$O/steps.txt"
done
gen 8 ""
s=$(date +%s.%N); timeout 300 cargo kani > "$O/kani-nobound.log" 2>&1 < /dev/null; rc=$?
echo "no unwinding bound (array of 8) rc=$rc $(python3 -c "import sys,time; print(round(time.time()-float(sys.argv[1]),1))" "$s")s $(grep -E 'VERIFICATION|Verification Time|unwinding' "$O/kani-nobound.log" | head -n 3 | tr '\n' ' ')" >> "$O/steps.txt"
cat "$O/steps.txt"; echo "kani loop experiment done" > "$O/status.txt"
JOB
