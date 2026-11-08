# parent-buffer-allocations-epyc-20261108T095640-8bd95dfd

Host: `root@88.216.222.150`; study: `parent-buffer-allocations-20261108`.

Runner result:
```
FAILED
job: exit 1
expect: out/allocation-bytes.tsv lacks '512\t1\t'
expect: no file out/status.txt
```

## Workflow latency

| Phase | Nanoseconds |
|---|---:|
| dispatch | 41778065 |
| lock_wait | 117371 |
| preparation | 655329952 |
| job | 11679649930 |
| verification | 551782 |
| total | 12377492840 |

## Instrument judgments

This run has no judgments TSV. Its checks and logs are in [out/](out/).

## Sources

[Manifest](manifest.json) · [Phases](phases.jsonl)
- `old`: https://github.com/samshackleton-tech/BLAKE3 at `4f1dd19c83122dfee2c62c1304eb593b812ee992`
- `new`: https://github.com/samshackleton-tech/BLAKE3 at `b817ac85c985582ed600208e02a380ece730c4a2`
- Script SHA-256: `654c13dd6edce22dc92accb531ee41ad7abcda22c1d25910cccb4136ae34be4b`
- Runner SHA-256: `f45d9b2e187b4074d7bd10bc8e2dce1ff7430d4f92ede54aab25bdd4172859cf`
