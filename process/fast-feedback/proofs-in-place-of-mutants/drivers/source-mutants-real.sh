#!/bin/bash
# The proof as the test, on the core crate's own functions (BLAKE3 #361, step 3): every source mutant
# cargo-mutants plants in CvStack::merge and Hash::to_hex (two-crate trial), judged by the function's
# theorem. For each mutant: apply it, build the crate for release, take the function's listing, lift
# it, and build the theorem on that code with no edit of the proof. Verdicts: "same bytes", "proved"
# (other bytes, the theorem checks), "rejected" (it does not), "lifter stops", "does not build".
set -uo pipefail
R="$1";O="$R/out";mkdir -p "$O";export HOME=/root;. <home>/.cargo/env
export ELAN_HOME="$R/elan"; export PATH="$ELAN_HOME/bin:$PATH"
{ echo "library $(git -C "$R/library" rev-parse HEAD)"; echo "crate $(git -C "$R/crate" rev-parse HEAD)"; rustc -V; cargo mutants --version; nproc; } > "$O/identity.txt" 2>&1
curl -sSf https://elan.lean-lang.org/elan-init.sh | sh -s -- -y --default-toolchain none --no-modify-path > "$O/elan.log" 2>&1
M="$R/library/tools/verify/machine"
(cd "$M/one" && lake build MergeSpec > "$O/build-one.log" 2>&1 < /dev/null) || { echo "one/ does not build"; exit 1; }
(cd "$M/hex" && lake build > "$O/build-hex.log" 2>&1 < /dev/null) || { echo "hex/ does not build"; exit 1; }
(cd "$R/crate" && cargo mutants --list --json --diff -f src/hasher.rs -f src/lib.rs > "$R/mutants.json" 2> "$O/list.err" < /dev/null)
cat > "$R/driver.py" <<'DRIVER_PY'
import collections, concurrent.futures, glob, json, os, re, shutil, subprocess, sys, time
R, O = sys.argv[1], sys.argv[2]
crate = f"{R}/crate"; M = f"{R}/library/tools/verify/machine"
SUBJECTS = {  # function name as cargo-mutants gives it -> (source file, symbol pattern, folder)
    "CvStack::merge": ("src/hasher.rs", r"CvStack>::merge::<", "one"),
    "Hash::to_hex": ("src/lib.rs", r"Hash>::to_hex$", "hex"),
}
mutants = [m for m in json.load(open(f"{R}/mutants.json")) if (m.get("function") or {}).get("function_name") in SUBJECTS]
def sh(cmd, cwd, timeout=1500, env=None):
    try:
        return subprocess.run(cmd, cwd=cwd, capture_output=True, text=True, timeout=timeout, env=env, stdin=subprocess.DEVNULL)
    except subprocess.TimeoutExpired:
        return subprocess.CompletedProcess(cmd, 124, "", "timed out")
def listing(xdir, pattern):
    """The function's block of llvm-objdump's listing, or None."""
    for obj in sorted(glob.glob(xdir + "/*.rcgu.o")):
        text = sh(["llvm-objdump", "-d", "-r", "-C", "-M", "intel", obj], xdir).stdout
        for block in re.split(r"\n(?=[0-9a-f]+ <)", text):
            m = re.match(r"^[0-9a-f]+ <(.+)>:", block)
            if m and re.search(pattern, re.sub(r" \(\.llvm\.\d+\)", "", m.group(1))):
                return block.split("\nDisassembly of section")[0].rstrip() + "\n"
    return None
def insns(text):
    return [re.sub(r"\s+", " ", l.split("\t", 1)[0].split(":", 1)[1]).strip() for l in text.splitlines() if re.match(r"^\s+[0-9a-f]+:\s+(?:[0-9a-f]{2} )+", l)]
def build_crate(tree, env, xdir):
    b = sh(["cargo", "build", "--release"], tree, env=env)
    if b.returncode: return False
    shutil.rmtree(xdir, ignore_errors=True); os.makedirs(xdir)
    rlib = glob.glob(env["CARGO_TARGET_DIR"] + "/release/lib*.rlib")[0]
    shutil.copy(rlib, xdir); sh(["ar", "x", os.path.basename(rlib)], xdir)
    return True
