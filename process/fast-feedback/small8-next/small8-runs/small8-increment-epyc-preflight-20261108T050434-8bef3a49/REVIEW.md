# small8-increment-epyc-preflight-20261108T050434-8bef3a49

Host: `root@88.216.222.150`; study: `small8-increment-epyc-20261108`.

Runner result:
```
VERIFIED
```

## Workflow latency

| Phase | Nanoseconds |
|---|---:|
| dispatch | 40470485 |
| lock_wait | 116561 |
| preparation | 1733001256 |
| job | 4778602005 |
| verification | 938863 |
| total | 6553194710 |

## Instrument judgments

This run has no judgments TSV. Its checks and logs are in [out/](out/).

## Sources

[Manifest](manifest.json) · [Phases](phases.jsonl)
- `old`: https://github.com/samshackleton-tech/BLAKE3 at `925e28d9de5bb11ea7d55eec7706adf761c5226e`
- `new`: https://github.com/samshackleton-tech/BLAKE3 at `6e74ed36d683a634f193cb101cf26eaca72e0e3c`
- `bench`: https://github.com/servil-software-factory/bench-hashes at `9994de190259648ede82f7c5e4dbac4f1534a41d`
- Script SHA-256: `2c6cd5f30a5303193ae984960777a321586d0579f441c55e1e0d1c04fd33a27a`
- Runner SHA-256: `f45d9b2e187b4074d7bd10bc8e2dce1ff7430d4f92ede54aab25bdd4172859cf`
