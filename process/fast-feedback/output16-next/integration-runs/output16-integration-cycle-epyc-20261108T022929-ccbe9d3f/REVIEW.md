# output16-integration-cycle-epyc-20261108T022929-ccbe9d3f

Host: `root@88.216.222.150`; study: `output16-integration-cycle-epyc-20261108`.

Runner result:
```
VERIFIED
```

## Workflow latency

| Phase | Nanoseconds |
|---|---:|
| dispatch | 38647722 |
| lock_wait | 120891 |
| preparation | 1427492709 |
| job | 88294351430 |
| verification | 1179694 |
| total | 89761869746 |

## Instrument judgments

[out/judgments-cycle.tsv](out/judgments-cycle.tsv): 400 Faster, 25 Level

## Sources

[Manifest](manifest.json) · [Phases](phases.jsonl)
- `old`: https://github.com/servil-software-factory/BLAKE3 at `597581e963b3b6a2eb3df96234339a99aec274cd`
- `new`: https://github.com/samshackleton-tech/BLAKE3 at `3414da907a2ce49d4bedaf2fbbf6ac91c3f21cce`
- `bench`: https://github.com/servil-software-factory/bench-hashes at `9994de190259648ede82f7c5e4dbac4f1534a41d`
- Script SHA-256: `4e07ef549424bc5efb491a611a0d0b9657944c90fe6e07edf9228ed6b8d82750`
- Runner SHA-256: `f45d9b2e187b4074d7bd10bc8e2dce1ff7430d4f92ede54aab25bdd4172859cf`
