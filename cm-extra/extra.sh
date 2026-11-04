#!/bin/bash
# cargo-mutants' extra mutations on BLAKE3-Servil (run cm-extra): the fork's --extra-mutations
# (samshackleton-tech/cargo-mutants sam/blind-spots, the manifest's commit), built here; the mutants it
# adds over the default set, for the files the arch's list covers (--list --json --diff, with and
# without the flag); each applied in its own shard's worktree and the suite run as check.py runs it
# (cargo nextest, profile mutants, cargo profile mutants, features serde,zeroize, --lib --tests),
# fail-fast, the process group killed at 300 s. Outcome a mutant: CAUGHT, MISSED, UNVIABLE (the
# build fails), TIMEOUT.
set -u
R="$1"; O="$R/out"; mkdir -p "$O"; cd "$R"
export HOME=/root; . /root/.cargo/env
SHARDS=${SHARDS:-8}
{ uname -m; nproc; grep -m1 -E 'model name' /proc/cpuinfo || lscpu | grep -m1 'Model name'; rustc --version; echo "servil $(git -C fork rev-parse HEAD)"; echo "cm $(git -C cm rev-parse HEAD)"; echo "shards $SHARDS"; } > "$O/machine.txt" 2>&1
(cd cm && cargo build --release -q) > "$O/cm-build.log" 2>&1 || { echo "cm build failed" >> "$O/status.txt"; exit 2; }
CM="$R/cm/target/release/cargo-mutants"; "$CM" --version >> "$O/machine.txt"
cd fork
L=tools/mutants/known-$(uname -m).txt
FILES=$(grep "^files:" $L | cut -d' ' -f2-)
A=""; for f in $FILES; do A="$A -f $f"; done
"$CM" mutants --list --json --diff $A > "$O/default.json" 2> "$O/list.err"
"$CM" mutants --list --json --diff --extra-mutations $A > "$O/extra.json" 2>> "$O/list.err"
echo "listed" >> "$O/status.txt"
cd "$R"
cat > run_extra.py <<'PY_RUN_END'
"""Each mutant of extra.json not in default.json (by name and place), sharded over worktrees."""
import json, os, signal, subprocess, sys, threading, collections
R, O, shards = sys.argv[1], sys.argv[2], int(sys.argv[3])
key = lambda m: (m["name"], m["span"]["start"]["line"], m["span"]["start"]["column"])
default = {key(m) for m in json.load(open(f"{O}/default.json"))}
added = [m for m in json.load(open(f"{O}/extra.json")) if key(m) not in default]
json.dump(added, open(f"{O}/added.json", "w"))
print(len(added), "added mutants", flush=True)
lock = threading.Lock()
out = open(f"{O}/outcomes.tsv", "w")
def run(cmd, cwd, env, timeout):
    p = subprocess.Popen(cmd, cwd=cwd, env=env, stdout=subprocess.PIPE, stderr=subprocess.STDOUT, text=True, start_new_session=True)
    try:
        o, _ = p.communicate(timeout=timeout)
        return p.returncode, o, False
    except subprocess.TimeoutExpired:
        os.killpg(p.pid, signal.SIGKILL); o, _ = p.communicate(); return None, o, True
def shard(k):
    tree = f"{R}/shard{k}"
    subprocess.run(["git", "-C", f"{R}/fork", "worktree", "add", "-q", "--detach", tree, "HEAD"], check=True)
    env = dict(os.environ, CARGO_TARGET_DIR=f"{R}/target{k}", BLAKE3_EMULATED="1")
    base = ["cargo", "nextest", "run", "--profile", "mutants", "--cargo-profile", "mutants", "--features", "serde,zeroize", "--lib", "--tests"]
    rc, o, _ = run(base, tree, env, 3600)
    with lock: out.write(f"BASELINE\tshard{k}\t{rc}\n"); out.flush()
    for i in range(k, len(added), shards):
        m = added[i]
        path = os.path.join(tree, m["file"]); orig = open(path).read()
        try:
            r = subprocess.run(["patch", "-s", "-p0", "--no-backup-if-mismatch", "-r", os.devnull, path], input=m["diff"], text=True, cwd=tree, capture_output=True)
            if r.returncode != 0:
                verdict = "NOPATCH"
            else:
                rc, o, timed = run(base, tree, env, 300)
                if timed: verdict = "TIMEOUT"
                elif "error[" in o or "could not compile" in o: verdict = "UNVIABLE"
                elif rc == 0: verdict = "MISSED"
                else: verdict = "CAUGHT"
        finally:
            open(path, "w").write(orig)
        with lock:
            out.write(f"{verdict}\t{m['genre']}\t{m['file']}:{m['span']['start']['line']}\t{m['name']}\n"); out.flush()
ts = [threading.Thread(target=shard, args=(k,)) for k in range(shards)]
[t.start() for t in ts]; [t.join() for t in ts]
print("done", flush=True)
PY_RUN_END
python3 run_extra.py "$R" "$O" $SHARDS > "$O/run.log" 2>&1; echo "run exit $?" >> "$O/status.txt"
cut -f1,2 "$O/outcomes.tsv" | sort | uniq -c > "$O/summary.txt"
echo "extra done" >> "$O/status.txt"
