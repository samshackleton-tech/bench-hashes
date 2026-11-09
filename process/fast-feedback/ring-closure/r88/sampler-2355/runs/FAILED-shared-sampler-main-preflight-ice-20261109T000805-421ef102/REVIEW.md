# shared-sampler-main-preflight-ice-20261109T000805-421ef102

Host: `root@185.8.106.126`; study: `shared-sampler-20261109`.

Runner result:
```
FAILED
job: exit 127
expect: no file out/identity.txt
expect: no file out/preflight-new.err
expect: no file out/validation.txt
expect: no file out/digest-fault-forward.err
expect: no file out/digest-fault-reverse.err
```

## Workflow latency

| Phase | Nanoseconds |
|---|---:|
| dispatch | 82100500 |
| lock_wait | 256891 |
| preparation | 9458249195 |
| job | 13030673 |
| verification | 908444 |
| total | 9554685487 |

## Instrument judgments

This run has no judgments TSV. Its checks and logs are in [out/](out/).

## Sources

[Manifest](manifest.json) · [Phases](phases.jsonl)
- `old`: https://github.com/servil-software-factory/BLAKE3 at `6e0dffd37e04b01b80dc56eb833b00fc337b6873`
- `new`: https://github.com/servil-software-factory/BLAKE3 at `7b1ba7b9da67e61dd53010de2054edfa32035170`
- `bench`: https://github.com/servil-software-factory/bench-hashes at `9994de190259648ede82f7c5e4dbac4f1534a41d`
- `evidence`: https://github.com/samshackleton-tech/bench-hashes at `c2308172c419a131a148a1fe49ea3afa2e611a6f`
- Script SHA-256: `42a62fa740e7e0ffad477eeecc4f2bc17fa82bdb577f188d33640bcea6b2d3a7`
- Runner SHA-256: `f45d9b2e187b4074d7bd10bc8e2dce1ff7430d4f92ede54aab25bdd4172859cf`
