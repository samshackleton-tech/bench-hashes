# small8-width-focused-epyc-20261108T054120-25d58d25

Host: `root@88.216.222.150`; study: `small8-width-focused-20261108`.

Runner result:
```
FAILED
job: exit 1
expect: no file out/identity.txt
expect: no file out/status.txt
expect: job.log lacks 'missing-eight-selection rejected'
expect: job.log lacks 'missing-eight-startup rejected'
```

## Workflow latency

| Phase | Nanoseconds |
|---|---:|
| dispatch | 42933370 |
| lock_wait | 126400 |
| preparation | 548833505 |
| job | 1044154 |
| verification | 415051 |
| total | 593411120 |

## Instrument judgments

This run has no judgments TSV. Its checks and logs are in [out/](out/).

## Sources

[Manifest](manifest.json) · [Phases](phases.jsonl)
- `fork`: https://github.com/samshackleton-tech/BLAKE3 at `ec08884ff386cb7927f03d08af8133ab84473dfb`
- Script SHA-256: `a4af377dbfbf9b5a333cf6c38f861faa569bd6a2354ccb2261f34f0d4959a13d`
- Runner SHA-256: `f45d9b2e187b4074d7bd10bc8e2dce1ff7430d4f92ede54aab25bdd4172859cf`
