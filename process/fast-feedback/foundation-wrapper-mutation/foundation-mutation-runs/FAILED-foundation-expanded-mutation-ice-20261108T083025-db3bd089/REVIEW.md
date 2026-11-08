# foundation-expanded-mutation-ice-20261108T083025-db3bd089

Host: `root@185.8.106.126`; study: `foundation-expanded-mutation-20261108`.

Runner result:
```
FAILED
job: exit 127
expect: no file out/wrapper-plan.txt
expect: no file out/mutation.log
expect: no file out/status.txt
```

## Workflow latency

| Phase | Nanoseconds |
|---|---:|
| dispatch | 82198934 |
| lock_wait | 252808 |
| preparation | 2412058277 |
| job | 20330803142 |
| verification | 1058151 |
| total | 22826531606 |

## Instrument judgments

This run has no judgments TSV. Its checks and logs are in [out/](out/).

## Sources

[Manifest](manifest.json) · [Phases](phases.jsonl)
- `fork`: https://github.com/servil-software-factory/BLAKE3 at `f16ee3829554fd66ef47c5b60e516c6be9d86a44`
- `base`: https://github.com/servil-software-factory/BLAKE3 at `7ee5c1f8cfad7937fb490e6510f8f36fe5ce912f`
- `mutator`: https://github.com/sourcefrog/cargo-mutants at `8ab1dc786a1f61a4e370416cc6c68b81a704e917`
- Script SHA-256: `89ea1fcc99b16eeb60ba159782f3ff7ee532291c1397d6a1e3a7c8847e8030c1`
- Runner SHA-256: `f45d9b2e187b4074d7bd10bc8e2dce1ff7430d4f92ede54aab25bdd4172859cf`
