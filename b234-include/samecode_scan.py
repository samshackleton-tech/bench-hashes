#!/usr/bin/env python3
"""For the rows of a mutation list whose reason starts with one of the given
prefixes (ALL: every row not already same code): build each of the row's
places as check.py builds a mutant (--profile mutants, features serde,zeroize,
--lib --tests), as cargo-mutants writes it, and with its line count kept (the
lines it deletes left blank); with SCAN_FRESH=1 the profile's incremental is
off (the release build's code); with SCAN_ONLY_KEPT=1 only the line-kept build. Compare every test binary's code hash
(tools/mutants/code_hash.py) with the unmutated build's in the same mode.

    samecode_scan.py CHECKOUT LIST OUT.tsv PREFIX...

Run from nowhere in particular; CHECKOUT is a clean fork checkout (it is
mutated and restored with git checkout). Needs cargo-mutants (for --list
--json --diff), MUTANTS_B3SUM, and CARGO_TARGET_DIR (its own).
A row of OUT.tsv: file, mutant, place, as-written (same/differs/nobuild),
line-kept (same/differs/nobuild), the binaries that differ line-kept.
"""
import json, os, re, subprocess, sys

tree, listing, out_path, *prefixes = sys.argv[1:]
NAME = re.compile(r"^(\S+?):\d+:\d+: (.*)$")
code_hash = os.path.join(tree, "tools", "mutants", "code_hash.py")
assert os.environ.get("MUTANTS_B3SUM") and os.environ.get("CARGO_TARGET_DIR")


ENV = dict(os.environ)
if os.environ.get("SCAN_FRESH") == "1":
    ENV["CARGO_PROFILE_MUTANTS_INCREMENTAL"] = "false"


def sh(*a, **k):
    return subprocess.run(a, cwd=tree, capture_output=True, text=True, env=ENV, **k)


def build():
    """The test binaries (--lib --tests, as check.py runs), or None."""
    r = sh("cargo", "test", "--profile", "mutants", "--features", "serde,zeroize", "--lib", "--tests", "--no-run", "--message-format=json")
    if r.returncode != 0:
        return None
    exes = []
    for line in r.stdout.splitlines():
        try:
            m = json.loads(line)
        except ValueError:
            continue
        if m.get("reason") == "compiler-artifact" and m.get("executable"):
            exes.append(m["executable"])
    return {os.path.basename(e).rsplit("-", 1)[0]: sh("python3", code_hash, e, check=True).stdout.strip() for e in sorted(exes)}


rows = []
for line in open(listing):
    if "\t" not in line or line.startswith("#"):
        continue
    file, mutant, count, reason = line.rstrip("\n").split("\t")
    if (prefixes == ["ALL"] and not reason.startswith("same code")) or reason.startswith(tuple(prefixes)):
        rows.append((file, mutant, int(count), reason))
files = sorted({r[0] for r in rows})
assert sh("git", "status", "--porcelain", "--untracked-files=no").stdout == "", "the checkout must be clean"
listed = json.loads(sh("cargo", "mutants", "--list", "--json", "--diff", *sum((["-f", f] for f in files), []), check=True).stdout)
by_key = {}
for m in listed:
    g = NAME.match(m["name"])
    by_key.setdefault((g.group(1), g.group(2)), []).append(m)
base = build()
assert base, "the unmutated tree does not build"
print(f"{len(rows)} rows, {len(base)} test binaries", flush=True)


def apply(m, keep_lines):
    """The mutant's text over its span (cargo-mutants' replacement as its diff
    shows it), padded with newlines to the span's line count if keep_lines."""
    path = os.path.join(tree, m["file"])
    src = open(path).read()
    # Apply cargo-mutants' own diff, then (keep_lines) pad after the changed hunk.
    open("/tmp/samecode.diff", "w").write(m["diff"])
    r = subprocess.run(["patch", "-s", "-p0", "-i", "/tmp/samecode.diff"], cwd=tree, capture_output=True, text=True)
    assert r.returncode == 0, r.stdout + r.stderr
    if keep_lines:
        new = open(path).read()
        lost = src.count("\n") - new.count("\n")
        if lost > 0:
            # The deleted lines left blank just after the mutant's first line.
            lines = new.split("\n")
            at = m["span"]["start"]["line"]  # 1-based: the line the mutant starts on
            lines[at - 1] = lines[at - 1] + "\n" * lost
            open(path, "w").write("\n".join(lines))
        assert open(path).read().count("\n") == src.count("\n"), "line count not kept"


def verdict(hashes):
    if hashes is None:
        return "nobuild", []
    d = [b for b in base if hashes.get(b) != base[b]]
    return ("same" if not d else "differs"), d


with open(out_path, "w") as out:
    out.write("file\tmutant\tplace\tas_written\tline_kept\tdiffers_line_kept\treason\n")
    for file, mutant, count, reason in rows:
        places = by_key.get((file, mutant), [])
        if len(places) != count:
            out.write(f"{file}\t{mutant}\t-\tPLACES {len(places)} listed {count}\t-\t-\t{reason[:60]}\n")
        for m in places:
            res = []
            for keep in (False, True):
                if not keep and os.environ.get("SCAN_ONLY_KEPT") == "1":
                    res.append(("skipped", []))
                    continue
                apply(m, keep)
                res.append(verdict(build()))
                sh("git", "checkout", "-q", "--", m["file"], check=True)
            place = m["name"].split(": ", 1)[0]
            out.write(f"{file}\t{mutant}\t{place}\t{res[0][0]}\t{res[1][0]}\t{','.join(res[1][1])}\t{reason[:60]}\n")
            out.flush()
            print(place, mutant, res[0][0], res[1][0], flush=True)
assert sh("git", "status", "--porcelain", "--untracked-files=no").stdout == ""
