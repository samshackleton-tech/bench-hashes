# output16-port-native-ice-preflight-20261108T003237-66728492

Host: `root@185.8.106.126`; study: `output16-next-20261108`.

Runner result:
```
FAILED
job: exit 101
expect: no file out/preflight.txt
```

## Workflow latency

| Phase | Nanoseconds |
|---|---:|
| dispatch | 85579267 |
| lock_wait | 264007 |
| preparation | 1582574799 |
| job | 8619720860 |
| verification | 998167 |
| total | 10289278657 |

## Instrument judgments

This run has no judgments TSV. Its checks and logs are in [out/](out/).

## Sources

[Manifest](manifest.json) · [Phases](phases.jsonl)
- `fork`: https://github.com/samshackleton-tech/BLAKE3 at `298828abea1e322fac093c25fd04485b113987f7`
- `frozen`: https://github.com/samshackleton-tech/BLAKE3 at `f9fcef459d9999af05765a598c9fb72f704029ff`
- Script SHA-256: `d195ad90d82670e35412d8fa7e383a7269f8e668f8f4482639e8ab7204421d0a`
- Runner SHA-256: `f45d9b2e187b4074d7bd10bc8e2dce1ff7430d4f92ede54aab25bdd4172859cf`
