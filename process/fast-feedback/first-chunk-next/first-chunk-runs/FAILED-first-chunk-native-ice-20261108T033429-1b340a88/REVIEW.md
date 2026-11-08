# first-chunk-native-ice-20261108T033429-1b340a88

Host: `root@185.8.106.126`; study: `first-chunk-native-20261108`.

Runner result:
```
FAILED
job: exit 101
expect: no file out/status.txt
```

## Workflow latency

| Phase | Nanoseconds |
|---|---:|
| dispatch | 81572620 |
| lock_wait | 292632 |
| preparation | 1258275010 |
| job | 23102303538 |
| verification | 1270773 |
| total | 24443864490 |

## Instrument judgments

This run has no judgments TSV. Its checks and logs are in [out/](out/).

## Sources

[Manifest](manifest.json) · [Phases](phases.jsonl)
- `fork`: https://github.com/samshackleton-tech/BLAKE3 at `85c4b2d92b71c87a42261509fa6258f02903a0bc`
- `frozen`: https://github.com/samshackleton-tech/BLAKE3 at `7c4166fa922165c7db8250908f6442cb3b9a28a2`
- Script SHA-256: `d195ad90d82670e35412d8fa7e383a7269f8e668f8f4482639e8ab7204421d0a`
- Runner SHA-256: `f45d9b2e187b4074d7bd10bc8e2dce1ff7430d4f92ede54aab25bdd4172859cf`
