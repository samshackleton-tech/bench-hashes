# pipeline-doc-queue-baseline-repeat-20261108T033938-9167efdd

Host: `root@185.8.106.126`; study: `pipeline-doc-queue-20261108`.

Runner result:
```
FAILED
expect: job.log lacks 'baseline queue invariant reproduced'
```

## Workflow latency

| Phase | Nanoseconds |
|---|---:|
| dispatch | 81421012 |
| lock_wait | 236966 |
| preparation | 1348314110 |
| job | 24958999066 |
| verification | 1838342 |
| total | 26390967079 |

## Instrument judgments

This run has no judgments TSV. Its checks and logs are in [out/](out/).

## Sources

[Manifest](manifest.json) · [Phases](phases.jsonl)
- `old`: https://github.com/samshackleton-tech/BLAKE3 at `d4f675f4967317b41546e8c8309d35eb384cbbaf`
- `new`: https://github.com/samshackleton-tech/BLAKE3 at `85c4b2d92b71c87a42261509fa6258f02903a0bc`
- Script SHA-256: `8c0bfae1a53644f75adce3ec745ad76cb2ce84fbac98c1a88bc4715d94e700e9`
- Runner SHA-256: `f45d9b2e187b4074d7bd10bc8e2dce1ff7430d4f92ede54aab25bdd4172859cf`
