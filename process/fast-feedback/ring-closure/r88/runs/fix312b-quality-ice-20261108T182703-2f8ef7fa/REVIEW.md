# fix312b-quality-ice-20261108T182703-2f8ef7fa

Host: `root@185.8.106.126`; study: `r88-20261108`.

Runner result:
```
VERIFIED
```

## Workflow latency

| Phase | Nanoseconds |
|---|---:|
| dispatch | 87142080 |
| lock_wait | 246935 |
| preparation | 1953033938 |
| job | 104110389488 |
| verification | 1576142 |
| total | 106152537849 |

## Instrument judgments

This run has no judgments TSV. Its checks and logs are in [out/](out/).

## Sources

[Manifest](manifest.json) · [Phases](phases.jsonl)
- `fork`: https://github.com/samshackleton-tech/BLAKE3 at `3f3abd29cced846dead9d821cfa50ad822c62fc7`
- `base`: https://github.com/servil-software-factory/BLAKE3 at `fd048373c8e5cb814ef9fc302709a75a96650a05`
- `mutator`: https://github.com/sourcefrog/cargo-mutants at `8ab1dc786a1f61a4e370416cc6c68b81a704e917`
- Script SHA-256: `6774d8f835bced830226f7142ce31bf349a7d58202c83b491478285f87ae8140`
- Runner SHA-256: `f45d9b2e187b4074d7bd10bc8e2dce1ff7430d4f92ede54aab25bdd4172859cf`
