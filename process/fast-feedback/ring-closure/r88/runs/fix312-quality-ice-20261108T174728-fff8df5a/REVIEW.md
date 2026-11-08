# fix312-quality-ice-20261108T174728-fff8df5a

Host: `root@185.8.106.126`; study: `r88-20261108`.

Runner result:
```
VERIFIED
```

## Workflow latency

| Phase | Nanoseconds |
|---|---:|
| dispatch | 84819752 |
| lock_wait | 255203 |
| preparation | 2246617865 |
| job | 93450842118 |
| verification | 1558317 |
| total | 95784230137 |

## Instrument judgments

This run has no judgments TSV. Its checks and logs are in [out/](out/).

## Sources

[Manifest](manifest.json) · [Phases](phases.jsonl)
- `fork`: https://github.com/samshackleton-tech/BLAKE3 at `9d620e4444cd9c0a4f1f7ad4404cfa4935c8d836`
- `base`: https://github.com/servil-software-factory/BLAKE3 at `fd048373c8e5cb814ef9fc302709a75a96650a05`
- `mutator`: https://github.com/sourcefrog/cargo-mutants at `8ab1dc786a1f61a4e370416cc6c68b81a704e917`
- Script SHA-256: `747488842460c0d092aa915694970b62240bbf9472789b469147e4cd6d9e5830`
- Runner SHA-256: `f45d9b2e187b4074d7bd10bc8e2dce1ff7430d4f92ede54aab25bdd4172859cf`
