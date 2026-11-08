# foundation-expanded-mutation-ice-20261108T083217-f2cf9605

Host: `root@185.8.106.126`; study: `foundation-expanded-mutation-20261108`.

Runner result:
```
FAILED
job: exit 1
expect: out/mutation.log lacks 'no new survivor'
expect: no file out/status.txt
```

## Workflow latency

| Phase | Nanoseconds |
|---|---:|
| dispatch | 87709080 |
| lock_wait | 247261 |
| preparation | 1633538901 |
| job | 197324706784 |
| verification | 27645883 |
| total | 199074001297 |

## Instrument judgments

This run has no judgments TSV. Its checks and logs are in [out/](out/).

## Sources

[Manifest](manifest.json) · [Phases](phases.jsonl)
- `fork`: https://github.com/servil-software-factory/BLAKE3 at `f16ee3829554fd66ef47c5b60e516c6be9d86a44`
- `base`: https://github.com/servil-software-factory/BLAKE3 at `7ee5c1f8cfad7937fb490e6510f8f36fe5ce912f`
- `mutator`: https://github.com/sourcefrog/cargo-mutants at `8ab1dc786a1f61a4e370416cc6c68b81a704e917`
- Script SHA-256: `faf0044c00c1f44eb8d161010801f0435f7a926870d82579e64fdf4c84c4b543`
- Runner SHA-256: `f45d9b2e187b4074d7bd10bc8e2dce1ff7430d4f92ede54aab25bdd4172859cf`
