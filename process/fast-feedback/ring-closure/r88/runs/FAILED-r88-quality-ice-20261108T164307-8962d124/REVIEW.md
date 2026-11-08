# r88-quality-ice-20261108T164307-8962d124

Host: `root@185.8.106.126`; study: `r88-20261108`.

Runner result:
```
FAILED
job: exit 1
expect: out/mutation.log lacks 'no new survivor'
expect: no file out/status.txt
```

## Workflow latency

| Phase | Nanoseconds |
|---|---:|
| dispatch | 93817100 |
| lock_wait | 260478 |
| preparation | 2012585433 |
| job | 124091622714 |
| verification | 13059755 |
| total | 126211524890 |

## Instrument judgments

This run has no judgments TSV. Its checks and logs are in [out/](out/).

## Sources

[Manifest](manifest.json) · [Phases](phases.jsonl)
- `fork`: https://github.com/servil-software-factory/BLAKE3 at `88e215ed79065823a9dadd48fb0a0f4150743989`
- `base`: https://github.com/servil-software-factory/BLAKE3 at `fbfb319f3414ac7fac4b3d4bce266488a1fdee3b`
- `mutator`: https://github.com/sourcefrog/cargo-mutants at `8ab1dc786a1f61a4e370416cc6c68b81a704e917`
- Script SHA-256: `f5f8f7ce94a7a3c5af094ac42b5fbcd305c01d4cc67a0c123d483045f9c1fd58`
- Runner SHA-256: `f45d9b2e187b4074d7bd10bc8e2dce1ff7430d4f92ede54aab25bdd4172859cf`
