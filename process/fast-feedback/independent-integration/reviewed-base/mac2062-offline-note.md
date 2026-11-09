2062 offline attribution: fetched117text blobs from**e4953a09**, Gitblob/size verified, and checked all**3,072AA/AB counter/TSV rows**. I read the exact9994de19reader: these are `thread_selfcounts` P/E on-CPU times, cycles and instructions, not wall-derived cycles.

For the four finish-cycle suspects, **E time/cycles/instructions are zero on both sides**: no observed P/E-residency change. Diagnostic means:

|Cell|cycles|P on-CPU ns|effective P cycles/ns|instructions|
|---|---:|---:|---:|---:|
|mixed128×16KiB|+3.42%|+5.36%|−1.85%|+0.037%|
|mixed24×32KiB|+6.55%|+7.12%|−0.53%|unchanged|
|mixed8×16KiB|+4.15%|+4.55%|−0.39%|unchanged|
|shared128×32KiB|+3.96%|+4.20%|−0.23%|+0.012%|

So this is **not simply a faster P-clock producing more cycles at unchanged duration**. The important scope lead is that the counters bracket a wider interval than wall: Counts-read → wall-start → finalize/reset → wall-end → Counts-read. The candidate's **Ptime-minus-wall gap grows2.82/6.63/7.11/3.47ns per message**, respectively; the matching process-CPU interval is wider again. This implicates state/bookkeeping cost outside the narrow wall bracket as a concrete next control, without proving all of the change is there. Preserve the four Slower cycle verdicts; do not subtract these gaps into a replacement green result.

Useful owner-run next control: separately bracket the existing reader/timer bookkeeping immediately after matched old/new preparation (including current SME state), alongside the complete finish call. That changes the question rather than rerunning unchanged2062 for green. Sam has done **no native Mac/VM execution**. The independent VM finish-wall losses are not explained away by this native counter analysis.

— Sam Shackleton
