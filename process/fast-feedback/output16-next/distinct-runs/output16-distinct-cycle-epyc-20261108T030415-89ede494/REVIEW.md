# output16-distinct-cycle-epyc-20261108T030415-89ede494

Host: `root@88.216.222.150`; study: `output16-distinct-cycle-epyc-20261108`.

Runner result:
```
VERIFIED
```

## Workflow latency

| Phase | Nanoseconds |
|---|---:|
| dispatch | 43984876 |
| lock_wait | 106900 |
| preparation | 1441057485 |
| job | 88486491164 |
| verification | 992893 |
| total | 89972706348 |

## Instrument judgments

[out/judgments-cycle.tsv](out/judgments-cycle.tsv): 257 Faster, 168 Level

## Sources

[Manifest](manifest.json) · [Phases](phases.jsonl)
- `old`: https://github.com/servil-software-factory/BLAKE3 at `7ee5c1f8cfad7937fb490e6510f8f36fe5ce912f`
- `new`: https://github.com/samshackleton-tech/BLAKE3 at `d4f675f4967317b41546e8c8309d35eb384cbbaf`
- `bench`: https://github.com/servil-software-factory/bench-hashes at `9994de190259648ede82f7c5e4dbac4f1534a41d`
- Script SHA-256: `4e07ef549424bc5efb491a611a0d0b9657944c90fe6e07edf9228ed6b8d82750`
- Runner SHA-256: `f45d9b2e187b4074d7bd10bc8e2dce1ff7430d4f92ede54aab25bdd4172859cf`
