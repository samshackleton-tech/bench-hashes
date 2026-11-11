#!/usr/bin/env python3
"""How far the model's lifter reaches: every compiled function of the core crate (real/all.s) through
one/lift_one.py; for each, lifted whole or where it stops."""
import collections, pathlib, re, subprocess, sys
lab = pathlib.Path.home() / "work/proof-lab"
text = (lab / "real/all.s").read_text()
blocks = re.split(r"\n(?=[0-9a-f]{16} <)", text)
ok, stops, total_ok, total = [], collections.Counter(), 0, 0
why = collections.defaultdict(list)
for i, b in enumerate(blocks):
    m = re.match(r"^[0-9a-f]{16} <(.+)>:", b)
    if not m: continue
    n = len(re.findall(r"^\s+[0-9a-f]+:\s+(?:[0-9a-f]{2} )+", b, re.M))
    if not n: continue
    total += n
    listing = lab / "reach/f.listing"
    body = re.sub(r"^([0-9a-f]{16}) <.+>:", r"\1 <f>:", b, count=1)
    body = body.replace(f"<{m.group(1)}+", "<f+")
    listing.write_text(body + "\n")
    r = subprocess.run([sys.executable, str(lab / "merge/lift_one.py"), str(listing), "f", "0x40000", str(lab / "reach/F.lean"), "F",
                        "--call", "blake3_servil_compress_in_place_avx512=0x30000", "--call", "blake3_servil_compress_in_place_sse41=0x20000"],
                       capture_output=True, text=True)
    if r.returncode == 0:
        ok.append((m.group(1), n)); total_ok += n
    else:
        msg = (r.stderr.strip().splitlines() or r.stdout.strip().splitlines() or ["?"])[-1]
        msg = re.sub(r"0x[0-9a-f]+", "N", msg)[:70]
        kind = "a call or jump out" if "call" in msg or "no address" in msg else "an instruction or operand form" 
        stops[kind] += 1; why[msg.split(":")[0][:40] + ": " + (msg.split()[-3] if len(msg.split()) > 3 else msg)].append(n)
print(f"{len(ok)} of {len(ok) + sum(stops.values())} functions lift whole: {total_ok} of {total} instructions ({total_ok / total:.0%})")
print("stops:", dict(stops))
c = collections.Counter()
for k, v in why.items(): c[k] = len(v)
for k, v in c.most_common(25): print(f"  {v:4d}  {k}")
