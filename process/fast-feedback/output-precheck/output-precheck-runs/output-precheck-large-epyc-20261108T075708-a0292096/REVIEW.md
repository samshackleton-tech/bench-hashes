# output-precheck-large-epyc-20261108T075708-a0292096

Host: `root@88.216.222.150`; study: `output-precheck-large-epyc-20261108`.

Runner result:
```
VERIFIED
```

## Workflow latency

| Phase | Nanoseconds |
|---|---:|
| dispatch | 39371157 |
| lock_wait | 112870 |
| preparation | 1754548021 |
| job | 141097992021 |
| verification | 1042654 |
| total | 142893124913 |

## Instrument judgments

[out/judgments-cycle.tsv](out/judgments-cycle.tsv): 320 Level
[out/judgments-finish.tsv](out/judgments-finish.tsv): 256 Level
[out/judgments-update.tsv](out/judgments-update.tsv): 320 Level

## Sources

[Manifest](manifest.json) · [Phases](phases.jsonl)
- `old`: https://github.com/samshackleton-tech/BLAKE3 at `4f1dd19c83122dfee2c62c1304eb593b812ee992`
- `new`: https://github.com/samshackleton-tech/BLAKE3 at `a5d1d3e82429df33ef411cb657e88067dfd87d02`
- `bench`: https://github.com/servil-software-factory/bench-hashes at `9994de190259648ede82f7c5e4dbac4f1534a41d`
- Script SHA-256: `f484d04c38974e6f4b2d6b61448499ee99a15a5f15a7ab893151d1c8fd77214c`
- Runner SHA-256: `f45d9b2e187b4074d7bd10bc8e2dce1ff7430d4f92ede54aab25bdd4172859cf`
