# reviewed-independent-aa-epyc-20261109T055459-bfcffc7c

Host: `root@88.216.222.150`; study: `reviewed-independent-20261109`.

Runner result:
```
VERIFIED
```

## Workflow latency

| Phase | Nanoseconds |
|---|---:|
| dispatch | 42465524 |
| lock_wait | 127750 |
| preparation | 3657182988 |
| job | 224549323595 |
| verification | 1398105 |
| total | 228250559762 |

## Instrument judgments

[out/judgments-cycle.tsv](out/judgments-cycle.tsv): 320 Level
[out/judgments-finish.tsv](out/judgments-finish.tsv): 256 Level
[out/judgments-update.tsv](out/judgments-update.tsv): 320 Level

## Sources

[Manifest](manifest.json) · [Phases](phases.jsonl)
- `old`: https://github.com/samshackleton-tech/BLAKE3 at `62b75883dd752bad5b74195138e157349b830344`
- `new`: https://github.com/samshackleton-tech/BLAKE3 at `62b75883dd752bad5b74195138e157349b830344`
- `bench`: https://github.com/servil-software-factory/bench-hashes at `9994de190259648ede82f7c5e4dbac4f1534a41d`
- `evidence`: https://github.com/samshackleton-tech/bench-hashes at `c2308172c419a131a148a1fe49ea3afa2e611a6f`
- Script SHA-256: `fe663157cccd6e7888015aade188a73f554dd1e64384db8c4ffd14cd0aa48bd7`
- Runner SHA-256: `f45d9b2e187b4074d7bd10bc8e2dce1ff7430d4f92ede54aab25bdd4172859cf`
