# blaze-build-compatibility-20261109T150658-ed842204

Host: `root@88.216.222.150`; study: `blaze-builds-20261109`.

Runner result:
```
FAILED
job: exit 1
expect: out/identity.txt lacks 'experiment_driver_exit=0'
expect: no file out/release-pins.json
expect: no file out/cargo-positive.stdout
expect: no file out/status.txt
```

## Workflow latency

| Phase | Nanoseconds |
|---|---:|
| dispatch | 36879999 |
| lock_wait | 122191 |
| preparation | 342636172 |
| job | 190583568 |
| verification | 480022 |
| total | 570766102 |

## Instrument judgments

This run has no judgments TSV. Its checks and logs are in [out/](out/).

## Sources

[Manifest](manifest.json) · [Phases](phases.jsonl)
- `library`: https://github.com/samshackleton-tech/BLAKE3 at `1cbdf5d72d70d8ed511870b18c7f017cce83da15`
- Script SHA-256: `42cb1163686fff790b377788e5ddb57375af7e203197b05144b4b488026c47f7`
- Runner SHA-256: `f45d9b2e187b4074d7bd10bc8e2dce1ff7430d4f92ede54aab25bdd4172859cf`
