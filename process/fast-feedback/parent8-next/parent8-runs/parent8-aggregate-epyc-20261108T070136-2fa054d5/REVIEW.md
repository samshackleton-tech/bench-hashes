# parent8-aggregate-epyc-20261108T070136-2fa054d5

Host: `root@88.216.222.150`; study: `parent8-aggregate-epyc-20261108`.

Runner result:
```
VERIFIED
```

## Workflow latency

| Phase | Nanoseconds |
|---|---:|
| dispatch | 36893549 |
| lock_wait | 118050 |
| preparation | 1525532946 |
| job | 141893797003 |
| verification | 1042844 |
| total | 143457446602 |

## Instrument judgments

[out/judgments-cycle.tsv](out/judgments-cycle.tsv): 154 Faster, 166 Level
[out/judgments-finish.tsv](out/judgments-finish.tsv): 256 Level
[out/judgments-update.tsv](out/judgments-update.tsv): 155 Faster, 165 Level

## Sources

[Manifest](manifest.json) · [Phases](phases.jsonl)
- `old`: https://github.com/samshackleton-tech/BLAKE3 at `60a42e1e644aed262123ff5b285ac6812ea7e8a6`
- `new`: https://github.com/samshackleton-tech/BLAKE3 at `4f1dd19c83122dfee2c62c1304eb593b812ee992`
- `bench`: https://github.com/servil-software-factory/bench-hashes at `9994de190259648ede82f7c5e4dbac4f1534a41d`
- Script SHA-256: `f484d04c38974e6f4b2d6b61448499ee99a15a5f15a7ab893151d1c8fd77214c`
- Runner SHA-256: `f45d9b2e187b4074d7bd10bc8e2dce1ff7430d4f92ede54aab25bdd4172859cf`
