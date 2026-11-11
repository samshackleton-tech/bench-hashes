#!/bin/bash
# The proof as the test (BLAKE3 #361, step 3): every source mutant cargo-mutants plants in the functions
# the detection theorem covers, judged by the theorem instead of the test suite. For each mutant: apply
# it, build the library for release, lift read_x86_features and its callees, and build the theorem on
# that code. Verdicts: "same bytes" (the compiler made the same machine code), "proved" (other bytes,
# the theorem holds: the mutant does not change what the function computes), "refuted" (the theorem
# does not check, and the CPU the prover names, run on the model, returns something else than the
# rule: witness.py), "not proved" (it does not check and no such CPU is confirmed), "lifter stops",
# "does not build".
set -uo pipefail
R="$1";O="$R/out";mkdir -p "$O";export HOME=/root;. <home>/.cargo/env
export ELAN_HOME="$R/elan"; export PATH="$ELAN_HOME/bin:$PATH"
cd "$R/library"; { echo "library $(git rev-parse HEAD)"; rustc -V; cargo mutants --version; nproc; } > "$O/identity.txt" 2>&1
curl -sSf https://elan.lean-lang.org/elan-init.sh | sh -s -- -y --default-toolchain none --no-modify-path > "$O/elan.log" 2>&1
(cd tools/verify/machine && lake build > "$O/build-unmutated.log" 2>&1 < /dev/null) || { echo "the unmutated theorem does not check"; exit 1; }
cargo mutants --list --json --diff -f src/platform.rs > "$R/mutants.json" 2> "$O/list.err" < /dev/null
cat > "$R/driver.py" <<'DRIVER_PY'
import concurrent.futures, glob, json, os, re, shutil, subprocess, sys, time
R, O = sys.argv[1], sys.argv[2]
lib = f"{R}/library"; M = f"{lib}/tools/verify/machine"
covered = {"features_of", "os_saves_avx", "read_cpu_words", "read_x86_features", "family", "wide_cpu"}
mutants = [m for m in json.load(open(f"{R}/mutants.json")) if (m.get("function") or {}).get("function_name") in covered]
want = {"blake3_servil::platform::read_x86_features": "features", "blake3_servil::platform::read_cpu_words": "words", "core::core_arch::x86::xsave::_xgetbv": "xgetbv"}
strip = lambda text: re.sub(r" *--.*", "", text)
base_code = strip(open(f"{M}/Code.lean").read())
def sh(cmd, cwd, timeout=900, env=None):
    try:
        return subprocess.run(cmd, cwd=cwd, capture_output=True, text=True, timeout=timeout, env=env, stdin=subprocess.DEVNULL)
    except subprocess.TimeoutExpired:
        return subprocess.CompletedProcess(cmd, 124, "", "timed out")
def listings(work):
    found = {}
    for obj in sorted(glob.glob(work + "/x/*.o")):
        plain = sh(["nm", "--defined-only", obj], work).stdout.splitlines()
        nice = sh(["nm", "-C", "--defined-only", obj], work).stdout.splitlines()
        for p, n in zip(plain, nice):
            pf, nf = p.split(None, 2), n.split(None, 2)
            if len(pf) == 3 and len(nf) == 3 and pf[1] in "Tt" and nf[2] in want and nf[2] not in found:
                found[nf[2]] = (obj, pf[2])
    args = []
    for (name, short), base in zip(want.items(), ("0x1000", "0x2000", "0x3000")):
        if name not in found: continue
        obj, mangled = found[name]
        text = sh(["llvm-objdump", "-d", "-r", "-M", "intel", f"--disassemble-symbols={mangled}", obj], work).stdout
        with open(f"{work}/{short}.s", "w") as f: f.write(text)
        args.append(f"{base}:{work}/{short}.s")
    return args, sorted(set(want.values()) - {want[k] for k in found})
