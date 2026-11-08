# small8-aggregate-epyc-20261108T051745-8d7143c8

Host: `root@88.216.222.150`; study: `small8-aggregate-epyc-20261108`.

Runner result:
```
VERIFIED
```

## Workflow latency

| Phase | Nanoseconds |
|---|---:|
| dispatch | 44293096 |
| lock_wait | 361231 |
| preparation | 1499020873 |
| job | 392555448450 |
| verification | 1987857 |
| total | 394101193007 |

## Instrument judgments

[out/judgments-cycle.tsv](out/judgments-cycle.tsv): 1147 Faster, 872 Level, 21 Slower

```json
{"items": "16", "metric": "wall_ns", "new_per_item": "445.3775", "old_per_item": "429.8922", "ratio_permille": "1036", "shape": "plain_1023_piece17", "verdict": "Slower", "versus": "old-cycle"}
```

```json
{"items": "16", "metric": "cpu_ns", "new_per_item": "445.3658", "old_per_item": "429.8806", "ratio_permille": "1036", "shape": "plain_1023_piece17", "verdict": "Slower", "versus": "old-cycle"}
```

```json
{"items": "16", "metric": "cycles", "new_per_item": "1928.1577", "old_per_item": "1861.1237", "ratio_permille": "1036", "shape": "plain_1023_piece17", "verdict": "Slower", "versus": "old-cycle"}
```

```json
{"items": "64", "metric": "package_nj", "new_per_item": "12869.8414", "old_per_item": "12495.2851", "ratio_permille": "1030", "shape": "plain_1024_piece256", "verdict": "Slower", "versus": "old-cycle"}
```

```json
{"items": "17", "metric": "wall_ns", "new_per_item": "75.3217", "old_per_item": "72.8549", "ratio_permille": "1034", "shape": "plain_128_piece17", "verdict": "Slower", "versus": "old-cycle"}
```

```json
{"items": "17", "metric": "cpu_ns", "new_per_item": "75.3197", "old_per_item": "72.8552", "ratio_permille": "1034", "shape": "plain_128_piece17", "verdict": "Slower", "versus": "old-cycle"}
```

```json
{"items": "17", "metric": "cycles", "new_per_item": "326.0690", "old_per_item": "315.4783", "ratio_permille": "1034", "shape": "plain_128_piece17", "verdict": "Slower", "versus": "old-cycle"}
```

```json
{"items": "17", "metric": "package_nj", "new_per_item": "5685.3455", "old_per_item": "5412.8620", "ratio_permille": "1050", "shape": "plain_128_piece17", "verdict": "Slower", "versus": "old-cycle"}
```

```json
{"items": "15", "metric": "wall_ns", "new_per_item": "2670.1833", "old_per_item": "2590.8152", "ratio_permille": "1031", "shape": "plain_2048_piece256", "verdict": "Slower", "versus": "old-cycle"}
```

```json
{"items": "15", "metric": "cpu_ns", "new_per_item": "2670.1668", "old_per_item": "2590.7671", "ratio_permille": "1031", "shape": "plain_2048_piece256", "verdict": "Slower", "versus": "old-cycle"}
```

```json
{"items": "15", "metric": "cycles", "new_per_item": "11570.5557", "old_per_item": "11225.5922", "ratio_permille": "1031", "shape": "plain_2048_piece256", "verdict": "Slower", "versus": "old-cycle"}
```

```json
{"items": "15", "metric": "package_nj", "new_per_item": "183250.4272", "old_per_item": "177621.0775", "ratio_permille": "1032", "shape": "plain_2048_piece256", "verdict": "Slower", "versus": "old-cycle"}
```

```json
{"items": "16", "metric": "wall_ns", "new_per_item": "233.5723", "old_per_item": "226.5589", "ratio_permille": "1031", "shape": "plain_512_piece17", "verdict": "Slower", "versus": "old-cycle"}
```

```json
{"items": "16", "metric": "wall_ns", "new_per_item": "45.4165", "old_per_item": "43.7815", "ratio_permille": "1037", "shape": "plain_65_piece17", "verdict": "Slower", "versus": "old-cycle"}
```

```json
{"items": "16", "metric": "cpu_ns", "new_per_item": "45.4155", "old_per_item": "43.7804", "ratio_permille": "1037", "shape": "plain_65_piece17", "verdict": "Slower", "versus": "old-cycle"}
```

```json
{"items": "16", "metric": "cycles", "new_per_item": "196.6488", "old_per_item": "189.5761", "ratio_permille": "1037", "shape": "plain_65_piece17", "verdict": "Slower", "versus": "old-cycle"}
```

```json
{"items": "16", "metric": "package_nj", "new_per_item": "3353.9494", "old_per_item": "3242.7728", "ratio_permille": "1034", "shape": "plain_65_piece17", "verdict": "Slower", "versus": "old-cycle"}
```

```json
{"items": "17", "metric": "wall_ns", "new_per_item": "55.3271", "old_per_item": "52.6931", "ratio_permille": "1050", "shape": "plain_65_piece17", "verdict": "Slower", "versus": "old-cycle"}
```

```json
{"items": "17", "metric": "cpu_ns", "new_per_item": "55.3258", "old_per_item": "52.6916", "ratio_permille": "1050", "shape": "plain_65_piece17", "verdict": "Slower", "versus": "old-cycle"}
```

```json
{"items": "17", "metric": "cycles", "new_per_item": "239.5901", "old_per_item": "228.1970", "ratio_permille": "1050", "shape": "plain_65_piece17", "verdict": "Slower", "versus": "old-cycle"}
```

```json
{"items": "17", "metric": "package_nj", "new_per_item": "4062.1855", "old_per_item": "3902.9125", "ratio_permille": "1041", "shape": "plain_65_piece17", "verdict": "Slower", "versus": "old-cycle"}
```

## Sources

[Manifest](manifest.json) · [Phases](phases.jsonl)
- `old`: https://github.com/samshackleton-tech/BLAKE3 at `85c4b2d92b71c87a42261509fa6258f02903a0bc`
- `new`: https://github.com/samshackleton-tech/BLAKE3 at `6e74ed36d683a634f193cb101cf26eaca72e0e3c`
- `bench`: https://github.com/servil-software-factory/bench-hashes at `9994de190259648ede82f7c5e4dbac4f1534a41d`
- Script SHA-256: `2c6cd5f30a5303193ae984960777a321586d0579f441c55e1e0d1c04fd33a27a`
- Runner SHA-256: `f45d9b2e187b4074d7bd10bc8e2dce1ff7430d4f92ede54aab25bdd4172859cf`
