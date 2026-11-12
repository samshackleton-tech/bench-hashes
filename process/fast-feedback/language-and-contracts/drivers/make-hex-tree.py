#!/usr/bin/env python3
"""Make the in-tree proof folder for the hash's hexadecimal (tools/verify/hex) from the experiment branch.

    make-hex-tree.py EXPERIMENT/tools/verify/machine  LIBRARY-CHECKOUT

Copies what the two theorems need and nothing else (the import closure of Meets_hex_bytes for x86-64, of
HexNeonBytes, Quiet_hex_neon and HexNeonRun for AArch64), with the generators and the scripts, and writes
the folder's own lakefiles. hex.ode, odec.py, check-shipped.sh and README.md in the destination are kept."""
import re, shutil, sys
from pathlib import Path

M, lib = Path(sys.argv[1]), Path(sys.argv[2])
dest = lib / "tools/verify/hex"


def closure(roots, dirs):
    seen, todo = {}, list(roots)
    while todo:
        m = todo.pop()
        if m in seen:
            continue
        f = next((M / d / (m + ".lean") for d in dirs if (M / d / (m + ".lean")).exists()), None)
        seen[m] = f
        if f:
            todo += re.findall(r"^(?:public )?import (\S+)", f.read_text(), re.M)
    return {k: v for k, v in seen.items() if v}


def lakefile(name, mods, targets, requires):
    text = f'name = "{name}"\ndefaultTargets = [{", ".join(chr(34) + t + chr(34) for t in targets)}]\n' + requires
    for m in sorted(mods):
        text += f'\n[[lean_lib]]\nname = "{m}"\n'
    return text


x86 = closure(["Meets_hex_bytes"], ["lang", "one", "spec"])
arm = closure(["HexNeonBytes", "Quiet_hex_neon", "HexNeonRun"], ["arm", "spec"])
spec = {k: v for k, v in {**x86, **arm}.items() if v.parent.name == "spec"}
for d in ("x86", "arm", "spec"):
    shutil.rmtree(dest / d, ignore_errors=True)
    (dest / d).mkdir(parents=True)
def copy(v, to):
    """A Lean file, with the experiment's folder names in its comments made this folder's."""
    to.write_text(v.read_text().replace("../lang/", "../x86/"))


for k, v in spec.items():
    copy(v, dest / "spec" / v.name)
(dest / "spec/lakefile.toml").write_text(lakefile("spec", spec, sorted(spec), ""))
for where, mods in (("x86", x86), ("arm", arm)):
    for k, v in mods.items():
        if k not in spec:
            copy(v, dest / where / v.name)
need_spec = '\n# What names no machine: the contract and the hexadecimal itself.\n[[require]]\nname = "spec"\npath = "../spec"\n'
(dest / "x86/lakefile.toml").write_text(lakefile("hex_x86", [m for m in x86 if m not in spec], ["Meets_hex_bytes"], need_spec))
(dest / "x86/lean-toolchain").write_text((M / "lang/lean-toolchain").read_text())
google = re.search(r"# Google DeepMind's.*?subDir = \"[^\"]*\"\n", (M / "arm/lakefile.toml").read_text(), re.S).group(0)
(dest / "arm/lakefile.toml").write_text(lakefile("hex_arm", [m for m in arm if m not in spec],
                                                 ["Quiet_hex_neon", "HexNeonRun", "Proof_hex_neon", "HexNeonBytes"], "\n" + google + need_spec))
(dest / "arm/lean-toolchain").write_text((M / "arm/lean-toolchain").read_text())
(dest / "spec/lean-toolchain").write_text((M / "lang/lean-toolchain").read_text())

# the generators, with the paths of this folder
shutil.copy(M / "lang/prove.py", dest / "x86/prove.py")
shutil.copy(M / "one/lift_one.py", dest / "x86/lift_one.py")
t = (M / "arm/gen_arm.py").read_text()
old = 'sys.path.insert(0, str(here.parent / "lang"))'
assert t.count(old) == 1
(dest / "arm/gen_arm.py").write_text(t.replace(old, "sys.path.insert(0, str(here.parent))"))
t = (M / "arm/mutants_quiet.py").read_text()
(dest / "arm/mutants_quiet.py").write_text(t)
# the x86-64 audit, for this folder's layout: the experiment's lists, and the contract's own statements
import ast
lists = {}
for node in ast.parse((M / "lang/mutants_hex.py").read_text()).body:
    if isinstance(node, ast.Assign) and getattr(node.targets[0], "id", "") in ("MUTANTS", "STATEMENTS"):
        lists[node.targets[0].id] = ast.literal_eval(node.value)
