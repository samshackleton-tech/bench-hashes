# whole-stack-startup-epyc-20261108T074302-77087fca

Host: `root@88.216.222.150`; study: `whole-stack-startup-epyc-20261108`.

Runner result:
```
VERIFIED
```

## Workflow latency

| Phase | Nanoseconds |
|---|---:|
| dispatch | 39948959 |
| lock_wait | 122371 |
| preparation | 1499732416 |
| job | 7080952575 |
| verification | 2705069 |
| total | 8623528690 |

## Instrument judgments

[out/judgments.tsv](out/judgments.tsv): 4 Level, 4 Slower

```json
{"metric": "wall_ns", "new_per_message": "34204.6875", "old_per_message": "30570.6562", "pairs": "4", "ratio_permille": "1118", "shape": "first", "verdict": "Slower"}
```

```json
{"metric": "cpu_ns", "new_per_message": "34495.3125", "old_per_message": "30859.3750", "pairs": "4", "ratio_permille": "1117", "shape": "first", "verdict": "Slower"}
```

```json
{"metric": "cycles", "new_per_message": "125886.7188", "old_per_message": "109639.7188", "pairs": "4", "ratio_permille": "1148", "shape": "first", "verdict": "Slower"}
```

```json
{"metric": "instructions", "new_per_message": "130624.9062", "old_per_message": "112736.9375", "pairs": "4", "ratio_permille": "1159", "shape": "first", "verdict": "Slower"}
```

## Sources

[Manifest](manifest.json) · [Phases](phases.jsonl)
- `old`: https://github.com/samshackleton-tech/BLAKE3 at `7ee5c1f8cfad7937fb490e6510f8f36fe5ce912f`
- `new`: https://github.com/samshackleton-tech/BLAKE3 at `4f1dd19c83122dfee2c62c1304eb593b812ee992`
- `bench`: https://github.com/servil-software-factory/bench-hashes at `9994de190259648ede82f7c5e4dbac4f1534a41d`
- Script SHA-256: `3ff99bcf175ba6faa4d8f0714474f3445619e0df0319d2c286807d6d58d9c13a`
- Runner SHA-256: `f45d9b2e187b4074d7bd10bc8e2dce1ff7430d4f92ede54aab25bdd4172859cf`
