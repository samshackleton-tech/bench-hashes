# output16-integration-startup-ice-20261108T023426-6ce24863

Host: `root@185.8.106.126`; study: `output16-integration-startup-20261108`.

Runner result:
```
VERIFIED
```

## Workflow latency

| Phase | Nanoseconds |
|---|---:|
| dispatch | 92690986 |
| lock_wait | 238125 |
| preparation | 3291069663 |
| job | 13881057137 |
| verification | 6914345 |
| total | 17272121960 |

## Instrument judgments

[out/judgments.tsv](out/judgments.tsv): 7 Level, 1 Slower

```json
{"metric": "instructions", "new_per_message": "95006.6250", "old_per_message": "82216.8125", "pairs": "4", "ratio_permille": "1156", "shape": "first", "verdict": "Slower"}
```

## Sources

[Manifest](manifest.json) · [Phases](phases.jsonl)
- `old`: https://github.com/servil-software-factory/BLAKE3 at `597581e963b3b6a2eb3df96234339a99aec274cd`
- `new`: https://github.com/samshackleton-tech/BLAKE3 at `3414da907a2ce49d4bedaf2fbbf6ac91c3f21cce`
- `bench`: https://github.com/servil-software-factory/bench-hashes at `9994de190259648ede82f7c5e4dbac4f1534a41d`
- Script SHA-256: `3ff99bcf175ba6faa4d8f0714474f3445619e0df0319d2c286807d6d58d9c13a`
- Runner SHA-256: `f45d9b2e187b4074d7bd10bc8e2dce1ff7430d4f92ede54aab25bdd4172859cf`
