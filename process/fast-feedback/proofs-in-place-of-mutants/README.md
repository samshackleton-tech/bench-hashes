# Proofs in place of mutants: the experiments' scripts and outputs (BLAKE3-Servil #361)

Sam Shackleton, November 10 and 11, 2026. What was proved is on the BLAKE3 fork
`samshackleton-tech/BLAKE3`, branch `experiment/sam-machine-code-lean`, directory
`tools/verify/machine/` (its README lists each folder and its limits). This directory holds the
job scripts that ran on rented machines (`drivers/`), each job's manifest without host and lock
(`manifests/`), and each run's text outputs (`runs/`). Machines are named by role. Nothing here
is a gate.

| Question | Driver | Runs |
|---|---|---|
| How big is the whole problem? (instructions, loops, calls, mnemonics of the core crate) | `size-of-the-problem.sh` (the manifests call it `inventory.sh`), `dump.sh`, `disasm.sh` | `proof-lab-inventory-*`, `proof-lab-dump-*`, `proof-lab-disasm*` |
| Other tools: Kani, Aeneas, Jasmin, Binsec, Sail's x86 to Lean, s2n-bignum | `kani.sh`, `kani-loop.sh`, `aeneas.sh`, `jasmin.sh`, `binsec.sh`, `binsec-real.sh`, `sail-lean.sh`, `s2n.sh` | by the same names |
| Do the Lean models agree with processors? | `cross-gpr.sh`, `cross-one.sh`, `cross-eq.sh` (they run the branch's own `cross*.sh`) | `proof-lab-cross-*` |
| Can a third party check everything from nothing, and how long does it take? | `skeptic-all.sh` | `proof-lab-skeptic-*` (the last are `skeptic-last-*` and `skeptic-head-*`) |
| What do the compiler flags that keep a loop's shape cost? | `loop-shape-speed.sh` (the manifests call it `flags-speed.sh`) | `proof-lab-flags-*` |
| How much machine code does another compiler change? | `compilers.sh`, `compilers-analyze.py` | `proof-lab-compilers4-*` (earlier ones compared names LLVM renames; see the analysis script) |
| How much does a commit change? | `churn.sh` | `proof-lab-churn3-*` |
| How much do a user's build settings change? | `builds.sh`, `builds-analyze.py` | `proof-lab-builds-*` |
| Does the detection proof check on other compilers' and other settings' code? | `detect-compilers.sh`, `detect-builds.sh` | `proof-lab-detect-*` |
| Do the branch's other-compiler scripts work from nothing? | `other-compilers.sh` | `proof-lab-other-compilers-*` |

Failed runs are kept (`runs/FAILED-*`): they are how several faults were found (a SAT time limit on
slower machines, a full disk, a control that did not build).

In Kani's logs the path of its own builders' machine (baked into its toolchain) is shortened to
`<kani-builder>/`. Compressed function texts (`text-*.json.gz`) and disassembly archives are left
out for their size; the scripts make them again.
