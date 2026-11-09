# shared-sampler-main-preflight-arm-tools-20261109T001114-55c95435

Host: `root@88.216.62.206`; study: `shared-sampler-20261109`.

Runner result:
```
FAILED
job: exit 1
expect: out/identity.txt lacks 'old 6e0dffd37e04b01b80dc56eb833b00fc337b6873'
expect: out/identity.txt lacks 'new 7b1ba7b9da67e61dd53010de2054edfa32035170'
expect: out/identity.txt lacks 'bench 9994de190259648ede82f7c5e4dbac4f1534a41d'
expect: out/identity.txt lacks 'api_family main'
expect: no file out/preflight-new.err
expect: no file out/validation.txt
expect: no file out/digest-fault-forward.err
expect: no file out/digest-fault-reverse.err
```

## Workflow latency

| Phase | Nanoseconds |
|---|---:|
| dispatch | 70776312 |
| lock_wait | 333842 |
| preparation | 6134920122 |
| job | 13135401346 |
| verification | 1255565 |
| total | 19342956088 |

## Instrument judgments

This run has no judgments TSV. Its checks and logs are in [out/](out/).

## Sources

[Manifest](manifest.json) · [Phases](phases.jsonl)
- `old`: https://github.com/servil-software-factory/BLAKE3 at `6e0dffd37e04b01b80dc56eb833b00fc337b6873`
- `new`: https://github.com/servil-software-factory/BLAKE3 at `7b1ba7b9da67e61dd53010de2054edfa32035170`
- `bench`: https://github.com/servil-software-factory/bench-hashes at `9994de190259648ede82f7c5e4dbac4f1534a41d`
- `evidence`: https://github.com/samshackleton-tech/bench-hashes at `c2308172c419a131a148a1fe49ea3afa2e611a6f`
- Script SHA-256: `6cabeae14e28be2c4a5af17739fa7ec1d9dc056e72da1ce3a9f181e35e99209d`
- Runner SHA-256: `f45d9b2e187b4074d7bd10bc8e2dce1ff7430d4f92ede54aab25bdd4172859cf`
