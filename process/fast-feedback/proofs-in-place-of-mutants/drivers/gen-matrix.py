#!/usr/bin/env python3
"""The generated proofs of gen/ on other compilers' and other optimisation levels' code: for each rustc
and each opt-level, print the Rust from Lean, compile, lift, write the proofs (make.py), and build each
function's theorem. One line a configuration: which of the eight check."""
import os, pathlib, shutil, subprocess, sys, time
lab = pathlib.Path.home() / "work/proof-lab"
src = lab / "gen"
out = lab / "gen-matrix.tsv"
objdump = str(pathlib.Path.home() / ".rustup/toolchains/1.99.1-aarch64-apple-darwin/lib/rustlib/aarch64-apple-darwin/bin/llvm-objdump")
configs = [(t, o, f) for t in ("1.99.1", "1.98.0", "1.97.0", "beta")
           for o, f in (("s", []), ("z", []), ("1", []), ("2", []), ("3", ["-Cllvm-args=-unroll-runtime=false"]), ("3", []))]
only = sys.argv[1:]
with open(out, "a") as log:
    for tool, opt, flags in configs:
        tag = f"{tool} opt-level={opt}" + (" no-runtime-unroll" if flags else "")
        if only and not any(o in tag for o in only): continue
        work = lab / "gen-matrix-work"
        if work.exists(): shutil.rmtree(work)
        shutil.copytree(src, work, ignore=shutil.ignore_patterns("mutants*", "a64"))
        env = dict(os.environ, RUSTUP_TOOLCHAIN=tool)
        t0 = time.time()
        cmd = [sys.executable, "make.py", "--objdump", objdump, "--opt", opt] + [f"--flag={f}" for f in flags]
        r = subprocess.run(cmd, cwd=work, env=env, capture_output=True, text=True)
        if r.returncode:
            line = f"{tag}\tthe generator stops: {(r.stderr.strip().splitlines() or ['?'])[-1][:160]}"
            print(line); log.write(line + "\n"); log.flush(); continue
        sizes = dict(l.split(": ") for l in r.stdout.strip().splitlines() if ": " in l)
        ok, bad = [], []
        for name in sizes:
            try:
                b = subprocess.run(["lake", "build", f"Proof_{name.capitalize()}"], cwd=work, capture_output=True, text=True, timeout=240)
                good = b.returncode == 0 and "sorryAx" not in b.stdout
            except subprocess.TimeoutExpired:
                good = False
            (ok if good else bad).append(name)
        line = f"{tag}\t{len(ok)} of {len(sizes)} check\t{sum(int(v.split()[0]) for v in sizes.values())} instructions\tnot: {' '.join(bad) or '-'}\t{time.time() - t0:.0f} s"
        print(line); log.write(line + "\n"); log.flush()
