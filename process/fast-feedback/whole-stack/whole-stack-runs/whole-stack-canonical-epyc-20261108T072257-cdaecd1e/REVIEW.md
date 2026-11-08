# whole-stack-canonical-epyc-20261108T072257-cdaecd1e

Host: `root@88.216.222.150`; study: `whole-stack-canonical-20261108`.

Runner result:
```
VERIFIED
```

## Workflow latency

| Phase | Nanoseconds |
|---|---:|
| dispatch | 39519568 |
| lock_wait | 116440 |
| preparation | 1449260331 |
| job | 360028540448 |
| verification | 750353 |
| total | 361518268300 |

## Instrument judgments

This run has no judgments TSV. Its checks and logs are in [out/](out/).

## Sources

[Manifest](manifest.json) · [Phases](phases.jsonl)
- `fork`: https://github.com/samshackleton-tech/BLAKE3 at `4f1dd19c83122dfee2c62c1304eb593b812ee992`
- `base`: https://github.com/servil-software-factory/BLAKE3 at `7ee5c1f8cfad7937fb490e6510f8f36fe5ce912f`
- `bench`: https://github.com/servil-software-factory/bench-hashes at `9994de190259648ede82f7c5e4dbac4f1534a41d`
- Script SHA-256: `8a045835f352c761e3a3a1a3a3aa3edeac9626525afbb737a53c0445798eaacb`
- Runner SHA-256: `f45d9b2e187b4074d7bd10bc8e2dce1ff7430d4f92ede54aab25bdd4172859cf`
