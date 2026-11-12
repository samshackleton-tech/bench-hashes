#!/bin/bash
# The whole mutation run of both crates on the Mac (arm64 macOS), with --write, at a named commit of the
# library: each crate's time, the lists as this machine writes them, every mutant's outcome.
# Run by hand in turn with the runner: mac-heavy bash whole-mac.sh COMMIT OUTDIR
# Single execution: inventory, no speed verdict.
set -uo pipefail
COMMIT="$1"; O="$2"; mkdir -p "$O"
export PATH="/opt/homebrew/opt/python@3.14/libexec/bin:/opt/homebrew/bin:$HOME/.cargo/bin:$PATH" PYTHONUNBUFFERED=1
R="$HOME/tmp/whole-mac"; rm -rf "$R"; mkdir -p "$R"
export GIT_AUTHOR_NAME='Sam Shackleton' GIT_COMMITTER_NAME='Sam Shackleton' GIT_AUTHOR_EMAIL='samshackleton-tech@users.noreply.github.com' GIT_COMMITTER_EMAIL='samshackleton-tech@users.noreply.github.com'
git -C "$HOME/work/b3-independent-flat" worktree prune
git -C "$HOME/work/b3-independent-flat" worktree add -q --detach "$R/library" "$COMMIT" || exit 1
cd "$R/library"
{ echo "library $(git rev-parse HEAD)"; rustc -Vv; sysctl -n hw.ncpu machdep.cpu.brand_string; uname -m; cargo mutants --version; } > "$O/identity.txt" 2>&1
CARGO_TARGET_DIR="$R/b3sum-target" cargo install --locked --version '=1.8.7' b3sum --root "$R/b3sum-official-1.8.7" > "$O/install-b3sum.log" 2>&1 < /dev/null
export MUTANTS_B3SUM="$R/b3sum-official-1.8.7/bin/b3sum"
export TMPDIR="$R/tmp"; mkdir -p "$TMPDIR"
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
git diff -- tools/mutants > "$O/lists.diff"
mkdir -p "$O/lists/threads"
cp tools/mutants/known-arm64.txt tools/mutants/timeouts-arm64.txt "$O/lists/" 2>/dev/null
cp tools/mutants/threads/known-arm64.txt tools/mutants/threads/timeouts-arm64.txt "$O/lists/threads/" 2>/dev/null
cat "$O/status.txt"
for n in core threads; do [ -f "$O/outcomes-$n.tsv" ] || continue; echo "$n: $(cut -f3 "$O/outcomes-$n.tsv" | sort | uniq -c | tr '\n' ' ')"; grep -E '^mutants:' "$O/whole-$n.log" | tail -n 4; done
echo "both crates ran" >> "$O/status.txt"
