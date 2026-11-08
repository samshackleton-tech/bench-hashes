# fe60-gate-epyc-20261108T175423-5839daac

Host: `root@88.216.222.150`; study: `r88-20261108`.

Runner result:
```
VERIFIED
```

## Workflow latency

| Phase | Nanoseconds |
|---|---:|
| dispatch | 42201338 |
| lock_wait | 110490 |
| preparation | 2129898038 |
| job | 1787226911859 |
| verification | 818013 |
| total | 1789399994178 |

## Instrument judgments

This run has no judgments TSV. Its checks and logs are in [out/](out/).

## Sources

[Manifest](manifest.json) · [Phases](phases.jsonl)
- `fork`: https://github.com/devonjonte/BLAKE3 at `fe60dc85bdb81c55163667dc78e18573765bc6cf`
- `base`: https://github.com/servil-software-factory/BLAKE3 at `fbfb319f3414ac7fac4b3d4bce266488a1fdee3b`
- `bench`: https://github.com/servil-software-factory/bench-hashes at `7ea20449cdc97540bfeecf35574b548d1a1f0d0d`
- Script SHA-256: `2b719b1c5c43f29807bfe7d0c9ba82c0ffe97b5c67564b2fa9b32f380356561d`
- Runner SHA-256: `f45d9b2e187b4074d7bd10bc8e2dce1ff7430d4f92ede54aab25bdd4172859cf`
