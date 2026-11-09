#!/usr/bin/env python3
"""Read-only consistency checks for the unchanged grouped-work sampler."""
import argparse
import csv
import json
import re
from collections import Counter
from pathlib import Path

parser = argparse.ArgumentParser()
parser.add_argument("runs", nargs="+", type=Path)
args = parser.parse_args()
summary = []
for run in args.runs:
    out = run / "out"
    checked = 0
    layouts = set()
    for side in ("old", "new"):
        for pair in range(1, 5):
            stem = f"{side}-{pair}"
            log = (out / f"{stem}.err").read_text()
            assert "finalization_contract=next: finalize_each resets; no additional cycle/finish reset" in log, run
            assert "measurements in that time may read slower than this machine runs" not in log, run
            assert any(line.startswith("load:") for line in log.splitlines()), run
            diagnostics = {}
            ownership = 0
            for line in log.splitlines():
                if line.startswith("ownership:"):
                    fields = dict(re.findall(r"(\w+)=([^\s;]+)", line))
                    size, alignment, stride, digest_stride = (int(fields[k]) for k in ("hasher_size", "align", "native_stride", "digest_stride"))
                    assert size == stride and stride % alignment == 0 and digest_stride == 32
                    assert "one caller owns states/descriptors/outputs" in line and "no concurrent sharing" in line
                    layouts.add((size, alignment, stride, digest_stride))
                    ownership += 1
                if line.startswith("core_counts "):
                    fields = dict(re.findall(r"(\w+)=([^\s]+)", line))
                    key = fields["shape"], fields["items"], fields["algorithm"]
                    assert key not in diagnostics, (run, stem, key)
                    diagnostics[key] = fields
            with (out / f"{stem}.tsv").open() as handle:
                rows = list(csv.DictReader(handle, delimiter="\t"))
            assert len(rows) == len(diagnostics) == 192 and ownership == 64, (run, stem)
            assert len({(row["shape"], row["items"]) for row in rows}) == 64
            seen = set()
            for row in rows:
                key = row["shape"], row["items"], row["algorithm"]
                assert key not in seen
                seen.add(key)
                d = diagnostics[key]
                assert row["items"] == d["items"] and row["calls"] == d["calls"], (run, stem, key)
                assert int(row["cycles"]) == int(d["p_cycles"]) + int(d["e_cycles"]), (run, stem, key)
                assert int(row["instructions"]) == int(d["p_instructions"]) + int(d["e_instructions"]), (run, stem, key)
                assert int(row["calls"]) > 0 and int(row["wall_ns"]) > 0 and int(row["cycles"]) > 0
                length = int(re.search(r"_len(\d+)_", row["shape"]).group(1))
                assert int(row["bytes"]) == int(row["items"]) * length
                if row["algorithm"] == "finish":
                    assert row["calls"] == "64" and row["package_nj"] == "NA", (run, stem, key)
                checked += 1
    judgments = {}
    for phase, expected in (("cycle", 320), ("update", 320), ("finish", 256)):
        with (out / f"judgments-{phase}.tsv").open() as handle:
            rows = list(csv.DictReader(handle, delimiter="\t"))
        assert len(rows) == expected
        judgments[phase] = dict(Counter(row["verdict"] for row in rows))
    summary.append({"run": run.name, "diagnostic_rows_checked": checked,
                    "native_layout_size_align_stride_digest_stride": sorted(layouts), "judgments": judgments})
print(json.dumps({"runs": summary, "diagnostic_rows_checked": sum(s["diagnostic_rows_checked"] for s in summary)}, indent=2))
