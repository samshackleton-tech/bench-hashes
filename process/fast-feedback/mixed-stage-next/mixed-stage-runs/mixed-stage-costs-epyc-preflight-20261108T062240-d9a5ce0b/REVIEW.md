# mixed-stage-costs-epyc-preflight-20261108T062240-d9a5ce0b

Host: `root@88.216.222.150`; study: `mixed-stage-costs-epyc-20261108`.

Runner result:
```
VERIFIED
```

## Workflow latency

| Phase | Nanoseconds |
|---|---:|
| dispatch | 43683213 |
| lock_wait | 128830 |
| preparation | 1523183746 |
| job | 4951469942 |
| verification | 667332 |
| total | 6519200213 |

## Instrument judgments

This run has no judgments TSV. Its checks and logs are in [out/](out/).

## Sources

[Manifest](manifest.json) · [Phases](phases.jsonl)
- `old`: https://github.com/samshackleton-tech/BLAKE3 at `60a42e1e644aed262123ff5b285ac6812ea7e8a6`
- `new`: https://github.com/samshackleton-tech/BLAKE3 at `a6fedec518aa7a32ba658c79ca7b41234c6e5d56`
- `bench`: https://github.com/servil-software-factory/bench-hashes at `9994de190259648ede82f7c5e4dbac4f1534a41d`
- Script SHA-256: `f484d04c38974e6f4b2d6b61448499ee99a15a5f15a7ab893151d1c8fd77214c`
- Runner SHA-256: `f45d9b2e187b4074d7bd10bc8e2dce1ff7430d4f92ede54aab25bdd4172859cf`
