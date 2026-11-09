# Exact released-bundle x86 gate — user approved

On November 9 the user explicitly approved the intact longer canonical gate, including its standard confirmation when suspects require it. Goal: compare the actual released-line repair composition, not infer its result from separately tested ingredients.

## Frozen sources

- Candidate: **7b1ba7b9da67e61dd53010de2054edfa32035170**, organization integrate/released-ring (GET verified before launch).
- Baseline: published main **6e0dffd37e04b01b80dc56eb833b00fc337b6873** (GET verified).
- Canonical benchmark: **5c1a092f71126b95f035e104c25d38b0cacae63b**, the last benchmark before the pipeline contender. Released main has no pipeline; using the later pipeline caller would test an unsupported API.
- Shared keyed sampler: SHA-256 **3a0595df2a83d2c2c42b5decf50ebad56449f26d82721ac3c32ba89cdd3782cb**, BLAKE3 **835914929e9d8408c9db7bd316dfd0c8f0d65b44c73a2206579cddf8c6ee119b**. Immutable distribution at personal bench-hashes **c2308172c419a131a148a1fe49ea3afa2e611a6f**, process/fast-feedback/ring-closure/r88/sampler-2355/mixed-stage-costs.sh. Both x86 API-family preflights, wrong-digest and integer-display/frozen-decision controls already passed on this exact sampler. API_FAMILY=main retains explicit reset inside cycle/finish work.
- Sampler clocks/benchmark: **9994de190259648ede82f7c5e4dbac4f1534a41d**. Canonical and sampler evidence stay separate; ratios are not composed.

## Runs

Ice root@185.8.106.126 and protected EPYC root@88.216.222.150, each under /root/bench-native-afk.lock from preparation through verification. No unrelated compute on either physical timing host. Each host queues its keyed job behind its canonical job; quiet hosts can progress independently.

Canonical scope: 25 named plain-mode points: continuous 64/128/256/512 B, 1/4/16/64/256 KiB and 1 MiB; continuous batches 16/64/1024; interleaved256; turn256 with other-work/idle/brief-idle schedules; continuous git-object/Nix collections; saturated/2us/20us receiving; Merkle65536; ordinary64B/1KiB. Both library contenders and canonical shared scenarios remain intact. No controlled-idle point is requested (EPYC lacks the required driver). The remaining benchmark points stay unmeasured.

Use unchanged bench-hashes check: default four fresh paired layouts and full 64-pair suspect confirmation. No --probe, reduced pairs, manual sample rejection, worker cap, branch substitution or shorter confirmation. Preserve same-code/pending/regression verdicts literally. Guard check execution at three hours, long enough for the expected intact study; a timeout is a failed run, never a passing gate.

Keyed scope: unchanged 64-shape complete cycle/update/consume-once finish matrix, four fresh adjacent alternating build/layout pairs, plain/shared/distinct/mixed modes and sparse subsets. Main contract selected at compile time. Constructors/keys/caller capacity outside counters; refill/library allocations/update/digest/reset inside complete work; finish once per prepared state; finish energy NA; package energy includes background. Existing load wait and busy-window abstention are retained. This is a scoped cost matrix, not a second canonical gate.

## Outcomes and boundaries

VERIFIED means source/instrument/output identities match, not no slowdown or acceptance. Record every Slower cell beside benefits. John decides exact-source cost acceptance and release; previous71154c1d/b4989d6c/next results do not accept or clear this composition. No merge, release, advisory, hardware rental/deletion, new ring design, worker tuning or library changes. Owner Mac/GPU/release/mutation-budget gates remain separate.

Keep failed attempts and exact executing drivers, publish raw outputs without binaries/private files/large artifacts, paired SHA-256/BLAKE3 manifests, verify remote modes/blob hashes/sizes and selected exact bytes, zero automatic workflows. A setup failure gets one script repair/retry; a second setup failure stops the affected item. Do not rerun a workload merely to seek green.
