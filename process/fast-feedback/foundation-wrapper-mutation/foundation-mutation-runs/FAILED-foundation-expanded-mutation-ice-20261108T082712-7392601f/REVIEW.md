# foundation-expanded-mutation-ice-20261108T082712-7392601f

Host: `root@185.8.106.126`; study: `foundation-expanded-mutation-20261108`.

Runner result:
```
FAILED
job: exit 101
expect: no file out/wrapper-plan.txt
expect: no file out/mutation.log
expect: no file out/status.txt
```

## Workflow latency

| Phase | Nanoseconds |
|---|---:|
| dispatch | 78243627 |
| lock_wait | 243117 |
| preparation | 1595024760 |
| job | 78403169 |
| verification | 918011 |
| total | 1752978297 |

## Instrument judgments

This run has no judgments TSV. Its checks and logs are in [out/](out/).

## Sources

[Manifest](manifest.json) · [Phases](phases.jsonl)
- `fork`: https://github.com/servil-software-factory/BLAKE3 at `f16ee3829554fd66ef47c5b60e516c6be9d86a44`
- `base`: https://github.com/servil-software-factory/BLAKE3 at `7ee5c1f8cfad7937fb490e6510f8f36fe5ce912f`
- Script SHA-256: `a012fbca875a8b458a3f7ef80c43dfd25d707146c575ec4f775c497a8226df17`
- Runner SHA-256: `f45d9b2e187b4074d7bd10bc8e2dce1ff7430d4f92ede54aab25bdd4172859cf`
