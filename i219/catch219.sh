#!/bin/bash
# BLAKE3 #219: on AArch64, do the counting tests of candidate/sam-counting-tests catch the
# AArch64 list's twins of the 15 x86-64 rows they caught there? Each mutant is applied with
# cargo-mutants' own diff, its test run in the mutants profile (as check.py builds); then the
# whole suite under nextest.
set -u
R="$1"; O="$R/out"; mkdir -p "$O"; cd "$R"
export HOME=/root; . /root/.cargo/env
{ uname -m; nproc; grep -m1 Features /proc/cpuinfo; rustc --version; cargo mutants --version; cargo nextest --version | head -1; git -C fork log -1 --format='fork %H'; } > "$O/machine.txt" 2>&1
cat > catches.py <<'PY_CATCH_END'
#!/usr/bin/env python3
"""Does a test catch the given mutants? Each mutant (cargo-mutants' own diff,
selected by name regex among FILE's) applied in turn, the test filter run
with cargo test --lib, the file restored.

    catches.py CHECKOUT FILE NAME_REGEX TEST_FILTER [--profile P]
Prints each mutant: CAUGHT (the test fails), MISSED, or NOBUILD.
"""
import json, os, re, subprocess, sys

tree, file, pattern, test = sys.argv[1:5]
profile = sys.argv[sys.argv.index("--profile") + 1] if "--profile" in sys.argv else "test"
listed = json.loads(subprocess.run(["cargo", "mutants", "--list", "--json", "--diff", "-f", file], cwd=tree,
                                   capture_output=True, text=True, check=True).stdout)
picked = [m for m in listed if re.search(pattern, m["name"])]
assert picked, "no mutant matches"
path = os.path.join(tree, file)
original = open(path).read()
missed = 0
for m in picked:
    try:
        subprocess.run(["patch", "-s", "-p0", "-r", os.devnull, path], input=m["diff"], text=True, cwd=tree, check=True)
        r = subprocess.run(["cargo", "test", "--profile", profile, "--lib", test, "--", "--test-threads", "4"],
                           cwd=tree, capture_output=True, text=True, timeout=600)
        out = r.stdout + r.stderr
        if "could not compile" in out or "error[" in out:
            verdict = "NOBUILD"
        elif r.returncode != 0:
            verdict = "CAUGHT"
        elif re.search(r"test result: ok\. [1-9]", out):
            verdict = "MISSED"
            missed += 1
        else:
            verdict = "NO TEST RAN"
            missed += 1
    finally:
        open(path, "w").write(original)
    print(f"{verdict:8} {m['name']}", flush=True)
sys.exit(1 if missed else 0)
PY_CATCH_END
export CARGO_TARGET_DIR="$R/target"
run() { python3 catches.py "$R/fork" "$1" "$2" "$3" --profile mutants >> "$O/catches.txt" 2>&1; echo "group $1 exit $?" >> "$O/status.txt"; }
run src/tree.rs 'in root_children$' tree::test::
run src/each.rs '(:40:.* in hash_each_multithreaded|:279:.*in hash_each_on|:282:.*in hash_each_on)$' each::test::test_hash_each_
run src/hasher.rs ':(341|352):.*in ChunkState<P>::absorb$' hasher::test::
run src/finish.rs '&& with \|\| in Finish::finished$|:76:19: replace & with \| in Finish::finished$' finish::tests::finished_unparks
run src/incremental.rs '(:171:62: replace \|\| with &&|:175:55: replace \* with /|:171:83: replace \+ with -|:175:74: replace \+ with -) in Hasher::gather_part$|:202:9: replace Hasher::held_group .* with None$' incremental::test::
git -C fork status --porcelain --untracked-files=no > "$O/tree-after.txt"
(cd fork && cargo nextest run --features serde,zeroize --lib --tests) > "$O/nextest.txt" 2>&1; echo "nextest exit $?" >> "$O/status.txt"
echo "catch done" >> "$O/status.txt"
