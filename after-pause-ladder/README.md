# The after-pause protocol, the depth ladder, on three Intel machines

ladder.sh: protocol.sh with the idle-state blocks a ladder by depth (shipped; then only states 0..k kept, for each k) and the core C3 and C7 hardware residencies read too. Hash-pinned runs, VERIFIED, on a Xeon E3-1240L v5 (Skylake, 4C/8T, states to C8), a Xeon E3-1241 v3 (Haswell, 4C/8T, states to C7s) and the 2x Xeon Gold 6330. summary.txt (summary.py) is the compact table; analysis.txt (analyze2.py) the full one; detectable.png (chart2.py).
