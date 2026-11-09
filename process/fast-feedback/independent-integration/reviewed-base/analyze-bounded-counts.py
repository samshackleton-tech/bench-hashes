#!/usr/bin/env python3
"""Analyze declared count-only patches; do not turn entry observers into instruction traces."""
from pathlib import Path
import ast
import collections
import json
import sys

run = Path(sys.argv[1]); out = run / 'out'; result = {}
for side in ['current', 'common', 'reference']:
    symbols = collections.defaultdict(list)
    init = []
    for line in (out / f'symbols-{side}.txt').read_text().splitlines():
        fields = line.split(None, 2)
        if len(fields) == 3:
            address, _, name = fields
            symbols[int(address, 16)].append(name)
            if name == 'blake3_servil::initialize': init.append(int(address, 16))
    assert len(init) == 1, init
    records = []; layouts = []; active = None; bias = None; layout = None
    for raw in (out / f'count-{side}.log').read_text().splitlines():
        line = raw.strip()
        if line.startswith('ANCHOR '): bias = int(line.split()[1], 16) - init[0]
        elif line.startswith('LAYOUT '):
            layout = dict(v.split('=', 1) for v in line.split()[1:])
            layout = {k: int(v, 16 if k == 'base' else 10) for k, v in layout.items()}; layouts.append(layout)
        elif line.startswith('BEGIN '):
            parts = line.split(); active = dict(phase=parts[1], **dict(v.split('=', 1) for v in parts[2:]))
            active['entries'] = []; active['requests'] = []; active['leaf_state_order'] = []
        elif active is not None and line.startswith('E '): active['entries'].append(int(line.split()[1], 16))
        elif active is not None and line.startswith('H '):
            fields = line.split(); assert len(fields) == 11, fields
            request = dict(platform=fields[1], **dict(zip(['block_bytes','inputs','counter','increment','flags','output_bytes'], map(int, fields[2:8]))))
            request.update(dict(zip(['input_pointer','output_pointer','key_pointer'], (int(v,16) for v in fields[8:]))))
            active['requests'].append(request)
            if active['phase']=='update' and request['block_bytes']==1024:
                assert layout is not None
                relative=request['input_pointer']-layout['base']-layout['stage_offset']
                assert relative >= 0 and relative % layout['stride']==0
                index=relative//layout['stride'];assert index < int(active['n'])
                active['leaf_state_order'].append(index)
        elif active is not None and line.startswith('S '):
            active['counts']=ast.literal_eval(line.split('counts=',1)[1].split(' selector=',1)[0]);active['selector']=int(line.rsplit('=',1)[1])
        elif active is not None and line.startswith('G '): active['groups']=ast.literal_eval(line[2:])
        elif active is not None and line.startswith('K '): active['observed_entry_set']=list(ast.literal_eval(line[2:]))
        elif active is not None and line=='END':
            assert active['counts'][5] == len(active['groups'])
            assert set(active['entries']) == set(active['observed_entry_set'])
            names=[]
            for address in active.pop('entries'):
                label='|'.join(symbols[address-bias]);assert label,label
                names.append(label)
            active['observed_entry_calls']=dict(collections.Counter(names))
            active['observed_entry_invocations']=len(names)
            active['entry_runs']=[(name,len(list(group))) for name,group in __import__('itertools').groupby(names)]
            requests=active.pop('requests');hist=collections.Counter((x['block_bytes'],x['inputs'],x['counter'],x['increment'],x['flags'],x['output_bytes'])for x in requests)
            active['request_histogram']=[dict(zip(['block_bytes','inputs','counter','increment','flags','output_bytes'], key),calls=count)for key,count in sorted(hist.items())]
            active['leaf_chunks']=sum(x['inputs']for x in requests if x['block_bytes']==1024 and x['increment']==1)
            active['shared_parent_blocks']=sum(x['inputs']for x in requests if x['block_bytes']==64 and x['increment']==0)
            active['leaf_requests']=sum(1 for x in requests if x['block_bytes']==1024 and x['increment']==1)
            records.append(active);active=None
    assert bias is not None and len(records) in [449,897],len(records)
    for layout in layouts:
        assert layout['size']==layout['stride']==18432 and layout['align']==64
        assert layout['stage_len']==16384
    for row in records:
        if row['phase']=='update' and row['groups']:
            n=int(row['n']);assert sum(map(len,row['groups']))==n
            assert row['leaf_chunks']==n*16
            assert len(set(row['leaf_state_order']))==n
    scope = 'Observed Rust-to-kernel entries only; not an instruction trace. RootBlock covers OutputReader tails, while OutputGroupTurn records the attempted finalize dispatch, not successful wide groups. Counts/addresses are from declared test-only instrumentation, not timing or production allocation measurements.'
    scope += (' This item extends the same observer at scalar compress_in_place/compress_xof FFI entries.' if 'root-entry' in run.name else ' The existing observer misses ordinary scalar finish calls: zero observed finish entries is a coverage gap, not zero work.')
    result[side]=dict(records=records,native_layouts=layouts,scope=scope)
output=run.parent.parent/('bounded-root-count-summary.json' if 'root-entry' in run.name else 'bounded-count-summary.json');output.write_text(json.dumps(dict(run=run.name,sides=result),indent=2)+'\n')
print('Count records checked:', {side:len(data['records'])for side,data in result.items()})
for side,data in result.items():
    print(side,'native layout first:',data['native_layouts'][0])
    for row in data['records']:
        if row['phase']=='startup':print(side,'startup:',row['counts'],row['observed_entry_calls'])
        elif row.get('n')=='512' and row.get('len')=='16384' and row.get('flavor')in['0','1'] and row.get('cycle')=='0' and row.get('order','61')=='61' and (row.get('piece')=='3' or row['phase']=='finish'):
            print(side,{k:row[k]for k in ['phase','flavor','partition','counts','observed_entry_calls','leaf_chunks','shared_parent_blocks']},'cohort sizes',dict(collections.Counter(map(len,row['groups']))))
print(output)
