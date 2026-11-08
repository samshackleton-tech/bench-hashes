# independent-costs-epyc-20261108T225152-e9f637d1

Host: `root@88.216.222.150`; study: `independent-20261108`.

Runner result:
```
VERIFIED
```

## Workflow latency

| Phase | Nanoseconds |
|---|---:|
| dispatch | 41685234 |
| lock_wait | 120391 |
| preparation | 1737094360 |
| job | 141198418642 |
| verification | 1082264 |
| total | 142978465022 |

## Instrument judgments

[out/judgments-cycle.tsv](out/judgments-cycle.tsv): 316 Level, 4 Slower

```json
{"items": "7", "metric": "wall_ns", "new_per_item": "2089.8703", "old_per_item": "2004.6372", "ratio_permille": "1043", "shape": "plain_open1024_len16384_piece4096", "verdict": "Slower", "versus": "old-cycle"}
```

```json
{"items": "7", "metric": "cpu_ns", "new_per_item": "2089.7715", "old_per_item": "2004.6221", "ratio_permille": "1042", "shape": "plain_open1024_len16384_piece4096", "verdict": "Slower", "versus": "old-cycle"}
```

```json
{"items": "7", "metric": "cycles", "new_per_item": "9052.0362", "old_per_item": "8681.2568", "ratio_permille": "1043", "shape": "plain_open1024_len16384_piece4096", "verdict": "Slower", "versus": "old-cycle"}
```

```json
{"items": "7", "metric": "package_nj", "new_per_item": "151620.8125", "old_per_item": "145263.4726", "ratio_permille": "1044", "shape": "plain_open1024_len16384_piece4096", "verdict": "Slower", "versus": "old-cycle"}
```
[out/judgments-finish.tsv](out/judgments-finish.tsv): 256 Level
[out/judgments-update.tsv](out/judgments-update.tsv): 316 Level, 4 Slower

```json
{"items": "7", "metric": "wall_ns", "new_per_item": "2005.4794", "old_per_item": "1920.5072", "ratio_permille": "1044", "shape": "plain_open1024_len16384_piece4096", "verdict": "Slower", "versus": "old-update"}
```

```json
{"items": "7", "metric": "cpu_ns", "new_per_item": "2005.4295", "old_per_item": "1920.4447", "ratio_permille": "1044", "shape": "plain_open1024_len16384_piece4096", "verdict": "Slower", "versus": "old-update"}
```

```json
{"items": "7", "metric": "cycles", "new_per_item": "8685.7613", "old_per_item": "8315.8946", "ratio_permille": "1044", "shape": "plain_open1024_len16384_piece4096", "verdict": "Slower", "versus": "old-update"}
```

```json
{"items": "2", "metric": "package_nj", "new_per_item": "145589.1733", "old_per_item": "141025.9361", "ratio_permille": "1032", "shape": "shared_key_open2_len16384_piece4096", "verdict": "Slower", "versus": "old-update"}
```

## Sources

[Manifest](manifest.json) · [Phases](phases.jsonl)
- `old`: https://github.com/samshackleton-tech/BLAKE3 at `b817ac85c985582ed600208e02a380ece730c4a2`
- `new`: https://github.com/samshackleton-tech/BLAKE3 at `a6aa7b4ed605168a191e8da2cea4619f92c28c50`
- `bench`: https://github.com/servil-software-factory/bench-hashes at `9994de190259648ede82f7c5e4dbac4f1534a41d`
- Script SHA-256: `f484d04c38974e6f4b2d6b61448499ee99a15a5f15a7ab893151d1c8fd77214c`
- Runner SHA-256: `f45d9b2e187b4074d7bd10bc8e2dce1ff7430d4f92ede54aab25bdd4172859cf`
