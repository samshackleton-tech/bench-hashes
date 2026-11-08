# independent-plain-costs-epyc-20261108T225842-e5565d65

Host: `root@88.216.222.150`; study: `independent-20261108`.

Runner result:
```
VERIFIED
```

## Workflow latency

| Phase | Nanoseconds |
|---|---:|
| dispatch | 42157865 |
| lock_wait | 106390 |
| preparation | 1726230526 |
| job | 141079192708 |
| verification | 1087525 |
| total | 142848852484 |

## Instrument judgments

[out/judgments-cycle.tsv](out/judgments-cycle.tsv): 320 Level
[out/judgments-finish.tsv](out/judgments-finish.tsv): 256 Level
[out/judgments-update.tsv](out/judgments-update.tsv): 320 Level

## Sources

[Manifest](manifest.json) · [Phases](phases.jsonl)
- `old`: https://github.com/samshackleton-tech/BLAKE3 at `b817ac85c985582ed600208e02a380ece730c4a2`
- `new`: https://github.com/samshackleton-tech/BLAKE3 at `cd2880f1d2f1a3d1d155877ce105b487ac6966b0`
- `bench`: https://github.com/servil-software-factory/bench-hashes at `9994de190259648ede82f7c5e4dbac4f1534a41d`
- Script SHA-256: `f484d04c38974e6f4b2d6b61448499ee99a15a5f15a7ab893151d1c8fd77214c`
- Runner SHA-256: `f45d9b2e187b4074d7bd10bc8e2dce1ff7430d4f92ede54aab25bdd4172859cf`
