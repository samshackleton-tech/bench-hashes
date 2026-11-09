# independent-next-ab-epyc-20261109T035612-c2ee469d

Host: `root@88.216.222.150`; study: `independent-integration-20261109`.

Runner result:
```
VERIFIED
```

## Workflow latency

| Phase | Nanoseconds |
|---|---:|
| dispatch | 43848560 |
| lock_wait | 120601 |
| preparation | 3576546439 |
| job | 224981141088 |
| verification | 1359365 |
| total | 228603082303 |

## Instrument judgments

[out/judgments-cycle.tsv](out/judgments-cycle.tsv): 230 Faster, 90 Level
[out/judgments-finish.tsv](out/judgments-finish.tsv): 256 Level
[out/judgments-update.tsv](out/judgments-update.tsv): 230 Faster, 90 Level

## Sources

[Manifest](manifest.json) · [Phases](phases.jsonl)
- `old`: https://github.com/servil-software-factory/BLAKE3 at `6eefdc657effe6002f9a001fccac9306699b3911`
- `new`: https://github.com/samshackleton-tech/BLAKE3 at `69d9256b2ef3e0f14d0477bc0221c9498ae6cd6e`
- `bench`: https://github.com/servil-software-factory/bench-hashes at `9994de190259648ede82f7c5e4dbac4f1534a41d`
- `evidence`: https://github.com/samshackleton-tech/bench-hashes at `c2308172c419a131a148a1fe49ea3afa2e611a6f`
- Script SHA-256: `fe663157cccd6e7888015aade188a73f554dd1e64384db8c4ffd14cd0aa48bd7`
- Runner SHA-256: `f45d9b2e187b4074d7bd10bc8e2dce1ff7430d4f92ede54aab25bdd4172859cf`
