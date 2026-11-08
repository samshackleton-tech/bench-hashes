# small8-width-focused-epyc-20261108T054202-bac0cb47

Host: `root@88.216.222.150`; study: `small8-width-focused-20261108`.

Runner result:
```
FAILED
job: exit 1
expect: no file out/status.txt
expect: job.log lacks 'missing-eight-selection rejected'
expect: job.log lacks 'missing-eight-startup rejected'
```

## Workflow latency

| Phase | Nanoseconds |
|---|---:|
| dispatch | 39061277 |
| lock_wait | 140030 |
| preparation | 327476159 |
| job | 11702201914 |
| verification | 599842 |
| total | 12069550082 |

## Instrument judgments

This run has no judgments TSV. Its checks and logs are in [out/](out/).

## Sources

[Manifest](manifest.json) · [Phases](phases.jsonl)
- `fork`: https://github.com/samshackleton-tech/BLAKE3 at `ec08884ff386cb7927f03d08af8133ab84473dfb`
- Script SHA-256: `31dbf5aaba09d09f5b9cf322d060620edc9f4e32abf0b093c20081308f293d46`
- Runner SHA-256: `f45d9b2e187b4074d7bd10bc8e2dce1ff7430d4f92ede54aab25bdd4172859cf`
