# bench-hashes #127: clock_survey on the EPYC 9255, the 2x Xeon Gold 6330 and the AmpereOne VM

At devonjonte/bench-hashes candidate/devon-raw-clock b3cd9b23 (219f62a9 changes nothing under clocks/). Runs `*T0618*` by `survey.sh` (pinned to CPU 2, then unpinned); runs `*T0622*` a second session's replication by `replication/survey.sh` (pinned to CPU 0). All VERIFIED. Each run's `out/machine.txt` holds the kernel, clock source, perf_event_paranoid, rdpmc and the time daemon.
