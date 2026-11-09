# shared-sampler-next-preflight-ice-20261109T000807-b6e2805e

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
| dispatch | 88668957 |
| lock_wait | 7075501346 |
| preparation | 8066104395 |
| job | 13350263 |
| verification | 913487 |
| total | 15244677078 |

## Instrument judgments

This run has no judgments TSV. Its checks and logs are in [out/](out/).

## Sources

[Manifest](manifest.json) · [Phases](phases.jsonl)
- `old`: https://github.com/servil-software-factory/BLAKE3 at `a930b4c1a7ac94a77b6decd4a5bfd710391286b6`
- `new`: https://github.com/servil-software-factory/BLAKE3 at `6eefdc657effe6002f9a001fccac9306699b3911`
- `bench`: https://github.com/servil-software-factory/bench-hashes at `9994de190259648ede82f7c5e4dbac4f1534a41d`
- `evidence`: https://github.com/samshackleton-tech/bench-hashes at `c2308172c419a131a148a1fe49ea3afa2e611a6f`
- Script SHA-256: `42a62fa740e7e0ffad477eeecc4f2bc17fa82bdb577f188d33640bcea6b2d3a7`
- Runner SHA-256: `f45d9b2e187b4074d7bd10bc8e2dce1ff7430d4f92ede54aab25bdd4172859cf`
