# parent8-test-first-ice-20261108T065028-aecee39d

Host: `root@185.8.106.126`; study: `parent8-test-first-20261108`.

Runner result:
```
FAILED
job: exit 1
expect: out/test.log lacks 'eight-wide parent remainder: AVX512 n=2'
expect: no file out/status.txt
```

## Workflow latency

| Phase | Nanoseconds |
|---|---:|
| dispatch | 84243959 |
| lock_wait | 252285 |
| preparation | 685126279 |
| job | 19377762755 |
| verification | 1034140 |
| total | 20148564013 |

## Instrument judgments

This run has no judgments TSV. Its checks and logs are in [out/](out/).

## Sources

[Manifest](manifest.json) · [Phases](phases.jsonl)
- `fork`: https://github.com/samshackleton-tech/BLAKE3 at `a6fedec518aa7a32ba658c79ca7b41234c6e5d56`
- Script SHA-256: `2b61d1e70ffde7d4cb45f5c1e91f56b8e1c8a65386dd1e34b8e423a9f886ff0a`
- Runner SHA-256: `f45d9b2e187b4074d7bd10bc8e2dce1ff7430d4f92ede54aab25bdd4172859cf`