# the unmutated build's listings, to recognise the same bytes (and to check that this build is the proved one)
env0 = dict(os.environ, CARGO_TARGET_DIR=f"{R}/target-base", CARGO_INCREMENTAL="0")
assert build_crate(crate, env0, f"{R}/x-base")
BASE = {name: insns(listing(f"{R}/x-base", pat)) for name, (_, pat, _) in SUBJECTS.items()}
print({k: len(v) for k, v in BASE.items()}, "instructions in the unmutated build")
def judge(name, text, k):
    """Lift this listing in a copy of the function's folder and build its theorem. (verdict, note)"""
    _, pattern, folder = SUBJECTS[name]
    work = f"{M}/{folder}.w{k}"            # beside the folder, so that its relative paths hold
    shutil.rmtree(work, ignore_errors=True); shutil.copytree(f"{M}/{folder}", work, symlinks=True)
    try:
        if folder == "one":
            text = re.sub(r"^([0-9a-f]+) <.*>:$", r"\1 <merge>:", text, count=1, flags=re.M)
            text = re.sub(r" <<[^\n]*?CvStack>::merge::<[^\n]*?>>\+(0x[0-9a-f]+)>", r" <merge+\1>", text)
            with open(f"{work}/m.listing", "w") as f: f.write(text)
            rets = re.findall(r"^\s+([0-9a-f]+):\s+c3\s+ret", text, re.M)
            if len(rets) != 1: return "lifter stops", f"{len(rets)} returns"
            l = sh([sys.executable, "lift_one.py", "m.listing", "merge", "0x40000", "Merge.lean", "Merge",
                    "--call", "blake3_servil_compress_in_place_avx512=0x30000", "--call", "blake3_servil_compress_in_place_sse41=0x20000",
                    "--panics-from", hex(int(rets[0], 16) + 1)], work)
            if l.returncode: return "lifter stops", ((l.stderr or l.stdout).strip().splitlines() or ["?"])[-1][:110]
            sh([sys.executable, "recode.py"], work)
            r = sh(["lake", "build", "MergeSpec"], work)
        else:
            with open(f"{work}/m.listing", "w") as f: f.write(text)
            l = sh([sys.executable, "lift_hex.py", "m.listing", "Code.lean"], work)
            if l.returncode: return "lifter stops", ((l.stderr or l.stdout).strip().splitlines() or ["?"])[-1][:110]
            r = sh(["lake", "build"], work)
        if r.returncode == 0 and "sorryAx" not in r.stdout: return "proved", ""
        e = re.search(r"error: .*", r.stdout)
        return "rejected", (e.group(0) if e else r.stderr.strip()[-90:])[:110]
    finally:
        shutil.rmtree(work, ignore_errors=True)
def shard(k, part):
    tree = f"{R}/tree-{k}"
    sh(["git", "worktree", "add", "-q", "--detach", tree, "HEAD"], crate)
    env = dict(os.environ, CARGO_TARGET_DIR=f"{R}/target-{k}", CARGO_INCREMENTAL="0")
    rows = []
    for i, m in part:
        t0 = time.time(); name = m["function"]["function_name"]; src, pattern, _ = SUBJECTS[name]
        sh(["git", "checkout", "-q", "--", "."], tree)
        with open(f"{R}/m-{k}.diff", "w") as f: f.write(m["diff"])
        p = sh(["patch", "-s", src, f"{R}/m-{k}.diff"], tree)
        if p.returncode: verdict, note = "patch failed", (p.stdout + p.stderr).strip()[:110]
        elif not build_crate(tree, env, f"{R}/x-{k}"): verdict, note = "does not build", ""
        else:
            text = listing(f"{R}/x-{k}", pattern)
            if text is None: verdict, note = "lifter stops", "the function is not in the objects (inlined or removed)"
            elif insns(text) == BASE[name]: verdict, note = "same bytes", f"{len(BASE[name])} instructions"
            else:
                verdict, note = judge(name, text, k)
                note = f"{len(insns(text))} instructions" + ("; " + note if note else "")
        rows.append((i, m["name"], verdict, note, round(time.time() - t0, 1)))
        with open(f"{O}/shard-{k}.tsv", "a") as f: f.write("\t".join(map(str, rows[-1])) + "\n")
    return rows
# a control: the unmutated listing, lifted and judged, must be "proved"
for name, (_, pat, _) in SUBJECTS.items():
    print("control,", name + ":", judge(name, listing(f"{R}/x-base", pat), "c"))
N = int(os.environ.get("SHARDS", "8"))
parts = [[(i, m) for i, m in enumerate(mutants) if i % N == k] for k in range(N)]
t0 = time.time()
with concurrent.futures.ThreadPoolExecutor(N) as pool:
    rows = sorted(r for rs in pool.map(lambda kp: shard(*kp), enumerate(parts)) for r in rs)
with open(f"{O}/verdicts.tsv", "w") as f:
    for r in rows: f.write("\t".join(map(str, r[1:])) + "\n")
for name in SUBJECTS:
    c = collections.Counter(r[2] for r in rows if f" in {name}" in r[1] or f"replace {name}" in r[1])
    print(f"{name}: {sum(c.values())} source mutants: " + ", ".join(f"{v} {k}" for k, v in c.most_common()))
print(f"{len(rows)} source mutants judged; {time.time() - t0:.0f} s on {N} shards")
DRIVER_PY
python3 "$R/driver.py" "$R" "$O" 2>&1 | tee "$O/summary.txt"
grep -q "source mutants judged" "$O/summary.txt" && echo "mutants judged by the theorems" > "$O/status.txt"
