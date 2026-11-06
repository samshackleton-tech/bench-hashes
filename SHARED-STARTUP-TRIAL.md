# Separate startup-fixture reuse trial: fewer instructions, no time verdict

**Not promoted into frozen #259. No startup time, CPU or energy win claimed.**

Source `probe/sam-shared-startup`, worktree `~/work/b3-shared-startup`, commit **d3a0baf7787161ee93af4a2d61731e2a7898ecb4**, based on frozen **1fb068fe77dc571ec47241753a0c35663b514c2f**.

Both finishing self-test shapes read the same deterministic 2 KiB bytes. This trial prepares them once outside the two-shape loop and passes the immutable buffer to the fixture helper. The fill is a pure index-derived pattern, not mutable RNG state. It retains **every kernel invocation, key, message length, byte, expected folded answer and corruption/entry control**. No reduction of runtime test coverage, assembly change or clock-based policy.

Fresh-process study: 32 old/new process pairs over four independent layouts, alternating processes; judgment aggregates within those layouts, preserving raw pairs. The interval is `initialize()` itself. Already-initialized controls are separate. Shared clocks judgments at 3% margin / 5% FDR.

| Host / first initialize | Old | New | Verdict |
|---|---:|---:|---|
| 9700X wall | 29.354 µs | 28.730 µs | Level |
| 9700X process CPU | 29.446 µs | 28.983 µs | Level |
| 9700X instructions | 150,615 | 143,361 | Faster (~4.8% lower) |
| Zen 3 wall | 40.883 µs | 38.934 µs | Level |
| Zen 3 process CPU | 42.249 µs | 40.257 µs | Level |
| Zen 3 instructions | 158,175 | 151,372 | Faster (~4.3% lower) |

Cycles are Level on both. All already-initialized metrics are Level, with identical instruction counts. These very short intervals do not support a package-energy claim; it is not inferred from instructions. The Zen 3 absolute initialization times in this new paired study are not substituted into older startup studies or combined by multiplying ratios.

Native checks at the trial commit: **187/187 on both 9700X and Zen 3**, no-default builds, doctests and warnings-denied rustdoc pass. The official-reference startup-answer test and planted-corruption stops remain intact. No new formal-proof claim is needed or made for these unchanged assembly instructions.

The trial removes measured instruction work, but does not establish real time/CPU/energy savings at the stated test margin. It stays a separate experiment rather than silently reducing or replacing the reported #259 startup cost.

Pinned records:
- `shared-startup-native-9700x-20261106T125759-c7ab0cb6`
- `shared-startup-native-zen3-20261106T125800-bd20a9c8`
- `shared-startup-cost-9700x-20261106T125800-499f6bf9`
- `shared-startup-cost-zen3-20261106T125802-b4ccab92`

Raw records: `shared-startup-runs/`; script/manifests: `scripts/shared-startup-*` and `scripts/startup-matrix.sh`.

— Sam Shackleton
