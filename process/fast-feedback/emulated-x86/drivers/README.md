# The suites under Intel's emulator, as CPUs the machine is not (November 10, 2026)

For BLAKE3-Servil #346 and #360. On an Ice Lake Xeon, `next` f4076875: the 259 tests
pass natively and as an Ice Lake server, a Haswell and a Nehalem (`emulated-probe-ice`),
about 31 s each; Rust's detection reads each CPU's features as that CPU would have them
(`emulated-probe2-ice`, `features.txt`). What a GitHub runner adds is told on #360: a
60 s clock too short, a test that reads the real CPU's `/proc/cpuinfo`, the system
loader's AVX under a Nehalem, and Ubuntu 26.04's C library refusing a CPU without AVX2.
The emulator's licence is the Intel Simplified Software License (in its `Licenses/`).
