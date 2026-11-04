"""b128-residency: per condition, CPU 2's cpuidle time share by state (sysfs, us) and the core's
cstate_core residency shares (perf: ticks of the TSC), over the command's wall time.
    residency_analyze.py OUT"""
import sys, glob, os, re, collections
O = sys.argv[1]
rows = collections.defaultdict(list)
for f in sorted(glob.glob(O + "/*.perf")):
    name = os.path.basename(f)[:-5]
    cond = name.split("-")[0]
    vals = {}
    for l in open(f):
        x = l.strip().split(",")
        if len(x) > 3 and x[0].replace(".", "").isdigit():
            vals[x[2]] = float(x[0])
    tsc = vals.get("msr/tsc/", 0)
    c1 = vals.get("cstate_core/c1-residency/", 0) / tsc if tsc else float("nan")
    c6 = vals.get("cstate_core/c6-residency/", 0) / tsc if tsc else float("nan")
    b = {l.split()[0]: (int(l.split()[1]), int(l.split()[2])) for l in open(f"{O}/{name}.before")}
    a = {l.split()[0]: (int(l.split()[1]), int(l.split()[2])) for l in open(f"{O}/{name}.after")}
    wall_us = tsc / 2.0e3 if tsc else 0  # Xeon Gold 6330: TSC 2.0 GHz
    sw = {s: ((a[s][1] - b[s][1]) / wall_us if wall_us else 0, a[s][0] - b[s][0]) for s in a}
    rows[cond].append((c1, c6, sw, wall_us / 1e6))
for cond in sorted(rows):
    for c1, c6, sw, wall in rows[cond]:
        print(f"{cond}: wall {wall:6.2f} s | hardware C1 {c1:5.1%} C6 {c6:5.1%} | cpuidle time share " + ", ".join(f"{s} {t:5.1%} ({n} entries)" for s, (t, n) in sw.items()))
