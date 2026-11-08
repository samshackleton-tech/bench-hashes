# output16-current-startup-ice-20261108T014414-5fa8dcb4

Host: `root@185.8.106.126`; study: `output16-startup-20261108`.

Runner result:
```
VERIFIED
```

## Workflow latency

| Phase | Nanoseconds |
|---|---:|
| dispatch | 83120398 |
| lock_wait | 269634 |
| preparation | 3292118685 |
| job | 13948542907 |
| verification | 7036692 |
| total | 17331240654 |

## Instrument judgments

[out/judgments.tsv](out/judgments.tsv): 1 Faster, 2 Level, 5 Slower

```json
{"metric": "cycles", "new_per_message": "1296.2812", "old_per_message": "1256.0000", "pairs": "4", "ratio_permille": "1032", "shape": "already_initialized", "verdict": "Slower"}
```

```json
{"metric": "wall_ns", "new_per_message": "79286.6250", "old_per_message": "75033.9062", "pairs": "4", "ratio_permille": "1057", "shape": "first", "verdict": "Slower"}
```

```json
{"metric": "cpu_ns", "new_per_message": "80187.1562", "old_per_message": "75930.5938", "pairs": "4", "ratio_permille": "1056", "shape": "first", "verdict": "Slower"}
```

```json
{"metric": "cycles", "new_per_message": "117520.7812", "old_per_message": "109581.4062", "pairs": "4", "ratio_permille": "1073", "shape": "first", "verdict": "Slower"}
```

```json
{"metric": "instructions", "new_per_message": "95002.9375", "old_per_message": "82216.1562", "pairs": "4", "ratio_permille": "1156", "shape": "first", "verdict": "Slower"}
```

## Sources

[Manifest](manifest.json) · [Phases](phases.jsonl)
- `old`: https://github.com/servil-software-factory/BLAKE3 at `597581e963b3b6a2eb3df96234339a99aec274cd`
- `new`: https://github.com/samshackleton-tech/BLAKE3 at `1d74d68667dce503e89c2399acdb20f630810871`
- `bench`: https://github.com/servil-software-factory/bench-hashes at `9994de190259648ede82f7c5e4dbac4f1534a41d`
- Script SHA-256: `3ff99bcf175ba6faa4d8f0714474f3445619e0df0319d2c286807d6d58d9c13a`
- Runner SHA-256: `f45d9b2e187b4074d7bd10bc8e2dce1ff7430d4f92ede54aab25bdd4172859cf`
