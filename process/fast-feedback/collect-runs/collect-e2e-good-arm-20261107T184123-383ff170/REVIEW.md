# collect-e2e-good-arm-20261107T184123-383ff170

Host: `root@88.216.62.206`; study: `end-to-end-147`.

Runner result:
```
VERIFIED
```

## Workflow latency

| Phase | Nanoseconds |
|---|---:|
| dispatch | 71778095 |
| lock_wait | 346122 |
| preparation | 13302434531 |
| job | 5244036476 |
| verification | 1064144 |
| total | 18619889189 |

## Instrument judgments

This run has no judgments TSV. Its checks and logs are in [out/](out/).

## Sources

[Manifest](manifest.json) · [Phases](phases.jsonl)
- `library`: https://github.com/servil-software-factory/BLAKE3 at `6e0dffd37e04b01b80dc56eb833b00fc337b6873`
- `tools`: https://github.com/samshackleton-tech/bench-hashes at `b66cd509f00a89a2c1458f2a6f63a54ecba84f2d`
- Script SHA-256: `82d3ea3ec8375e28852d38d9d72a041d170b7d08b3d5353bb5eb4127cbe789b1`
- Runner SHA-256: `f583b6a510ab155d34176fe6dc43d5761c35ba6d46017ebcbba6244aa74a62fd`
