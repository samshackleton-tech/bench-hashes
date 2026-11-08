# parent-buffer-short-epyc-20261108T095007-cbcdfcdf

Host: `root@88.216.222.150`; study: `parent-buffer-short-epyc-20261108`.

Runner result:
```
VERIFIED
```

## Workflow latency

| Phase | Nanoseconds |
|---|---:|
| dispatch | 44007954 |
| lock_wait | 1768756230 |
| preparation | 1480266786 |
| job | 14780358449 |
| verification | 973584 |
| total | 18074434753 |

## Instrument judgments

[out/judgments-cycle.tsv](out/judgments-cycle.tsv): 20 Level
[out/judgments-finish.tsv](out/judgments-finish.tsv): 16 Level
[out/judgments-update.tsv](out/judgments-update.tsv): 20 Level

## Sources

[Manifest](manifest.json) · [Phases](phases.jsonl)
- `old`: https://github.com/samshackleton-tech/BLAKE3 at `4f1dd19c83122dfee2c62c1304eb593b812ee992`
- `new`: https://github.com/samshackleton-tech/BLAKE3 at `b817ac85c985582ed600208e02a380ece730c4a2`
- `bench`: https://github.com/servil-software-factory/bench-hashes at `9994de190259648ede82f7c5e4dbac4f1534a41d`
- Script SHA-256: `35daff9e4fb558bda1a6942558b1dc849b3d47ce210882376421ef39a77de46a`
- Runner SHA-256: `f45d9b2e187b4074d7bd10bc8e2dce1ff7430d4f92ede54aab25bdd4172859cf`
