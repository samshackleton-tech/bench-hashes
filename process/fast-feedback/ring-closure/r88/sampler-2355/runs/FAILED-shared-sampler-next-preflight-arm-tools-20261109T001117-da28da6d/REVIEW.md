# shared-sampler-next-preflight-arm-tools-20261109T001117-da28da6d

Host: `root@88.216.62.206`; study: `shared-sampler-20261109`.

Runner result:
```
FAILED
job: exit 1
expect: out/identity.txt lacks 'old a930b4c1a7ac94a77b6decd4a5bfd710391286b6'
expect: out/identity.txt lacks 'new 6eefdc657effe6002f9a001fccac9306699b3911'
expect: out/identity.txt lacks 'bench 9994de190259648ede82f7c5e4dbac4f1534a41d'
expect: out/identity.txt lacks 'api_family next'
expect: no file out/preflight-new.err
expect: no file out/validation.txt
expect: no file out/digest-fault-forward.err
expect: no file out/digest-fault-reverse.err
```

## Workflow latency

| Phase | Nanoseconds |
|---|---:|
| dispatch | 88007029 |
| lock_wait | 16649183617 |
| preparation | 6227582731 |
| job | 11433088032 |
| verification | 1271165 |
| total | 34399335075 |

## Instrument judgments

This run has no judgments TSV. Its checks and logs are in [out/](out/).

## Sources

[Manifest](manifest.json) · [Phases](phases.jsonl)
- `old`: https://github.com/servil-software-factory/BLAKE3 at `a930b4c1a7ac94a77b6decd4a5bfd710391286b6`
- `new`: https://github.com/servil-software-factory/BLAKE3 at `6eefdc657effe6002f9a001fccac9306699b3911`
- `bench`: https://github.com/servil-software-factory/bench-hashes at `9994de190259648ede82f7c5e4dbac4f1534a41d`
- `evidence`: https://github.com/samshackleton-tech/bench-hashes at `c2308172c419a131a148a1fe49ea3afa2e611a6f`
- Script SHA-256: `6cabeae14e28be2c4a5af17739fa7ec1d9dc056e72da1ce3a9f181e35e99209d`
- Runner SHA-256: `f45d9b2e187b4074d7bd10bc8e2dce1ff7430d4f92ede54aab25bdd4172859cf`
