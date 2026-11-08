# output-precheck-aggregate-ice-20261108T080931-48919b48

Host: `root@185.8.106.126`; study: `output-precheck-aggregate-ice-20261108`.

Runner result:
```
VERIFIED
```

## Workflow latency

| Phase | Nanoseconds |
|---|---:|
| dispatch | 85223130 |
| lock_wait | 2352977 |
| preparation | 3338170020 |
| job | 171501761413 |
| verification | 2393196 |
| total | 174930034846 |

## Instrument judgments

[out/judgments-cycle.tsv](out/judgments-cycle.tsv): 155 Faster, 165 Level
[out/judgments-finish.tsv](out/judgments-finish.tsv): 12 Faster, 243 Level, 1 Slower

```json
{"items": "16", "metric": "wall_ns", "new_per_item": "138.6570", "old_per_item": "134.3501", "ratio_permille": "1032", "shape": "plain_open16_len16384_piece4096", "verdict": "Slower", "versus": "old-finish"}
```
[out/judgments-update.tsv](out/judgments-update.tsv): 152 Faster, 168 Level

## Sources

[Manifest](manifest.json) · [Phases](phases.jsonl)
- `old`: https://github.com/samshackleton-tech/BLAKE3 at `7ee5c1f8cfad7937fb490e6510f8f36fe5ce912f`
- `new`: https://github.com/samshackleton-tech/BLAKE3 at `a5d1d3e82429df33ef411cb657e88067dfd87d02`
- `bench`: https://github.com/servil-software-factory/bench-hashes at `9994de190259648ede82f7c5e4dbac4f1534a41d`
- Script SHA-256: `f484d04c38974e6f4b2d6b61448499ee99a15a5f15a7ab893151d1c8fd77214c`
- Runner SHA-256: `f45d9b2e187b4074d7bd10bc8e2dce1ff7430d4f92ede54aab25bdd4172859cf`
