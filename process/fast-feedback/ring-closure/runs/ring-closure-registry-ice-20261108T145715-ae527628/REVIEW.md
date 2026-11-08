# ring-closure-registry-ice-20261108T145715-ae527628

Host: `root@185.8.106.126`; study: `ring-closure-20261108`.

Runner result:
```
VERIFIED
```

## Workflow latency

| Phase | Nanoseconds |
|---|---:|
| dispatch | 81403172 |
| lock_wait | 245639 |
| preparation | 2010158084 |
| job | 124483132161 |
| verification | 18873528 |
| total | 126593953118 |

## Instrument judgments

This run has no judgments TSV. Its checks and logs are in [out/](out/).

## Sources

[Manifest](manifest.json) · [Phases](phases.jsonl)
- `fork`: https://github.com/samshackleton-tech/BLAKE3 at `05fd8b92fcf93f182b5bd0206abd166461b60ce7`
- `base`: https://github.com/servil-software-factory/BLAKE3 at `fbfb319f3414ac7fac4b3d4bce266488a1fdee3b`
- `mutator`: https://github.com/sourcefrog/cargo-mutants at `8ab1dc786a1f61a4e370416cc6c68b81a704e917`
- Script SHA-256: `f64125b06949346ffc68368f3cfe3e98e42fcf153f6092bdfc4b7bae213ed7d4`
- Runner SHA-256: `f45d9b2e187b4074d7bd10bc8e2dce1ff7430d4f92ede54aab25bdd4172859cf`
