# small8-increment-ice-20261108T050451-eecf4200

Host: `root@185.8.106.126`; study: `small8-increment-ice-20261108`.

Runner result:
```
VERIFIED
```

## Workflow latency

| Phase | Nanoseconds |
|---|---:|
| dispatch | 78586701 |
| lock_wait | 236481 |
| preparation | 3339704803 |
| job | 402516894745 |
| verification | 4939009 |
| total | 405940510002 |

## Instrument judgments

[out/judgments-cycle.tsv](out/judgments-cycle.tsv): 880 Faster, 1140 Level, 20 Slower

```json
{"items": "17", "metric": "package_nj", "new_per_item": "5312.5149", "old_per_item": "5136.7825", "ratio_permille": "1034", "shape": "mixed_mode_64_piece256", "verdict": "Slower", "versus": "old-cycle"}
```

```json
{"items": "17", "metric": "wall_ns", "new_per_item": "36.1871", "old_per_item": "35.1194", "ratio_permille": "1030", "shape": "plain_0_piece17", "verdict": "Slower", "versus": "old-cycle"}
```

```json
{"items": "17", "metric": "cpu_ns", "new_per_item": "36.1839", "old_per_item": "35.1009", "ratio_permille": "1031", "shape": "plain_0_piece17", "verdict": "Slower", "versus": "old-cycle"}
```

```json
{"items": "17", "metric": "cycles", "new_per_item": "72.2194", "old_per_item": "70.0567", "ratio_permille": "1031", "shape": "plain_0_piece17", "verdict": "Slower", "versus": "old-cycle"}
```

```json
{"items": "17", "metric": "package_nj", "new_per_item": "3828.9454", "old_per_item": "3699.3611", "ratio_permille": "1035", "shape": "plain_0_piece17", "verdict": "Slower", "versus": "old-cycle"}
```

```json
{"items": "17", "metric": "cycles", "new_per_item": "72.4430", "old_per_item": "70.2978", "ratio_permille": "1030", "shape": "plain_0_piece256", "verdict": "Slower", "versus": "old-cycle"}
```

```json
{"items": "16", "metric": "wall_ns", "new_per_item": "45.8562", "old_per_item": "44.1947", "ratio_permille": "1038", "shape": "plain_1_piece17", "verdict": "Slower", "versus": "old-cycle"}
```

```json
{"items": "16", "metric": "cpu_ns", "new_per_item": "45.8399", "old_per_item": "44.1918", "ratio_permille": "1037", "shape": "plain_1_piece17", "verdict": "Slower", "versus": "old-cycle"}
```

```json
{"items": "16", "metric": "cycles", "new_per_item": "91.4916", "old_per_item": "88.1711", "ratio_permille": "1038", "shape": "plain_1_piece17", "verdict": "Slower", "versus": "old-cycle"}
```

```json
{"items": "16", "metric": "wall_ns", "new_per_item": "60.9890", "old_per_item": "58.5293", "ratio_permille": "1042", "shape": "plain_31_piece17", "verdict": "Slower", "versus": "old-cycle"}
```

```json
{"items": "16", "metric": "cpu_ns", "new_per_item": "60.9792", "old_per_item": "58.5272", "ratio_permille": "1042", "shape": "plain_31_piece17", "verdict": "Slower", "versus": "old-cycle"}
```

```json
{"items": "16", "metric": "cycles", "new_per_item": "121.7095", "old_per_item": "116.7641", "ratio_permille": "1042", "shape": "plain_31_piece17", "verdict": "Slower", "versus": "old-cycle"}
```

```json
{"items": "16", "metric": "package_nj", "new_per_item": "6443.9752", "old_per_item": "6197.0353", "ratio_permille": "1040", "shape": "plain_31_piece17", "verdict": "Slower", "versus": "old-cycle"}
```

```json
{"items": "16", "metric": "wall_ns", "new_per_item": "90.7689", "old_per_item": "87.6640", "ratio_permille": "1035", "shape": "plain_63_piece17", "verdict": "Slower", "versus": "old-cycle"}
```

```json
{"items": "16", "metric": "cpu_ns", "new_per_item": "90.7700", "old_per_item": "87.6627", "ratio_permille": "1035", "shape": "plain_63_piece17", "verdict": "Slower", "versus": "old-cycle"}
```

```json
{"items": "16", "metric": "cycles", "new_per_item": "181.1833", "old_per_item": "174.9544", "ratio_permille": "1036", "shape": "plain_63_piece17", "verdict": "Slower", "versus": "old-cycle"}
```

```json
{"items": "16", "metric": "package_nj", "new_per_item": "9569.7343", "old_per_item": "9267.1806", "ratio_permille": "1033", "shape": "plain_63_piece17", "verdict": "Slower", "versus": "old-cycle"}
```

```json
{"items": "16", "metric": "wall_ns", "new_per_item": "90.7499", "old_per_item": "87.6527", "ratio_permille": "1035", "shape": "plain_64_piece17", "verdict": "Slower", "versus": "old-cycle"}
```

```json
{"items": "16", "metric": "cpu_ns", "new_per_item": "90.7440", "old_per_item": "87.6088", "ratio_permille": "1036", "shape": "plain_64_piece17", "verdict": "Slower", "versus": "old-cycle"}
```

```json
{"items": "16", "metric": "cycles", "new_per_item": "181.0986", "old_per_item": "174.8636", "ratio_permille": "1036", "shape": "plain_64_piece17", "verdict": "Slower", "versus": "old-cycle"}
```

## Sources

[Manifest](manifest.json) · [Phases](phases.jsonl)
- `old`: https://github.com/samshackleton-tech/BLAKE3 at `925e28d9de5bb11ea7d55eec7706adf761c5226e`
- `new`: https://github.com/samshackleton-tech/BLAKE3 at `6e74ed36d683a634f193cb101cf26eaca72e0e3c`
- `bench`: https://github.com/servil-software-factory/bench-hashes at `9994de190259648ede82f7c5e4dbac4f1534a41d`
- Script SHA-256: `2c6cd5f30a5303193ae984960777a321586d0579f441c55e1e0d1c04fd33a27a`
- Runner SHA-256: `f45d9b2e187b4074d7bd10bc8e2dce1ff7430d4f92ede54aab25bdd4172859cf`
