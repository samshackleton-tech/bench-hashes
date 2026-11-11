#!/usr/bin/env python3
"""A skeptic run's steps.txt -> the time from nothing (elan, toolchain, every folder once)."""
import re, sys
for path in sys.argv[1:]:
    tot, bad = 0.0, []
    for l in open(path):
        m = re.match(r"(\S+) rc=(\d+) ([\d.]+)s", l)
        if not m: continue
        if m.group(1).startswith("build") or m.group(1) in ("elan", "toolchain"):
            tot += float(m.group(3))
        if m.group(2) != "0": bad.append(m.group(1))
    print(f"{path.split('/')[-3][:60]}: from nothing {tot:.0f} s = {tot / 60:.1f} min; failed steps: {bad or 'none'}")
