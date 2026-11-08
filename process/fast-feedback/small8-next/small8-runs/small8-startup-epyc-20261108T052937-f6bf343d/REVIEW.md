# small8-startup-epyc-20261108T052937-f6bf343d

Host: `root@88.216.222.150`; study: `small8-startup-epyc-20261108`.

Runner result:
```
VERIFIED
```

## Workflow latency

| Phase | Nanoseconds |
|---|---:|
| dispatch | 49383404 |
| lock_wait | 117591 |
| preparation | 1494740031 |
| job | 7176275461 |
| verification | 2683510 |
| total | 8723262347 |

## Instrument judgments

[out/judgments.tsv](out/judgments.tsv): 4 Level, 4 Slower

```json
{"metric": "wall_ns", "new_per_message": "36322.8438", "old_per_message": "34192.5625", "pairs": "4", "ratio_permille": "1062", "shape": "first", "verdict": "Slower"}
```

```json
{"metric": "cpu_ns", "new_per_message": "36609.0938", "old_per_message": "34479.7500", "pairs": "4", "ratio_permille": "1062", "shape": "first", "verdict": "Slower"}
```

```json
{"metric": "cycles", "new_per_message": "134478.6562", "old_per_message": "124512.6875", "pairs": "4", "ratio_permille": "1080", "shape": "first", "verdict": "Slower"}
```

```json
{"metric": "instructions", "new_per_message": "130601.5000", "old_per_message": "125505.6562", "pairs": "4", "ratio_permille": "1041", "shape": "first", "verdict": "Slower"}
```

## Sources

[Manifest](manifest.json) · [Phases](phases.jsonl)
- `old`: https://github.com/samshackleton-tech/BLAKE3 at `925e28d9de5bb11ea7d55eec7706adf761c5226e`
- `new`: https://github.com/samshackleton-tech/BLAKE3 at `6e74ed36d683a634f193cb101cf26eaca72e0e3c`
- `bench`: https://github.com/servil-software-factory/bench-hashes at `9994de190259648ede82f7c5e4dbac4f1534a41d`
- Script SHA-256: `3ff99bcf175ba6faa4d8f0714474f3445619e0df0319d2c286807d6d58d9c13a`
- Runner SHA-256: `f45d9b2e187b4074d7bd10bc8e2dce1ff7430d4f92ede54aab25bdd4172859cf`
