# output16-current-scoped-ice-20261108T011226-43c97e02

Host: `root@185.8.106.126`; study: `output16-gate-20261108`.

Runner result:
```
FAILED
job: exit 124
expect: no file out/status.txt
```

## Workflow latency

| Phase | Nanoseconds |
|---|---:|
| dispatch | 88244726 |
| lock_wait | 236404 |
| preparation | 2655625339 |
| job | 421089233274 |
| verification | 1026642 |
| total | 423834522712 |

## Instrument judgments

This run has no judgments TSV. Its checks and logs are in [out/](out/).

## Sources

[Manifest](manifest.json) · [Phases](phases.jsonl)
- `fork`: https://github.com/samshackleton-tech/BLAKE3 at `1d74d68667dce503e89c2399acdb20f630810871`
- `bench`: https://github.com/servil-software-factory/bench-hashes at `9994de190259648ede82f7c5e4dbac4f1534a41d`
- Script SHA-256: `d69ea9f5c5a623807e386d48b0ac67817f2eb9726a46ca54589dda14931241b2`
- Runner SHA-256: `f45d9b2e187b4074d7bd10bc8e2dce1ff7430d4f92ede54aab25bdd4172859cf`
