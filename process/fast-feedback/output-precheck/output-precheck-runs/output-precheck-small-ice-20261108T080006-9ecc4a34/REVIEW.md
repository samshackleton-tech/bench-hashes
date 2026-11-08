# output-precheck-small-ice-20261108T080006-9ecc4a34

Host: `root@185.8.106.126`; study: `output-precheck-small-ice-20261108`.

Runner result:
```
VERIFIED
```

## Workflow latency

| Phase | Nanoseconds |
|---|---:|
| dispatch | 89096936 |
| lock_wait | 242608 |
| preparation | 3351418728 |
| job | 401283712329 |
| verification | 5141010 |
| total | 404729766007 |

## Instrument judgments

[out/judgments-cycle.tsv](out/judgments-cycle.tsv): 2039 Level, 1 Slower

```json
{"items": "32", "metric": "package_nj", "new_per_item": "9792.6845", "old_per_item": "9504.3896", "ratio_permille": "1030", "shape": "plain_128_piece256", "verdict": "Slower", "versus": "old-cycle"}
```

## Sources

[Manifest](manifest.json) · [Phases](phases.jsonl)
- `old`: https://github.com/samshackleton-tech/BLAKE3 at `4f1dd19c83122dfee2c62c1304eb593b812ee992`
- `new`: https://github.com/samshackleton-tech/BLAKE3 at `a5d1d3e82429df33ef411cb657e88067dfd87d02`
- `bench`: https://github.com/servil-software-factory/bench-hashes at `9994de190259648ede82f7c5e4dbac4f1534a41d`
- Script SHA-256: `2c6cd5f30a5303193ae984960777a321586d0579f441c55e1e0d1c04fd33a27a`
- Runner SHA-256: `f45d9b2e187b4074d7bd10bc8e2dce1ff7430d4f92ede54aab25bdd4172859cf`
