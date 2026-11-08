# mixed-stage-costs-epyc-preflight-20261108T062139-445f8fee

Host: `root@88.216.222.150`; study: `mixed-stage-costs-epyc-20261108`.

Runner result:
```
FAILED
job: exit 1
expect: no file out/preflight.txt
```

## Workflow latency

| Phase | Nanoseconds |
|---|---:|
| dispatch | 44296134 |
| lock_wait | 109621 |
| preparation | 1947719428 |
| job | 2446081537 |
| verification | 506702 |
| total | 4438772022 |

## Instrument judgments

This run has no judgments TSV. Its checks and logs are in [out/](out/).

## Sources

[Manifest](manifest.json) · [Phases](phases.jsonl)
- `old`: https://github.com/samshackleton-tech/BLAKE3 at `60a42e1e644aed262123ff5b285ac6812ea7e8a6`
- `new`: https://github.com/samshackleton-tech/BLAKE3 at `a6fedec518aa7a32ba658c79ca7b41234c6e5d56`
- `bench`: https://github.com/servil-software-factory/bench-hashes at `9994de190259648ede82f7c5e4dbac4f1534a41d`
- Script SHA-256: `5d012b172b3e8e389bf279dbaf435df7dfdb3cb78d86c7ccd81f5a6bf9641c53`
- Runner SHA-256: `f45d9b2e187b4074d7bd10bc8e2dce1ff7430d4f92ede54aab25bdd4172859cf`
