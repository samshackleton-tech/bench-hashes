#!/bin/bash
# The whole mutation run of the two-crate trial (BLAKE3 #335), both crates, with
# --write: each crate's time, its lists as this machine writes them, and every
# mutant's outcome. Single execution: inventory, no speed verdict.
set -euo pipefail
exec timeout -k 30s 12600s bash -s -- "$1" <<'JOB'
set -uo pipefail
R="$1";O="$R/out";mkdir -p "$O";export HOME=/root;. <home>/.cargo/env
export CARGO_TARGET_DIR="$R/target" TMPDIR="$R/whole-tmp" PYTHONUNBUFFERED=1;mkdir -p "$TMPDIR"
export GIT_AUTHOR_NAME='Sam Shackleton' GIT_COMMITTER_NAME='Sam Shackleton' GIT_AUTHOR_EMAIL='samshackleton-tech@users.noreply.github.com' GIT_COMMITTER_EMAIL='samshackleton-tech@users.noreply.github.com'
cd "$R/library"
{ for repo in library mutator;do echo "$repo $(git -C "$R/$repo" rev-parse HEAD)";done;rustc -Vv;nproc;grep -o -m1 avx512f /proc/cpuinfo || echo "no avx512f"; } > "$O/identity.txt"
CARGO_TARGET_DIR="$R/mutator-target" cargo install --locked --path "$R/mutator" --root "$R/mutator-install" > "$O/install-mutator.log" 2>&1 < /dev/null
export PATH="$R/mutator-install/bin:$PATH"
CARGO_TARGET_DIR="$R/b3sum-target" cargo install --locked --version '=1.8.7' b3sum --root "$R/target/b3sum-official-1.8.7" > "$O/install-b3sum.log" 2>&1 < /dev/null
export MUTANTS_B3SUM="$R/target/b3sum-official-1.8.7/bin/b3sum"
unset CARGO_TARGET_DIR
for crate in . threads; do
  name=$([ $crate = . ] && echo core || echo threads)
  start=$(date +%s)
  python3 tools/mutants/check.py --whole --write --crate $crate > "$O/whole-$name.log" 2>&1 < /dev/null; rc=$?
  echo "$name: whole run with --write exit $rc in $(( $(date +%s) - start )) s" >> "$O/status.txt"
  last=tmp/mutants-last$([ $crate = . ] || echo /threads)
  python3 - "$last" > "$O/outcomes-$name.tsv" <<'PY'
import json,glob,sys
for label in ("run","loom"):
    for p in sorted(glob.glob(sys.argv[1]+f"/{label}/shard*/outcomes.json")):
        with open(p) as f:
            for x in json.load(f)["outcomes"]:
                s=x["scenario"]
                if s!="Baseline": print(label+"\t"+s["Mutant"]["name"]+"\t"+x["summary"]+"\t"+str(round(sum(ph.get("duration",0) for ph in x.get("phase_results",[])),2)))
PY
done
git diff -- tools/mutants > "$O/lists.diff"; mkdir -p "$O/lists/threads"; cp tools/mutants/known-x86_64.txt tools/mutants/timeouts-x86_64.txt "$O/lists/"; cp tools/mutants/threads/known-x86_64.txt tools/mutants/threads/timeouts-x86_64.txt "$O/lists/threads/"; git checkout -q -- tools/mutants
cat "$O/status.txt"; for n in core threads; do echo "$n: $(cut -f3 "$O/outcomes-$n.tsv" | sort | uniq -c | tr '\n' ' ')"; grep -E '^mutants:' "$O/whole-$n.log" | tail -n 4; done
echo "both crates ran" >> "$O/status.txt"
JOB
