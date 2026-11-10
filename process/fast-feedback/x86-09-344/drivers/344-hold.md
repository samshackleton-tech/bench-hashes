The Ice Lake hold is settled on this tree, with one small change: the head is now **448cbf99** (807684c8 plus one commit).

**What the instrument found on 807684c8** (the complete-cycle matrix that found the original hold: old `next` a4095ba6 against the candidate, four fresh paired layouts, 3% margin; 64 shapes, each by wall, CPU, cycles, instructions and energy):

- The old hold is gone: plain messages are Level at every count on both hosts (512 plain: 1000‰ and 999‰ on the Ice Lake host).
- A new, smaller one: **a pair of keyed hashers** (two open, 16 and 32 KiB messages in 4 KiB pieces, distinct or shared keys) was **Slower on the Ice Lake host, +3.5 to +3.6%** of a whole cycle (wall, CPU and cycles alike), and Level on the EPYC.

**The change (448cbf99):** `INDEPENDENT_MIN = 3`. Two held hashers keep `next`'s route (a keyed one hashes alone at full width); three or more take the independent lanes. The count is public; no key decides the route. Tests first: a keyed pair takes two passes on either route, with equal and with distinct keys.

**The same matrix on 448cbf99:**

| | whole cycle | update phase | finish phase |
|---|---|---|---|
| Ice Lake | 241 Level, 79 Faster, **0 Slower** | 242 Level, 78 Faster, 0 Slower | 238 Level, 18 Faster, 0 Slower |
| EPYC 9255 | 128 Level, 192 Faster, 0 Slower | 126 Level, 194 Faster, 0 Slower | 256 Level |

Whole-cycle wall, new over old, keyed and mixed-mode messages of 16 and 32 KiB with 8 to 512 open: EPYC 0.89 to 0.94 (keyed 9–11% faster, mixed 6–8%); Ice Lake 0.96 to 0.99 (mostly inside the margin). A pair is Level on both (1.001 to 1.003). Counts of three to seven are not in the matrix, on either route.

**Gates at 448cbf99:** EPYC: every step passes; mutation check 66 mutants, and all 105 with `--every-mutant`, no new survivor. Ice Lake: the same but `check-builds.sh` (that host has no cargo-c, as before).

**Left before it lands:** the AVX2 wrapper lines on the i7 (#342, Devon's run, then my tests or rows); the M4 Max check (someone with write access to `mac-runner`: old a4095ba6, new 448cbf99, bench 148827f3); a rebase after #331 and the pipeline changes.

— Sam Shackleton
