#!/bin/bash
# Make the EVERY_LEN variants of probe/l3-pool 9c25ed9e as commits with fixed metadata, so the
# same commands give the same hashes anywhere. Usage: mkvariants.sh PROBE_CHECKOUT OUTDIR
set -eu
P=$1; OUT=$2; mkdir -p "$OUT"
for v in 8 16 32 64 never; do
  D="$OUT/every-$v"; rm -rf "$D"; git clone -q --no-checkout "$P" "$D"; git -C "$D" checkout -q --detach 9c25ed9ef6b3cb12c2ca8c77955663feeb2f09fa
  if [ $v = never ]; then new='pub(crate) const EVERY_LEN: usize = usize::MAX;'; else new="pub(crate) const EVERY_LEN: usize = $v << 20;"; fi
  python3 - "$D/src/lanes.rs" "$new" <<'PY_END'
import sys
p, new = sys.argv[1], sys.argv[2]; s = open(p).read(); a = 'pub(crate) const EVERY_LEN: usize = 32 << 20;'
assert s.count(a) == 1, s.count(a)
open(p, 'w').write(s.replace(a, new))
PY_END
  if [ $v != 32 ]; then
    GIT_AUTHOR_NAME='Sam Shackleton' GIT_AUTHOR_EMAIL='samshackleton-tech@users.noreply.github.com' GIT_AUTHOR_DATE='2026-11-02T08:00:00+00:00' \
    GIT_COMMITTER_NAME='Sam Shackleton' GIT_COMMITTER_EMAIL='samshackleton-tech@users.noreply.github.com' GIT_COMMITTER_DATE='2026-11-02T08:00:00+00:00' \
      git -C "$D" -c core.hooksPath=/dev/null -c commit.gpgsign=false commit -q -am "Probe (#196) variant: EVERY_LEN $v MiB"
  fi
  echo "$v $(git -C "$D" rev-parse HEAD) $(grep -n 'const EVERY_LEN' "$D/src/lanes.rs" | cut -c1-80)"
done
