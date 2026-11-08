# mixed-stage-costs-epyc-20261108T062248-85c3691a

Host: `root@88.216.222.150`; study: `mixed-stage-costs-epyc-20261108`.

Runner result:
```
VERIFIED
```

## Workflow latency

| Phase | Nanoseconds |
|---|---:|
| dispatch | 51028578 |
| lock_wait | 120211 |
| preparation | 1506363707 |
| job | 141925810999 |
| verification | 1081043 |
| total | 143484471529 |

## Instrument judgments

[out/judgments-cycle.tsv](out/judgments-cycle.tsv): 134 Faster, 183 Level, 3 Slower

```json
{"items": "7", "metric": "wall_ns", "new_per_item": "2223.1598", "old_per_item": "2145.5630", "ratio_permille": "1036", "shape": "mixed_modes_open1024_len16384_piece4096", "verdict": "Slower", "versus": "old-cycle"}
```

```json
{"items": "7", "metric": "cpu_ns", "new_per_item": "2223.0331", "old_per_item": "2145.4580", "ratio_permille": "1036", "shape": "mixed_modes_open1024_len16384_piece4096", "verdict": "Slower", "versus": "old-cycle"}
```

```json
{"items": "7", "metric": "cycles", "new_per_item": "9629.6457", "old_per_item": "9294.5663", "ratio_permille": "1036", "shape": "mixed_modes_open1024_len16384_piece4096", "verdict": "Slower", "versus": "old-cycle"}
```
[out/judgments-finish.tsv](out/judgments-finish.tsv): 256 Level
[out/judgments-update.tsv](out/judgments-update.tsv): 134 Faster, 182 Level, 4 Slower

```json
{"items": "7", "metric": "wall_ns", "new_per_item": "2137.2242", "old_per_item": "2061.6714", "ratio_permille": "1037", "shape": "mixed_modes_open1024_len16384_piece4096", "verdict": "Slower", "versus": "old-update"}
```

```json
{"items": "7", "metric": "cpu_ns", "new_per_item": "2137.1558", "old_per_item": "2061.6122", "ratio_permille": "1037", "shape": "mixed_modes_open1024_len16384_piece4096", "verdict": "Slower", "versus": "old-update"}
```

```json
{"items": "7", "metric": "cycles", "new_per_item": "9258.6676", "old_per_item": "8929.2846", "ratio_permille": "1037", "shape": "mixed_modes_open1024_len16384_piece4096", "verdict": "Slower", "versus": "old-update"}
```

```json
{"items": "7", "metric": "package_nj", "new_per_item": "154694.6485", "old_per_item": "149570.7170", "ratio_permille": "1034", "shape": "mixed_modes_open1024_len16384_piece4096", "verdict": "Slower", "versus": "old-update"}
```

## Sources

[Manifest](manifest.json) · [Phases](phases.jsonl)
- `old`: https://github.com/samshackleton-tech/BLAKE3 at `60a42e1e644aed262123ff5b285ac6812ea7e8a6`
- `new`: https://github.com/samshackleton-tech/BLAKE3 at `a6fedec518aa7a32ba658c79ca7b41234c6e5d56`
- `bench`: https://github.com/servil-software-factory/bench-hashes at `9994de190259648ede82f7c5e4dbac4f1534a41d`
- Script SHA-256: `f484d04c38974e6f4b2d6b61448499ee99a15a5f15a7ab893151d1c8fd77214c`
- Runner SHA-256: `f45d9b2e187b4074d7bd10bc8e2dce1ff7430d4f92ede54aab25bdd4172859cf`
