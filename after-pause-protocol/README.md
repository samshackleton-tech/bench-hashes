# The after-pause protocol experiment

protocol.sh (hash-pinned runs, VERIFIED): pause before the call (20 us, 200 us, 1 ms, 5 ms, shuffled) x idle settings (as shipped; C6 off; C1E and C6 off) x four cells (servil st 16 x 64 B and 1 KiB, official 1 KiB, servil mt 1 MiB), with cpuidle usage and the cstate_core hardware residencies read after each call. analysis.txt is analyze.py over both runs; after-pause.png is chart.py.
