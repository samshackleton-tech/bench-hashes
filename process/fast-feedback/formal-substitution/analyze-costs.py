#!/usr/bin/env python3
"""Verify proof-region counters and disclose the separate driver lifecycle/RSS."""
from pathlib import Path
import csv
import hashlib
import json
import re
import subprocess

root = Path(__file__).resolve().parent
repo = '/home/samshackleton/work/b3-verify-substitution'
old = '69d9256b2ef3e0f14d0477bc0221c9498ae6cd6e'
new = '58aa5767ff6184bf430ef3e020b4846eb148a5dc'
source_hashes = {}
for commit in [old, new]:
    data = subprocess.check_output(['git', '-C', repo, 'show', commit + ':tools/verify/lean_spec.py'])
    source_hashes[commit] = dict(sha256=hashlib.sha256(data).hexdigest(), blake3=subprocess.check_output(['b3sum','--no-names'], input=data).decode().strip())
runs = [('aa', 'formal-substitution-costs-aa-20261109T100320-9b1929c0'), ('ab', 'formal-substitution-costs-ab-20261109T101948-5a7354f6')]
records = []; summaries = []
pattern = re.compile(r'process_wall_ns=(\d+) process_cpu_ns=Some\((\d+)\) max_rss_bytes=Some\((\d+)\) storage_read_bytes=Some\((\d+)\) major_faults=Some\((\d+)\) success=true\s*')
for kind, name in runs:
    out = root / 'runs' / name / 'out'; fingerprints = []
    for side in ['old','new']:
        commit = new if kind == 'ab' and side == 'new' else old
        for pair in range(1,5):
            tsv = list(csv.DictReader((out/f'{side}-{pair}.tsv').open(),delimiter='\t')); assert len(tsv)==3
            by_shape = {x['shape']:x for x in tsv}
            for shape in ['substitution64','compress','chunk16']:
                data = json.loads((out/f'{side}-{pair}-{shape}.json').read_text()); row=by_shape[shape]
                assert data['shape']==shape and data['loaded_source_sha256']==source_hashes[commit]['sha256']
                assert data['wall_ns']>0 and data['cpu_ns']>0 and data['p_cycles']+data['e_cycles']>0 and data['p_instructions']+data['e_instructions']>0
                assert data['e_cycles']==data['e_instructions']==data['e_time_ns']==0
                assert row['calls']=='1' and row['package_nj']=='NA'
                for field in ['wall_ns','cpu_ns']:assert int(row[field])==data[field]
                assert int(row['cycles'])==data['p_cycles']+data['e_cycles']
                assert int(row['instructions'])==data['p_instructions']+data['e_instructions']
                load=(out/f'{side}-{pair}-{shape}-load.err').read_text();assert 'busiest window'in load and 'measurement abstained'not in load and 'busy load window'not in load
                m=pattern.fullmatch((out/f'{side}-{pair}-{shape}-process.txt').read_text());assert m
                wall,cpu,rss,reads,faults=map(int,m.groups());assert wall>=data['wall_ns']and cpu>=data['cpu_ns']and rss>=data['max_rss_bytes']
                if shape=='substitution64':fingerprints.append(data['semantic_fingerprint'])
                else:assert data['verdict'].startswith('proved (')
                records.append(dict(kind=kind,run=name,side=side,pair=pair,shape=shape,source=commit,proof=data,process=dict(wall_ns=wall,cpu_ns=cpu,max_rss_bytes=rss,storage_read_bytes=reads,major_faults=faults)))
    assert len(set(fingerprints))==1
    judgments=list(csv.DictReader((out/'judgments.tsv').open(),delimiter='\t'));assert len(judgments)==12
    if kind=='aa':assert all(x['verdict']=='Level'for x in judgments)
    summaries.append(dict(kind=kind,run=name,judgments=judgments))
for shape in ['substitution64','compress','chunk16']:
    result={}
    for side in ['old','new']:
        rows=[r for r in records if r['kind']=='ab'and r['shape']==shape and r['side']==side]
        result[side]=dict(process_wall_ns_mean=dict(numerator=sum(r['process']['wall_ns']for r in rows),denominator=4),process_cpu_ns_mean=dict(numerator=sum(r['process']['cpu_ns']for r in rows),denominator=4),max_rss_bytes_range=[min(r['process']['max_rss_bytes']for r in rows),max(r['process']['max_rss_bytes']for r in rows)])
    print(shape,result)
output=dict(schema=1,source_digests=source_hashes,checked_json_records=len(records),records=records,canonical_judgments=summaries,scope='Counter/TSV/load/resource verification only; canonical frozen Rust judgments retained. Process totals/RSS include preparation and Python teardown, are not separately judged, and are not production pool-throughput measurements.')
(root/'COUNTER-RESOURCE-AUDIT.json').write_text(json.dumps(output,indent=2)+'\n')
print('Verified',len(records),'counter/resource rows; all8micro final-answer fingerprints/run agree')
