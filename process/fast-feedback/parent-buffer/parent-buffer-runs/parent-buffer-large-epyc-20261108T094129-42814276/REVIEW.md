# parent-buffer-large-epyc-20261108T094129-42814276

Host: `root@88.216.222.150`; study: `parent-buffer-large-epyc-20261108`.

Runner result:
```
VERIFIED
```

## Workflow latency

| Phase | Nanoseconds |
|---|---:|
| dispatch | 39004586 |
| lock_wait | 111370 |
| preparation | 1520347952 |
| job | 141145966625 |
| verification | 1071203 |
| total | 142706571677 |

## Instrument judgments

[out/judgments-cycle.tsv](out/judgments-cycle.tsv): 320 Level
[out/judgments-finish.tsv](out/judgments-finish.tsv): 256 Level
[out/judgments-update.tsv](out/judgments-update.tsv): 320 Level

## Sources

[Manifest](manifest.json) · [Phases](phases.jsonl)
- `old`: https://github.com/samshackleton-tech/BLAKE3 at `4f1dd19c83122dfee2c62c1304eb593b812ee992`
- `new`: https://github.com/samshackleton-tech/BLAKE3 at `b817ac85c985582ed600208e02a380ece730c4a2`
- `bench`: https://github.com/servil-software-factory/bench-hashes at `9994de190259648ede82f7c5e4dbac4f1534a41d`
- Script SHA-256: `f484d04c38974e6f4b2d6b61448499ee99a15a5f15a7ab893151d1c8fd77214c`
- Runner SHA-256: `f45d9b2e187b4074d7bd10bc8e2dce1ff7430d4f92ede54aab25bdd4172859cf`
