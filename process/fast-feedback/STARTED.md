# Fast-feedback pilot: first implementation

Historical snapshot of the first slice. [Current delivery](README.md) links the maintained runner; the initial code remains in the source commit below.

Tracking: [program #146](https://github.com/servil-software-factory/bench-hashes/issues/146), [pilot #147](https://github.com/servil-software-factory/bench-hashes/issues/147).

## Delivered

The existing pinned-run now records workflow phases automatically and includes
them in fetched artifacts. Its lock still covers preparation, execution and
verification. Terminal records survive a repeated executor invocation.

Source: **`4d0306cc0858a0cf98ac6c6dac1be2581be4fa41`**.
[Implementation delta](https://github.com/samshackleton-tech/bench-hashes/compare/54b829d...4d0306cc0858a0cf98ac6c6dac1be2581be4fa41).

From a checkout of that source, one command runs the suite and all four planted-fault controls:

```sh
python3 tools/pinned-run/check.py --output /tmp/pinned-run-check
```

Both pinned checks passed **21 tests** and rejected all four faults:

| Host | Pinned run |
|---|---|
| ARM VM | `pinned-phase-check-arm-20261107T173419-6676eb5c` |
| Zen 3 | `pinned-phase-check-zen3-20261107T173419-6eea0898` |

The faults omit the lock event, report it before locking, rewrite a terminal
record, and release the lock before verification. Each fails its named test.
The logs and manifests are in `phase-runs/`.

The verified tool was installed locally and deployed through pinned-run's
existing content-checked installation path to the ARM host. A live outer run,
`pinned-phase-live-arm-20261107T174234-f9b47736`, passed the same suite and controls.
Its fetched `phases.jsonl` has all seven events in monotonic order on one boot,
ending in VERIFIED. Its manifest identifies the deployed runner by SHA-256
`1194a6ee1fd6efdea7527d89b283c13ad272df67c437ed2f7ccc8b3e0a8da8ce`.

## Fast-lane hardware ordered

Cherry server **1057251**, hostname **fast-feedback-icelake-147**, is provisioning
in Chicago. It matches the existing dual Xeon Gold 6330 CPU class: 56 cores,
112 threads, 256 GB RAM. The intended role is reserved interactive native checks
and short quiet timing checks, separate from long matrices on the existing host.

The account rate is **USD 0.74/hour**, or **USD 124.32 per seven-day week**.
The catalog quote was EUR 0.632/hour. A 9700X replica was out of stock; Ice Lake
was available and had the largest queue/preparation tail among the sampled x86
hosts. Existing servers remain available, including protected EPYC 1040431.

## Next

- Bootstrap the new host with the existing setup and lockdown tools.
- Run representative native and short timing checks there.
- Use the recorded phases to separate waiting, preparation and actual work.
- Add exact-instrument preflight and study-scoped collection where they save
  manual work; use the existing scoped benchmark facilities.
- Publish the pilot's complete-check coverage, latency and cost comparison.

Sam The User's design criterion is in #146: automate reliable repetitive steps
when their saved effort exceeds their complexity and maintenance cost. Keep
judgment explicit where a script would be an incomplete substitute.

— Sam Shackleton
