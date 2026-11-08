# r88-fix-open-check-epyc-20261108T165118-2323f8fd

Host: `root@88.216.222.150`; study: `r88-20261108`.

Runner result:
```
VERIFIED
```

## Workflow latency

| Phase | Nanoseconds |
|---|---:|
| dispatch | 40570359 |
| lock_wait | 1479776059070 |
| preparation | 1789485925 |
| job | 84875116569 |
| verification | 536042 |
| total | 1566481835655 |

## Instrument judgments

This run has no judgments TSV. Its checks and logs are in [out/](out/).

## Sources

[Manifest](manifest.json) · [Phases](phases.jsonl)
- `fork`: https://github.com/samshackleton-tech/BLAKE3 at `fc250d0c027119e784d78d9dd659605a227d71fc`
- `base`: https://github.com/servil-software-factory/BLAKE3 at `fbfb319f3414ac7fac4b3d4bce266488a1fdee3b`
- `bench`: https://github.com/servil-software-factory/bench-hashes at `7ea20449cdc97540bfeecf35574b548d1a1f0d0d`
- Script SHA-256: `5eb7184912f7f0450789aee189dcca5342314caecba77f2bfb0ed755b216e7a8`
- Runner SHA-256: `f45d9b2e187b4074d7bd10bc8e2dce1ff7430d4f92ede54aab25bdd4172859cf`
