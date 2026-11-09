# independent-next-quality3-epyc-20261109T034827-bf1cb4cd

Host: `root@88.216.222.150`; study: `independent-integration-20261109`.

Runner result:
```
FAILED
job: exit 1
expect: no file out/status.txt
```

## Workflow latency

| Phase | Nanoseconds |
|---|---:|
| dispatch | 45502517 |
| lock_wait | 127890 |
| preparation | 763845250 |
| job | 96366724006 |
| verification | 6051472 |
| total | 97182331445 |

## Instrument judgments

This run has no judgments TSV. Its checks and logs are in [out/](out/).

## Sources

[Manifest](manifest.json) · [Phases](phases.jsonl)
- `library`: https://github.com/samshackleton-tech/BLAKE3 at `69d9256b2ef3e0f14d0477bc0221c9498ae6cd6e`
- `base`: https://github.com/servil-software-factory/BLAKE3 at `6eefdc657effe6002f9a001fccac9306699b3911`
- `mutator`: https://github.com/sourcefrog/cargo-mutants at `8ab1dc786a1f61a4e370416cc6c68b81a704e917`
- Script SHA-256: `f6bb6a82286e68936427c74d527c5a66797cf20780c2ce5f374f554bdb4b2d5d`
- Runner SHA-256: `f45d9b2e187b4074d7bd10bc8e2dce1ff7430d4f92ede54aab25bdd4172859cf`
