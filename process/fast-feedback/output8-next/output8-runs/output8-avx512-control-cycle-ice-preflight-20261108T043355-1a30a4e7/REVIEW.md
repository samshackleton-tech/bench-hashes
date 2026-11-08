# output8-avx512-control-cycle-ice-preflight-20261108T043355-1a30a4e7

Host: `root@185.8.106.126`; study: `output8-control-ice-20261108`.

Runner result:
```
VERIFIED
```

## Workflow latency

| Phase | Nanoseconds |
|---|---:|
| dispatch | 91816143 |
| lock_wait | 251531 |
| preparation | 3340555070 |
| job | 11812656146 |
| verification | 1856170 |
| total | 15247281183 |

## Instrument judgments

This run has no judgments TSV. Its checks and logs are in [out/](out/).

## Sources

[Manifest](manifest.json) · [Phases](phases.jsonl)
- `old`: https://github.com/samshackleton-tech/BLAKE3 at `85c4b2d92b71c87a42261509fa6258f02903a0bc`
- `new`: https://github.com/samshackleton-tech/BLAKE3 at `925e28d9de5bb11ea7d55eec7706adf761c5226e`
- `bench`: https://github.com/servil-software-factory/bench-hashes at `9994de190259648ede82f7c5e4dbac4f1534a41d`
- Script SHA-256: `1eb0cd7fbe560b1197a265c0a89da2d9626cedb4175158325e8b45627c5391cc`
- Runner SHA-256: `f45d9b2e187b4074d7bd10bc8e2dce1ff7430d4f92ede54aab25bdd4172859cf`