extra = [
    ("../spec/HexContract.lean", "(Bytes.plain 64).fills out (Hex.text hash)", "(Bytes.plain 64).fills out (Hex.text hash.reverse)", "the contract: the hash is written backwards"),
    ("../spec/HexContract.lean", "(Bytes.plain 64).fills out (Hex.text hash)", "(Bytes.plain 63).fills out (Hex.text hash)", "the contract: only 63 bytes may change"),
    ("../spec/HexContract.lean", "reads := [(Bytes.plain 32).keeps inp hash]", "reads := [(Bytes.plain 31).keeps inp hash]", "the contract: the hash is 31 bytes"),
    ("../spec/HexContract.lean", "args := [out, inp]", "args := [inp, out]", "the contract: the arguments the other way round"),
    ("../spec/HexContract.lean", "returns := fun _ => True", "returns := fun r => r = 0#64", "the contract: it returns zero"),
    ("../spec/Contract.lean", "def plain (n : Nat) : Layout (List (BitVec 8)) := ⟨n, fun b v => b = v⟩", "def plain (n : Nat) : Layout (List (BitVec 8)) := ⟨n, fun b v => b = v.reverse⟩", "plain bytes are said to be in memory backwards"),
]
statements = lists["STATEMENTS"] + extra
audit = '''#!/usr/bin/env python3
"""Does the proof of `hex` on x86-64 notice a changed instruction or a false statement? Each change is made
in a copy of this folder and of ../spec, and `lake build Meets_hex_bytes` must then fail. The control: the
unchanged copy, built afresh, must be accepted. Written by the experiment's make-hex-tree.py from its lists.
usage: mutants.py [JOBS]"""
import concurrent.futures, pathlib, shutil, subprocess, sys, tempfile

here = pathlib.Path(__file__).resolve().parent
jobs = int(sys.argv[1]) if len(sys.argv) > 1 else 4
MUTANTS = %s
STATEMENTS = %s


def check(job):
    with tempfile.TemporaryDirectory(prefix="mut-hex-") as d:
        d = pathlib.Path(d)
        work = d / "x86"
        skip = shutil.ignore_patterns(".lake", "lake-manifest.json", "*.log", "*.o")
        shutil.copytree(here, work, ignore=skip)
        shutil.copytree(here.parent / "spec", d / "spec", ignore=skip)
        if job is not None and len(job[0]) == 5:        # an instruction, by its address: the table's row and its lemma
            at, old, new, what = job
            text = (work / "Code_hex.lean").read_text()
            lines = [l for l in text.split("\\n") if f"0x{at}," in l or f"at_{at} " in l]
            if len(lines) != 2 or any(old not in l for l in lines):
                return "MALFORMED", what
            for l in lines:
                text = text.replace(l, l.replace(old, new))
            (work / "Code_hex.lean").write_text(text)
        elif job is not None:                             # a line of what is claimed
            file, old, new, what = job
            text = (work / file).read_text()
            if file.endswith("HexText.lean"):             # without the specification's own example: the machine proof must object
                text = text[:text.index("/-- For example")]
            if text.count(old) != 1:
                return "MALFORMED", what
            (work / file).write_text(text.replace(old, new))
        else:
            what = "the unchanged copy"
        try:
            r = subprocess.run(["lake", "build", "Meets_hex_bytes"], cwd=work, capture_output=True, text=True, timeout=1500)
        except subprocess.TimeoutExpired:
            return "rejected", what + " (time limit)"
        out = r.stdout + r.stderr
        ok = r.returncode == 0 and "sorryAx" not in out and "'hex_meets_bytes' depends on axioms" in out
        return ("ACCEPTED" if ok else "rejected"), what


verdict, _ = check(None)
print(f"control: the unchanged copy is {verdict}", flush=True)
if verdict != "ACCEPTED":
    sys.exit("the control failed: the audit proves nothing")
bad = False
for name, group in (("changed instructions", MUTANTS), ("false statements", STATEMENTS)):
    tally = {}
    with concurrent.futures.ThreadPoolExecutor(jobs) as pool:
        for verdict, what in pool.map(check, group):
            tally[verdict] = tally.get(verdict, 0) + 1
            print(f"{verdict}\\t{what}", flush=True)
    print(f"{len(group)} {name}: " + ", ".join(f"{n} {k}" for k, n in sorted(tally.items())), flush=True)
    bad = bad or set(tally) != {"rejected"}
sys.exit(1 if bad else 0)
'''
import pprint
(dest / "x86/mutants.py").write_text(audit % (pprint.pformat(lists["MUTANTS"], width=200), pprint.pformat(statements, width=200)))

for d in ("x86", "arm", "spec"):
    (dest / d / ".gitignore").write_text(".lake/\nlake-manifest.json\n*.o\n*.listing\n*.words\n*.log\n*.rows\nagain/\nLifted_*.lean\n*.printed.S\nhex.S\nhex_neon.S\n")
# the two scripts written for this layout
files = Path(__file__).resolve().parent / "hex-tree-files"
for d in ("x86", "arm"):
    shutil.copy(files / f"{d}-prove.sh", dest / d / "prove.sh")
n = lambda mods: (len(mods), sum(len(v.read_text().split("\n")) - 1 for v in mods.values()))
print("x86-64: %d Lean files, %d lines; AArch64: %d, %d (the three of spec/ in both)" % (n(x86) + n(arm)))
