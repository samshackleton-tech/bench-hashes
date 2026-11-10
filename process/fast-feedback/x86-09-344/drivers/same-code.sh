#!/bin/bash
# Is the library's machine code on this target the same at the candidate as at next?
# Clean release builds, no incremental state; the code bytes of every object in the
# rlib compared; next built twice as the control.
set -euo pipefail
exec timeout -k 15s 1500s bash -s -- "$1" <<'JOB'
set -euo pipefail
R="$1";O="$R/out";mkdir -p "$O";export HOME=/root;. <home>/.cargo/env
export CARGO_INCREMENTAL=0
{ for r in library baseline; do echo "$r $(git -C "$R/$r" rev-parse HEAD)"; done; rustc -Vv | grep -E '^(rustc|host)'; } > "$O/identity.txt"
build() { # checkout dir, label, features
  rm -rf "$R/t-$2"; (cd "$R/$1" && CARGO_TARGET_DIR="$R/t-$2" cargo build --release $3 > "$O/build-$2.log" 2>&1)
  mkdir -p "$R/x-$2"; cp "$R/t-$2/release/libblake3_servil.rlib" "$R/x-$2/"; (cd "$R/x-$2" && ar x libblake3_servil.rlib && for o in *.o; do objcopy -O binary -j '.text*' "$o" "$o.text" 2>/dev/null || : > "$o.text"; echo "$(stat -c %s "$o.text") $(sha256sum "$o.text" | cut -c1-16)"; done | sort > "$O/$2.txt")
  echo "$2: $(wc -l < "$O/$2.txt") objects, $(awk '{s+=$1} END {print s}' "$O/$2.txt") code bytes" >> "$O/sizes.txt"; rm -rf "$R/t-$2"
}
for f in "default:" "features:--features serde,zeroize"; do n=${f%%:*}; a=${f#*:}
  build baseline next-$n-1 "$a"; build library candidate-$n "$a"; build baseline next-$n-2 "$a"
  cmp -s "$O/next-$n-1.txt" "$O/next-$n-2.txt" && echo "$n: next built twice: identical" >> "$O/status.txt" || echo "$n: next built twice: DIFFERENT (the comparison means nothing)" >> "$O/status.txt"
  cmp -s "$O/next-$n-1.txt" "$O/candidate-$n.txt" && echo "$n: candidate against next: identical code in every object" >> "$O/status.txt" || echo "$n: candidate against next: $(diff "$O/next-$n-1.txt" "$O/candidate-$n.txt" | grep -c '^<') objects DIFFER" >> "$O/status.txt"
done
cat "$O/sizes.txt" "$O/status.txt"; echo "comparison done" >> "$O/status.txt"
JOB
