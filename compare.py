"""cm-whole (A) against cm-hangs-{c,b,a2}: time, and the lists each run wrote."""
import glob, json, os, sys, collections
def runs_dir(tag): return glob.glob(f"runs/*{open(tag).read().strip()}")[0] + "/out"
def phases(Q):
    tests, total = [], 0.0
    for f in glob.glob(f"{Q}/mutants-last/*/*/outcomes.json"):
        for o in json.load(open(f))['outcomes']:
            for ph in o.get('phase_results', []):
                d = ph['duration']; d = d['secs'] + d['nanos'] / 1e9 if isinstance(d, dict) else float(d)
                total += d
                if ph['phase'] == 'Test': tests.append(d)
    return total, tests
def rows(path): return sorted(l.rstrip("\n") for l in open(path) if l.strip() and not l.startswith("#"))
runs = [("A servil's tools", "run-whole.txt"), ("C change, --all-hangs", "run-hangs-c.txt"), ("B change", "run-hangs-b.txt"), ("A2 servil's tools", "run-hangs-a2.txt")]
base = None
print(f"{'run':24} {'start':>8} {'wall':>8} {'shard h':>8} {'tests':>6} {'>=29 s':>7} {'list':>10} {'timeouts':>10}")
for label, tag in runs:
    try: Q = runs_dir(tag)
    except (IndexError, FileNotFoundError): print(f"{label:24} (not fetched)"); continue
    start, end = int(open(f"{Q}/start.txt").read()), int(open(f"{Q}/end.txt").read())
    total, tests = phases(Q)
    L, T = rows(f"{Q}/list-written.txt"), rows(f"{Q}/timeouts-written.txt")
    if base is None: base = (L, T)
    same = lambda a, b: "same" if a == b else f"{len(set(a) ^ set(b))} differ"
    import time
    print(f"{label:24} {time.strftime('%H:%M', time.gmtime(start)):>8} {(end - start) / 60:7.1f}m {total / 3600:8.2f} {len(tests):6} {sum(1 for d in tests if d >= 29):7} {same(L, base[0]):>10} {same(T, base[1]):>10}")
