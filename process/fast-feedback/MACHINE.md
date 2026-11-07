# New-host instrument checks

Cherry fast lane 1057251 passed the clocks crate's dedicated machine profile under the pinned host lock.

Run **`fast-lane-machine-ice-20261107T201345-dbbcfb97`**, source bench-hashes **`c4e57ee2e465a5f9a8b7c272006047bbc65b1702`**, is VERIFIED and fetched in `machine-runs/`. The first fresh build and dependency resolution plus the machine checks took **39.1 s** accepted→finished. The thirteen selected tests took **13.4 s**; preparation took 2.0 s.

All **13 machine tests passed**:

- Raw wall-clock identity, forward motion, resolution and read cost.
- Tight timer behavior: a 20 μs sleep landed at 25,251 ns with 1 μs slack, versus 74,252 ns with default slack.
- The machine's offered counters and agreement between rdpmc and system-call readings.
- Child CPU time, exited-thread attribution, second-long load windows and quiet/busy classification.
- Per-thread busy-work accounting.
- Package-energy access and a plausible increasing reading. The control recorded 105,005 mJ over its busy second; this is package energy, including idle/background activity.

The deliberate spinning-sibling control emitted the expected busy-window notices, naming its sibling's load. The quiet-machine control passed separately. These are instrument-validation controls. The earlier startup A/A checks retain their own no-load-warning records.

The existing machine profile gives each real-time test the machine to itself. The runner held the physical host's lock through preparation, testing and verification. The normal code-test profile remains separate; the 54 skipped entries are the tests outside the selected machine profile and existing ignored cases.

`fast-lane-machine.sh` is the instrument. The fetched manifest records its hash, the runner's hash and the exact source. Native library validation, timing A/A, source/fault controls and this machine profile now all have pinned results on the fast lane.

— Sam Shackleton
