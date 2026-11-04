#!/bin/bash
# BLAKE3 #219, the fresh Hasher's prefetch on SME2 machines (run b219-pfsme): this VM has no SME2, so the
# control emulates one: servil ab5e14b1 with the test's early return made unconditional (what an SME2
# machine does: Platform::detect() is SME2 there). Then the fix (fix/sam-prefetch-hasher-neon: the test's
# Hasher on NEON whatever the machine). For each, every mutant of prefetch_update_kernels and of
# Hasher::update's prefetch condition, with prefetch_counts' tests (catches.py, mutants profile).
set -u
R="$1"; O="$R/out"; mkdir -p "$O"; cd "$R"
export HOME=/root; . /root/.cargo/env
{ uname -m; nproc; uptime; grep -m1 Features /proc/cpuinfo; rustc --version; cargo mutants --version; git -C control log -1 --format='control %H'; git -C fix log -1 --format='fix %H'; } > "$O/machine.txt" 2>&1
cat > catches.py <<'PY_CATCH_END'
#!/usr/bin/env python3
"""Does a test catch the given mutants? Each mutant (cargo-mutants' own diff,
selected by name regex among FILE's) applied in turn, the test filter run
with cargo test --lib, the file restored.

    catches.py CHECKOUT FILE NAME_REGEX TEST_FILTER [--profile P]
Prints each mutant: CAUGHT (the test fails), MISSED, or NOBUILD.
"""
import json, os, re, subprocess, sys


def run_group(argv, timeout, **kw):
    """subprocess.run in a session of its own: on a time-out the whole group (cargo and the test
    binaries it started) is killed by its process-group id, never by a pattern (no pkill)."""
    import signal
    p = subprocess.Popen(argv, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True, start_new_session=True, **kw)
    try:
        out, err = p.communicate(timeout=timeout)
    except subprocess.TimeoutExpired:
        os.killpg(p.pid, signal.SIGKILL)
        p.communicate()
        raise
    return subprocess.CompletedProcess(argv, p.returncode, out, err)

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
            r = run_group(["cargo", "test", "--profile", profile, "--lib", test, "--", "--test-threads", "4"],
                               cwd=tree, timeout=600)
        except subprocess.TimeoutExpired:
            # The test hung: no verdict but a time-out (run_group killed its process group).
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
python3 - "$R/control/src/test.rs" <<'PY_CTL_END' || { echo "patch control failed" >> "$O/status.txt"; exit 2; }
import sys
p = sys.argv[1]; s = open(p).read()
a = "        if !matches!(Platform::detect(), Platform::NEON) {\n            return; // a Hasher takes the machine's platform"
assert s.count(a) == 1
open(p, "w").write(s.replace(a, "        if true || !matches!(Platform::detect(), Platform::NEON) {\n            return; // (control: as on an SME2 machine) a Hasher takes the machine's platform"))
PY_CTL_END
git -C control diff --stat > "$O/patch-control.txt"
git -C control -c user.name=job -c user.email=job@localhost -c core.hooksPath=/dev/null commit -qam "job: control"
for v in control fix; do
  export CARGO_TARGET_DIR="$R/target-$v"   # a target directory each: shared, cargo once ran one checkout's test binary for the other's
  python3 catches.py "$R/$v" src/lib.rs 'in prefetch_update_kernels$|replace prefetch_update_kernels with' prefetch_counts --profile mutants > "$O/catches-$v-lib.txt" 2>&1; echo "$v lib exit $?" >> "$O/status.txt"
  python3 catches.py "$R/$v" src/incremental.rs 'in Hasher::update$' prefetch_counts --profile mutants > "$O/catches-$v-update.txt" 2>&1; echo "$v update exit $?" >> "$O/status.txt"
done
(cd fix && CARGO_TARGET_DIR="$R/target-fix" cargo test --features serde,zeroize --lib prefetch_counts) > "$O/tests-fix.txt" 2>&1; echo "fix tests exit $?" >> "$O/status.txt"
echo "pfsme done" >> "$O/status.txt"
