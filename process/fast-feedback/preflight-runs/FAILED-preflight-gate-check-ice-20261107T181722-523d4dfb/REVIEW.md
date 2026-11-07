# preflight-gate-check-ice-20261107T181722-523d4dfb

Host: `root@185.8.106.126`; study: ``.

Runner result:
```
FAILED
job: exit 1
expect: out/check.log lacks 'control rejected: mismatched-preflight-inputs'
expect: out/check.log lacks 'pinned-run phase checks passed'
expect: no file out/status.txt
```

## Workflow latency

| Phase | Nanoseconds |
|---|---:|
| dispatch | 76348871 |
| lock_wait | 262218 |
| preparation | 12680943658 |
| job | 2275595478 |
| verification | 1300236 |
| total | 15034602564 |

## Instrument judgments

This run has no judgments TSV. Its checks and logs are in [out/](out/).

## Sources

[Manifest](manifest.json) · [Phases](phases.jsonl)
- `tools`: https://github.com/samshackleton-tech/bench-hashes at `348de1c5c0e4e967b7b04bc06bc06445257b3b10`
- Script SHA-256: `fdc789b0a1d01f87515e3811d71bea84043ee4322c4b0f16bf2e50bce7ac2d35`
- Runner SHA-256: `1194a6ee1fd6efdea7527d89b283c13ad272df67c437ed2f7ccc8b3e0a8da8ce`
