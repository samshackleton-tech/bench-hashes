#!/usr/bin/env python3
"""The record of every test on every mutant, from the shards' own cargo-mutants output
(the run was cut by its time limit before check.py wrote tests.tsv): one row a mutant
with its raw outcome and the tests that failed or timed out, and each test's unmutated time."""
import glob, json, os, sys
root, salvage, out = sys.argv[1], sys.argv[2], sys.argv[3]
sys.path.insert(0, os.path.join(root, "tools", "mutants"))
here = os.getcwd(); os.chdir(root)
import check
os.chdir(here)
mutants, unmutated, shards = [], {}, {}
for d in sorted(glob.glob(os.path.join(salvage, "run-*/mutants-result/mutants.out")), key=lambda p: int(p.split("run-")[1].split("/")[0])):
    shard = d.split("run-")[1].split("/")[0]
    outcomes = json.load(open(os.path.join(d, "outcomes.json")))["outcomes"]
    planned = len(json.load(open(os.path.join(d, "mutants.json"))))
    done = 0
    for o in outcomes:
        log = os.path.join(d, o["log_path"]) if o.get("log_path") else None
        tests = check.read_tests(log) if log and os.path.exists(log) else []
        if not isinstance(o["scenario"], dict):
            for t, outcome, ms in tests:
                if outcome == "PASS":
                    unmutated[t] = min(unmutated.get(t, ms), ms)
            continue
        done += 1
        m = o["scenario"]["Mutant"]
        same = o["summary"] == "CaughtMutant" and log and check.SAME_CODE_MARKER in open(log, errors="replace").read()
        mutants.append(dict(name=m["name"], file=m["file"], function=(m.get("function") or {}).get("function_name", ""),
                            line=m["span"]["start"]["line"], column=m["span"]["start"]["column"], shard=shard,
                            summary="SameCode" if same else o["summary"],
                            failed=sorted(t for t, outcome, _ in tests if outcome == "FAIL"),
                            timed_out=sorted(t for t, outcome, _ in tests if outcome == "TIMEOUT"),
                            ran=len(tests), seconds={p["phase"]: p["duration"] for p in o["phase_results"]}))
    shards[shard] = dict(planned=planned, done=done)
with open(out, "w") as f:
    json.dump(dict(shards=shards, unmutated_ms=unmutated, mutants=mutants), f)
print("shards", {k: f"{v['done']}/{v['planned']}" for k, v in shards.items()})
print("mutants recorded", len(mutants), "tests", len(unmutated))
