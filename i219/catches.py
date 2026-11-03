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
