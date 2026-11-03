#!/bin/bash
# BLAKE3 #219 (Devon's #228): the AArch64 twins of the 15 x86-64 rows its tests now catch (all
# still in known-aarch64.txt at its commit). Each mutant applied on the AmpereOne (Linux,
# FEAT_SHA3, no SME2), the library's tests run in the mutants profile. A catch here is evidence for
# the Mac's list; a miss in code only SME2 runs says nothing for it.
set -u
R="$1"; O="$R/out"; mkdir -p "$O"; cd "$R"
export HOME=/root; . /root/.cargo/env
{ uname -m; nproc; grep -m1 Features /proc/cpuinfo; rustc --version; cargo mutants --version; git -C fork log -1 --format='fork %H'; } > "$O/machine.txt" 2>&1
cat > names.txt <<'NAMES_END'
src/lanes.rs	replace > with < in sources::open	1
src/lanes.rs	replace > with == in sources::open	1
src/lanes.rs	replace > with >= in sources::open	1
src/lanes.rs	replace sources::closed with ()	1
src/lanes.rs	replace sources::open -> bool with false	1
src/lanes.rs	replace sources::open -> bool with true	1
src/lanes.rs	replace sources::opened with ()	1
src/many.rs	delete match arm 3 in hash_four_at_a_time	1
src/many.rs	replace != with == in hash_four_at_a_time	1
src/many.rs	replace % with + in hash_four_at_a_time	1
src/many.rs	replace % with / in hash_four_at_a_time	1
src/many.rs	replace && with || in hash_four_at_a_time	1
src/many.rs	replace * with / in hash_four_at_a_time	1
src/many.rs	replace - with + in hash_four_at_a_time	1
src/many.rs	replace > with >= in hash_four_at_a_time	1
NAMES_END
cat > catch_names.py <<'PY_CATCH_END'
#!/usr/bin/env python3
"""Do the library's tests catch the named mutants? NAMES lines: file <TAB> mutant (no line) [<TAB> ...].
Every place of each name (cargo-mutants' own diffs) applied in turn, `cargo test --profile mutants
--lib` run, the file restored. Prints CAUGHT / MISSED / NOBUILD / TIMEOUT per place.
    catch_names.py CHECKOUT NAMES"""
import json, os, re, resource, subprocess, sys

def cap_memory():
    # A mutant's test that allocates without end fails its allocation (a catch), rather than
    # taking the machine's memory and the job with it: 8 GiB of data a process (rustc needs less).
    resource.setrlimit(resource.RLIMIT_DATA, (8 << 30, 8 << 30))
tree, names_path = sys.argv[1:3]
NAME = re.compile(r"^(\S+?):\d+:\d+: (.*)$")
want = {tuple(l.rstrip('\n').split('\t')[:2]) for l in open(names_path) if '\t' in l}
files = sorted({f for f, _ in want})
listed = json.loads(subprocess.run(["cargo", "mutants", "--list", "--json", "--diff", *sum((["-f", f] for f in files), [])], cwd=tree, capture_output=True, text=True, check=True).stdout)
picked = [m for m in listed if (lambda g: (g.group(1), g.group(2)) in want)(NAME.match(m["name"]))]
found = {(NAME.match(m["name"]).group(1), NAME.match(m["name"]).group(2)) for m in picked}
for k in sorted(want - found): print(f"NOT IN SOURCE  {k[0]}: {k[1]}", flush=True)
for m in picked:
    path = os.path.join(tree, m["file"]); original = open(path).read()
    try:
        subprocess.run(["patch", "-s", "-p0", "-r", os.devnull, path], input=m["diff"], text=True, cwd=tree, check=True)
        try:
            r = subprocess.run(["cargo", "test", "--profile", "mutants", "--features", "serde,zeroize", "--lib", "--", "--test-threads", "4"], cwd=tree, capture_output=True, text=True, timeout=900, preexec_fn=cap_memory)
        except subprocess.TimeoutExpired:
            subprocess.run(["pkill", "-f", "--", "--test-threads 4"], capture_output=True)
            print(f"TIMEOUT  {m['name']}", flush=True); continue
        out = r.stdout + r.stderr
        v = "NOBUILD" if ("could not compile" in out or "error[" in out) else ("CAUGHT" if r.returncode != 0 else "MISSED")
    finally:
        open(path, "w").write(original)
    print(f"{v:8} {m['name']}", flush=True)
PY_CATCH_END
export CARGO_TARGET_DIR="$R/target"
python3 catch_names.py "$R/fork" names.txt > "$O/catches.txt" 2> "$O/catches.err"; echo "catch exit $?" >> "$O/status.txt"
git -C fork status --porcelain --untracked-files=no > "$O/tree-after.txt"
echo "twins done" >> "$O/status.txt"
