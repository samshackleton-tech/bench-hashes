#!/bin/bash
# Stable bench-hashes 0.20.4 scoped regress, not the retired coverage-wide
# check. Builds against each pinned library through build-against. Four
# fresh builds per side (distinct Rust metadata/layouts), alternating runs;
# regress supplies the clock, statistics, load rule and reported verdicts.
set -euo pipefail
R="$1"; O="$R/out"; mkdir -p "$O"; cd "$R"
export HOME=/root; . /root/.cargo/env
POINTS='continuous 1 MiB,continuous 4 MiB,continuous 64 KiB,continuous batch 1024,continuous collection git objects,continuous collection Nix files'
{ date -u; uname -a; grep -m1 'model name' /proc/cpuinfo; for s in old new bench; do echo "$s $(git -C "$s" rev-parse HEAD)"; done; } > "$O/identity.txt"
(cd "$R/bench" && CARGO_TARGET_DIR="$R/bootstrap" cargo build --release) > "$O/bootstrap.log" 2>&1
B="$R/bootstrap/release/bench-hashes"
for pair in 1 2 3 4; do
 for side in old new; do
  (cd "$R/bench" && RUSTFLAGS="-C metadata=scoped_pair_$pair" CARGO_TARGET_DIR="$R/target-$side-$pair" "$B" build-against "$R/$side") > "$O/build-$side-$pair.out" 2> "$O/build-$side-$pair.err"
  cp "$(tail -n 1 "$O/build-$side-$pair.out")" "$O/exe-$side-$pair"
  "$O/exe-$side-$pair" provenance > "$O/provenance-$side-$pair.txt"
 done
done
cd "$O"
set +e
"$O/exe-new-1" regress --contenders blake3-servil-st,blake3-servil-mt --points "$POINTS" \
 "$O/exe-old-1" "$O/exe-old-2" "$O/exe-old-3" "$O/exe-old-4" -- \
 "$O/exe-new-1" "$O/exe-new-2" "$O/exe-new-3" "$O/exe-new-4" > "$O/regress.out" 2> "$O/regress.err"
rc=$?
set -e
echo "regress exit $rc" > "$O/status.txt"
[ "$rc" -le 2 ] || exit "$rc"
echo 'scoped regress done' >> "$O/status.txt"
