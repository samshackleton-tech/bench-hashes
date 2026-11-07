#!/usr/bin/env python3
"""Scope reuse using the landed script's real key helper and Git trees only."""
import argparse
import importlib.util
import json
from pathlib import Path
import subprocess
import tempfile

HEAD = '31c11c254c3bce80ff2cd00543fd693f6969fb37'
parser = argparse.ArgumentParser(description=__doc__)
parser.add_argument('repo', type=Path)
parser.add_argument('output', type=Path, nargs='?', default=Path('proof-key-history.json'))
args = parser.parse_args()
repo, output = args.repo.resolve(), args.output


def git(*args):
    return subprocess.check_output(['git', '-C', str(repo), *args], text=True)


with tempfile.TemporaryDirectory(prefix='proof-key-scope-') as temp:
    temp = Path(temp)
    for name in ['long-proofs.sh', 'test_long_proof_inputs.py']:
        (temp / name).write_text(git('show', HEAD + ':tools/verify/' + name))
    spec = importlib.util.spec_from_file_location('scoped_proof_key', temp / 'test_long_proof_inputs.py')
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    module.SCRIPT = temp / 'long-proofs.sh'
    case = module.LongProofInputs('test_identical_inputs_and_unrelated_documentation_keep_the_cache_key')
    case.setUp()
    try:
        commits = git('rev-list', '--first-parent', '--max-count=51', HEAD).splitlines()[::-1]
        assert len(commits) == 51
        case.root = repo
        selected = commits[0]

        def resolve(*args):
            # key() normally resolves HEAD. Supply the fixed historical target
            # through that existing hook; the production shell expression is unchanged.
            assert args == ('rev-parse', 'HEAD')
            return selected

        case.git = resolve
        before, rows = case.key(), []
        for parent, commit in zip(commits, commits[1:]):
            selected = commit
            key = case.key()
            rows.append(dict(commit=commit, parent=parent, input_key=key, same_as_parent=key == before,
                             changed_paths=git('diff', '--name-only', parent, commit).splitlines()))
            before = key
        record = dict(head=HEAD, expression=case.expression, transitions=rows)
        output.write_text(json.dumps(record, indent=2) + '\n')
        print('transitions:', len(rows), 'unchanged keys:', sum(r['same_as_parent'] for r in rows),
              'distinct target classes:', len({r['input_key'] for r in rows}))
    finally:
        case.doCleanups()
