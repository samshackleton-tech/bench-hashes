# mixed-stage-aa-epyc-20261108T062847-413165d5

Host: `root@88.216.222.150`; study: `mixed-stage-aa-epyc-20261108`.

Runner result:
```
VERIFIED
```

## Workflow latency

| Phase | Nanoseconds |
|---|---:|
| dispatch | 45715970 |
| lock_wait | 119620 |
| preparation | 1513007261 |
| job | 141145522585 |
| verification | 1060484 |
| total | 142705500120 |

## Instrument judgments

[out/judgments-cycle.tsv](out/judgments-cycle.tsv): 320 Level
[out/judgments-finish.tsv](out/judgments-finish.tsv): 256 Level
[out/judgments-update.tsv](out/judgments-update.tsv): 320 Level

## Sources

[Manifest](manifest.json) · [Phases](phases.jsonl)
- `old`: https://github.com/samshackleton-tech/BLAKE3 at `a6fedec518aa7a32ba658c79ca7b41234c6e5d56`
- `new`: https://github.com/samshackleton-tech/BLAKE3 at `a6fedec518aa7a32ba658c79ca7b41234c6e5d56`
- `bench`: https://github.com/servil-software-factory/bench-hashes at `9994de190259648ede82f7c5e4dbac4f1534a41d`
- Script SHA-256: `f484d04c38974e6f4b2d6b61448499ee99a15a5f15a7ab893151d1c8fd77214c`
- Runner SHA-256: `f45d9b2e187b4074d7bd10bc8e2dce1ff7430d4f92ede54aab25bdd4172859cf`
