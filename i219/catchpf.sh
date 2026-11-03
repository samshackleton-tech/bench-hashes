#!/bin/bash
# BLAKE3 #219, the prefetch family on AArch64 (candidate/sam-prefetch-counts): each mutant of the
# prefetch functions (cargo-mutants 27.1.0's own diff), its prefetch_counts tests run in the mutants
# profile; then the whole suite under nextest (pool_fairness is known to fail on this 4-vCPU VM).
set -u
R="$1"; O="$R/out"; mkdir -p "$O"; cd "$R"
export HOME=/root; . /root/.cargo/env
{ uname -m; nproc; uptime; grep -m1 Features /proc/cpuinfo; rustc --version; cargo mutants --version; git -C fork log -1 --format='fork %H'; } > "$O/machine.txt" 2>&1
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
        try:
            r = subprocess.run(["cargo", "test", "--profile", profile, "--lib", test, "--", "--test-threads", "4"],
                               cwd=tree, capture_output=True, text=True, timeout=600)
        except subprocess.TimeoutExpired:
            # The test hung: no verdict but a time-out (its process is left to the timeout's kill).
            subprocess.run(["pkill", "-f", "--", "--test-threads 4"], capture_output=True)
            print(f"TIMEOUT  {m['name']}", flush=True)
            missed += 1
            continue
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
python3 catches.py "$R/fork" src/lib.rs '(in (batch_after_pause|code_may_be_cold|prefetch_after_pause|prefetch_kernels|prefetch_update_kernels)|^src/lib.rs:(1091|1232|1129|1138):|replace (batch_after_pause|code_may_be_cold) -> bool|replace (prefetch_after_pause|prefetch_kernels|prefetch_update_kernels) with)' prefetch_counts --profile mutants >> "$O/catches.txt" 2>&1; echo "group exit $?" >> "$O/status.txt"
python3 catches.py "$R/fork" src/platform.rs '(in (prefetch_code|ticks_in_100_us|counter)$|replace (counter|ticks_in_100_us) -> u64|replace prefetch_code with)' prefetch_counts --profile mutants >> "$O/catches.txt" 2>&1; echo "group exit $?" >> "$O/status.txt"
python3 catches.py "$R/fork" src/ffi_neon_hybrid.rs '(in (prefetch_message_code|prefetch_pair_code|prefetch_parent_code|prefetch_tree_code)$|replace (chunk_code|parent_code) ->|replace (prefetch_message_code|prefetch_pair_code|prefetch_parent_code|prefetch_tree_code) with)' prefetch_counts --profile mutants >> "$O/catches.txt" 2>&1; echo "group exit $?" >> "$O/status.txt"
python3 catches.py "$R/fork" src/incremental.rs 'in Hasher::update$' prefetch_counts --profile mutants >> "$O/catches.txt" 2>&1; echo "group exit $?" >> "$O/status.txt"

git -C fork status --porcelain --untracked-files=no > "$O/tree-after.txt"
(cd fork && cargo nextest run --features serde,zeroize --lib --tests) > "$O/nextest.txt" 2>&1; echo "nextest exit $?" >> "$O/status.txt"
echo "catch done" >> "$O/status.txt"
