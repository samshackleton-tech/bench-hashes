# formal-substitution-quality-20261109T063105-da8de7e0

Host: `root@88.216.222.150`; study: `formal-verification-20261109`.

Runner result:
```
FAILED
expect: no file out/reversed-output-order-red.log
expect: no file out/lost-counter-binding-red.log
expect: no file out/output16.log
expect: no file out/output8.log
expect: no file out/status.txt
```

## Workflow latency

| Phase | Nanoseconds |
|---|---:|
| dispatch | 41543848 |
| lock_wait | 112351 |
| preparation | 897043365 |
| job | 1370602867 |
| verification | 507812 |
| total | 2309892213 |

## Instrument judgments

This run has no judgments TSV. Its checks and logs are in [out/](out/).

## Sources

[Manifest](manifest.json) · [Phases](phases.jsonl)
- `library`: https://github.com/samshackleton-tech/BLAKE3 at `d188e700c41c9c6a32811a97e0cfcb2a23398e92`
- `reference`: https://github.com/samshackleton-tech/BLAKE3 at `69d9256b2ef3e0f14d0477bc0221c9498ae6cd6e`
- Script SHA-256: `db31d1cf2bfbd62bc2f30b8f07415fa4e79958d0a077fb3393edb81e71d78e16`
- Runner SHA-256: `f45d9b2e187b4074d7bd10bc8e2dce1ff7430d4f92ede54aab25bdd4172859cf`