def shard(k, part):
    tree = f"{R}/tree-{k}"
    sh(["git", "worktree", "add", "-q", "--detach", tree, "HEAD"], lib)
    env = dict(os.environ, CARGO_TARGET_DIR=f"{R}/target-{k}", CARGO_INCREMENTAL="0")
    rows = []
    for i, m in part:
        t0 = time.time(); work = f"{R}/w-{k}"; shutil.rmtree(work, ignore_errors=True); os.makedirs(work + "/x")
        sh(["git", "checkout", "-q", "--", "src/platform.rs"], tree)
        with open(f"{work}/m.diff", "w") as f: f.write(m["diff"])
        p = sh(["patch", "-s", "src/platform.rs", f"{work}/m.diff"], tree)
        verdict, note = None, ""
        if p.returncode: verdict, note = "patch failed", (p.stdout + p.stderr).strip()[:120]
        if not verdict:
            b = sh(["cargo", "build", "--release"], tree, env=env)
            if b.returncode: verdict, note = "does not build", ""
        if not verdict:
            rlib = glob.glob(f"{R}/target-{k}/release/libblake3_servil.rlib")[0]
            shutil.copy(rlib, work + "/x/"); sh(["ar", "x", "libblake3_servil.rlib"], work + "/x")
            args, missing = listings(work)
            l = sh([sys.executable, f"{M}/lift.py", f"{work}/Code.lean", "Code"] + args, work)
            if l.returncode: verdict, note = "lifter stops", ((l.stderr or l.stdout).strip().splitlines() or ["?"])[-1][:120] + (f"; not found: {missing}" if missing else "")
        if not verdict:
            code = open(f"{work}/Code.lean").read()
            n = len(re.findall(r"^  \(0x", code, re.M))
            if strip(code) == base_code: verdict, note = "same bytes", f"{n} instructions"
            else:
                os.makedirs(work + "/m")
                for f in glob.glob(f"{M}/*.lean") + [f"{M}/lakefile.toml", f"{M}/lean-toolchain", f"{M}/lake-manifest.json"]: shutil.copy(f, work + "/m/")
                shutil.copy(f"{work}/Code.lean", work + "/m/Code.lean")
                r = sh(["lake", "build"], work + "/m", timeout=600)
                good = r.returncode == 0 and "sorryAx" not in r.stdout
                note = f"{n} instructions"
                if good: verdict = "proved"
                else:
                    # the CPU the prover names, run on the model: a refutation that does not rest on the prover
                    with open(work + "/m/build.log", "w") as f: f.write(r.stdout)
                    w = sh([sys.executable, f"{M}/witness.py", "build.log"], work + "/m")
                    with open(work + "/m/Witness.lean", "w") as f: f.write(w.stdout)
                    e = sh(["lake", "env", "lean", "Witness.lean"], work + "/m", timeout=120)
                    said = re.search(r"witness agrees: (false); code and rule: \(?([^;]*?)\)?; (leaf1.*?)\"", e.stdout)
                    if said:
                        verdict = "refuted"; note += f"; code and rule {said.group(2)} on {said.group(3)}"
                    else:
                        verdict = "not proved"; note += "; " + (re.search(r"error: .*", r.stdout) or re.search(r".*", r.stderr)).group(0)[:90]
        rows.append((i, m["name"], verdict, note, round(time.time() - t0, 1)))
        with open(f"{O}/shard-{k}.tsv", "a") as f: f.write("\t".join(map(str, rows[-1])) + "\n")
    sh(["git", "checkout", "-q", "--", "src/platform.rs"], tree)
    return rows
N = int(os.environ.get("SHARDS", "6"))
parts = [[(i, m) for i, m in enumerate(mutants) if i % N == k] for k in range(N)]
t0 = time.time()
with concurrent.futures.ThreadPoolExecutor(N) as pool:
    rows = sorted(r for rs in pool.map(lambda kp: shard(*kp), enumerate(parts)) for r in rs)
with open(f"{O}/verdicts.tsv", "w") as f:
    for r in rows: f.write("\t".join(map(str, r[1:])) + "\n")
import collections
c = collections.Counter(r[2] for r in rows)
print(f"{len(rows)} source mutants in {sorted(covered)}: " + ", ".join(f"{v} {k}" for k, v in c.most_common()) + f"; {time.time() - t0:.0f} s on {N} shards")
DRIVER_PY
python3 "$R/driver.py" "$R" "$O" 2>&1 | tee "$O/summary.txt"
grep -q "source mutants" "$O/summary.txt" && echo "mutants judged by the theorem" > "$O/status.txt"
