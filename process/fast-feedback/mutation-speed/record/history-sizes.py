#!/usr/bin/env python3
"""How many mutants each change on `next` produced: for each of the last N first-parent
commits, the mutants cargo-mutants lists in the lines that commit changed, in the files
that commit's own x86-64 list names (as check.py plans a change's check). No build runs."""
import json, os, re, subprocess, sys, tempfile
repo, tip, count, out = sys.argv[1], sys.argv[2], int(sys.argv[3]), sys.argv[4]
def git(*a, cwd=repo, check=True):
    return subprocess.run(["git", "-C", cwd, *a], capture_output=True, text=True, check=check).stdout
scratch = os.path.join(repo, "tmp", "wt-history-scan")
if not os.path.exists(scratch):
    git("worktree", "add", "-q", "--detach", scratch, tip)
commits = git("rev-list", "--first-parent", "-n", str(count), tip).split()
with open(out, "w") as f:
    for c in commits:
        subject, author, date = git("show", "-s", "--format=%s%x09%an%x09%cI", c).rstrip("\n").split("\t")
        parents = git("show", "-s", "--format=%P", c).split()
        row = dict(commit=c, subject=subject, author=author, date=date, mutants=None, files=0, lines=0)
        try:
            header = git("show", f"{c}:tools/mutants/known-x86_64.txt", check=False)
            files = next((l.split()[1:] for l in header.splitlines() if l.startswith("files:")), [])
            if parents and files:
                diff = git("diff", parents[0], c, "--", *files)
                row["lines"] = sum(1 for l in diff.splitlines() if l.startswith("+") and not l.startswith("+++"))
                row["files"] = len(re.findall(r"^diff --git", diff, re.M))
                if not diff:
                    row["mutants"] = 0
                else:
                    git("checkout", "-q", "--detach", "-f", c, cwd=scratch)
                    with tempfile.NamedTemporaryFile("w", suffix=".diff", delete=False) as d:
                        d.write(diff)
                    r = subprocess.run(["cargo", "mutants", "--list", "--in-diff", d.name, *[a for x in files for a in ("--file", x)]],
                                       cwd=scratch, capture_output=True, text=True)
                    os.unlink(d.name)
                    if r.returncode == 0:
                        row["mutants"] = sum(1 for l in r.stdout.splitlines() if l.strip())
                    else:
                        row["error"] = r.stderr.strip()[-200:]
        except Exception as e:  # recorded, never guessed
            row["error"] = repr(e)[:200]
        f.write(json.dumps(row) + "\n"); f.flush()
