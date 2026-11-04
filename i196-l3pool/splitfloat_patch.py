"""Probe for #196 (splitfloat), on splitwake (splitwake_patch.py applied first): every worker pinned to
its domain's CPUs, as servil's are, not to one core's; primaries and second workers stay as they are
counted (a domain's first `cores` workers take stream tasks). Usage: splitfloat_patch.py TREE"""
import sys, pathlib
p = pathlib.Path(sys.argv[1]) / "src/lanes.rs"
s = p.read_text()
a = "            let cpus = if cores.is_empty() { &pool.domains.cpus[d as usize] } else { &cores[local % cores.len()] };\n"
assert s.count(a) == 1, "worker_main's mask"
s = s.replace(a, "            // Probe (splitfloat): the domain's CPUs, every worker.\n            let cpus = &pool.domains.cpus[d as usize];\n")
p.write_text(s)
print("splitfloat patched")
