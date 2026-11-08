# whole-stack-startup-ice-20261108T073655-77a86ef9

Host: `root@185.8.106.126`; study: `whole-stack-startup-ice-20261108`.

Runner result:
```
VERIFIED
```

## Workflow latency

| Phase | Nanoseconds |
|---|---:|
| dispatch | 89028134 |
| lock_wait | 247842 |
| preparation | 3330211674 |
| job | 13987250371 |
| verification | 7020582 |
| total | 17413902148 |

## Instrument judgments

[out/judgments.tsv](out/judgments.tsv): 1 Faster, 3 Level, 4 Slower

```json
{"metric": "wall_ns", "new_per_message": "80603.8438", "old_per_message": "74980.0938", "pairs": "4", "ratio_permille": "1075", "shape": "first", "verdict": "Slower"}
```

```json
{"metric": "cpu_ns", "new_per_message": "81514.0000", "old_per_message": "75889.3750", "pairs": "4", "ratio_permille": "1074", "shape": "first", "verdict": "Slower"}
```

```json
{"metric": "cycles", "new_per_message": "121211.9375", "old_per_message": "109992.3438", "pairs": "4", "ratio_permille": "1102", "shape": "first", "verdict": "Slower"}
```

```json
{"metric": "instructions", "new_per_message": "100222.1562", "old_per_message": "82246.6250", "pairs": "4", "ratio_permille": "1219", "shape": "first", "verdict": "Slower"}
```

## Sources

[Manifest](manifest.json) · [Phases](phases.jsonl)
- `old`: https://github.com/samshackleton-tech/BLAKE3 at `7ee5c1f8cfad7937fb490e6510f8f36fe5ce912f`
- `new`: https://github.com/samshackleton-tech/BLAKE3 at `4f1dd19c83122dfee2c62c1304eb593b812ee992`
- `bench`: https://github.com/servil-software-factory/bench-hashes at `9994de190259648ede82f7c5e4dbac4f1534a41d`
- Script SHA-256: `3ff99bcf175ba6faa4d8f0714474f3445619e0df0319d2c286807d6d58d9c13a`
- Runner SHA-256: `f45d9b2e187b4074d7bd10bc8e2dce1ff7430d4f92ede54aab25bdd4172859cf`
