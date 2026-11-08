# small8-width-cycle-ice-20261108T054419-3b97f837

Host: `root@185.8.106.126`; study: `small8-width-cycle-ice-20261108`.

Runner result:
```
VERIFIED
```

## Workflow latency

| Phase | Nanoseconds |
|---|---:|
| dispatch | 89716587 |
| lock_wait | 251692 |
| preparation | 3360230545 |
| job | 400942911312 |
| verification | 4965392 |
| total | 404398221141 |

## Instrument judgments

[out/judgments-cycle.tsv](out/judgments-cycle.tsv): 44 Faster, 1988 Level, 8 Slower

```json
{"items": "17", "metric": "wall_ns", "new_per_item": "51.3222", "old_per_item": "49.7437", "ratio_permille": "1032", "shape": "mixed_mode_64_piece256", "verdict": "Slower", "versus": "old-cycle"}
```

```json
{"items": "17", "metric": "cpu_ns", "new_per_item": "51.3020", "old_per_item": "49.7383", "ratio_permille": "1031", "shape": "mixed_mode_64_piece256", "verdict": "Slower", "versus": "old-cycle"}
```

```json
{"items": "17", "metric": "cycles", "new_per_item": "102.4070", "old_per_item": "99.2723", "ratio_permille": "1032", "shape": "mixed_mode_64_piece256", "verdict": "Slower", "versus": "old-cycle"}
```

```json
{"items": "17", "metric": "package_nj", "new_per_item": "5423.3514", "old_per_item": "5258.0095", "ratio_permille": "1031", "shape": "plain_63_piece256", "verdict": "Slower", "versus": "old-cycle"}
```

```json
{"items": "17", "metric": "wall_ns", "new_per_item": "51.2501", "old_per_item": "49.6937", "ratio_permille": "1031", "shape": "plain_64_piece256", "verdict": "Slower", "versus": "old-cycle"}
```

```json
{"items": "17", "metric": "cpu_ns", "new_per_item": "51.2436", "old_per_item": "49.6914", "ratio_permille": "1031", "shape": "plain_64_piece256", "verdict": "Slower", "versus": "old-cycle"}
```

```json
{"items": "17", "metric": "cycles", "new_per_item": "102.2657", "old_per_item": "99.1713", "ratio_permille": "1031", "shape": "plain_64_piece256", "verdict": "Slower", "versus": "old-cycle"}
```

```json
{"items": "17", "metric": "package_nj", "new_per_item": "5425.7904", "old_per_item": "5261.6153", "ratio_permille": "1031", "shape": "plain_64_piece256", "verdict": "Slower", "versus": "old-cycle"}
```

## Sources

[Manifest](manifest.json) · [Phases](phases.jsonl)
- `old`: https://github.com/samshackleton-tech/BLAKE3 at `6e74ed36d683a634f193cb101cf26eaca72e0e3c`
- `new`: https://github.com/samshackleton-tech/BLAKE3 at `ec08884ff386cb7927f03d08af8133ab84473dfb`
- `bench`: https://github.com/servil-software-factory/bench-hashes at `9994de190259648ede82f7c5e4dbac4f1534a41d`
- Script SHA-256: `2c6cd5f30a5303193ae984960777a321586d0579f441c55e1e0d1c04fd33a27a`
- Runner SHA-256: `f45d9b2e187b4074d7bd10bc8e2dce1ff7430d4f92ede54aab25bdd4172859cf`
