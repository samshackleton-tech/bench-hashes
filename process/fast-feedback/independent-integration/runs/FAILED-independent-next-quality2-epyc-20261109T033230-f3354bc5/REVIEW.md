# independent-next-quality2-epyc-20261109T033230-f3354bc5

Host: `root@88.216.222.150`; study: `independent-integration-20261109`.

Runner result:
```
FAILED
job: exit 1
expect: no file out/native-status.txt
expect: no file out/mutation.log
expect: no file out/status.txt
```

## Workflow latency

| Phase | Nanoseconds |
|---|---:|
| dispatch | 44145934 |
| lock_wait | 113660 |
| preparation | 1829604822 |
| job | 12339067254 |
| verification | 622992 |
| total | 14213618812 |

## Instrument judgments

This run has no judgments TSV. Its checks and logs are in [out/](out/).

## Sources

[Manifest](manifest.json) · [Phases](phases.jsonl)
- `library`: https://github.com/samshackleton-tech/BLAKE3 at `69d9256b2ef3e0f14d0477bc0221c9498ae6cd6e`
- `base`: https://github.com/servil-software-factory/BLAKE3 at `6eefdc657effe6002f9a001fccac9306699b3911`
- `mutator`: https://github.com/sourcefrog/cargo-mutants at `8ab1dc786a1f61a4e370416cc6c68b81a704e917`
- Script SHA-256: `eec8078b1abe6a2a0356748c6cc377dd4e6b350d067ffcdeb8000ccda3c0e49c`
- Runner SHA-256: `f45d9b2e187b4074d7bd10bc8e2dce1ff7430d4f92ede54aab25bdd4172859cf`
