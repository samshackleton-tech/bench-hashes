# independent-quality-ice-20261108T225144-c2d73e47

Host: `root@185.8.106.126`; study: `independent-20261108`.

Runner result:
```
FAILED
job: exit 101
expect: no file out/status.txt
expect: no file out/control-red.log
expect: no file out/mutation.log
```

## Workflow latency

| Phase | Nanoseconds |
|---|---:|
| dispatch | 93217033 |
| lock_wait | 228273 |
| preparation | 1976961835 |
| job | 14458457354 |
| verification | 1069729 |
| total | 16530129150 |

## Instrument judgments

This run has no judgments TSV. Its checks and logs are in [out/](out/).

## Sources

[Manifest](manifest.json) · [Phases](phases.jsonl)
- `fork`: https://github.com/samshackleton-tech/BLAKE3 at `a6aa7b4ed605168a191e8da2cea4619f92c28c50`
- `base`: https://github.com/samshackleton-tech/BLAKE3 at `b817ac85c985582ed600208e02a380ece730c4a2`
- `mutator`: https://github.com/sourcefrog/cargo-mutants at `8ab1dc786a1f61a4e370416cc6c68b81a704e917`
- Script SHA-256: `3f33b864e446527a3634d9201c23f89502ffb88e25d536c499999621179c215e`
- Runner SHA-256: `f45d9b2e187b4074d7bd10bc8e2dce1ff7430d4f92ede54aab25bdd4172859cf`
