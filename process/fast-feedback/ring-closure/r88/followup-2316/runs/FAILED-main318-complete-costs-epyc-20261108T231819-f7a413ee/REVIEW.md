# main318-complete-costs-epyc-20261108T231819-f7a413ee

Host: `root@88.216.222.150`; study: `main318-security-20261108`.

Runner result:
```
FAILED
job: exit 101
expect: no file out/status.txt
expect: no file out/judgments-cycle.tsv
expect: no file out/judgments-finish.tsv
expect: no file out/judgments-update.tsv
```

## Workflow latency

| Phase | Nanoseconds |
|---|---:|
| dispatch | 45367566 |
| lock_wait | 112650 |
| preparation | 1705367881 |
| job | 7177933325 |
| verification | 714453 |
| total | 8929557825 |

## Instrument judgments

This run has no judgments TSV. Its checks and logs are in [out/](out/).

## Sources

[Manifest](manifest.json) · [Phases](phases.jsonl)
- `old`: https://github.com/servil-software-factory/BLAKE3 at `6e0dffd37e04b01b80dc56eb833b00fc337b6873`
- `new`: https://github.com/servil-software-factory/BLAKE3 at `71154c1dc4661e7bfa30e89d8b434a9394f2feaa`
- `bench`: https://github.com/servil-software-factory/bench-hashes at `9994de190259648ede82f7c5e4dbac4f1534a41d`
- Script SHA-256: `f484d04c38974e6f4b2d6b61448499ee99a15a5f15a7ab893151d1c8fd77214c`
- Runner SHA-256: `f45d9b2e187b4074d7bd10bc8e2dce1ff7430d4f92ede54aab25bdd4172859cf`
