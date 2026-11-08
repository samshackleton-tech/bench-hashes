# output16-current-scoped-epyc-20261108T013359-31cbe861

Host: `root@88.216.222.150`; study: `output16-gate-epyc-20261108`.

Runner result:
```
FAILED
job: exit 2
expect: no file out/status.txt
```

## Workflow latency

| Phase | Nanoseconds |
|---|---:|
| dispatch | 37896208 |
| lock_wait | 115371 |
| preparation | 1169110702 |
| job | 316257219589 |
| verification | 568982 |
| total | 317464985713 |

## Instrument judgments

This run has no judgments TSV. Its checks and logs are in [out/](out/).

## Sources

[Manifest](manifest.json) · [Phases](phases.jsonl)
- `fork`: https://github.com/samshackleton-tech/BLAKE3 at `1d74d68667dce503e89c2399acdb20f630810871`
- `bench`: https://github.com/servil-software-factory/bench-hashes at `9994de190259648ede82f7c5e4dbac4f1534a41d`
- Script SHA-256: `0881bd61973dbcdcbacd9331a6b8404e01c18710a11f7293af9aa12ab3fdbf5c`
- Runner SHA-256: `f45d9b2e187b4074d7bd10bc8e2dce1ff7430d4f92ede54aab25bdd4172859cf`
