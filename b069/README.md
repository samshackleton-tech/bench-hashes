# bench-hashes #69: odd and even cores in a plain loop, SMT on and off, on the EPYC 9255

oddeven.sh, hash-pinned, VERIFIED. times.txt: phase round cpu kind n ns-a-call calls; perf-*.csv: perf stat (user mode) of one 2 s run, with its .ns (ns a call and calls).

## The bench's context, piece by piece (John's next step)

- `context.sh` (run b069-context): cold (every call after clocks' busy gap, through
  `measure_after_gaps_prepared` as 0.20 samples solo `ManyMessages`), + the pool parked, + two copy
  threads waiting; CPUs 0-3; 4 processes a context. The gap comes back with the cold calls alone.
  Its counted pass reads zeros: six counters do not fit beside the NMI watchdog and clocks' two.
- `context2.sh` (b069-context2): cold only, CPUs 0-7. Timing valid; counters again empty (four a group).
- `context3.sh` (b069-context3): groups of three, but both enabled at once: multiplexed, discard its counts.
- `context4.sh` (b069-context4): each group enabled only for its own pass: no sample multiplexed.
- `context5.sh` (b069-context5): plus group C, where L2's fills came from (`l2_fill_rsp_src`).
