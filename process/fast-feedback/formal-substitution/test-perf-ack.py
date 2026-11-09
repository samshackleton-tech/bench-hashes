#!/usr/bin/env python3
"""Controller wire controls using the function in the executed profile worker."""
from pathlib import Path
import ast
import io
import unittest

WORKER = Path(__file__).resolve().parent / 'runs/formal-proof-instruction-profile2-epyc-20261109T130317-985d333d/out/profile-worker.py'

class PerfAck(unittest.TestCase):
    def controller(self, data):
        tree = ast.parse(WORKER.read_text())
        function = next(n for n in ast.walk(tree) if isinstance(n, ast.FunctionDef) and n.name == 'command')
        module = ast.fix_missing_locations(ast.Module(body=[function], type_ignores=[]))
        namespace = dict(control=io.StringIO(), ack=io.BytesIO(data), result={})
        exec(compile(module, 'executed-controller', 'exec'), namespace)
        return namespace

    def test_exact_consecutive_acknowledgements(self):
        state = self.controller(b'ack\n\0' * 2)
        state['command']('enable'); state['command']('disable')
        self.assertEqual(state['result']['perf_acks'], ['61636b0a00'] * 2)
        self.assertEqual(state['control'].getvalue(), 'enable\ndisable\n')

    def test_short_and_wrong_acknowledgements_reject(self):
        for data in [b'ack\n', b'bad\n\0', b'\0ack\n']:
            with self.subTest(data=data):
                state = self.controller(data)
                with self.assertRaises(AssertionError): state['command']('enable')
                self.assertEqual(state['result'], {})

    def test_original_line_reader_leaves_nul(self):
        stream = io.StringIO((b'ack\n\0' * 2).decode())
        self.assertEqual(stream.readline().strip(), 'ack')
        self.assertNotEqual(stream.readline().strip(), 'ack')

if __name__ == '__main__': unittest.main(verbosity=2)
