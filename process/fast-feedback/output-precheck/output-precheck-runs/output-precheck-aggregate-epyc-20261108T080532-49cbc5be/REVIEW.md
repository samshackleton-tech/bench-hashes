# output-precheck-aggregate-epyc-20261108T080532-49cbc5be

Host: `root@88.216.222.150`; study: `output-precheck-aggregate-epyc-20261108`.

Runner result:
```
VERIFIED
```

## Workflow latency

| Phase | Nanoseconds |
|---|---:|
| dispatch | 38834424 |
| lock_wait | 117121 |
| preparation | 1501229890 |
| job | 141949229836 |
| verification | 1105794 |
| total | 143490585415 |

## Instrument judgments

[out/judgments-cycle.tsv](out/judgments-cycle.tsv): 154 Faster, 166 Level
[out/judgments-finish.tsv](out/judgments-finish.tsv): 256 Level
[out/judgments-update.tsv](out/judgments-update.tsv): 154 Faster, 166 Level

## Sources

[Manifest](manifest.json) · [Phases](phases.jsonl)
- `old`: https://github.com/samshackleton-tech/BLAKE3 at `7ee5c1f8cfad7937fb490e6510f8f36fe5ce912f`
- `new`: https://github.com/samshackleton-tech/BLAKE3 at `a5d1d3e82429df33ef411cb657e88067dfd87d02`
- `bench`: https://github.com/servil-software-factory/bench-hashes at `9994de190259648ede82f7c5e4dbac4f1534a41d`
- Script SHA-256: `f484d04c38974e6f4b2d6b61448499ee99a15a5f15a7ab893151d1c8fd77214c`
- Runner SHA-256: `f45d9b2e187b4074d7bd10bc8e2dce1ff7430d4f92ede54aab25bdd4172859cf`
