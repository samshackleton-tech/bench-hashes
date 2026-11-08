# ring-closure-quality-ice-20261108T143801-2d9cc8c9

Host: `root@185.8.106.126`; study: `ring-closure-20261108`.

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
| dispatch | 92773940 |
| lock_wait | 245696 |
| preparation | 2062559201 |
| job | 256996583066 |
| verification | 29109823 |
| total | 259181427649 |

## Instrument judgments

This run has no judgments TSV. Its checks and logs are in [out/](out/).

## Sources

[Manifest](manifest.json) · [Phases](phases.jsonl)
- `fork`: https://github.com/servil-software-factory/BLAKE3 at `ddb7199d7f0b0f04390e923474b630ffc7ff2811`
- `base`: https://github.com/servil-software-factory/BLAKE3 at `fbfb319f3414ac7fac4b3d4bce266488a1fdee3b`
- `mutator`: https://github.com/sourcefrog/cargo-mutants at `8ab1dc786a1f61a4e370416cc6c68b81a704e917`
- Script SHA-256: `db1e7aa2a53921ae88335a2abbae8c4783fcae89f10346a6824fe2bac1ed3eb8`
- Runner SHA-256: `f45d9b2e187b4074d7bd10bc8e2dce1ff7430d4f92ede54aab25bdd4172859cf`
