#!/bin/bash
set -euo pipefail
R="$1";O="$R/out";mkdir -p "$O";export HOME=/root;. /root/.cargo/env
E="$R/evidence"
{ echo "data $(git -C "$E" rev-parse HEAD)";echo "bench $(git -C "$R/bench" rev-parse HEAD)";echo 'Analysis only: immutable x86 samples, not a new native timing run'; } > "$O/identity.txt"
mkdir -p "$R/judge/src"
cp "$E/scripts/aa-judge.rs" "$R/judge/src/main.rs"
printf '[package]\nname="finalaajudge"\nversion="0.1.0"\nedition="2021"\n[dependencies]\nclocks={path="%s/bench/clocks"}\n' "$R" > "$R/judge/Cargo.toml"
(cd "$R/judge" && CARGO_TARGET_DIR="$R/target" cargo build --release) > "$O/build.log" 2>&1
python3 - "$E" <<'PY'
import pathlib,sys
D=pathlib.Path(sys.argv[1])/'frozen-multibuffer-runs'
runs=list(D.glob('frozen-multibuffer-*'))
assert len(runs)==4
for r in runs:
 s=(r/'out/identity.txt').read_text()
 assert 'library 1fb068fe77dc571ec47241753a0c35663b514c2f' in s
 assert 'isal f22c49aef162d7632bde4f22dc7491b22f0a7fc2' in s
 for side in ['old','new']:
  for p in range(1,5):assert (r/f'out/{side}-{p}.tsv').is_file()
PY
for D in "$E"/frozen-multibuffer-runs/frozen-multibuffer-*;do
 for A in b3 mb_sha256 sha256;do
  "$R/target/release/finalaajudge" "$D/out" "$A" > "$O/$(basename "$D")-$A.tsv"
 done
done
python3 - "$O" <<'PY'
import pathlib,sys,csv,collections
O=pathlib.Path(sys.argv[1]);files=list(O.glob('frozen-multibuffer-*.tsv'));assert len(files)==12
with (O/'summary.txt').open('w') as out:
 for p in sorted(files):
  rows=list(csv.DictReader(p.open(),delimiter='\t'));assert len(rows)==180
  print(p.name,dict(collections.Counter(r['verdict'] for r in rows)),file=out)
print('A/A analysis done: 12 separate 180-metric families',file=(O/'status.txt').open('w'))
PY
