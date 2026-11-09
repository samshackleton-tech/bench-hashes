# independent-next-quality-ice-20261109T030827-45aecb8c

Host: `root@185.8.106.126`; study: `independent-integration-20261109`.

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
| dispatch | 86575747 |
| lock_wait | 247059 |
| preparation | 1987732052 |
| job | 313442309945 |
| verification | 1958432 |
| total | 315518977623 |

## Instrument judgments

This run has no judgments TSV. Its checks and logs are in [out/](out/).

## Sources

[Manifest](manifest.json) · [Phases](phases.jsonl)
- `library`: https://github.com/samshackleton-tech/BLAKE3 at `9bdfe0e97a2f8ad98870ef593322632090c9e326`
- `base`: https://github.com/servil-software-factory/BLAKE3 at `6eefdc657effe6002f9a001fccac9306699b3911`
- `mutator`: https://github.com/sourcefrog/cargo-mutants at `8ab1dc786a1f61a4e370416cc6c68b81a704e917`
- Script SHA-256: `a9a157d4a1644d40086ee46b18cc7b32ea0d8eced58beee716aaea07aa6f61a5`
- Runner SHA-256: `f45d9b2e187b4074d7bd10bc8e2dce1ff7430d4f92ede54aab25bdd4172859cf`
