#!/bin/bash
# Experiment (BLAKE3 #361): Kani on x86-64 detection's decisions, the source as it is in src/platform.rs,
# against the rule written a feature at a time, for every input. Times the install, the proof, and
# seventeen wrong versions that the proof must reject.
set -euo pipefail
exec timeout -k 15s 3000s bash -s -- "$1" <<'JOB'
set -uo pipefail
R="$1";O="$R/out";mkdir -p "$O";export HOME=/root;. <home>/.cargo/env
cat > "$R/extract.py" <<'EXTRACT_PY'
"""A standalone Rust file of x86-64 detection's pure decisions, cut from src/platform.rs as it is:
the constants, CpuWords, os_saves_avx, features_of, family, wide_cpu. Fails if a piece is missing."""
import re, sys
src = open(sys.argv[1]).read()
def item(start, end="\n}\n"):
    a = src.index(start); b = src.index(end, a) + len(end); return src[a:b]
bits = item("mod x86_bits {")
out = ["#![allow(dead_code)]", bits.replace("mod x86_bits", "pub mod x86_bits"),
       item("#[derive(Clone, Copy, Default, PartialEq, Eq, Debug)]\nstruct CpuWords {"),
       item("const fn os_saves_avx("), item("const fn features_of("), item("const fn family("), item("const fn wide_cpu(")]
text = "\n".join(out)
text = text.replace("struct CpuWords", "pub struct CpuWords").replace("    leaf1_eax: u32", "    pub leaf1_eax: u32").replace("    leaf1_ecx: u32", "    pub leaf1_ecx: u32")
text = text.replace("    xcr0: u32", "    pub xcr0: u32").replace("    leaf7_ebx: u32", "    pub leaf7_ebx: u32").replace("    amd: bool", "    pub amd: bool")
for f in ("os_saves_avx", "features_of", "family", "wide_cpu"):
    text = text.replace(f"const fn {f}(", f"pub const fn {f}(")
text = re.sub(r"(?m)^\s*#\[cfg[^\n]*\]\n", "", text)
open(sys.argv[2], "w").write(text + "\n")
EXTRACT_PY
{ echo "library $(git -C "$R/library" rev-parse HEAD)"; rustc -V; nproc; } > "$O/identity.txt"
s=$SECONDS; cargo install --locked kani-verifier > "$O/install.log" 2>&1 < /dev/null; echo "install rc=$? $((SECONDS-s))s" > "$O/steps.txt"
s=$SECONDS; cargo kani setup > "$O/setup.log" 2>&1 < /dev/null; echo "setup rc=$? $((SECONDS-s))s" >> "$O/steps.txt"
cargo kani --version > "$O/kani-version.txt" 2>&1 < /dev/null
mkdir -p "$R/k/src"; cd "$R/k"
printf '[package]\nname = "detect-proof"\nversion = "0.1.0"\nedition = "2024"\n[lints.rust]\nunexpected_cfgs = { level = "allow" }\n' > Cargo.toml
python3 "$R/extract.py" "$R/library/src/platform.rs" src/detect.rs
cat > src/lib.rs <<'RS'
pub mod detect;
#[cfg(kani)]
mod proof {
    use crate::detect::*;
    use crate::detect::x86_bits::*;
    fn bit(w: u32, n: u32) -> bool { w & (1 << n) != 0 }
    /// The rule, a feature at a time.
    fn rule(c: CpuWords) -> u8 {
        let base = (c.leaf1_eax >> 8) & 0xF;
        let family = if base == 0xF { base + ((c.leaf1_eax >> 20) & 0xFF) } else { base };
        let sse41 = bit(c.leaf1_ecx, 19);
        let os = bit(c.leaf1_ecx, 26) && bit(c.leaf1_ecx, 27) && bit(c.leaf1_ecx, 28);
        let avx2 = os && bit(c.xcr0, 1) && bit(c.xcr0, 2) && bit(c.leaf7_ebx, 5);
        let avx512 = os && bit(c.xcr0, 1) && bit(c.xcr0, 2) && bit(c.xcr0, 5) && bit(c.xcr0, 6) && bit(c.xcr0, 7) && bit(c.leaf7_ebx, 16) && bit(c.leaf7_ebx, 31);
        let wide = avx512 && c.amd && family >= 0x1A;
        READ | if sse41 { SSE41 } else { 0 } | if avx2 { AVX2 } else { 0 } | if avx512 { AVX512 } else { 0 } | if wide { WIDE } else { 0 }
    }
    #[kani::proof]
    fn features_of_is_the_rule() {
        let c = CpuWords { leaf1_eax: kani::any(), leaf1_ecx: kani::any(), xcr0: kani::any(), leaf7_ebx: kani::any(), amd: kani::any() };
        assert_eq!(features_of(c), rule(c));
    }
}
RS
cp src/detect.rs "$O/detect.rs"
s=$SECONDS; cargo kani > "$O/kani.log" 2>&1 < /dev/null; echo "proof rc=$? $((SECONDS-s))s $(grep -E 'VERIFICATION|Verification Time' "$O/kani.log" | tr '\n' ' ')" >> "$O/steps.txt"
s=$SECONDS; cargo kani > "$O/kani-again.log" 2>&1 < /dev/null; echo "proof again rc=$? $((SECONDS-s))s" >> "$O/steps.txt"
# Wrong versions: each must fail verification.
python3 - "$O" <<'PY'
import subprocess, sys, time
from pathlib import Path
out = sys.argv[1]; p = Path("src/detect.rs"); good = p.read_text()
muts = [("1 << 19", "1 << 18"), ("(1 << 26) | (1 << 27)", "(1 << 26) & (1 << 27)"), ("leaf1_ecx & avx == avx", "leaf1_ecx & avx != avx"), ("(0b110, 0b1110_0110)", "(0b100, 0b1110_0110)"),
        ("(0b110, 0b1110_0110)", "(0b110, 0b1110_0100)"), ("words.xcr0 & ymm == ymm &&", "words.xcr0 & ymm == ymm ||"), ("1 << 5", "1 << 6"), ("(1 << 16) | (1 << 31)", "(1 << 16)"),
        ("words.leaf7_ebx & f_vl == f_vl", "words.leaf7_ebx & f_vl != 0"), ("family >= 0x1A", "family > 0x1A"), ("amd && family", "amd || family"), ("features |= WIDE", "features |= AVX512"),
        ("(eax >> 8) & 0xF", "(eax >> 8) & 0x7"), ("(eax >> 20) & 0xFF", "(eax >> 16) & 0xFF"), ("if base == 0xF", "if base != 0xF"), ("features |= AVX2;", ""), ("let mut features = READ;", "let mut features = 0;"),
        ("(1 << 26) | (1 << 27)", "(1 << 26) ^ (1 << 27)"), ("features |= SSE41", "features ^= SSE41")]
rows = []
for old, new in muts:
    assert old in good, old
    p.write_text(good.replace(old, new, 1)); t = time.time()
    r = subprocess.run(["cargo", "kani"], capture_output=True, text=True, stdin=subprocess.DEVNULL)
    verdict = "rejected" if "VERIFICATION:- FAILED" in r.stdout else "ACCEPTED" if "VERIFICATION:- SUCCESSFUL" in r.stdout else "error"
    rows.append(f"{verdict}\t{time.time()-t:.1f}s\t{old} -> {new}")
p.write_text(good)
Path(out, "mutants.tsv").write_text("\n".join(rows) + "\n")
PY
cat "$O/steps.txt"; cut -f1 "$O/mutants.tsv" | sort | uniq -c
echo "kani experiment done" > "$O/status.txt"
JOB
