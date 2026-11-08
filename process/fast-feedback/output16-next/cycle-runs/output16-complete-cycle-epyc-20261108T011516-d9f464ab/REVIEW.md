# output16-complete-cycle-epyc-20261108T011516-d9f464ab

Host: `root@88.216.222.150`; study: `output16-cycle-epyc-20261108`.

Runner result:
```
VERIFIED
```

## Workflow latency

| Phase | Nanoseconds |
|---|---:|
| dispatch | 41737952 |
| lock_wait | 103621 |
| preparation | 1392921703 |
| job | 88482162887 |
| verification | 1178344 |
| total | 89918176507 |

## Instrument judgments

[out/judgments-cycle.tsv](out/judgments-cycle.tsv): 409 Faster, 16 Level

## Sources

[Manifest](manifest.json) · [Phases](phases.jsonl)
- `old`: https://github.com/servil-software-factory/BLAKE3 at `597581e963b3b6a2eb3df96234339a99aec274cd`
- `new`: https://github.com/samshackleton-tech/BLAKE3 at `1d74d68667dce503e89c2399acdb20f630810871`
- `bench`: https://github.com/servil-software-factory/bench-hashes at `9994de190259648ede82f7c5e4dbac4f1534a41d`
- Script SHA-256: `4e07ef549424bc5efb491a611a0d0b9657944c90fe6e07edf9228ed6b8d82750`
- Runner SHA-256: `f45d9b2e187b4074d7bd10bc8e2dce1ff7430d4f92ede54aab25bdd4172859cf`
