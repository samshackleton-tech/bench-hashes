# reviewed-independent-quality-epyc-20261109T055005-51b8611d

Host: `root@88.216.222.150`; study: `reviewed-independent-20261109`.

Runner result:
```
VERIFIED
```

## Workflow latency

| Phase | Nanoseconds |
|---|---:|
| dispatch | 37832148 |
| lock_wait | 110250 |
| preparation | 1310619293 |
| job | 96986116230 |
| verification | 6267874 |
| total | 98341025195 |

## Instrument judgments

This run has no judgments TSV. Its checks and logs are in [out/](out/).

## Sources

[Manifest](manifest.json) · [Phases](phases.jsonl)
- `library`: https://github.com/samshackleton-tech/BLAKE3 at `62b75883dd752bad5b74195138e157349b830344`
- `base`: https://github.com/servil-software-factory/BLAKE3 at `0b5bf7b71cb5f850067fa4182d9a3c724d7e5710`
- `mutator`: https://github.com/sourcefrog/cargo-mutants at `8ab1dc786a1f61a4e370416cc6c68b81a704e917`
- Script SHA-256: `938f786b12e6799eed6b5b63626d3c72fb38ef8fb3e9d075572d46d7d5ba5070`
- Runner SHA-256: `f45d9b2e187b4074d7bd10bc8e2dce1ff7430d4f92ede54aab25bdd4172859cf`
