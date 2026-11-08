# r88-fix-packed-check-epyc-20261108T165118-1d4abecb

Host: `root@88.216.222.150`; study: `r88-20261108`.

Runner result:
```
VERIFIED
```

## Workflow latency

| Phase | Nanoseconds |
|---|---:|
| dispatch | 37152477 |
| lock_wait | 1565556975634 |
| preparation | 1684755824 |
| job | 356975227922 |
| verification | 570122 |
| total | 1924254741739 |

## Instrument judgments

This run has no judgments TSV. Its checks and logs are in [out/](out/).

## Sources

[Manifest](manifest.json) · [Phases](phases.jsonl)
- `fork`: https://github.com/samshackleton-tech/BLAKE3 at `3b5e049fac8dabd9baddde1e8396c4ef0f4eac36`
- `base`: https://github.com/servil-software-factory/BLAKE3 at `fbfb319f3414ac7fac4b3d4bce266488a1fdee3b`
- `bench`: https://github.com/servil-software-factory/bench-hashes at `7ea20449cdc97540bfeecf35574b548d1a1f0d0d`
- Script SHA-256: `5eb7184912f7f0450789aee189dcca5342314caecba77f2bfb0ed755b216e7a8`
- Runner SHA-256: `f45d9b2e187b4074d7bd10bc8e2dce1ff7430d4f92ede54aab25bdd4172859cf`
